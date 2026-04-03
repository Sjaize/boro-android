import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/common_app_bar.dart';
import 'mypage_post_card.dart';
import 'mypage_post_model.dart';
import 'mypage_post_service.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final MypageService _mypageService = MypageService();
  int _selectedTab = 0;
  late Future<List<MypagePostItem>> _postsFuture;

  static const List<String> _tabs = ['빌려주세요', '빌려드려요'];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    final postType = _selectedTab == 0 ? 'borrow' : 'lend';
    setState(() {
      _postsFuture = _mypageService.fetchMyPosts(postType: postType);
    });
  }

  void _showPendingMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        title: '내가 쓴 글',
        showBackButton: true,
        backgroundColor: AppColors.white,
        showBottomDivider: false,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: FutureBuilder<List<MypagePostItem>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return _PostsErrorState(
                    message: '내 게시글을 불러오지 못했습니다.',
                    onRetry: _loadPosts,
                  );
                }

                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return _PostsEmptyState(tabLabel: _tabs[_selectedTab]);
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MypagePostCard(
                      item: item,
                      trailingWidget: GestureDetector(
                        onTap: () => _showPendingMessage('더보기'),
                        child: const Icon(
                          Icons.more_vert,
                          color: AppColors.textDark,
                          size: 18,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_selectedTab == i) return;
                  setState(() {
                    _selectedTab = i;
                    _loadPosts();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
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
    );
  }
}

class _PostsErrorState extends StatelessWidget {
  const _PostsErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.textHint,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.b4.copyWith(color: AppColors.textMedium),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsEmptyState extends StatelessWidget {
  const _PostsEmptyState({required this.tabLabel});

  final String tabLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          '$tabLabel 게시글이 아직 없습니다.',
          textAlign: TextAlign.center,
          style: AppTypography.b4.copyWith(color: AppColors.textMedium),
        ),
      ),
    );
  }
}
