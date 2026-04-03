import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'data/models/chat_room.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';

  int _selectedFilter = 0;
  late Future<List<ChatRoom>> _chatRoomsFuture;

  static const List<String> _filters = ['전체', '빌려주세요', '빌려드려요'];
  static const List<String> _filterTypes = ['ALL', 'BORROW', 'LEND'];

  @override
  void initState() {
    super.initState();
    _chatRoomsFuture = _fetchChatRooms();
  }

  Future<List<ChatRoom>> _fetchChatRooms() async {
    final type = _filterTypes[_selectedFilter];
    final uri = Uri.parse('$_baseUrl/api/chats?type=$type&page=1&size=20');
    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          '채팅 목록을 불러오지 못했습니다. (${response.statusCode})',
        );
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final rooms = data['chat_rooms'] as List<dynamic>? ?? const [];
      return rooms
          .map((item) => ChatRoom.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      client.close(force: true);
    }
  }

  void _reloadChatRooms() {
    setState(() {
      _chatRoomsFuture = _fetchChatRooms();
    });
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('거래 화면은 아직 준비 중입니다.')),
        );
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/mypage');
        break;
    }
  }

  void _showPendingMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12), // 헤더와 필터 사이 간격 추가
            _buildFilterRow(),
            const SizedBox(height: 8), // 필터와 리스트 사이 간격 추가
            Expanded(
              child: FutureBuilder<List<ChatRoom>>(
                future: _chatRoomsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _ChatListErrorState(onRetry: _reloadChatRooms);
                  }

                  final items = snapshot.data ?? const [];
                  if (items.isEmpty) {
                    return const _ChatListEmptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ChatPreviewTile(
                        item: item,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/chat-room',
                          arguments: item,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: 1,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '채팅',
              style: AppTypography.h1.copyWith(
                color: AppColors.textDark,
                fontSize: 24,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showPendingMessage('채팅 설정'),
            child: SvgPicture.asset(
              'assets/icons/ic_chat_settings.svg',
              width: 30,
              height: 30,
              colorFilter: const ColorFilter.mode(
                AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      height: 47,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          for (var i = 0; i < _filters.length; i++)
            Padding(
              padding: EdgeInsets.only(right: i == _filters.length - 1 ? 0 : 8),
              child: GestureDetector(
                onTap: () {
                  if (_selectedFilter == i) return;
                  setState(() {
                    _selectedFilter = i;
                    _chatRoomsFuture = _fetchChatRooms();
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color:
                        _selectedFilter == i ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    _filters[i],
                    style: AppTypography.b4.copyWith(
                      fontSize: 14,
                      color: _selectedFilter == i
                          ? AppColors.white
                          : AppColors.primary,
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

class _ChatPreviewTile extends StatelessWidget {
  const _ChatPreviewTile({
    required this.item,
    required this.onTap,
  });

  final ChatRoom item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isHighlighted ? AppColors.primaryLight : AppColors.bgPage,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChatAvatar(imageUrl: item.profileImageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nickname,
                        style: AppTypography.b4.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.timeAgo,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    if (item.unreadCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${item.unreadCount}',
                            style: AppTypography.c1
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEFF2F7),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _ChatAvatarPlaceholder(),
            )
          : const _ChatAvatarPlaceholder(),
    );
  }
}

class _ChatAvatarPlaceholder extends StatelessWidget {
  const _ChatAvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        color: AppColors.textHint,
        size: 30,
      ),
    );
  }
}

class _ChatListErrorState extends StatelessWidget {
  const _ChatListErrorState({required this.onRetry});

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
              '채팅 목록을 불러오지 못했습니다.',
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

class _ChatListEmptyState extends StatelessWidget {
  const _ChatListEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          '채팅방이 아직 없습니다.',
          textAlign: TextAlign.center,
          style: AppTypography.b4.copyWith(color: AppColors.textMedium),
        ),
      ),
    );
  }
}
