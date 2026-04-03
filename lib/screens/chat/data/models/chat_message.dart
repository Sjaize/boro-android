class ChatMessage {
  final int messageId;
  final int senderUserId;
  final String messageType; // "text" or "emoji" (based on current UI)
  final String content;
  final String? createdAtRaw;
  final DateTime createdAt;
  final bool isMine;
  final bool isRead;

  const ChatMessage({
    required this.messageId,
    required this.senderUserId,
    required this.messageType,
    required this.content,
    required this.createdAtRaw,
    required this.createdAt,
    required this.isMine,
    required this.isRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'] as String?;
    return ChatMessage(
      messageId: (json['message_id'] as num?)?.toInt() ?? 0,
      senderUserId: (json['sender_user_id'] as num?)?.toInt() ?? 0,
      messageType: (json['message_type'] as String?) ?? 'text',
      content: (json['content'] as String?) ?? '',
      createdAtRaw: createdAtRaw,
      createdAt: DateTime.tryParse(createdAtRaw ?? '') ?? DateTime.now(),
      isMine: json['is_mine'] == true,
      isRead: json['is_read'] == true,
    );
  }
}
