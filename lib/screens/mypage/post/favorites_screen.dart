import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/common_app_bar.dart';
import 'mypage_post_card.dart';
import 'mypage_post_model.dart';
import 'mypage_post_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MypageService _mypageService = MypageService();
  List<MypagePostItem>? _favorites;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await _mypageService.fetchFavorites();
      if (mounted) {
        setState(() {
          _favorites = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '관심 목록을 불러오지 못했습니다.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleUnlike(int postId) async {
    final success = await _mypageService.unlikePost(postId);
    if (success) {
      if (mounted) {
        setState(() {
          _favorites?.removeWhere((item) => item.postId == postId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('관심 등록을 해제했습니다.')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('관심 등록 해제에 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        title: '관심 목록',
        showBackButton: true,
        showBottomDivider: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return _FavoritesErrorState(onRetry: _loadFavorites);
    }

    final items = _favorites ?? const [];
    if (items.isEmpty) {
      return const _FavoritesEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MypagePostCard(
          item: item,
          trailingWidget: GestureDetector(
            onTap: () => _handleUnlike(item.postId),
            child: const Icon(
              Icons.favorite,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

class _FavoritesErrorState extends StatelessWidget {
  const _FavoritesErrorState({required this.onRetry});

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
              '관심 목록을 불러오지 못했습니다.',
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

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          '관심 등록한 게시글이 아직 없습니다.',
          textAlign: TextAlign.center,
          style: AppTypography.b4.copyWith(color: AppColors.textMedium),
        ),
      ),
    );
  }
}
