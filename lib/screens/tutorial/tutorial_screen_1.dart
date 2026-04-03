import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_cards.dart';

class TutorialScreen1 extends StatefulWidget {
  const TutorialScreen1({super.key});

  @override
  State<TutorialScreen1> createState() => _TutorialScreen1State();
}

class _TutorialScreen1State extends State<TutorialScreen1>
    with SingleTickerProviderStateMixin {
  static const List<String> _routes = [
    '/tutorial-1',
    '/tutorial-2',
    '/tutorial-3',
    '/tutorial-4',
    '/tutorial-5',
  ];

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

  late final AnimationController _motionController;
  late final Animation<double> _topRowOffset;
  late final Animation<double> _bottomRowOffset;
  late final Animation<double> _cardsOpacity;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    final curve = CurvedAnimation(
      parent: _motionController,
      curve: Curves.easeInOutCubic,
    );
    _topRowOffset = Tween<double>(begin: -24, end: 24).animate(curve);
    _bottomRowOffset = Tween<double>(begin: 24, end: -24).animate(curve);
    _cardsOpacity = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _motionController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-2');
  }

  void _skipTutorial(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _goToPage(BuildContext context, int index) {
    if (index == 0) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -150) {
      _goNext(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) => _handleSwipe(context, details),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                top: 44,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    _PageIndicator(
                      currentIndex: 0,
                      totalCount: 5,
                      onDotTap: (index) => _goToPage(context, index),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 124,
                left: -118,
                right: -118,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _motionController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _cardsOpacity.value,
                        child: Transform.rotate(
                          angle: -13 * math.pi / 180,
                          child: Column(
                            children: [
                              Transform.translate(
                                offset: Offset(_topRowOffset.value, 0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 62),
                                  child: Row(
                                    children: _topCards
                                        .map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: _TutorialUrgentCard(
                                              data: item,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Transform.translate(
                                offset: Offset(_bottomRowOffset.value, 0),
                                child: Row(
                                  children: _bottomCards
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: _TutorialUrgentCard(
                                            data: item,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                        blurRadius: 95,
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
              Positioned(
                top: 32,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _skipTutorial(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        'Skip',
                        style: AppTypography.b4.copyWith(
                          color: const Color(0xFFA4A7AE),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final ValueChanged<int> onDotTap;

  const _PageIndicator({
    required this.currentIndex,
    required this.totalCount,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalCount,
        (index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDotTap(index),
          child: Container(
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
