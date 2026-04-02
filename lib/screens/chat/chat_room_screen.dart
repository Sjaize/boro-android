import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isActionPanelOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('메시지 전송 기능은 아직 준비 중입니다.')),
    );
    _controller.clear();
  }

  void _toggleActionPanel() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isActionPanelOpen = !_isActionPanelOpen;
    });
  }

  Future<void> _showReviewBottomSheet() async {
    setState(() {
      _isActionPanelOpen = false;
    });

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
            decoration: const BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '후기를 남겨주세요',
                  style: AppTypography.h1.copyWith(
                    color: AppColors.textDark,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '다음 거래자를 위해 후기를 남겨주세요!',
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 74),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(this.context, '/review-write');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      '후기 작성하기',
                      style: AppTypography.b2.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      resizeToAvoidBottomInset: true,
      appBar: const CommonAppBar(
        title: '채팅하기',
        showBackButton: true,
      ),
      body: Column(
        children: [
          const _ChatRoomProductHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  Text(
                    '2026년 3월 26일',
                    style: AppTypography.b4.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _OutgoingMessageBubble(
                    text: '텍스트가 들어갈 공간입니다',
                    maxWidth: 212,
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _OutgoingMessageWithTime(
                      text: '텍스트',
                      time: '16:00',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _IncomingMessageBubble(text: '음'),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _IncomingMessageBubble(text: '텍스트입니다'),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _IncomingMessageBubble(text: '흠'),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _IncomingMessageBubble(text: '하하'),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _IncomingEmojiWithTime(
                      emoji: '🥹',
                      time: '16:00',
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ChatInputBar(
            controller: _controller,
            focusNode: _focusNode,
            onSend: _sendMessage,
            onAddTap: _toggleActionPanel,
          ),
          if (_isActionPanelOpen)
            _ChatActionPanel(
              onCameraTap: () {},
              onAlbumTap: () {},
              onTradeEndTap: _showReviewBottomSheet,
            ),
        ],
      ),
    );
  }
}

class _ChatRoomProductHeader extends StatelessWidget {
  const _ChatRoomProductHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: AppColors.primaryLight,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8C8C8C),
                  Color(0xFF2D2D2D),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 6,
                  bottom: 8,
                  child: Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0D3B8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    width: 26,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '보조배터리 구해요',
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '1,100원',
                      style: AppTypography.b1.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/',
                      style: AppTypography.c1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '1시간',
                      style: AppTypography.c1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.more_vert,
            color: AppColors.textDark,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _OutgoingMessageBubble extends StatelessWidget {
  const _OutgoingMessageBubble({
    required this.text,
    required this.maxWidth,
  });

  final String text;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            text,
            style: AppTypography.b4.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

class _OutgoingMessageWithTime extends StatelessWidget {
  const _OutgoingMessageWithTime({
    required this.text,
    required this.time,
  });

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            text,
            style: AppTypography.b4.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTypography.c2.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }
}

class _IncomingMessageBubble extends StatelessWidget {
  const _IncomingMessageBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: AppTypography.b4.copyWith(color: AppColors.textDark),
      ),
    );
  }
}

class _IncomingEmojiWithTime extends StatelessWidget {
  const _IncomingEmojiWithTime({
    required this.emoji,
    required this.time,
  });

  final String emoji;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            time,
            style: AppTypography.c2.copyWith(color: AppColors.textHint),
          ),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAddTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        color: AppColors.bgPage,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onAddTap,
              child: const Icon(
                Icons.add,
                color: AppColors.textLight,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).requestFocus(focusNode),
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    onTap: () => FocusScope.of(context).requestFocus(focusNode),
                    onSubmitted: (_) => onSend(),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    style: AppTypography.b4.copyWith(
                      color: AppColors.textDark,
                    ),
                    cursorColor: AppColors.primary,
                    showCursor: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onSend,
              child: const Icon(
                Icons.send_outlined,
                color: AppColors.textLight,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatActionPanel extends StatelessWidget {
  const _ChatActionPanel({
    required this.onCameraTap,
    required this.onAlbumTap,
    required this.onTradeEndTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onAlbumTap;
  final VoidCallback onTradeEndTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            _ChatActionItem(
              icon: Icons.camera_alt_outlined,
              label: '사진',
              onTap: onCameraTap,
            ),
            const SizedBox(width: 30),
            _ChatActionItem(
              icon: Icons.photo_library_outlined,
              label: '앨범',
              onTap: onAlbumTap,
            ),
            const SizedBox(width: 30),
            _ChatActionItem(
              icon: Icons.check_circle_outline,
              label: '거래 종료',
              onTap: onTradeEndTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatActionItem extends StatelessWidget {
  const _ChatActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.b4.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
