import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:boro_android/data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    switch (index) {
      case 1: Navigator.pushNamed(context, '/trade'); break;
      case 2: Navigator.pushNamed(context, '/chat-list'); break;
      case 3: Navigator.pushNamed(context, '/mypage'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdBanner(),
            _buildUrgentSection(),
            _buildFrequentSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post-create'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 24),
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
            Text('지역명',
                style: AppTypography.h1.copyWith(color: AppColors.textDark)),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textDark, size: 18),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textDark, size: 24),
          onPressed: () => Navigator.pushNamed(context, '/search'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textDark, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildAdBanner() {
    return Container(
      height: 80,
      width: double.infinity,
      color: AppColors.divider,
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.image_outlined, color: AppColors.textHint, size: 32),
          ),
          Positioned(
            right: 10,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Text('AD',
                  style: AppTypography.c2.copyWith(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('긴급',
                  style: AppTypography.h2.copyWith(color: AppColors.textDark)),
              Text('더보기',
                  style: AppTypography.c2.copyWith(color: AppColors.textLight)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: MockData.urgentRequests.length,
            itemBuilder: (context, index) {
              final item = MockData.urgentRequests[index];
              return _UrgentCard(item: item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrequentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Text('회원님이 자주 찾는 물건',
              style: AppTypography.h3.copyWith(color: AppColors.textDark)),
        ),
        const SizedBox(height: 8),
        ...MockData.frequentItems.map((item) => _FrequentItem(label: item)),
      ],
    );
  }
}

class _UrgentCard extends StatelessWidget {
  final UrgentRequest item;
  const _UrgentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 170,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          // 하트 아이콘
          Positioned(
            top: 15,
            right: 10,
            child: SvgPicture.asset(
              'assets/icons/ic_home.svg',
              width: 11,
              height: 12,
              colorFilter: const ColorFilter.mode(
                  AppColors.white, BlendMode.srcIn),
            ),
          ),
          // 내용
          Positioned(
            left: 10,
            right: 10,
            top: 12,
            bottom: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.timeAgo,
                    style: AppTypography.c2.copyWith(color: AppColors.white)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: AppTypography.c1.copyWith(
                            color: AppColors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(item.duration,
                        style: AppTypography.c2.copyWith(color: AppColors.white)),
                  ],
                ),
              ],
            ),
          ),
          // 채팅하기 버튼
          Positioned(
            left: 10,
            right: 10,
            bottom: 8,
            child: Container(
              height: 21,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text('채팅하기',
                    style: AppTypography.c2.copyWith(color: AppColors.primary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequentItem extends StatelessWidget {
  final String label;
  const _FrequentItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(17, 0, 17, 5),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.b4.copyWith(
                  color: AppColors.textDark, fontWeight: FontWeight.w600)),
          const Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}
