import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';
import 'data/models/chat_message.dart';
import 'data/models/chat_room.dart';
import 'data/services/chat_service.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isActionPanelOpen = false;

  ChatRoom? _chatRoom;
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_chatRoom == null) {
      _chatRoom = ModalRoute.of(context)!.settings.arguments as ChatRoom?;
      if (_chatRoom != null) {
        _loadMessages();
      }
    }
  }

  Future<void> _loadMessages() async {
    if (_chatRoom == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final messages = await _chatService.fetchMessages(_chatRoom!.chatRoomId);
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
        
        // 마지막 메시지를 읽음 처리
        if (messages.isNotEmpty) {
          _chatService.markAsRead(_chatRoom!.chatRoomId, messages.last.messageId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '메시지를 불러오지 못했습니다.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty || _chatRoom == null) return;

    _controller.clear(); // 즉시 입력창 비우기

    final newMessage = await _chatService.sendMessage(_chatRoom!.chatRoomId, content);
    if (newMessage != null) {
      if (mounted) {
        setState(() {
          _messages.add(newMessage);
        });
        _chatService.markAsRead(_chatRoom!.chatRoomId, newMessage.messageId);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('메시지 전송에 실패했습니다.')),
        );
      }
    }
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
      appBar: CommonAppBar(
        title: _chatRoom?.nickname ?? '채팅하기',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _ChatRoomProductHeader(
            title: _chatRoom?.postTitle ?? '물품 정보 없음',
            price: '1,100원', // Mock price as it's not in ChatRoom spec
          ),
          Expanded(
            child: Stack(
              children: [
                _buildMessageList(),
                if (_isActionPanelOpen)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: AppColors.bgPage,
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ChatInputBar(
                              controller: _controller,
                              focusNode: _focusNode,
                              onSend: _sendMessage,
                              onAddTap: _toggleActionPanel,
                            ),
                            _ChatActionPanel(
                              onCameraTap: () {},
                              onAlbumTap: () {},
                              onTradeEndTap: _showReviewBottomSheet,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!_isActionPanelOpen)
            _ChatInputBar(
              controller: _controller,
              focusNode: _focusNode,
              onSend: _sendMessage,
              onAddTap: _toggleActionPanel,
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: AppTypography.b4),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadMessages, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    if (_messages.isEmpty) {
      return const Center(
        child: Text('대화 내용이 없습니다.', style: AppTypography.b4),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        
        // Show date header if it's the first message or date changed (omitted for brevity in this mock-like spec)
        
        if (message.isMine) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13), // 8에서 13으로 증가
            child: _OutgoingMessageWithTime(
              text: message.content,
              time: message.formattedTime,
            ),
          );
        } else {
          if (message.messageType == 'emoji') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 13), // 8에서 13으로 증가
              child: Align(
                alignment: Alignment.centerLeft,
                child: _IncomingEmojiWithTime(
                  emoji: message.content,
                  time: message.formattedTime,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 13), // 8에서 13으로 증가
              child: Align(
                alignment: Alignment.centerLeft,
                child: _IncomingMessageBubble(
                  text: message.content,
                  time: message.formattedTime,
                ),
              ),
            );
          }
        }
      },
    );
  }
}

class _ChatRoomProductHeader extends StatelessWidget {
  const _ChatRoomProductHeader({
    required this.title,
    required this.price,
  });

  final String title;
  final String price;

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
                  title,
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      price,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
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
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: AppTypography.c2.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Text(
              text,
              style: AppTypography.b4.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingMessageBubble extends StatelessWidget {
  const _IncomingMessageBubble({
    required this.text,
    required this.time,
  });

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320), // 최대 너비를 320으로 증가
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(22),
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Text(
              text,
              style: AppTypography.b4.copyWith(color: AppColors.textDark),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: AppTypography.c2.copyWith(color: AppColors.textHint),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(22),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
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
    return Container(
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
                keyboardType: TextInputType.multiline, // multiline으로 변경하여 조합 가독성 개선
                maxLines: null, // 자동 줄바꿈 허용
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '메시지를 입력하세요',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                style: AppTypography.b4.copyWith(
                  color: AppColors.textDark,
                ),
                cursorColor: AppColors.primary,
                showCursor: true,
              ),            ),
          ),          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: const Icon(
              Icons.send,
              color: AppColors.textLight,
              size: 28,
            ),
          ),
        ],
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
      height: 300, // SVG 명세에 맞춰 높이 확대
      color: AppColors.bgPage,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 0), // 상단 여백 확보
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              size: 28, // 아이콘 크기 약간 확대
            ),
          ),
          const SizedBox(height: 12), // 간격 조정
          Text(
            label,
            style: AppTypography.b4.copyWith(
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
