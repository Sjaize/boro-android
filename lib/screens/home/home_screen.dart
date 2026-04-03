import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_banner.dart';
import '../../widgets/common_cards.dart';
import '../../widgets/common_carousel.dart';
import '../../widgets/common_home_header.dart';
import '../../widgets/primary_add_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  bool _isFabOpen = false;
  String _currentRegionName = '지역명';

  static const List<_UrgentCardData> _urgentItems = [
    _UrgentCardData('방금 전', '보조배터리 구해요', '1시간 동안'),
    _UrgentCardData('2분 전', '정장 구합니다', '1일 동안'),
    _UrgentCardData('5분 전', '충전기 빌려주실 분', '1일 동안'),
    _UrgentCardData('10분 전', '우산 필요해요', '3시간 동안'),
    _UrgentCardData('30분 전', '보조배터리가 필요해요', '1일 동안'),
  ];

  static const List<String> _frequentItems = [
    '보조배터리',
    '충전기',
    '우산',
    '교재',
  ];

  @override
  void initState() {
    super.initState();
    _loadRegionName();
  }

  Future<void> _loadRegionName() async {
    final regionName = await PostService.fetchRegionName();
    if (!mounted || regionName == null || regionName.isEmpty) return;
    setState(() => _currentRegionName = regionName);
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _isFabOpen = false);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/trade');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat-list');
        break;
      case 3:
        Navigator.pushNamed(context, '/mypage');
        break;
    }
  }

  void _closeFabMenu() {
    if (!_isFabOpen) return;
    setState(() => _isFabOpen = false);
  }

  void _openPostCreateByType(String type) {
    setState(() => _isFabOpen = false);
    Navigator.pushNamed(context, '/post-create', arguments: {'type': type});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 1, bottom: 0),
        child: Transform.translate(
          offset: const Offset(2, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isFabOpen) ...[
                _SplitFabMenuPanel(
                  onUrgentTap: () => _openPostCreateByType('urgent'),
                  onBorrowTap: () => _openPostCreateByType('borrow'),
                  onLendTap: () => _openPostCreateByType('lend'),
                ),
                const SizedBox(height: 12),
              ],
              PrimaryAddFab(
                onTap: () => setState(() => _isFabOpen = !_isFabOpen),
                icon: _isFabOpen ? Icons.close : Icons.add,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHomeHeader(
                    title: _currentRegionName,
                    onSearchTap: () => Navigator.pushNamed(context, '/search'),
                    onNotificationTap: () =>
                        Navigator.pushNamed(context, '/notification'),
                  ),
                  const PromoBanner(),
                  const SizedBox(height: 30),
                  const _SectionHeader(
                    title: '긴급',
                    actionLabel: '더보기',
                  ),
                  const SizedBox(height: 28),
                  CommonHorizontalCarousel(
                    height: 176,
                    itemCount: _urgentItems.length,
                    spacing: 10,
                    itemBuilder: (_, index) {
                      final item = _urgentItems[index];
                      return UrgentRequestCard(
                        timeText: item.timeText,
                        title: item.title,
                        duration: item.duration,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '회원들이 자주 찾는 물건',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textDark,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ..._frequentItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: _FrequentItem(
                        label: item,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/search',
                          arguments: item,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 82),
                ],
              ),
            ),
            if (_isFabOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeFabMenu,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
              ),
          ],
        ),
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

// ignore: unused_element
class _HomeHeader extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationTap;

  const _HomeHeader({
    required this.onSearchTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Row(
          children: [
            Text(
              '지역명',
              style: AppTypography.h1.copyWith(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: SvgPicture.asset(
                'assets/icons/ic_chevron_down.svg',
                width: 14,
                height: 8,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: onSearchTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/icons/ic_search.svg',
                  width: 19,
                  height: 19,
                ),
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: onNotificationTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/icons/ic_bell.svg',
                  width: 20,
                  height: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.h2.copyWith(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                actionLabel!,
                style: AppTypography.c2.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UrgentCardData {
  final String timeText;
  final String title;
  final String duration;

  const _UrgentCardData(this.timeText, this.title, this.duration);
}

class _FrequentItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FrequentItem({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Text(
              label,
              style: AppTypography.b4.copyWith(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 13,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
