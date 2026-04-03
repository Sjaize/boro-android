import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_messaging_service.dart';
import 'post_service.dart';

class KakaoLoginResult {
  const KakaoLoginResult({
    required this.isSuccess,
    this.kakaoAccessToken,
    this.backendLoginSucceeded = false,
    this.errorMessage,
  });

  final bool isSuccess;
  final String? kakaoAccessToken;
  final bool backendLoginSucceeded;
  final String? errorMessage;
}

class AuthService {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';
  static const String _accessTokenKey = 'boro_access_token';
  static const String _refreshTokenKey = 'boro_refresh_token';
  static const String _kakaoAccessTokenKey = 'kakao_access_token';
  static const String _kakaoRefreshTokenKey = 'kakao_refresh_token';

  static String? kakaoAccessToken;

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    PostService.accessToken = prefs.getString(_accessTokenKey);
    kakaoAccessToken = prefs.getString(_kakaoAccessTokenKey);
    debugPrint('AUTH_LOAD_TOKENS kakao=${kakaoAccessToken != null} backend=${PostService.accessToken != null}');
  }

  static Future<void> resetStartupSession() async {
    try {
      await UserApi.instance.logout();
      debugPrint('KAKAO_STARTUP_LOGOUT_SUCCESS');
    } catch (error) {
      debugPrint('KAKAO_STARTUP_LOGOUT_ERROR=$error');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_kakaoAccessTokenKey);
    await prefs.remove(_kakaoRefreshTokenKey);

    PostService.accessToken = null;
    kakaoAccessToken = null;
    debugPrint('AUTH_STARTUP_SESSION_RESET');
  }

  static Future<KakaoLoginResult> loginWithKakao() async {
    try {
      debugPrint('KAKAO_LOGIN_START');
      late OAuthToken kakaoToken;

      if (await isKakaoTalkInstalled()) {
        debugPrint('KAKAO_TALK_INSTALLED=true');
        try {
          kakaoToken = await UserApi.instance.loginWithKakaoTalk();
          debugPrint('KAKAO_LOGIN_METHOD=kakao_talk');
        } catch (error) {
          debugPrint('KAKAO_TALK_LOGIN_FALLBACK=$error');
          kakaoToken = await UserApi.instance.loginWithKakaoAccount();
          debugPrint('KAKAO_LOGIN_METHOD=kakao_account');
        }
      } else {
        debugPrint('KAKAO_TALK_INSTALLED=false');
        kakaoToken = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('KAKAO_LOGIN_METHOD=kakao_account');
      }

      await _saveKakaoTokens(
        accessToken: kakaoToken.accessToken,
        refreshToken: kakaoToken.refreshToken,
      );
      kakaoAccessToken = kakaoToken.accessToken;

      debugPrint('KAKAO_ACCESS_TOKEN=${kakaoToken.accessToken}');
      debugPrint('KAKAO_REFRESH_TOKEN=${kakaoToken.refreshToken ?? ''}');

      final backendSuccess = await _loginToBackend(kakaoToken.accessToken);
      debugPrint('KAKAO_BACKEND_LOGIN_ENABLED=true');
      if (backendSuccess) {
        await FirebaseMessagingService.handleLoginCompleted();
      }

      return KakaoLoginResult(
        isSuccess: true,
        kakaoAccessToken: kakaoToken.accessToken,
        backendLoginSucceeded: backendSuccess,
      );
    } catch (error, stackTrace) {
      debugPrint('KAKAO_LOGIN_ERROR=$error');
      debugPrint('$stackTrace');
      return const KakaoLoginResult(
        isSuccess: false,
        errorMessage: '카카오 로그인에 실패했습니다. 다시 시도해 주세요.',
      );
    }
  }

  // ignore: unused_element
  static Future<bool> _loginToBackend(String kakaoAccessToken) async {
    try {
      debugPrint('KAKAO_BACKEND_LOGIN_START');
      final uri = Uri.parse('$_baseUrl/api/auth/oauth/kakao');
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'access_token': kakaoAccessToken}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('KAKAO_BACKEND_STATUS=${res.statusCode}');
      debugPrint('KAKAO_BACKEND_BODY=${res.body}');

      if (res.statusCode != 200) {
        return false;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final accessToken = body['data']['access_token'] as String;
      final refreshToken = body['data']['refresh_token'] as String;

      await _saveBackendTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      PostService.accessToken = accessToken;
      return true;
    } catch (error, stackTrace) {
      debugPrint('KAKAO_BACKEND_LOGIN_ERROR=$error');
      debugPrint('$stackTrace');
      return false;
    }
  }

  static Future<void> _saveBackendTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<void> _saveKakaoTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kakaoAccessTokenKey, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_kakaoRefreshTokenKey, refreshToken);
    }
  }

  static Future<void> logout() async {
    await FirebaseMessagingService.handleLogout();
    try {
      await UserApi.instance.logout();
      debugPrint('KAKAO_LOGOUT_SUCCESS');
    } catch (error) {
      debugPrint('KAKAO_LOGOUT_ERROR=$error');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_kakaoAccessTokenKey);
    await prefs.remove(_kakaoRefreshTokenKey);

    PostService.accessToken = null;
    kakaoAccessToken = null;
    debugPrint('AUTH_TOKENS_CLEARED');
  }

  static bool get isLoggedIn => PostService.accessToken != null;
}
