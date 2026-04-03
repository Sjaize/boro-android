import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'mypage_post_model.dart';

class MypagePostCard extends StatelessWidget {
  const MypagePostCard({
    super.key,
    required this.item,
    required this.trailingWidget,
  });

  final MypagePostItem item;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PostThumbnail(),
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
                        trailingWidget,
                      ],
                    ),
                    const SizedBox(height: 4), // 간격을 8에서 4로 줄임
                    Row(
                      children: [
                        Text(
                          item.regionName,
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '·',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                        Text(
                          item.timeAgo,
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32), // 20에서 32로 증가
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
                          '1시간',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        _PostMeta(
                          icon: Icons.chat_bubble_outline,
                          count: '${item.chatCount}',
                        ),
                        const SizedBox(width: 10),
                        _PostMeta(
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
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
        ],
      ),
    );
  }
}

class _PostThumbnail extends StatelessWidget {
  const _PostThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7A7A7A),
            Color(0xFF2F2F2F),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            bottom: 12,
            child: Container(
              width: 48,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFF2D7BC),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 14,
            child: Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostMeta extends StatelessWidget {
  const _PostMeta({
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
