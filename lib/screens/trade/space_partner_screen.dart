import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_banner.dart';
import '../../widgets/common_home_header.dart';
import '../../widgets/primary_add_fab.dart';

class SpacePartnerScreen extends StatelessWidget {
  const SpacePartnerScreen({super.key});

  PostItem _fallbackPost(String id) {
    return PostItem(
      id: id,
      title: '보조배터리 빌려드려요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '영통동',
      timeAgo: '방금 전',
      authorName: '닉네임',
      authorId: 'space_partner_$id',
      description: '보조배터리가 필요하신 분께 잠시 빌려드려요.',
      distance: '150m',
      likeCount: 0,
      chatCount: 0,
    );
  }

  PostItem _lendPostAt(int index, String id) {
    if (index < MockData.posts.length) {
      return MockData.posts[index];
    }
    return _fallbackPost(id);
  }

  List<_PartnerTradeListItem> get _items => [
        _PartnerTradeListItem(
          post: _lendPostAt(0, 'partner_0'),
          title: '보조배터리 빌려드려요',
          distance: '150m',
          timeAgo: '방금 전',
          priceText: '1,100원',
          isOfficialPartner: true,
          thumbAsset: 'assets/images/search_result_powerbank.jpg',
        ),
        _PartnerTradeListItem(
          post: _lendPostAt(1, 'partner_1'),
          title: '충전기 빌려드려요',
          distance: '150m',
          timeAgo: '2분 전',
          priceText: '1,100원',
          thumbAsset: 'assets/images/search_result_powerbank.jpg',
        ),
        _PartnerTradeListItem(
          post: _lendPostAt(2, 'partner_2'),
          title: '우산 빌려드려요',
          distance: '180m',
          timeAgo: '2분 전',
          priceText: '1,100원',
          thumbAsset: 'assets/images/search_result_powerbank.jpg',
        ),
        _PartnerTradeListItem(
          post: _lendPostAt(3, 'partner_3'),
          title: '교재 빌려드려요',
          distance: '250m',
          timeAgo: '2분 전',
          priceText: '1,100원',
          thumbAsset: 'assets/images/search_result_powerbank.jpg',
        ),
      ];

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/trade');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat-list');
        break;
      case 3:
        Navigator.pushNamed(context, '/mypage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: 1,
        onTap: (index) => _onNavTap(context, index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 1, bottom: 0),
        child: Transform.translate(
          offset: const Offset(2, 2),
          child: PrimaryAddFab(
            onTap: () => Navigator.pushNamed(context, '/post-create'),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CommonHomeHeader(
              title: '지역명',
              onSearchTap: () => Navigator.pushNamed(context, '/search'),
              onNotificationTap: () =>
                  Navigator.pushNamed(context, '/notification'),
            ),
            const PromoBanner(),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '빌려드려요',
                style: AppTypography.b4.copyWith(color: AppColors.textDark),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _PartnerTradeCard(
                    item: item,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/post-detail',
                      arguments: item.post,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerTradeCard extends StatelessWidget {
  final _PartnerTradeListItem item;
  final VoidCallback onTap;

  const _PartnerTradeCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 138,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider),
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  item.thumbAsset,
                  width: 102,
                  height: 102,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 19, right: 16, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.b4.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (item.isOfficialPartner) ...[
                          const SizedBox(width: 6),
                          const _OfficialPartnerBadge(),
                        ],
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.more_vert,
                          size: 18,
                          color: AppColors.textLight,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${item.distance} · ${item.timeAgo}',
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    if (item.isOfficialPartner) ...[
                      const SizedBox(height: 4),
                      Text(
                        '공식파트너',
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.priceText,
                          style: AppTypography.b1.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          ' / 1시간',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 13,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '0',
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.favorite_border,
                          size: 13,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '0',
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficialPartnerBadge extends StatelessWidget {
  const _OfficialPartnerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_partner_badge_check.svg',
            width: 6,
            height: 4,
          ),
          const SizedBox(width: 4),
          Text(
            '공식 파트너',
            style: AppTypography.c2.copyWith(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerTradeListItem {
  final PostItem post;
  final String title;
  final String distance;
  final String timeAgo;
  final String priceText;
  final String thumbAsset;
  final bool isOfficialPartner;

  const _PartnerTradeListItem({
    required this.post,
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.priceText,
    required this.thumbAsset,
    this.isOfficialPartner = false,
  });
}
