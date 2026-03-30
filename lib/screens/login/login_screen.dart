import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma 기준 화면 사이즈 (384 x 824)
    const double designW = 384;
    const double designH = 824;

    const Color primaryBlue = Color(0xFF1570EF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scaleX = constraints.maxWidth / designW;
          final scaleY = constraints.maxHeight / designH;

          return Stack(
            children: [
              // 1. "급할 때 바로, 필요할 때 보로" 문구 (한 줄로 배열)
              Positioned(
                top: 329 * scaleY,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '급할 때 바로, 필요할 때 보로',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.b2.copyWith(
                      fontSize: 16 * scaleY,
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                  ),
                ),
              ),

              // 2. "Boro" 로고 문구 (한 줄로 배열)
              Positioned(
                top: 357 * scaleY,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Boro',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.h1.copyWith(
                      fontSize: 72 * scaleY,
                      color: primaryBlue,
                      letterSpacing: -2,
                      height: 1.0,
                    ),
                  ),
                ),
              ),

              // 3. 하단 버튼 영역
              Positioned(
                left: 20 * scaleX,
                right: 20 * scaleX,
                bottom: 34 * scaleY,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SNS 안내 말풍선
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 8 * scaleY),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scaleX,
                            vertical: 8 * scaleY,
                          ),
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SNS 계정으로 간편 가입하기',
                            style: AppTypography.b3.copyWith(
                              fontSize: 14 * scaleY,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: CustomPaint(
                            size: const Size(12, 8),
                            painter: _TrianglePainter(color: primaryBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12 * scaleY),

                    // 카카오 로그인 버튼
                    _LoginButton(
                      text: '카카오로 바로 시작',
                      backgroundColor: primaryBlue,
                      textColor: Colors.white,
                      onPressed: () {},
                      scaleY: scaleY,
                    ),
                    SizedBox(height: 12 * scaleY),

                    // 이메일 로그인 버튼
                    _LoginButton(
                      text: '이메일로 로그인',
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFF344054),
                      borderColor: const Color(0xFFD0D5DD),
                      onPressed: () {},
                      scaleY: scaleY,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final double scaleY;

  const _LoginButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onPressed,
    required this.scaleY,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56 * scaleY,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: AppTypography.b2.copyWith(
            fontSize: 18 * scaleY,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
