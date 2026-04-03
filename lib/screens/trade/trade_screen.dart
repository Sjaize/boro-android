import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_banner.dart';
import '../../widgets/common_home_header.dart';
import '../../widgets/primary_add_fab.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final int _currentNav = 1;

  int _tabIndex = 0;
  String _currentLocationLabel = '지역명';
  String _selectedCategory = '급구';
  String _sortOrder = '거리순';
  bool _isFabOpen = false;
  bool _isSortOpen = false;
  bool _isLocationSheetOpen = false;
  bool _isLoading = true;
  int _selectedLocationIndex = 0;
  List<_TradeListItem> _items = const [];

  static const List<String> _locationLabels = ['위치 1', '위치 2'];
  static const List<String> _categories = [
    '급구',
    '전체',
    '생활용품',
    '전자기기',
    '전시소품',
    '패션/의류',
    '도서/교육',
    '스포츠/레저',
    '악기',
    '잡화/기타',
  ];

  @override
  void initState() {
    super.initState();
    _loadRegionName();
    _loadPosts();
  }

  Future<void> _loadRegionName() async {
    final regionName = await PostService.fetchRegionName();
    if (!mounted || regionName == null || regionName.isEmpty) return;
    setState(() {
      _currentLocationLabel = regionName;
    });
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await PostService.fetchPosts(
      postType: _tabIndex == 0 ? 'BORROW' : 'LEND',
      category: _selectedCategory == '급구' ? _selectedCategory : null,
    );
    if (!mounted) return;

    final mapped = posts.map(_toTradeListItem).toList();
    setState(() {
      _items = _sortOrder == '최신순' ? mapped.reversed.toList() : mapped;
      _isLoading = false;
    });
    if (_selectedCategory != '전체' && _selectedCategory != '급구') {
      setState(() {
        _items = _applyCategoryFilter(_items);
      });
    }
  }

  List<_TradeListItem> _applyCategoryFilter(List<_TradeListItem> items) {
    return items
        .where((item) => _matchesCategory(item.post.category, _selectedCategory))
        .toList();
  }

  bool _matchesCategory(String postCategory, String selectedCategory) {
    final normalizedPost = postCategory.replaceAll(' ', '');
    final normalizedSelected = selectedCategory.replaceAll(' ', '');

    if (normalizedPost == normalizedSelected) {
      return true;
    }

    switch (selectedCategory) {
      case '생활용품':
        return normalizedPost.contains('생활');
      case '전자기기':
        return normalizedPost.contains('전자');
      case '전시소품':
        return normalizedPost.contains('전시');
      case '패션/의류':
        return normalizedPost.contains('패션') || normalizedPost.contains('의류');
      case '도서/교육':
        return normalizedPost.contains('도서') || normalizedPost.contains('교육');
      case '스포츠/레저':
        return normalizedPost.contains('스포츠') || normalizedPost.contains('레저');
      case '악기':
        return normalizedPost.contains('악기');
      case '잡화/기타':
        return normalizedPost.contains('잡화') || normalizedPost.contains('기타');
      default:
        return false;
    }
  }

  _TradeListItem _toTradeListItem(PostItem post) {
    return _TradeListItem(
      post: post,
      title: post.title,
      distance: post.distance.isEmpty ? '250m' : post.distance,
      timeAgo: post.timeAgo,
      priceText: _formatPriceText(post.pricePerHour),
      imageUrl: _normalizedImageUrl(post.imageUrl),
    );
  }

  String _formatPriceText(int price) {
    final value = price <= 0 ? 1100 : price;
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  String? _normalizedImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final lower = imageUrl.toLowerCase();
    if (lower.contains('dummy') ||
        lower.contains('example.com') ||
        lower.contains('picsum.photos')) {
      return null;
    }
    return imageUrl;
  }

  void _onNavTap(int index) {
    if (index == _currentNav) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
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
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentNav,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                CommonHomeHeader(
                  title: _currentLocationLabel,
                  onTitleTap: () => setState(() {
                    _isLocationSheetOpen = true;
                    _isFabOpen = false;
                    _isSortOpen = false;
                  }),
                  onSearchTap: () => Navigator.pushNamed(context, '/search'),
                  onNotificationTap: () =>
                      Navigator.pushNamed(context, '/notification'),
                ),
                const PromoBanner(),
                Row(
                  children: [
                    _TradeTab(
                      label: '빌려주세요',
                      isActive: _tabIndex == 0,
                      onTap: () {
                        setState(() {
                          _tabIndex = 0;
                          _isFabOpen = false;
                          _isSortOpen = false;
                          _isLocationSheetOpen = false;
                        });
                        _loadPosts();
                      },
                    ),
                    _TradeTab(
                      label: '빌려드려요',
                      isActive: _tabIndex == 1,
                      onTap: () {
                        setState(() {
                          _tabIndex = 1;
                          _isFabOpen = false;
                          _isSortOpen = false;
                          _isLocationSheetOpen = false;
                        });
                        _loadPosts();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    itemBuilder: (_, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                            _isFabOpen = false;
                            _isSortOpen = false;
                            _isLocationSheetOpen = false;
                          });
                          _loadPosts();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: AppColors.primary),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: AppTypography.b4.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          _isSortOpen = !_isSortOpen;
                          _isFabOpen = false;
                          _isLocationSheetOpen = false;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                _sortOrder,
                                style: AppTypography.c2.copyWith(
                                  color: AppColors.textMedium,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: AppColors.textMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _items.length,
                          itemBuilder: (_, index) => _TradeCard(
                            item: _items[index],
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/post-detail',
                              arguments: _items[index].post,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            if (_isFabOpen || _isSortOpen || _isLocationSheetOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _isFabOpen = false;
                    _isSortOpen = false;
                    _isLocationSheetOpen = false;
                  }),
                  child: Container(
                    color: (_isFabOpen || _isLocationSheetOpen)
                        ? Colors.black.withValues(alpha: 0.55)
                        : Colors.transparent,
                  ),
                ),
              ),
            if (_isLocationSheetOpen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _LocationSelectionSheet(
                  selectedIndex: _selectedLocationIndex,
                  onSelect: (index) => setState(() {
                    _selectedLocationIndex = index;
                  }),
                  onConfirm: () => setState(() {
                    _currentLocationLabel =
                        _locationLabels[_selectedLocationIndex];
                    _isLocationSheetOpen = false;
                  }),
                  onChangeLocation: () async {
                    setState(() => _isLocationSheetOpen = false);
                    final result =
                        await Navigator.pushNamed(context, '/location-search');
                    if (!mounted) return;
                    if (result is String && result.isNotEmpty) {
                      setState(() => _currentLocationLabel = result);
                    }
                  },
                ),
              ),
            if (_isSortOpen)
              Positioned(
                top: 250,
                right: 16,
                child: Container(
                  width: 121,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15.3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SortMenuItem(
                        label: '거리순',
                        onTap: () {
                          setState(() {
                            _sortOrder = '거리순';
                            _isSortOpen = false;
                          });
                          _loadPosts();
                        },
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _SortMenuItem(
                        label: '최신순',
                        onTap: () {
                          setState(() {
                            _sortOrder = '최신순';
                            _isSortOpen = false;
                          });
                          _loadPosts();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              right: 10,
              bottom: 18,
              child: Transform.translate(
                offset: const Offset(2, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isFabOpen) ...[
                      _SplitFabMenuPanel(
                        onUrgentTap: () {
                          setState(() {
                            _isFabOpen = false;
                          });
                          Navigator.pushNamed(
                            context,
                            '/post-create',
                            arguments: const {'type': 'urgent'},
                          );
                        },
                        onBorrowTap: () {
                          setState(() {
                            _isFabOpen = false;
                          });
                          Navigator.pushNamed(
                            context,
                            '/post-create',
                            arguments: const {'type': 'borrow'},
                          );
                        },
                        onLendTap: () {
                          setState(() {
                            _isFabOpen = false;
                          });
                          Navigator.pushNamed(
                            context,
                            '/post-create',
                            arguments: const {'type': 'lend'},
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    PrimaryAddFab(
                      onTap: () => setState(() {
                        _isFabOpen = !_isFabOpen;
                        _isSortOpen = false;
                        _isLocationSheetOpen = false;
                      }),
                      icon: _isFabOpen ? Icons.close : Icons.add,
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

class _TradeTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TradeTab({
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
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : AppColors.divider,
                width: isActive ? 2 : 1,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.b4.copyWith(
              color: isActive ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _TradeCard extends StatelessWidget {
  final _TradeListItem item;
  final VoidCallback onTap;

  const _TradeCard({
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
              child: _TradeThumbnail(imageUrl: item.imageUrl),
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
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.b4.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
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
                          '${item.post.chatCount}',
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
                          '${item.post.likeCount}',
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

class _TradeThumbnail extends StatelessWidget {
  final String? imageUrl;

  const _TradeThumbnail({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final child = imageUrl == null
        ? Image.asset(
            'assets/images/search_result_powerbank.jpg',
            width: 102,
            height: 102,
            fit: BoxFit.cover,
          )
        : Image.network(
            imageUrl!,
            width: 102,
            height: 102,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/search_result_powerbank.jpg',
              width: 102,
              height: 102,
              fit: BoxFit.cover,
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: child,
    );
  }
}

class _OfficialPartnerCheckBadge extends StatelessWidget {
  const _OfficialPartnerCheckBadge();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ic_partner_badge.svg',
      width: 19,
      height: 24,
    );
  }
}

class _OfficialPartnerPill extends StatelessWidget {
  const _OfficialPartnerPill();

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

class _SplitFabMenuPanel extends StatelessWidget {
  final VoidCallback onUrgentTap;
  final VoidCallback onBorrowTap;
  final VoidCallback onLendTap;

  const _SplitFabMenuPanel({
    required this.onUrgentTap,
    required this.onBorrowTap,
    required this.onLendTap,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration panelDecoration() => BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 121,
          decoration: panelDecoration(),
          child: _SplitFabMenuItem(
            iconAsset: 'assets/icons/ic_urgent_outline.svg',
            label: '긴급',
            onTap: onUrgentTap,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 121,
          decoration: panelDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SplitFabMenuItem(
                iconAsset: 'assets/icons/ic_borrow_outline.svg',
                label: '빌려주세요',
                onTap: onBorrowTap,
              ),
              const Divider(height: 1, color: AppColors.divider),
              _SplitFabMenuItem(
                iconAsset: 'assets/icons/ic_lend_outline.svg',
                label: '빌려드려요',
                onTap: onLendTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SplitFabMenuItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const _SplitFabMenuItem({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: 14, height: 14),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: AppTypography.b4.copyWith(color: AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortMenuItem({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Text(
          label,
          style: AppTypography.c2.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LocationSelectionSheet extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onConfirm;
  final VoidCallback onChangeLocation;

  const _LocationSelectionSheet({
    required this.selectedIndex,
    required this.onSelect,
    required this.onConfirm,
    required this.onChangeLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '내 위치 설정',
              style: AppTypography.b2.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '현재 위치를 변경할 수 있어요.',
              style: AppTypography.c2.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 18),
            _LocationOptionRow(
              label: '위치 1',
              selected: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
            const SizedBox(height: 14),
            _LocationOptionRow(
              label: '위치 2',
              selected: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  '확인',
                  style: AppTypography.b3.copyWith(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onChangeLocation,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  '위치 변경하기',
                  style: AppTypography.b3.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationOptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LocationOptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: AppTypography.b4.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeListItem {
  final PostItem post;
  final String title;
  final String distance;
  final String timeAgo;
  final String priceText;
  final String? imageUrl;

  const _TradeListItem({
    required this.post,
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.priceText,
    this.imageUrl,
  });
}
