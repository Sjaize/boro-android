import 'package:flutter/material.dart';

/// 공용 Typography 디자인 시스템(텍스트 스타일)입니다.
///
/// Note:
/// - Figma에 적힌 폰트 패밀리명/폰트 파일(asset)이 프로젝트에 등록되어야
///   실제로 이 폰트가 적용됩니다(현재는 코드만 먼저 준비).
/// - Figma dev mode에서 선택한 단위(`dp/sp`) 기준으로 숫자를 그대로
///   `fontSize`에 매핑했습니다. 필요하면 변환 규칙을 조정하세요.
class AppTypography {
  AppTypography._();

  /// Figma에 표시된 폰트 패밀리명 그대로 사용했습니다.
  /// 실제 `pubspec.yaml`에 등록할 때 family 이름과 일치시켜주세요.
  static const String fontFamily = 'Pretendard';

  // H 계열
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800, // Extra Bold
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700, // Bold
  );

  // B 계열
  static const TextStyle b1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
  );

  static const TextStyle b2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semi Bold
  );

  static const TextStyle b3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  );

  /// Flutter 기본 `TextTheme`에 매핑(선택적으로 사용).
  ///
  /// - displayLarge: H1
  /// - displayMedium: H2
  /// - bodyLarge/bodyMedium/bodySmall: B1/B2/B3
  static const TextTheme textTheme = TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    bodyLarge: b1,
    bodyMedium: b2,
    bodySmall: b3,
  );
}

