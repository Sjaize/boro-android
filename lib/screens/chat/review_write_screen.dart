import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class ReviewWriteScreen extends StatefulWidget {
  const ReviewWriteScreen({super.key});

  @override
  State<ReviewWriteScreen> createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  final TextEditingController _reviewController =
      TextEditingController(text: '좋은 거래 감사합니다.');

  int _selectedStarCount = 4;
  final Set<String> _selectedTags = {
    '거래 약속을 잘 지켜요',
    '친절하고 매너가 좋아요',
    '응답이 빨라요',
    '물건 상태가 좋아요',
  };

  static const List<String> _tags = [
    '거래 약속을 잘 지켜요',
    '친절하고 매너가 좋아요',
    '응답이 빨라요',
    '꼭 필요한 문의만 해요',
    '물건 상태가 좋아요',
    '또 거래하고 싶어요',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        title: '후기 작성',
        showBackButton: true,
        showBottomDivider: false, // 회색 줄 제거
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: '거래 전후 사진'),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: _ReviewImageCard()),
                        SizedBox(width: 4),
                        Expanded(child: _ReviewImageCard()),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _SectionTitle(title: '별점'),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isFilled = index < _selectedStarCount;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStarCount = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Icon(
                              Icons.star_rounded,
                              size: 52,
                              color: isFilled
                                  ? AppColors.primary
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 42),
                    _SectionTitle(title: '매너 평가'),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in _tags)
                          _ReviewTagChip(
                            label: tag,
                            isSelected: _selectedTags.contains(tag),
                            onTap: () => _toggleTag(tag),
                          ),
                      ],
                    ),
                    const SizedBox(height: 42),
                    _SectionTitle(title: '후기를 더 자세히 적어주세요'),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      height: 112,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        minLines: 5,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textDark,
                          fontSize: 12,
                          height: 1.35,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: AppColors.white, // 하단 배경 흰색으로 변경
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/review-complete');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    '등록',
                    style: AppTypography.b2.copyWith(color: AppColors.white),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        color: AppColors.textDark,
        fontSize: 18,
      ),
    );
  }
}

class _ReviewImageCard extends StatelessWidget {
  const _ReviewImageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 218,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD7D8D9),
            Color(0xFF9EA1A7),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 20,
            child: Container(
              width: 52,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF927259),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 38,
            child: Container(
              width: 4,
              height: 66,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          Positioned(
            right: 18,
            top: 24,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFF2F3338),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 94,
            child: Container(
              width: 4,
              height: 88,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTagChip extends StatelessWidget {
  const _ReviewTagChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: AppTypography.b4.copyWith(
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
