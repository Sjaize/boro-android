import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class TradeHistoryScreen extends StatefulWidget {
  const TradeHistoryScreen({super.key});

  @override
  State<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['내가 빌린 물건', '내가 빌려준 물건'];

  static const List<_TradeHistoryItem> _items = [
    _TradeHistoryItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
      reviewButtonText: '받은 후기 보기',
      status: '거래 완료',
    ),
    _TradeHistoryItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
      reviewButtonText: '받은 후기 보기',
      status: '거래 완료',
    ),
    _TradeHistoryItem(
      title: '보조배터리 구해요',
      distance: '150m',
      timeAgo: '방금 전',
      price: '1,100원',
      unit: '1시간',
      reviewButtonText: '받은 후기 보기',
      status: '거래 완료',
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
        title: '거래내역',
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
                return _TradeHistoryCard(
                  item: item,
                  onMoreTap: () => _showPendingMessage('더보기'),
                  onReviewTap: () => _showPendingMessage(item.reviewButtonText),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeHistoryCard extends StatelessWidget {
  const _TradeHistoryCard({
    required this.item,
    required this.onMoreTap,
    required this.onReviewTap,
  });

  final _TradeHistoryItem item;
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
              _TradeThumbnail(status: item.status),
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
                        const _MetaIconCount(
                          icon: Icons.chat_bubble_outline,
                          count: '0',
                        ),
                        const SizedBox(width: 10),
                        const _MetaIconCount(
                          icon: Icons.favorite_border,
                          count: '0',
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
        ],
      ),
    );
  }
}

class _TradeThumbnail extends StatelessWidget {
  const _TradeThumbnail({required this.status});

  final String status;

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
            Color(0xFF5C5C5C),
            Color(0xFF1E1E1E),
          ],
        ),
      ),
      child: Stack(
        children: [
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

class _MetaIconCount extends StatelessWidget {
  const _MetaIconCount({
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

class _TradeHistoryItem {
  final String title;
  final String distance;
  final String timeAgo;
  final String price;
  final String unit;
  final String reviewButtonText;
  final String status;

  const _TradeHistoryItem({
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.price,
    required this.unit,
    required this.reviewButtonText,
    required this.status,
  });
}
