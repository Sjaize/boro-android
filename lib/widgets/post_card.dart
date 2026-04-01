import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../data/mock_data.dart';

class PostCard extends StatelessWidget {
  final PostItem post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 88,
                height: 88,
                color: AppColors.bgCard,
                child: post.imageUrl != null
                    ? Image.network(
                        post.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => const _PlaceholderImage(),
                      )
                    : const _PlaceholderImage(),
              ),
            ),
            const SizedBox(width: 12),
            // 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 칩
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      post.category,
                      style: AppTypography.c1.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 제목
                  Text(
                    post.title,
                    style: AppTypography.b2.copyWith(color: AppColors.textDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // 위치 + 시간
                  Text(
                    '${post.location} · ${post.timeAgo}',
                    style: AppTypography.c2.copyWith(color: AppColors.textHint),
                  ),
                  const SizedBox(height: 6),
                  // 가격
                  Row(
                    children: [
                      Text(
                        '${_formatPrice(post.pricePerHour)}원',
                        style: AppTypography.b1.copyWith(color: AppColors.textDark),
                      ),
                      Text(
                        '/시간',
                        style: AppTypography.c1.copyWith(color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, color: AppColors.textHint, size: 32),
    );
  }
}
