import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/app_config.dart';
import 'post_service.dart';

class ImageUploadService {
  static const String _baseUrl = AppConfig.backendBaseUrl;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (PostService.accessToken != null)
          'Authorization': 'Bearer ${PostService.accessToken}',
      };

  /// GET /api/images/presigned-url?folder=profiles|posts
  /// Returns { upload_url, image_url }
  static Future<({String uploadUrl, String imageUrl})?> getPresignedUrl(
      String folder) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/images/presigned-url')
          .replace(queryParameters: {'folder': folder});
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        final uploadUrl = data['upload_url'] as String;
        final imageUrl = data['image_url'] as String;
        debugPrint('IMAGE_UPLOAD: presigned ok image_url=$imageUrl');
        return (uploadUrl: uploadUrl, imageUrl: imageUrl);
      }
      debugPrint('IMAGE_UPLOAD: presigned-url failed status=${res.statusCode} body=${res.body}');
      return null;
    } catch (e) {
      debugPrint('IMAGE_UPLOAD: presigned-url error=$e');
      return null;
    }
  }

  /// PUT image bytes directly to S3 presigned URL
  static Future<bool> uploadToS3(String presignedUrl, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final res = await http.put(
        Uri.parse(presignedUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: bytes,
      ).timeout(const Duration(seconds: 30));
      debugPrint('IMAGE_UPLOAD: s3 PUT status=${res.statusCode}');
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (e) {
      debugPrint('IMAGE_UPLOAD: s3 PUT error=$e');
      return false;
    }
  }

  /// Full flow: pick → get presigned URL → upload → return final image_url
  static Future<String?> uploadImage(File imageFile, {String folder = 'profiles'}) async {
    final urls = await getPresignedUrl(folder);
    if (urls == null) return null;

    final success = await uploadToS3(urls.uploadUrl, imageFile);
    if (!success) return null;

    return urls.imageUrl;
  }
}
