class TradeHistoryItem {
  final int transactionId;
  final String title;
  final String? postImageUrl;
  final int price;
  final String rentalPeriodText;
  final int chatCount;
  final int likeCount;
  final String timeAgo;
  final bool hasReceivedReview;

  const TradeHistoryItem({
    required this.transactionId,
    required this.title,
    required this.postImageUrl,
    required this.price,
    required this.rentalPeriodText,
    required this.chatCount,
    required this.likeCount,
    required this.timeAgo,
    required this.hasReceivedReview,
  });

  factory TradeHistoryItem.fromJson(Map<String, dynamic> json) {
    final completedAtRaw = json['completed_at'] as String?;
    final completedAt =
        completedAtRaw != null ? DateTime.tryParse(completedAtRaw) : null;
    final review = json['review'] as Map<String, dynamic>? ?? {};

    return TradeHistoryItem(
      transactionId: (json['transaction_id'] as num?)?.toInt() ?? 0,
      title: (json['post_title'] as String?) ?? '',
      postImageUrl: json['post_image_url'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      rentalPeriodText: (json['rental_period_text'] as String?) ?? '1시간',
      chatCount: (json['chat_count'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      timeAgo: _formatTimeAgo(completedAt),
      hasReceivedReview: review['has_received_review'] == true,
    );
  }

  String get priceText => '${price.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      )}원';

  String get reviewButtonText => '받은 후기 보기';

  String get status => '거래 완료';

  static String _formatTimeAgo(DateTime? completedAt) {
    if (completedAt == null) return '방금 전';

    final now = DateTime.now().toUtc();
    final difference = now.difference(completedAt.toUtc());

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inHours < 1) return '${difference.inMinutes}분 전';
    if (difference.inDays < 1) return '${difference.inHours}시간 전';
    return '${difference.inDays}일 전';
  }
}
