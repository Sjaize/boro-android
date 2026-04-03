import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';
import 'post_service.dart';
import 'user_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  debugPrint('FCM_BACKGROUND_MESSAGE=${message.data}');
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
      debugPrint('FCM_TOKEN=${_currentToken ?? ''}');
    } catch (error) {
      debugPrint('FCM_GET_TOKEN_ERROR=$error');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _currentToken = token;
      debugPrint('FCM_TOKEN_REFRESH=$token');
      await syncTokenWithServer();
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM_FOREGROUND_MESSAGE=${message.data}');
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
      debugPrint('FCM_PERMISSION_STATUS=${settings.authorizationStatus.name}');
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
    debugPrint('FCM_TOKEN_SYNC=$success');
  }

  static Future<void> unregisterFromServer() async {
    final token = _currentToken;
    if (token == null || token.isEmpty) return;

    final success = await NotificationService.unregisterDeviceToken(token);
    debugPrint('FCM_TOKEN_UNREGISTER=$success');
  }

  static Future<void> handleLoginCompleted() async {
    await syncTokenWithServer();
    await _syncLocationOnAppResume(force: false);
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
      debugPrint('FCM_LOCATION_SYNC=true');
    } catch (error) {
      debugPrint('FCM_LOCATION_SYNC_ERROR=$error');
    }
  }

  static void _handlePushNavigation(Map<String, dynamic> payload) {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) return;

    final type = payload['type']?.toString();
    final relatedChatRoomId = payload['related_chat_room_id']?.toString();
    final relatedPostId = payload['related_post_id']?.toString();

    if (type == 'chat_message' || relatedChatRoomId != null) {
      navigator.pushNamed('/chat-list');
      return;
    }

    if (relatedPostId != null) {
      navigator.pushNamed('/notification');
      return;
    }

    navigator.pushNamed('/notification');
  }
}
