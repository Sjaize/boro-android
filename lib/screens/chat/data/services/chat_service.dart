import 'dart:convert';
import 'dart:io';

import '../models/chat_message.dart';

class ChatService {
  static const String _baseUrl = 'https://boro-backend-production.up.railway.app';

  Future<List<ChatMessage>> fetchMessages(int chatRoomId, {int? cursor, int size = 20}) async {
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
    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId/messages');
    final client = HttpClient();

    try {
      final request = await client.postUrl(uri);
      
      // 헤더 설정 (UTF-8 명시)
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

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
        print('ChatService Error: Status ${response.statusCode}, Body: $body');
        return null;
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      return ChatMessage.fromJson(data);
    } catch (e) {
      print('ChatService Exception: $e');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<bool> markAsRead(int chatRoomId, int lastReadMessageId) async {
    final uri = Uri.parse('$_baseUrl/api/chats/$chatRoomId/read');
    final client = HttpClient();

    try {
      final request = await client.patchUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      request.add(utf8.encode(jsonEncode({
        'last_read_message_id': lastReadMessageId,
      })));

      final response = await request.close();
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('ChatService markAsRead Exception: $e');
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
