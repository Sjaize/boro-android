import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedFilter = 0;

  static const List<String> _filters = ['전체', '빌려주세요', '빌려드려요'];

  static const List<_ChatPreviewItem> _items = [
    _ChatPreviewItem(
      nickname: '닉네임',
      message: '보조배터리 필요하시단 글 보고 연락드렸어요',
      timeAgo: '2분 전',
      unreadCount: 1,
      isHighlighted: true,
      avatarStyle: _AvatarStyle.dog,
    ),
    _ChatPreviewItem(
      nickname: '닉네임',
      message: '거래 감사합니다',
      timeAgo: '3주 전',
      unreadCount: 0,
      isHighlighted: false,
      avatarStyle: _AvatarStyle.raccoon,
    ),
  ];

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
            _buildFilterRow(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _ChatPreviewTile(
                    item: item,
                    onTap: () => Navigator.pushNamed(context, '/chat-room'),
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
            child: const Icon(
              Icons.settings_outlined,
              color: AppColors.textDark,
              size: 22,
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
                  setState(() {
                    _selectedFilter = i;
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
                    style: AppTypography.c1.copyWith(
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

  final _ChatPreviewItem item;
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
              _ChatAvatar(style: item.avatarStyle),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.nickname,
                              style: AppTypography.b4.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Text(
                            item.timeAgo,
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.message,
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (item.unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 28),
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
                      style: AppTypography.c1.copyWith(color: AppColors.white),
                    ),
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
  const _ChatAvatar({required this.style});

  final _AvatarStyle style;

  @override
  Widget build(BuildContext context) {
    final isDog = style == _AvatarStyle.dog;

    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDog
              ? const [Color(0xFFF4F4F4), Color(0xFFDADADA)]
              : const [Color(0xFFD8E7B0), Color(0xFF7EA35A)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.28),
            ),
          ),
          Icon(
            isDog ? Icons.pets : Icons.cruelty_free_outlined,
            color: isDog ? const Color(0xFFB58452) : AppColors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}

enum _AvatarStyle { dog, raccoon }

class _ChatPreviewItem {
  final String nickname;
  final String message;
  final String timeAgo;
  final int unreadCount;
  final bool isHighlighted;
  final _AvatarStyle avatarStyle;

  const _ChatPreviewItem({
    required this.nickname,
    required this.message,
    required this.timeAgo,
    required this.unreadCount,
    required this.isHighlighted,
    required this.avatarStyle,
  });
}
