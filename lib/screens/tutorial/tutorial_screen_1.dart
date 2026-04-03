import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_cards.dart';

class TutorialScreen1 extends StatelessWidget {
  const TutorialScreen1({super.key});

  static const List<_TutorialCardData> _topCards = [
    _TutorialCardData('2분 전', '정장 구합니다', '1일 동안'),
    _TutorialCardData('5분 전', '충전기 빌려주실 분', '1일 동안'),
    _TutorialCardData('10분 전', '우산 필요해요', '3시간 동안'),
    _TutorialCardData('2분 전', '보조배터리 구해요', '1시간 동안'),
  ];

  static const List<_TutorialCardData> _bottomCards = [
    _TutorialCardData('2분 전', '정장 구합니다', '1일 동안'),
    _TutorialCardData('5분 전', '충전기 빌려주실 분', '1일 동안'),
    _TutorialCardData('10분 전', '우산 필요해요', '3시간 동안'),
    _TutorialCardData('2분 전', '보조배터리 구해요', '1시간 동안'),
  ];

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-2');
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
              child: Column(
                children: [
                  const _PageIndicator(currentIndex: 0, totalCount: 5),
                ],
              ),
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
              top: 98,
              left: -118,
              right: -118,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: -13 * math.pi / 180,
                  child: Column(
                    children: [
                      Row(
                        children: _topCards
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _TutorialUrgentCard(data: item),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: _bottomCards
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _TutorialUrgentCard(data: item),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
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
                        '보로에 오신 것을 환영해요!',
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

class _TutorialUrgentCard extends StatelessWidget {
  final _TutorialCardData data;

  const _TutorialUrgentCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 176,
      child: UrgentRequestCard(
        timeText: data.timeText,
        title: data.title,
        duration: data.duration,
      ),
    );
  }
}

class _TutorialCardData {
  final String timeText;
  final String title;
  final String duration;

  const _TutorialCardData(this.timeText, this.title, this.duration);
}
