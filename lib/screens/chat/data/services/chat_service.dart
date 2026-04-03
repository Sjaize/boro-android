import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../services/post_service.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';

class ChatService {
  static const String _baseUrl = 'https://boro-backend-production.up.railway.app';

  static int cachedUnreadCount = 0;

  static Future<int> fetchTotalUnreadCount() async {
    if (!PostService.isAuthenticated) return cachedUnreadCount;
    final uri = Uri.parse('$_baseUrl/api/chats?type=ALL&page=1&size=50');
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
        return cachedUnreadCount;
      }
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final rooms = data['chat_rooms'] as List<dynamic>? ?? [];
      cachedUnreadCount = rooms.fold<int>(0, (sum, item) {
        final unread =
            (item as Map<String, dynamic>)['unread_count'] as num? ?? 0;
        return sum + unread.toInt();
      });
      return cachedUnreadCount;
    } catch (_) {
      return cachedUnreadCount;
    } finally {
      client.close(force: true);
    }
  }

  Future<ChatRoom?> fetchChatRoom(int chatRoomId) async {
    if (!PostService.isAuthenticated) return null;
    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId');
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer ${PostService.accessToken}');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode < 200 || response.statusCode >= 300) return null;
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>;
      return ChatRoom.fromDetailJson(data);
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<List<ChatMessage>> fetchMessages(int chatRoomId, {int? cursor, int size = 20}) async {
    if (!PostService.isAuthenticated) return [];
    final queryParams = <String, String>{
      'size': size.toString(),
    };
    if (cursor != null) {
      queryParams['cursor'] = cursor.toString();
    }

    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId/messages').replace(queryParameters: queryParams);
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
        throw HttpException('메시지를 불러오지 못했습니다. (${response.statusCode})');
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final messages = data['messages'] as List<dynamic>? ?? const [];
      
      return messages
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      client.close(force: true);
    }
  }

  Future<ChatMessage?> sendMessage(int chatRoomId, String content, {String type = 'text'}) async {
    if (!PostService.isAuthenticated) return null;
    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId/messages');
    final client = HttpClient();

    try {
      final request = await client.postUrl(uri);
      
      // 헤더 설정 (UTF-8 명시)
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      // 바디 작성 (인코딩 명시)
      final Map<String, dynamic> bodyData = {
        'message_type': type,
        'content': content,
      };
      
      final String jsonString = jsonEncode(bodyData);
      request.add(utf8.encode(jsonString));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('CHAT_SEND_ERROR status=${response.statusCode} body=$body');
        return null;
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      return ChatMessage.fromJson(data);
    } catch (e) {
      debugPrint('CHAT_SEND_EXCEPTION=$e');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<bool> completeTransaction({
    required int postId,
    required int chatRoomId,
  }) async {
    if (!PostService.isAuthenticated) return false;
    final uri = Uri.parse('$_baseUrl/api/transactions');
    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );
      request.add(utf8.encode(jsonEncode({
        'post_id': postId,
        'chat_room_id': chatRoomId,
      })));
      final response = await request.close();
      await response.drain<void>();
      debugPrint('TRANSACTION_COMPLETE status=${response.statusCode}');
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('TRANSACTION_COMPLETE_EXCEPTION=$e');
      return false;
    } finally {
      client.close(force: true);
    }
  }

  Future<bool> markAsRead(int chatRoomId, int lastReadMessageId) async {
    if (!PostService.isAuthenticated) return false;
    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId/read');
    final client = HttpClient();

    try {
      final request = await client.patchUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      request.add(utf8.encode(jsonEncode({
        'last_read_message_id': lastReadMessageId,
      })));

      final response = await request.close();
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('CHAT_READ_EXCEPTION=$e');
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
