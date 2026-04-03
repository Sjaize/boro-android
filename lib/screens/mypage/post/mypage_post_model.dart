class MypagePostItem {
  final int postId;
  final String title;
  final String regionName;
  final int price;
  final int likeCount;
  final int chatCount;
  final String timeAgo;

  const MypagePostItem({
    required this.postId,
    required this.title,
    required this.regionName,
    required this.price,
    required this.likeCount,
    required this.chatCount,
    required this.timeAgo,
  });

  factory MypagePostItem.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'] as String?;
    final createdAt =
        createdAtRaw != null ? DateTime.tryParse(createdAtRaw) : null;

    return MypagePostItem(
      postId: (json['post_id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      regionName: (json['region_name'] as String?) ?? '지역 미설정',
      price: (json['price'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      chatCount: (json['chat_count'] as num?)?.toInt() ?? 0,
      timeAgo: _formatTimeAgo(createdAt),
    );
  }

  String get priceText => '${price.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      )}원';

  static String _formatTimeAgo(DateTime? createdAt) {
    if (createdAt == null) return '방금 전';

    final now = DateTime.now().toUtc();
    final difference = now.difference(createdAt.toUtc());

    if (difference.inMinutes < 1) return '방금 전';
    if (difference.inHours < 1) return '${difference.inMinutes}분 전';
    if (difference.inDays < 1) return '${difference.inHours}시간 전';
    return '${difference.inDays}일 전';
  }
}
