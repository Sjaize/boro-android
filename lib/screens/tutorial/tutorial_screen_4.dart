import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen4 extends StatelessWidget {
  const TutorialScreen4({super.key});

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-5');
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
              child: const _PageIndicator(currentIndex: 3, totalCount: 5),
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
              top: 130,
              left: 23,
              right: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '거래 전후 사진',
                    style: _TutorialSectionLabel.style,
                  ),
                  SizedBox(height: 14),
                  _PhotoPreviewRow(),
                  SizedBox(height: 22),
                  Text(
                    '별점',
                    style: _TutorialSectionLabel.style,
                  ),
                  SizedBox(height: 10),
                  _RatingRow(),
                  SizedBox(height: 22),
                  Text(
                    '매너 평가',
                    style: _TutorialSectionLabel.style,
                  ),
                  SizedBox(height: 14),
                  _MannerTags(),
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
  const _RatingRow();

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
  const _MannerTags();

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
      children: tags.map((tag) {
        final isSelected = tag.$2;
        return Container(
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
        );
      }).toList(),
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
