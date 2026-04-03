import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen3 extends StatelessWidget {
  const TutorialScreen3({super.key});

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-4');
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
              child: const _PageIndicator(currentIndex: 2, totalCount: 5),
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
            Positioned(
              top: 151,
              left: 16,
              right: 16,
              child: Column(
                children: const [
                  _TutorialNotificationCard(),
                  SizedBox(height: 7),
                  _TutorialNotificationCard(),
                  SizedBox(height: 7),
                  _TutorialNotificationCard(),
                ],
              ),
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
                        '필요한 물건을 요청하면\n근처 사람들에게 즉시 알림이 가요.',
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

class _TutorialNotificationCard extends StatelessWidget {
  const _TutorialNotificationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 23,
            left: 20,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 2.8,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Boro',
                style: AppTypography.b4.copyWith(
                  color: AppColors.bgPage,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: 21,
            left: 95,
            right: 62,
            child: Text(
              'BORO',
              style: AppTypography.b4.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            top: 26,
            right: 18,
            child: Text(
              '2분 전',
              style: AppTypography.c2.copyWith(
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            top: 47,
            left: 95,
            right: 20,
            child: Text(
              '150m - 수익 기회가 생겼어요!\n노트북 충전기 (C타입), 2000원, 지금 당장 필요해요',
              style: AppTypography.c2.copyWith(
                color: AppColors.textDark,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
