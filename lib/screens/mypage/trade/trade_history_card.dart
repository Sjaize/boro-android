import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'trade_history_model.dart';

class TradeHistoryCard extends StatelessWidget {
  const TradeHistoryCard({
    super.key,
    required this.item,
    required this.onMoreTap,
    required this.onReviewTap,
  });

  final TradeHistoryItem item;
  final VoidCallback onMoreTap;
  final VoidCallback onReviewTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TradeThumbnail(
                status: item.status,
                imageUrl: item.postImageUrl,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTypography.b4.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onMoreTap,
                          child: const Icon(
                            Icons.more_vert,
                            color: AppColors.textDark,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.timeAgo,
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // 12에서 24로 증가
                    Row(
                      children: [
                        Text(
                          item.priceText,
                          style: AppTypography.b1.copyWith(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          item.rentalPeriodText,
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        MetaIconCount(
                          icon: Icons.chat_bubble_outline,
                          count: '${item.chatCount}',
                        ),
                        const SizedBox(width: 10),
                        MetaIconCount(
                          icon: Icons.favorite_border,
                          count: '${item.likeCount}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onReviewTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                item.reviewButtonText,
                style: AppTypography.b2.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
        ],
      ),
    );
  }
}

class TradeThumbnail extends StatelessWidget {
  const TradeThumbnail({
    super.key,
    required this.status,
    required this.imageUrl,
  });

  final String status;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: hasImage
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5C5C5C),
                  Color(0xFF1E1E1E),
                ],
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasImage
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            left: 14,
            bottom: 18,
            child: Container(
              width: 42,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withValues(alpha: 0.26),
              ),
              alignment: Alignment.center,
              child: Text(
                status,
                style: AppTypography.b4.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetaIconCount extends StatelessWidget {
  const MetaIconCount({
    required this.icon,
    required this.count,
  });

  final IconData icon;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 2),
        Text(
          count,
          style: AppTypography.c2.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }
}
