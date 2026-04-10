import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../data/mock_data.dart';
import 'post_service.dart';

class UserService {
  static const String _baseUrl = AppConfig.backendBaseUrl;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (PostService.accessToken != null)
          'Authorization': 'Bearer ${PostService.accessToken}',
      };

  /// GET /api/users/me
  static Future<UserProfile?> fetchMyProfile() async {
    try {
      if (PostService.accessToken == null) return null;
      final uri = Uri.parse('$_baseUrl/api/users/me');
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final d =
            (jsonDecode(res.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        return UserProfile(
          id: (d['id'] as num).toInt(),
          nickname: d['nickname'] ?? '',
          profileImageUrl: d['profile_image_url'] as String?,
          regionName: d['region_name'] ?? '',
          trustScore: (d['trust_score'] as num?)?.toDouble() ?? 0.0,
          borrowCount: (d['borrow_count'] as num?)?.toInt() ?? 0,
          lendCount: (d['lend_count'] as num?)?.toInt() ?? 0,
          likeCount: (d['like_count'] as num?)?.toInt() ?? 0,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/users/{user_id}
  static Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/users/$userId');
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final d =
            (jsonDecode(res.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        return UserProfile(
          id: (d['id'] as num).toInt(),
          nickname: d['nickname'] ?? '',
          profileImageUrl: d['profile_image_url'] as String?,
          regionName: d['region_name'] ?? '',
          trustScore: (d['trust_score'] as num?)?.toDouble() ?? 0.0,
          lendCount:
              (d['completed_transaction_count'] as num?)?.toInt() ?? 0,
          reviewCount: (d['review_count'] as num?)?.toInt() ?? 0,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/users/{user_id}/reviews
  static Future<List<ReviewItem>> fetchUserReviews(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/users/$userId/reviews')
          .replace(queryParameters: {'page': '1', 'size': '10'});
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = body['data']['reviews'] as List<dynamic>;
        return list
            .map((r) => ReviewItem(
                  authorName: '',
                  tradeCount: 0,
                  comment: r['comment'] ?? '',
                  timeAgo: PostService.timeAgo(r['created_at'] ?? ''),
                  rating: (r['rating'] as num?)?.toInt() ?? 5,
                ))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// GET /api/users/{user_id}/posts
  static Future<List<PostItem>> fetchUserPosts(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/users/$userId/posts')
          .replace(queryParameters: {'page': '1', 'size': '10'});
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = body['data']['posts'] as List<dynamic>;
        return list
            .map((p) => PostItem(
                  id: p['post_id'].toString(),
                  title: p['title'] ?? '',
                  category: '',
                  pricePerHour: (p['price'] as num?)?.toInt() ?? 0,
                  location: p['region_name'] ?? '',
                  timeAgo: PostService.timeAgo(p['created_at'] ?? ''),
                  authorName: '',
                  authorId: userId,
                  description: '',
                  isAvailable: p['status'] == 'active',
                  likeCount: (p['like_count'] as num?)?.toInt() ?? 0,
                  chatCount: (p['chat_count'] as num?)?.toInt() ?? 0,
                ))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// PUT /api/users/me/location → region_name 반환
  static Future<String?> updateLocation(double lat, double lng) async {
    try {
      if (PostService.accessToken == null) return null;
      final uri = Uri.parse('$_baseUrl/api/users/me/location');
      final res = await http
          .put(
            uri,
            headers: _headers,
            body: jsonEncode({'lat': lat, 'lng': lng}),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return body['data']['region_name'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PATCH /api/users/me/settings
  static Future<bool> updateMySettings({
    int? notificationRadiusM,
    bool? nearbyUrgentAlertsEnabled,
    List<String>? interestKeywords,
  }) async {
    try {
      if (!PostService.isAuthenticated) return false;
      final payload = <String, dynamic>{};
      if (notificationRadiusM != null) {
        payload['notification_radius_m'] = notificationRadiusM;
      }
      if (nearbyUrgentAlertsEnabled != null) {
        payload['nearby_urgent_alerts_enabled'] = nearbyUrgentAlertsEnabled;
      }
      if (interestKeywords != null) {
        payload['interest_keywords'] = interestKeywords;
      }
      if (payload.isEmpty) return true;

      final uri = Uri.parse('$_baseUrl/api/users/me/settings');
      final res = await http
          .patch(uri, headers: _headers, body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
