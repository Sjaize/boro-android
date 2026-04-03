import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class SearchResultItem {
  final String id;
  final String title;
  final String distance;
  final String timeAgo;
  final int pricePerHour;
  final int chatCount;
  final int likeCount;
  final SearchThumbnailVariant thumbnail;
  final PostItem? sourcePost;

  const SearchResultItem({
    required this.id,
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.pricePerHour,
    required this.chatCount,
    required this.likeCount,
    required this.thumbnail,
    this.sourcePost,
  });
}

enum SearchThumbnailVariant {
  powerbankDark,
  powerbankWhite,
  powerbankCable,
}

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showHint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;

  const SearchInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.showHint,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTypography.c2.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: showHint ? '필요한 물건을 검색해보세요' : '',
                hintStyle: AppTypography.c2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSearchTap,
            child: SvgPicture.asset(
              'assets/icons/ic_search_input.svg',
              width: 15,
              height: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchSectionHeader extends StatelessWidget {
  final String title;

  const SearchSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: AppTypography.h3.copyWith(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class RecentSearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const RecentSearchChip({
    super.key,
    required this.label,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.textHint),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.c2.copyWith(
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
                size: 10,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularSearchRow extends StatelessWidget {
  final int rank;
  final String label;
  final VoidCallback onTap;

  const PopularSearchRow({
    super.key,
    required this.rank,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              '$rank',
              style: AppTypography.b4.copyWith(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 18),
            Text(
              label,
              style: AppTypography.b4.copyWith(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SearchTab({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.b4.copyWith(
              color: isActive ? AppColors.textDark : AppColors.textLight,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultCard extends StatelessWidget {
  final SearchResultItem item;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 144,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            SearchResultThumbnail(variant: item.thumbnail),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 118,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 12,
                      right: 26,
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.b4.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 42,
                      child: Text(
                        '${item.distance} · ${item.timeAgo}',
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 6,
                      top: 10,
                      child: Icon(
                        Icons.more_vert,
                        color: AppColors.textHint,
                        size: 18,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_formatPrice(item.pricePerHour)}원',
                            style: AppTypography.b1.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ' / 1시간',
                            style: AppTypography.c1.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 6,
                      bottom: 10,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 11,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.chatCount}',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.favorite_border,
                            size: 11,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.likeCount}',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final value = price <= 0 ? 1100 : price;
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}

class SearchResultThumbnail extends StatelessWidget {
  final SearchThumbnailVariant variant;

  const SearchResultThumbnail({
    super.key,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 104,
        height: 118,
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: _gradient),
          child: Stack(children: _children),
        ),
      ),
    );
  }

  Gradient get _gradient {
    switch (variant) {
      case SearchThumbnailVariant.powerbankDark:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5E1DB), Color(0xFFCFC8BF)],
        );
      case SearchThumbnailVariant.powerbankWhite:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F8F8), Color(0xFFE7E7E7)],
        );
      case SearchThumbnailVariant.powerbankCable:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCFCFD), Color(0xFFEAEFF8)],
        );
    }
  }

  List<Widget> get _children {
    switch (variant) {
      case SearchThumbnailVariant.powerbankDark:
        return [
          Positioned(
            left: 8,
            bottom: 12,
            child: Transform.rotate(
              angle: -0.22,
              child: Container(
                width: 24,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1F22),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 10,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 38,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D33),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ];
      case SearchThumbnailVariant.powerbankWhite:
        return [
          Positioned(
            left: 8,
            top: 18,
            child: Container(
              width: 72,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFE3E3E3)),
              ),
            ),
          ),
          Positioned(
            left: 26,
            top: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ];
      case SearchThumbnailVariant.powerbankCable:
        return [
          Positioned(
            left: 16,
            top: 20,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 30,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFDCE3F2)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 46,
            top: 16,
            child: Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2F6FE4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            left: 54,
            top: 18,
            child: Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4B83F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ];
    }
  }
}
