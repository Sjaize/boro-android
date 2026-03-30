import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 개발 편의를 위해 일정 시간 후 다음 화면으로 전환합니다.
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    const double designW = 384;
    const double designH = 824;

    const String tagline = '급할 때 바로, 필요할 때 보로';
    const String logoText = 'BORO';
    const String logoAsset = 'assets/images/splash/Boro.png';

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / designW;
        final scaleY = constraints.maxHeight / designH;

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: const Color(0xFF1570EF),
          child: Stack(
            children: [
              Positioned(
                top: 330 * scaleY,
                left: 107 * scaleX,
                right: 101 * scaleX,
                child: Text(
                  tagline,
                  textAlign: TextAlign.center,
                  style: AppTypography.b3.copyWith(
                    fontSize: 16 * scaleY,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              Positioned(
                top: 357 * scaleY,
                left: 77 * scaleX,
                right: 71 * scaleX,
                height: (401 - 357) * scaleY,
                child: Center(
                  child: Image.asset(
                    logoAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        logoText,
                        textAlign: TextAlign.center,
                        style: AppTypography.b2.copyWith(
                          fontSize: 48 * scaleY,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFFFFF),
                          // 이미지에서 보이는 오프셋 그림자 느낌(의도 근사).
                          shadows: const [
                            Shadow(
                              offset: Offset(6, 8),
                              blurRadius: 0,
                              color: Color(0xFF2B35D2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

