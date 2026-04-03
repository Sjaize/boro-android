class ChatRoom {
  final int chatRoomId;
  final int postId;
  final String postTitle;
  final String postType;
  final String nickname;
  final String? profileImageUrl;
  final String message;
  final String timeAgo;
  final int unreadCount;
  final bool isHighlighted;

  const ChatRoom({
    required this.chatRoomId,
    required this.postId,
    required this.postTitle,
    required this.postType,
    required this.nickname,
    required this.profileImageUrl,
    required this.message,
    required this.timeAgo,
    required this.unreadCount,
    required this.isHighlighted,
  });

  factory ChatRoom.fromDetailJson(Map<String, dynamic> json) {
    final post = json['post'] as Map<String, dynamic>? ?? {};
    final participants = json['participants'] as List<dynamic>? ?? [];
    final partner = participants.length > 1
        ? participants[1] as Map<String, dynamic>
        : (participants.isNotEmpty ? participants[0] as Map<String, dynamic> : <String, dynamic>{});
    final unreadCount = (json['unread_count'] as num?)?.toInt() ?? 0;

    return ChatRoom(
      chatRoomId: (json['chat_room_id'] as num).toInt(),
      postId: (post['post_id'] as num?)?.toInt() ?? 0,
      postTitle: (post['title'] as String?) ?? '',
      postType: (post['post_type'] as String?) ?? 'BORROW',
      nickname: (partner['nickname'] as String?) ?? '',
      profileImageUrl: partner['profile_image_url'] as String?,
      message: '',
      timeAgo: '방금 전',
      unreadCount: unreadCount,
      isHighlighted: unreadCount > 0,
    );
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    final lastMessageAtRaw = json['last_message_at'] as String?;
    final lastMessageAt =
        lastMessageAtRaw != null ? DateTime.tryParse(lastMessageAtRaw) : null;
    final unreadCount = (json['unread_count'] as num?)?.toInt() ?? 0;

    return ChatRoom(
      chatRoomId: (json['chat_room_id'] as num?)?.toInt() ?? 0,
      postId: (json['post_id'] as num?)?.toInt() ?? 0,
      postTitle: (json['post_title'] as String?) ?? '',
      postType: (json['post_type'] as String?) ?? 'BORROW',
      nickname: (json['partner_nickname'] as String?) ?? '닉네임',
      profileImageUrl: json['partner_profile_image_url'] as String?,
      message: (json['last_message_preview'] as String?) ?? '',
      timeAgo: _formatTimeAgo(lastMessageAt),
      unreadCount: unreadCount,
      isHighlighted: unreadCount > 0,
    );
  }

  static String _formatTimeAgo(DateTime? createdAt) {
    if (createdAt == null) return '방금 전';

    final now = DateTime.now().toUtc();
    final difference = now.difference(createdAt.toUtc());

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inHours < 1) return '${difference.inMinutes}분 전';
    if (difference.inHours < 24) return '${difference.inHours}시간 전';
    if (difference.inDays < 7) return '${difference.inDays}일 전';
    return '${(difference.inDays / 7).floor()}주 전';
  }
}
