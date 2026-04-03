import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';
import 'post_service.dart';
import 'user_service.dart';
import '../screens/chat/data/services/chat_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class FirebaseMessagingService {
  static const MethodChannel _pushChannel = MethodChannel('boro/push');
  static const String _prefsNearbyEnabled = 'nearby_urgent_alerts_enabled';
  static const String _prefsNotificationRadius = 'notification_radius_m';
  static const String _prefsLastLocationSyncAt = 'last_location_sync_at';
  static const int _defaultRadiusM = 1500;
  static const Duration _maxLocationAge = Duration(hours: 6);

  static String? _currentToken;
  static bool _initialized = false;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static AppLifecycleListener? _lifecycleListener;

  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static const _androidChannel = AndroidNotificationChannel(
    'boro_default_channel',
    'BORO 알림',
    importance: Importance.high,
  );

  static Future<void> _initLocalNotifications() async {
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    // Android 13+ POST_NOTIFICATIONS 권한 요청
    await androidPlugin?.requestNotificationsPermission();
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) {
      debugPrint('FCM_LOCAL_NOTIFY_SKIP=no notification payload');
      return;
    }
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    _localNotifications.show(
      id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );
    debugPrint('FCM_LOCAL_NOTIFY_SHOWN title=${notification.title}');
  }

  static String? get currentToken => _currentToken;

  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    _navigatorKey = navigatorKey;

    if (_initialized) {
      return;
    }

    try {
      await Firebase.initializeApp();
      _initialized = true;
    } catch (error) {
      debugPrint('FIREBASE_INIT_SKIPPED=$error');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;

    try {
      _currentToken = await messaging.getToken();
    } catch (error) {
      debugPrint('FCM_GET_TOKEN_ERROR=$error');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _currentToken = token;
      await syncTokenWithServer();
    });

    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handlePushNavigation(message.data);
    });

    _pushChannel.setMethodCallHandler((call) async {
      if (call.method != 'onPushOpened') return;
      final arguments = Map<String, dynamic>.from(call.arguments as Map);
      _handlePushNavigation(arguments);
    });

    try {
      final initialPayload = await _pushChannel.invokeMapMethod<String, dynamic>(
        'getInitialPushPayload',
      );
      if (initialPayload != null && initialPayload.isNotEmpty) {
        _handlePushNavigation(initialPayload);
      }
    } catch (error) {
      debugPrint('FCM_INITIAL_PUSH_ERROR=$error');
    }

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _syncLocationOnAppResume(force: false);
      },
    );
  }

  static Future<bool> requestNotificationPermission() async {
    if (!_initialized) return false;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final granted = settings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      return granted;
    } catch (error) {
      debugPrint('FCM_PERMISSION_ERROR=$error');
      return false;
    }
  }

  static Future<int> getSavedNotificationRadius() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefsNotificationRadius) ?? _defaultRadiusM;
  }

  static Future<void> saveNotificationRadius(int radiusMeters) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsNotificationRadius, radiusMeters);
  }

  static Future<bool> isNearbyUrgentAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsNearbyEnabled) ?? false;
  }

  static Future<bool> setNearbyUrgentAlertsEnabled(bool enabled) async {
    if (!PostService.isAuthenticated) return false;

    final radius = await getSavedNotificationRadius();

    if (enabled) {
      final granted = await requestNotificationPermission();
      if (!granted) return false;
    }

    final success = await UserService.updateMySettings(
      notificationRadiusM: radius,
      nearbyUrgentAlertsEnabled: enabled,
    );

    if (!success) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsNearbyEnabled, enabled);

    if (enabled) {
      await _syncLocationToBackend(force: true);
    }

    return true;
  }

  static Future<void> syncTokenWithServer() async {
    if (!_initialized) return;
    if (!PostService.isAuthenticated) return;
    final token = _currentToken;
    if (token == null || token.isEmpty) return;

    final success = await NotificationService.registerDeviceToken(
      deviceToken: token,
      platform: 'android',
    );
  }

  static Future<void> unregisterFromServer() async {
    final token = _currentToken;
    if (token == null || token.isEmpty) return;

    final success = await NotificationService.unregisterDeviceToken(token);
  }

  static Future<void> handleLoginCompleted() async {
    await syncTokenWithServer();
    await _syncLocationOnAppResume(force: false);
    await updateLocationOnce();
  }

  static Future<String?> updateLocationOnce() async {
    if (!PostService.isAuthenticated) {
      debugPrint('LOCATION_ONCE: not authenticated, skip');
      return null;
    }
    try {
      var permission = await Geolocator.checkPermission();
      debugPrint('LOCATION_ONCE: permission=$permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('LOCATION_ONCE: after request permission=$permission');
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('LOCATION_ONCE: permission denied, skip');
        return null;
      }

      // Try last known position first (instant, no timeout)
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        debugPrint('LOCATION_ONCE: using last known=${position.latitude},${position.longitude}');
      } else {
        // Fall back to current position with longer timeout
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
        ).timeout(const Duration(seconds: 15));
        debugPrint('LOCATION_ONCE: current position=${position.latitude},${position.longitude}');
      }

      final regionName = await UserService.updateLocation(position.latitude, position.longitude);
      debugPrint('LOCATION_ONCE: backend region_name=$regionName');
      return regionName;
    } catch (e) {
      debugPrint('LOCATION_ONCE: error=$e');
      return null;
    }
  }

  static Future<void> handleLogout() async {
    await unregisterFromServer();
  }

  static Future<void> onNotificationRadiusUpdated(int radiusMeters) async {
    await saveNotificationRadius(radiusMeters);
    final enabled = await isNearbyUrgentAlertsEnabled();
    if (!enabled || !PostService.isAuthenticated) return;

    await UserService.updateMySettings(
      notificationRadiusM: radiusMeters,
      nearbyUrgentAlertsEnabled: true,
    );
    await _syncLocationToBackend(force: false);
  }

  static Future<void> _syncLocationOnAppResume({required bool force}) async {
    final enabled = await isNearbyUrgentAlertsEnabled();
    if (!enabled) return;
    await _syncLocationToBackend(force: force);
  }

  static Future<void> _syncLocationToBackend({required bool force}) async {
    if (!PostService.isAuthenticated) return;

    final prefs = await SharedPreferences.getInstance();
    final lastSyncMillis = prefs.getInt(_prefsLastLocationSyncAt);
    if (!force && lastSyncMillis != null) {
      final lastSync = DateTime.fromMillisecondsSinceEpoch(lastSyncMillis);
      if (DateTime.now().difference(lastSync) < _maxLocationAge) {
        return;
      }
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 5));

      final regionName = await UserService.updateLocation(
        position.latitude,
        position.longitude,
      );
      if (regionName == null) return;

      await prefs.setInt(
        _prefsLastLocationSyncAt,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (error) {
      debugPrint('FCM_LOCATION_SYNC_ERROR=$error');
    }
  }

  static Future<void> _handlePushNavigation(Map<String, dynamic> payload) async {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) return;

    final type = payload['type']?.toString();
    final relatedChatRoomId = payload['related_chat_room_id'];
    final relatedPostId = payload['related_post_id'];

    if (type == 'chat_message' && relatedChatRoomId != null) {
      final roomId = int.tryParse(relatedChatRoomId.toString());
      if (roomId != null) {
        final chatRoom = await ChatService().fetchChatRoom(roomId);
        if (chatRoom != null) {
          navigator.pushNamed('/chat-room', arguments: chatRoom);
          return;
        }
      }
      navigator.pushNamed('/chat-list');
      return;
    }

    if ((type == 'urgent_post' || type == 'interest_post') && relatedPostId != null) {
      final postId = relatedPostId.toString();
      final post = await PostService.fetchPostDetail(postId);
      if (post != null) {
        navigator.pushNamed('/post-detail', arguments: post);
        return;
      }
    }

    navigator.pushNamed('/notification');
  }
}
