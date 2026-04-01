import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/post_card.dart';
import '../../data/mock_data.dart';

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
      case 1:
        Navigator.pushNamed(context, '/chat-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/trade');
        break;
      case 3:
        Navigator.pushNamed(context, '/mypage');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post-create'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Text(
        'BORO',
        style: AppTypography.h1.copyWith(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
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
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.divider),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildCategoryChips(),
        Expanded(child: _buildPostList()),
      ],
    );
  }

  Widget _buildCategoryChips() {
    const categories = ['전체', '전자기기', '생활용품', '이동수단', '의류', '도서', '기타'];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _CategoryChip(
              label: categories[index],
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.separated(
      itemCount: MockData.posts.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (context, index) {
        final post = MockData.posts[index];
        return PostCard(
          post: post,
          onTap: () => Navigator.pushNamed(
            context,
            '/post-detail',
            arguments: post,
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.c1.copyWith(
          color: isSelected ? AppColors.white : AppColors.textMedium,
        ),
      ),
    );
  }
}
