import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/skeleton.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';

  bool _isLoading = true;
  List<_FavoriteItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      if (!PostService.isAuthenticated) {
        setState(() => _isLoading = false);
        return;
      }
      final uri = Uri.parse('$_baseUrl/api/users/me/likes')
          .replace(queryParameters: {'page': '1', 'size': '30'});
      final client = HttpClient();
      try {
        final request = await client.getUrl(uri);
        request.headers.set(HttpHeaders.acceptHeader, 'application/json');
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer ${PostService.accessToken}',
        );
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        if (response.statusCode == 200) {
          final decoded = jsonDecode(body) as Map<String, dynamic>;
          final posts = (decoded['data']['posts'] as List<dynamic>? ?? []);
          if (!mounted) return;
          setState(() {
            _items = posts.map((p) {
              final map = p as Map<String, dynamic>;
              final price = (map['price'] as num?)?.toInt() ?? 0;
              return _FavoriteItem(
                postId: map['post_id'].toString(),
                title: map['title'] as String? ?? '',
                regionName: map['region_name'] as String? ?? '',
                price: price,
                likeCount: (map['like_count'] as num?)?.toInt() ?? 0,
                chatCount: (map['chat_count'] as num?)?.toInt() ?? 0,
                status: map['status'] as String? ?? '',
                createdAt: map['created_at'] as String? ?? '',
                thumbnailUrl: map['thumbnail_url'] as String?,
              );
            }).toList();
            _isLoading = false;
          });
        } else {
          if (!mounted) return;
          setState(() => _isLoading = false);
        }
      } finally {
        client.close(force: true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '관심 목록',
        showBackButton: true,
      ),
      body: _isLoading
          ? ListView.separated(
              itemCount: 6,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (_, __) => const PostItemSkeleton(),
            )
          : _items.isEmpty
              ? Center(
                  child: Text(
                    '관심 등록한 게시물이 없습니다.',
                    style: AppTypography.b4
                        .copyWith(color: AppColors.textMedium),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      return _FavoriteCard(item: _items[index]);
                    },
                  ),
                ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.item});

  final _FavoriteItem item;

  String _formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  String _timeAgo(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inDays < 1) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${(diff.inDays / 7).floor()}주 전';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumbnail(url: item.thumbnailUrl),
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
                    const Icon(
                      Icons.favorite,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.regionName,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    if (item.createdAt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '·',
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    if (item.createdAt.isNotEmpty)
                      Text(
                        _timeAgo(item.createdAt),
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
                      '${_formatPrice(item.price)}원',
                      style: AppTypography.b1.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    _Meta(icon: Icons.chat_bubble_outline, count: item.chatCount),
                    const SizedBox(width: 10),
                    _Meta(icon: Icons.favorite_border, count: item.likeCount),
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

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final valid = url != null &&
        url!.isNotEmpty &&
        !url!.contains('example.com') &&
        !url!.contains('picsum');
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFE9EAEB),
      ),
      clipBehavior: Clip.antiAlias,
      child: valid
          ? Image.network(url!, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _ThumbPlaceholder())
          : const _ThumbPlaceholder(),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, color: Color(0xFFA4A7AE), size: 32),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.count});
  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: AppTypography.c2.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }
}

class _FavoriteItem {
  final String postId;
  final String title;
  final String regionName;
  final int price;
  final int likeCount;
  final int chatCount;
  final String status;
  final String createdAt;
  final String? thumbnailUrl;

  const _FavoriteItem({
    required this.postId,
    required this.title,
    required this.regionName,
    required this.price,
    required this.likeCount,
    required this.chatCount,
    required this.status,
    required this.createdAt,
    this.thumbnailUrl,
  });
}
