import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/mock_data.dart';
import 'post_service.dart';

class NotificationService {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (PostService.accessToken != null)
          'Authorization': 'Bearer ${PostService.accessToken}',
      };

  /// GET /api/notifications
  static Future<List<NotificationItem>> fetchNotifications({
    int page = 1,
    int size = 20,
  }) async {
    try {
      if (!PostService.isAuthenticated) return [];
      final uri = Uri.parse('$_baseUrl/api/notifications')
          .replace(queryParameters: {'page': '$page', 'size': '$size'});
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      debugPrint('NOTIFICATION_STATUS=${res.statusCode} body=${res.body}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = body['data']['notifications'] as List<dynamic>;
        return list
            .map((n) => NotificationItem(
                  id: (n['id'] as num).toInt(),
                  type: n['type'] ?? '',
                  title: n['title'] ?? '',
                  body: n['body'] ?? '',
                  relatedPostId: n['related_post_id'] != null
                      ? (n['related_post_id'] as num).toInt()
                      : null,
                  relatedChatRoomId: n['related_chat_room_id'] != null
                      ? (n['related_chat_room_id'] as num).toInt()
                      : null,
                  isRead: n['is_read'] as bool? ?? false,
                  createdAt: n['created_at'] ?? '',
                ))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('NOTIFICATION_ERROR=$e');
      return [];
    }
  }

  /// PATCH /api/notifications/{notification_id}/read
  static Future<bool> markRead(int notificationId) async {
    try {
      if (!PostService.isAuthenticated) return false;
      final uri = Uri.parse(
          '$_baseUrl/api/notifications/$notificationId/read');
      final res = await http
          .patch(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// POST /api/notifications/device-tokens
  static Future<bool> registerDeviceToken({
    required String deviceToken,
    required String platform,
  }) async {
    try {
      if (!PostService.isAuthenticated) return false;
      final uri = Uri.parse('$_baseUrl/api/notifications/device-tokens');
      final res = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({
              'device_token': deviceToken,
              'platform': platform,
            }),
          )
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// DELETE /api/notifications/device-tokens
  static Future<bool> unregisterDeviceToken(String deviceToken) async {
    try {
      if (!PostService.isAuthenticated) return false;
      final uri = Uri.parse('$_baseUrl/api/notifications/device-tokens');
      final res = await http
          .delete(
            uri,
            headers: _headers,
            body: jsonEncode({'device_token': deviceToken}),
          )
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
