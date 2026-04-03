import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen4 extends StatefulWidget {
  const TutorialScreen4({super.key});

  @override
  State<TutorialScreen4> createState() => _TutorialScreen4State();
}

class _TutorialScreen4State extends State<TutorialScreen4>
    with SingleTickerProviderStateMixin {
  static const List<String> _routes = [
    '/tutorial-1',
    '/tutorial-2',
    '/tutorial-3',
    '/tutorial-4',
    '/tutorial-5',
  ];

  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-5');
  }

  void _skip(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _goPrevious(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-3');
  }

  void _goToPage(BuildContext context, int index) {
    if (index == 3) return;
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
                      currentIndex: 3,
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
                top: 130,
                left: 23,
                right: 22,
                bottom: 304,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '거래 전후 사진',
                      style: _TutorialSectionLabel.style,
                    ),
                    const SizedBox(height: 14),
                    _AnimatedReveal(
                      animation: CurvedAnimation(
                        parent: _revealController,
                        curve:
                            const Interval(0.0, 0.34, curve: Curves.easeOutCubic),
                      ),
                      child: const _PhotoPreviewRow(),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      '별점',
                      style: _TutorialSectionLabel.style,
                    ),
                    const SizedBox(height: 10),
                    _RatingRow(controller: _revealController),
                    const SizedBox(height: 22),
                    const Text(
                      '매너 평가',
                      style: _TutorialSectionLabel.style,
                    ),
                    const SizedBox(height: 14),
                    _MannerTags(controller: _revealController),
                  ],
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
                          '안전한 거래를 위해 사진 인증과\n평가 시스템이 제공돼요.',
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

class _TutorialSectionLabel {
  static const TextStyle style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    fontFamily: AppTypography.fontFamily,
    height: 1,
  );
}

class _AnimatedReveal extends StatelessWidget {
  const _AnimatedReveal({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final translateY = (1 - animation.value) * 18;
        final scale = 0.97 + (animation.value * 0.03);
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _PhotoPreviewRow extends StatelessWidget {
  const _PhotoPreviewRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              'assets/images/search_result_powerbank.jpg',
              height: 177,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              'assets/images/search_result_powerbank.jpg',
              height: 177,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < 4;
        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : 9),
          child: Icon(
            Icons.star,
            size: 35,
            color: isFilled ? AppColors.primary : const Color(0xFFD9D9D9),
          ),
        );
      }),
    );
  }
}

class _MannerTags extends StatelessWidget {
  const _MannerTags({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final tags = [
      ('거래 약속을 잘 지켜요', true),
      ('친절하고 매너가 좋아요', false),
      ('응답이 빨라요', false),
      ('꼭 필요한 문의만 해요', false),
      ('물건 상태가 좋아요', false),
      ('또 거래하고 싶어요', false),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;
        final isSelected = tag.$2;
        return _AnimatedReveal(
          animation: CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.42 + (index * 0.05),
              0.67 + (index * 0.05),
              curve: Curves.easeOutCubic,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.bgPage,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              tag.$1,
              style: AppTypography.c2.copyWith(
                color: isSelected ? AppColors.white : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
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
