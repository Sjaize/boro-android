import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen2 extends StatelessWidget {
  const TutorialScreen2({super.key});

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 44,
              left: 0,
              right: 0,
              child: const _PageIndicator(currentIndex: 1, totalCount: 5),
            ),
            Positioned(
              top: 48,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _goNext(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      'Skip',
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textHint,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              top: 98,
              bottom: 304,
              child: _TutorialMapGraphic(),
            ),
            Positioned(
              left: 1,
              right: 0,
              bottom: 0,
              child: Container(
                height: 304,
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 50,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 37, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '보로는 가까이 있는 사람들에게\n물건을 빌리고, 빌려주며\n도움을 받을 수 있는 서비스에요.',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _goNext(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            '다음',
                            style: AppTypography.b3.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialMapGraphic extends StatelessWidget {
  const _TutorialMapGraphic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: -24,
          child: Container(
            width: 560,
            height: 560,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: 88,
          child: Container(
            width: 337,
            height: 337,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
          ),
        ),
        Positioned(
          top: 136,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: 182,
          child: Column(
            children: [
              Container(
                width: 112,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'HELP!',
                      style: AppTypography.c2.copyWith(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      child: CustomPaint(
                        size: const Size(12, 8),
                        painter: _TrianglePainter(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Icon(
                Icons.location_on,
                size: 48,
                color: AppColors.primary,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const _PageIndicator({
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalCount,
        (index) => Container(
          width: 5,
          height: 5,
          margin: EdgeInsets.only(right: index == totalCount - 1 ? 0 : 7),
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors.primary
                : const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
