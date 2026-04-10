import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../data/mock_data.dart';

class PostService {
  static const String _baseUrl = AppConfig.backendBaseUrl;

  static String? accessToken;
  static bool get isAuthenticated =>
      accessToken != null && accessToken!.isNotEmpty;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

  /// ISO 8601 문자열 → "N분 전" 형식
  static String timeAgo(String isoDateTime) {
    try {
      final dt = DateTime.parse(isoDateTime).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inSeconds < 60) return '방금 전';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      if (diff.inDays < 7) return '${diff.inDays}일 전';
      return '${diff.inDays ~/ 7}주 전';
    } catch (_) {
      return '';
    }
  }

  /// GET /api/posts
  /// [postType]: 'BORROW' | 'LEND'
  /// [category]: null이면 전체, '급구'이면 is_urgent=true로 처리
  /// [keyword]: 검색어
  static Future<List<PostItem>> fetchPosts({
    String postType = 'LEND',
    String? category,
    String? keyword,
    int page = 1,
    int size = 20,
  }) async {
    try {
      final params = <String, String>{
        'post_type': postType,
        'page': page.toString(),
        'size': size.toString(),
        'sort': 'created_at',
      };

      if (category == '급구') {
        params['is_urgent'] = 'true';
      } else if (category != null && category != '전체') {
        params['category'] = category;
      }
      if (keyword != null && keyword.isNotEmpty) {
        params['keyword'] = keyword;
      }

      final uri = Uri.parse('$_baseUrl/api/posts')
          .replace(queryParameters: params);
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
                  category: p['category'] ?? '',
                  pricePerHour: (p['price'] as num?)?.toInt() ?? 0,
                  location: p['region_name'] ?? '',
                  timeAgo: timeAgo(p['created_at'] ?? ''),
                  imageUrl: p['thumbnail_url'] as String?,
                  authorName: '',
                  authorId: '',
                  description: '',
                  isAvailable: p['status'] == 'AVAILABLE',
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

  /// GET /api/posts?post_type=BORROW&is_urgent=true (홈 화면 긴급 섹션)
  static Future<List<PostItem>> fetchUrgentPosts({int size = 5}) async {
    try {
      final params = <String, String>{
        'post_type': 'BORROW',
        'is_urgent': 'true',
        'page': '1',
        'size': size.toString(),
        'sort': 'created_at',
      };

      final uri = Uri.parse('$_baseUrl/api/posts')
          .replace(queryParameters: params);
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
                  category: p['category'] ?? '',
                  pricePerHour: (p['price'] as num?)?.toInt() ?? 0,
                  location: p['region_name'] ?? '',
                  timeAgo: timeAgo(p['created_at'] ?? ''),
                  imageUrl: p['thumbnail_url'] as String?,
                  authorName: '',
                  authorId: '',
                  description: '',
                  isAvailable: p['status'] == 'AVAILABLE',
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

  /// GET /api/posts/{post_id}
  static Future<PostItem?> fetchPostDetail(String postId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/posts/$postId');
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final p = (jsonDecode(res.body) as Map<String, dynamic>)['data'];
        final author = p['author'] as Map<String, dynamic>? ?? {};
        return PostItem(
          id: p['post_id'].toString(),
          title: p['title'] ?? '',
          category: p['category'] ?? '',
          pricePerHour: (p['price'] as num?)?.toInt() ?? 0,
          location: p['region_name'] ?? '',
          timeAgo: timeAgo(p['created_at'] ?? ''),
          imageUrl: (p['images'] as List?)?.isNotEmpty == true
              ? p['images'][0]['image_url'] as String?
              : null,
          authorName: author['nickname'] ?? '',
          authorId: author['user_id']?.toString() ?? '',
          description: p['content'] ?? '',
          isAvailable: p['status'] == 'AVAILABLE',
          likeCount: (p['like_count'] as num?)?.toInt() ?? 0,
          chatCount: (p['chat_count'] as num?)?.toInt() ?? 0,
          isLikedByMe: p['is_liked_by_me'] as bool? ?? false,
          authorProfileUrl: author['profile_image_url'] as String?,
          authorTrustScore:
              (author['trust_score'] as num?)?.toDouble() ?? 0.0,
          meetingPlaceText: p['meeting_place_text'] as String?,
          rentalPeriodText: p['rental_period_text'] as String?,
          postType: p['post_type'] ?? 'LEND',
          lat: (p['lat'] as num?)?.toDouble(),
          lng: (p['lng'] as num?)?.toDouble(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/posts → post_id 반환
  static Future<String?> createPost(Map<String, dynamic> data) async {
    try {
      if (accessToken == null) return null;
      final uri = Uri.parse('$_baseUrl/api/posts');
      final res = await http
          .post(uri, headers: _headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return body['data']['post_id'].toString();
      }
      debugPrint('CREATE_POST_ERROR status=${res.statusCode} body=${res.body}');
      return null;
    } catch (e) {
      debugPrint('CREATE_POST_EXCEPTION=$e');
      return null;
    }
  }

  /// POST /api/posts/{post_id}/likes
  static Future<Map<String, dynamic>?> likePost(String postId) async {
    try {
      if (!isAuthenticated) return null;
      final uri = Uri.parse('$_baseUrl/api/posts/$postId/likes');
      final res = await http
          .post(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (jsonDecode(res.body) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// DELETE /api/posts/{post_id}/likes
  static Future<Map<String, dynamic>?> unlikePost(String postId) async {
    try {
      if (!isAuthenticated) return null;
      final uri = Uri.parse('$_baseUrl/api/posts/$postId/likes');
      final res = await http
          .delete(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST /api/posts/{post_id}/chats → chat_room_id 반환
  static Future<int?> createChatRoom(String postId) async {
    try {
      if (!isAuthenticated) return null;
      final uri = Uri.parse('$_baseUrl/api/posts/$postId/chats');
      final res = await http
          .post(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return (body['data']['chat_room_id'] as num).toInt();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/users/me → region_name 반환
  static Future<String?> fetchRegionName() async {
    try {
      if (!isAuthenticated) {
        debugPrint('FETCH_REGION: not authenticated');
        return null;
      }
      final uri = Uri.parse('$_baseUrl/api/users/me');
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      debugPrint('FETCH_REGION: status=${res.statusCode} body=${res.body}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final name = body['data']['region_name'] as String?;
        debugPrint('FETCH_REGION: region_name=$name');
        return name;
      }
      return null;
    } catch (e) {
      debugPrint('FETCH_REGION: error=$e');
      return null;
    }
  }
}
