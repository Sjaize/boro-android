import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['빌려주세요', '빌려드려요'];

  static const List<_MyPostItem> _items = [
    _MyPostItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
    _MyPostItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
    _MyPostItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
    _MyPostItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
    ),
  ];

  void _showPendingMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '내가 쓴 글',
        showBackButton: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTab = i;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgPage,
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTab == i
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: _selectedTab == i ? 2 : 1,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _tabs[i],
                          style: AppTypography.b4.copyWith(
                            color: _selectedTab == i
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _MyPostCard(
                  item: item,
                  onMoreTap: () => _showPendingMessage('더보기'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MyPostCard extends StatelessWidget {
  const _MyPostCard({
    required this.item,
    required this.onMoreTap,
  });

  final _MyPostItem item;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MyPostThumbnail(),
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
                    const _MyPostMeta(icon: Icons.chat_bubble_outline, count: '0'),
                    const SizedBox(width: 10),
                    const _MyPostMeta(icon: Icons.favorite_border, count: '0'),
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

class _MyPostThumbnail extends StatelessWidget {
  const _MyPostThumbnail();

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

class _MyPostMeta extends StatelessWidget {
  const _MyPostMeta({
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

class _MyPostItem {
  final String title;
  final String distance;
  final String timeAgo;
  final String price;
  final String unit;

  const _MyPostItem({
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.price,
    required this.unit,
  });
}
