import 'dart:convert';
import 'dart:io';

import '../../../config/app_config.dart';
import '../../../services/post_service.dart';
import 'mypage_post_model.dart';

class MypageService {
  static const String _baseUrl = AppConfig.backendBaseUrl;

  Future<List<MypagePostItem>> fetchMyPosts({
    required String postType,
    int page = 1,
    int size = 10,
  }) async {
    if (!PostService.isAuthenticated) return [];
    final uri = Uri.parse(
      '$_baseUrl/api/users/me/posts?post_type=$postType&page=$page&size=$size',
    );
    return _fetchPostList(uri, '내 게시글을 불러오지 못했습니다.');
  }

  Future<List<MypagePostItem>> fetchFavorites({
    int page = 1,
    int size = 10,
  }) async {
    if (!PostService.isAuthenticated) return [];
    final uri = Uri.parse(
      '$_baseUrl/api/users/me/likes?page=$page&size=$size',
    );
    return _fetchPostList(uri, '관심 목록을 불러오지 못했습니다.');
  }

  Future<bool> unlikePost(int postId) async {
    if (!PostService.isAuthenticated) return false;
    final uri = Uri.parse('$_baseUrl/api/posts/$postId/likes');
    final client = HttpClient();
    try {
      final request = await client.deleteUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  Future<List<MypagePostItem>> _fetchPostList(Uri uri, String errorMessage) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('$errorMessage (${response.statusCode})');
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final posts = data['posts'] as List<dynamic>? ?? const [];
      
      return posts
          .map((item) => MypagePostItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      client.close(force: true);
    }
  }
}
