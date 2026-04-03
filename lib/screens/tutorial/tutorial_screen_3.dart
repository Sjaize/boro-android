import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen3 extends StatefulWidget {
  const TutorialScreen3({super.key});

  @override
  State<TutorialScreen3> createState() => _TutorialScreen3State();
}

class _TutorialScreen3State extends State<TutorialScreen3>
    with SingleTickerProviderStateMixin {

  static const List<String> _routes = [
    '/tutorial-1',
    '/tutorial-2',
    '/tutorial-3',
    '/tutorial-4',
    '/tutorial-5',
  ];

  static const List<_TutorialNotificationData> _notifications = [
    _TutorialNotificationData(
      timeText: '2분 전',
      message:
          '150m - 수익 기회가 생겼어요!\n노트북 충전기 (C타입), 2000원, 지금 당장 필요해요',
    ),
    _TutorialNotificationData(
      timeText: '5분 전',
      message:
          '320m - 수익 기회가 생겼어요!\n보조배터리, 1000원, 지금 당장 필요해요',
    ),
    _TutorialNotificationData(
      timeText: '10분 전',
      message:
          '480m - 수익 기회가 생겼어요!\n우산, 1500원, 지금 당장 필요해요',
    ),
  ];

  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-4');
  }

  void _skip(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _goPrevious(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-2');
  }

  void _goToPage(BuildContext context, int index) {
    if (index == 2) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -150) {
      _goNext(context);
    } else if (velocity > 150) {
      _goPrevious(context);
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
                    currentIndex: 2,
                    totalCount: 5,
                    onDotTap: (index) => _goToPage(context, index),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _skip(context),
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
            Positioned(
              top: 151,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  for (int index = 0; index < _notifications.length; index++) ...[
                    _AnimatedNotificationCard(
                      animation: CurvedAnimation(
                        parent: _staggerController,
                        curve: Interval(
                          0.08 + (index * 0.18),
                          0.62 + (index * 0.18),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      emphasize: index == 0,
                      child: _TutorialNotificationCard(
                        data: _notifications[index],
                      ),
                    ),
                    if (index != _notifications.length - 1)
                      const SizedBox(height: 7),
                  ],
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
      ),
    );
  }
}

class _TutorialNotificationCard extends StatelessWidget {
  const _TutorialNotificationCard({
    required this.data,
  });

  final _TutorialNotificationData data;

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
              data.timeText,
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
              data.message,
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

class _AnimatedNotificationCard extends StatelessWidget {
  const _AnimatedNotificationCard({
    required this.animation,
    required this.child,
    required this.emphasize,
  });

  final Animation<double> animation;
  final Widget child;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final translateY = (1 - animation.value) * 26;
        final scale = 0.96 + (animation.value * 0.04);
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: Container(
                decoration: emphasize
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      )
                    : null,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TutorialNotificationData {
  final String timeText;
  final String message;

  const _TutorialNotificationData({
    required this.timeText,
    required this.message,
  });
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
