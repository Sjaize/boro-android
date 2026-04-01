import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../data/mock_data.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  int _tabIndex = 0; // 0: 빌려주세요, 1: 빌려드려요
  final int _currentNav = 1;
  String _selectedCategory = '급구';

  static const List<String> _categories = [
    '급구', '전체', '생활용품', '전자기기', '전시소품', '패션/의류', '도서/교육', '스포츠/레저', '악기', '잡화/기타',
  ];

  void _onNavTap(int index) {
    if (index == _currentNav) return;
    switch (index) {
      case 0: Navigator.pushReplacementNamed(context, '/home'); break;
      case 2: Navigator.pushNamed(context, '/chat-list'); break;
      case 3: Navigator.pushNamed(context, '/mypage'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = _tabIndex == 0 ? MockData.borrowRequests : MockData.posts;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 광고 배너
          Container(
            height: 80,
            width: double.infinity,
            color: AppColors.divider,
            child: Stack(children: [
              const Center(child: Icon(Icons.image_outlined, color: AppColors.textHint, size: 32)),
              Positioned(
                right: 10,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(17)),
                  child: Text('AD', style: AppTypography.c2.copyWith(color: AppColors.white)),
                ),
              ),
            ]),
          ),
          // 탭
          Row(children: [
            _TabItem(label: '빌려주세요', isActive: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
            _TabItem(label: '빌려드려요', isActive: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
          ]),
          // 카테고리 필터
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: Text(cat,
                          style: AppTypography.b4.copyWith(
                              color: isSelected ? AppColors.white : AppColors.primary)),
                    ),
                  ),
                );
              },
            ),
          ),
          // 정렬
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: SizedBox(
              height: 26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('거리순', style: AppTypography.c2.copyWith(color: AppColors.textMedium)),
                  const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMedium),
                ],
              ),
            ),
          ),
          // 게시글 목록
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _TradeCard(
                  post: posts[index],
                  onTap: () => Navigator.pushNamed(context, '/post-detail', arguments: posts[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post-create'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 24),
      ),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentNav,
        onTap: _onNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgPage,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('지역명', style: AppTypography.h1.copyWith(color: AppColors.textDark)),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textDark, size: 18),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textDark, size: 24),
          onPressed: () => Navigator.pushNamed(context, '/search'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.b4.copyWith(
                color: isActive ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  final PostItem post;
  final VoidCallback onTap;
  const _TradeCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 127,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider),
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            // 썸네일
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 32),
            ),
            const SizedBox(width: 13),
            // 정보
            Expanded(
              child: SizedBox(
                height: 127,
                child: Stack(
                  children: [
                    // 제목 (top 15 + 15 = 30 from card top → ~15px from content top)
                    Positioned(
                      left: 0,
                      top: 20,
                      right: 30,
                      child: Text(
                        post.title,
                        style: AppTypography.b4.copyWith(color: AppColors.textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 거리 · 시간
                    Positioned(
                      left: 0,
                      top: 43,
                      child: Row(
                        children: [
                          Text(post.distance, style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                          Text(' · ', style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                          Text(post.timeAgo, style: AppTypography.c2.copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    // 더보기 아이콘
                    const Positioned(
                      right: 10,
                      top: 15,
                      child: Icon(Icons.more_vert, color: AppColors.textHint, size: 18),
                    ),
                    // 가격
                    Positioned(
                      left: 0,
                      top: 95,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_formatPrice(post.pricePerHour)}원',
                            style: AppTypography.b1.copyWith(
                                color: AppColors.textDark, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 2),
                          Text(' / 1시간',
                              style: AppTypography.c1.copyWith(color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    // 채팅 + 찜 수
                    Positioned(
                      right: 10,
                      top: 95,
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 11, color: AppColors.textLight),
                          const SizedBox(width: 2),
                          Text('0', style: AppTypography.c2.copyWith(color: AppColors.textLight)),
                          const SizedBox(width: 9),
                          const Icon(Icons.favorite_border, size: 11, color: AppColors.textLight),
                          const SizedBox(width: 2),
                          Text('0', style: AppTypography.c2.copyWith(color: AppColors.textLight)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
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
