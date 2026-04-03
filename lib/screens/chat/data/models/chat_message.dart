class ChatMessage {
  final int messageId;
  final int senderUserId;
  final String messageType; // "text" or "emoji" (based on current UI)
  final String content;
  final DateTime createdAt;
  final bool isMine;

  const ChatMessage({
    required this.messageId,
    required this.senderUserId,
    required this.messageType,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: (json['message_id'] as num?)?.toInt() ?? 0,
      senderUserId: (json['sender_user_id'] as num?)?.toInt() ?? 0,
      messageType: (json['message_type'] as String?) ?? 'text',
      content: (json['content'] as String?) ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      isMine: json['is_mine'] == true,
    );
  }

  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}
