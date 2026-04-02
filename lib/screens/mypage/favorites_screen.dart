import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const List<_FavoriteItem> _items = [
    _FavoriteItem(
      title: '우산 빌려드려요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
    _FavoriteItem(
      title: '우산 빌려드려요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '관심 목록',
        showBackButton: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: _items.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _FavoriteCard(item: item);
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.item});

  final _FavoriteItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FavoriteThumbnail(),
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
                    const Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.distance,
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      item.price,
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
                      item.unit,
                      style: AppTypography.c1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const Spacer(),
                    const _FavoriteMeta(icon: Icons.chat_bubble_outline, count: '0'),
                    const SizedBox(width: 10),
                    const _FavoriteMeta(icon: Icons.favorite_border, count: '0'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteThumbnail extends StatelessWidget {
  const _FavoriteThumbnail();

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
            Color(0xFF7B7B7B),
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
                color: const Color(0xFFF0D3B8),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
          Positioned(
            right: 12,
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

class _FavoriteMeta extends StatelessWidget {
  const _FavoriteMeta({
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

class _FavoriteItem {
  final String title;
  final String distance;
  final String timeAgo;
  final String price;
  final String unit;

  const _FavoriteItem({
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.price,
    required this.unit,
  });
}
