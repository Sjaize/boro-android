class PostItem {
  final String id;
  final String title;
  final String category;
  final int pricePerHour;
  final String location;
  final String timeAgo;
  final String? imageUrl;
  final String authorName;
  final String authorId;
  final String description;
  final bool isAvailable;
  final String distance;
  final int likeCount;
  final int chatCount;
  final bool isLikedByMe;
  final String? authorProfileUrl;
  final double authorTrustScore;
  final String? meetingPlaceText;
  final String? rentalPeriodText;
  final String postType;
  final double? lat;
  final double? lng;

  const PostItem({
    required this.id,
    required this.title,
    required this.category,
    required this.pricePerHour,
    required this.location,
    required this.timeAgo,
    this.imageUrl,
    required this.authorName,
    required this.authorId,
    required this.description,
    this.isAvailable = true,
    this.distance = '250m',
    this.likeCount = 0,
    this.chatCount = 0,
    this.isLikedByMe = false,
    this.authorProfileUrl,
    this.authorTrustScore = 0.0,
    this.meetingPlaceText,
    this.rentalPeriodText,
    this.postType = 'LEND',
    this.lat,
    this.lng,
  });
}

class UrgentRequest {
  final String id;
  final String title;
  final String duration;
  final String timeAgo;

  const UrgentRequest({
    required this.id,
    required this.title,
    required this.duration,
    required this.timeAgo,
  });
}

class ReviewItem {
  final String authorName;
  final int tradeCount;
  final String comment;
  final String timeAgo;
  final int rating;

  const ReviewItem({
    required this.authorName,
    required this.tradeCount,
    required this.comment,
    required this.timeAgo,
    this.rating = 5,
  });
}

class NotificationItem {
  final int id;
  final String type;
  final String title;
  final String body;
  final int? relatedPostId;
  final int? relatedChatRoomId;
  final bool isRead;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.relatedPostId,
    this.relatedChatRoomId,
    this.isRead = false,
    required this.createdAt,
  });
}

class UserProfile {
  final int id;
  final String nickname;
  final String? profileImageUrl;
  final String regionName;
  final double trustScore;
  final int borrowCount;
  final int lendCount;
  final int likeCount;
  final int reviewCount;

  const UserProfile({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
    required this.regionName,
    this.trustScore = 0.0,
    this.borrowCount = 0,
    this.lendCount = 0,
    this.likeCount = 0,
    this.reviewCount = 0,
  });
}

class MockData {
  static const List<UrgentRequest> urgentRequests = [
    UrgentRequest(
      id: '1',
      title: '보조배터리 구해요',
      duration: '1시간 동안',
      timeAgo: '방금 전',
    ),
    UrgentRequest(
      id: '2',
      title: '정장 급히 필요해요',
      duration: '1일 동안',
      timeAgo: '2분 전',
    ),
    UrgentRequest(
      id: '3',
      title: '충전기 빌려주실 분',
      duration: '1일 동안',
      timeAgo: '5분 전',
    ),
    UrgentRequest(
      id: '4',
      title: '우산이 필요해요',
      duration: '3시간 동안',
      timeAgo: '10분 전',
    ),
    UrgentRequest(
      id: '5',
      title: '보조배터리 필요해요',
      duration: '1일 동안',
      timeAgo: '30분 전',
    ),
  ];

  static const List<String> frequentItems = [
    '보조배터리',
    '충전기',
    '우산',
    '교재',
  ];

  static const List<PostItem> borrowRequests = [
    PostItem(
      id: 'r1',
      title: '보조배터리 구해요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '서울 성동구',
      timeAgo: '2분 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-borrow-1/300/300',
      authorName: '닉네임',
      authorId: 'u1',
      description: '보조배터리 있으신 분 계신가요? 오늘 한 시간만 빌리려고요',
      distance: '150m',
      likeCount: 0,
      chatCount: 0,
      authorTrustScore: 3.0,
      postType: 'BORROW',
    ),
    PostItem(
      id: 'r2',
      title: '정장 구합니다',
      category: '패션/의류',
      pricePerHour: 1100,
      location: '강남구',
      timeAgo: '2분 전',
      authorName: '준호',
      authorId: 'u2',
      description: '면접이 있어서 잠깐 입을 정장이 필요해요.',
      distance: '180m',
      likeCount: 0,
      chatCount: 0,
      postType: 'BORROW',
    ),
    PostItem(
      id: 'r3',
      title: '보조배터리 필요해요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '영통구',
      timeAgo: '2분 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-borrow-2/300/300',
      authorName: '닉네임',
      authorId: 'u3',
      description: '보조배터리 있으신 분 계신가요? 오늘 한 시간만 빌리려고요',
      distance: '250m',
      likeCount: 0,
      chatCount: 0,
      authorTrustScore: 3.0,
      postType: 'BORROW',
    ),
    PostItem(
      id: 'r4',
      title: '우산 필요해요',
      category: '생활용품',
      pricePerHour: 1100,
      location: '이태원역',
      timeAgo: '2분 전',
      authorName: '민수',
      authorId: 'u4',
      description: '갑자기 비가 와서 우산을 빌리고 싶어요.',
      distance: '300m',
      likeCount: 0,
      chatCount: 0,
      postType: 'BORROW',
    ),
    PostItem(
      id: 'r5',
      title: '보조배터리 필요해요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '수원역',
      timeAgo: '2분 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-borrow-3/300/300',
      authorName: '닉네임',
      authorId: 'u5',
      description: '보조배터리 있으신 분 계신가요? 오늘 한 시간만 빌리려고요',
      distance: '150m',
      likeCount: 0,
      chatCount: 0,
      authorTrustScore: 3.0,
      postType: 'BORROW',
    ),
    PostItem(
      id: 'r6',
      title: '경제학 책 빌려주세요',
      category: '도서/교육',
      pricePerHour: 1100,
      location: '신촌역',
      timeAgo: '2분 전',
      authorName: '가영',
      authorId: 'u6',
      description: '시험 전에 잠깐 볼 교재가 필요합니다.',
      distance: '150m',
      likeCount: 0,
      chatCount: 0,
      postType: 'BORROW',
    ),
  ];

  static const List<PostItem> posts = [
    PostItem(
      id: '1',
      title: '보조배터리 빌려주세요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '서울 성동구',
      timeAgo: '방금 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-lend-1/300/300',
      authorName: '민지',
      authorId: 'user_1',
      description: 'C타입 보조배터리 빌려드려요. 카페 근처에서 거래 가능해요.',
      distance: '150m',
      likeCount: 0,
      chatCount: 0,
    ),
    PostItem(
      id: '2',
      title: '보조배터리 빌려주세요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '강남구',
      timeAgo: '2분 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-lend-2/300/300',
      authorName: '지우',
      authorId: 'user_2',
      description: '작고 가벼운 보조배터리예요. 잠깐 쓰실 분 연락 주세요.',
      distance: '180m',
      likeCount: 0,
      chatCount: 0,
    ),
    PostItem(
      id: '3',
      title: '보조배터리 필요해요',
      category: '전자기기',
      pricePerHour: 1100,
      location: '영통구',
      timeAgo: '2분 전',
      imageUrl: 'https://picsum.photos/seed/boro-powerbank-lend-3/300/300',
      authorName: '닉네임',
      authorId: 'user_3',
      description: '보조배터리 있으신 분 계신가요? 오늘 한 시간만 빌리려고요',
      distance: '250m',
      likeCount: 0,
      chatCount: 0,
      authorTrustScore: 3.0,
      postType: 'BORROW',
    ),
    PostItem(
      id: '4',
      title: '자전거 헬멧 빌려드려요',
      category: '이동수단',
      pricePerHour: 3000,
      location: '수원역',
      timeAgo: '1시간 전',
      authorName: '현우',
      authorId: 'user_4',
      description: '자전거 헬멧 필요하신 분께 빌려드려요.',
      distance: '320m',
      likeCount: 1,
      chatCount: 0,
    ),
    PostItem(
      id: '5',
      title: '미러리스 카메라 빌려드려요',
      category: '전자기기',
      pricePerHour: 5000,
      location: '이태원역',
      timeAgo: '2시간 전',
      authorName: '다온',
      authorId: 'user_5',
      description: '촬영용 카메라 필요하신 분께 대여 가능합니다.',
      distance: '400m',
      likeCount: 2,
      chatCount: 1,
    ),
  ];

  static const List<ReviewItem> reviews = [
    ReviewItem(
      authorName: '지민',
      tradeCount: 10,
      comment: '급하게 필요했는데 바로 빌려주셔서 감사했어요.',
      timeAgo: '1일 전',
    ),
    ReviewItem(
      authorName: '준호',
      tradeCount: 3,
      comment: '응답이 빠르고 친절했어요.',
      timeAgo: '3일 전',
    ),
    ReviewItem(
      authorName: '서아',
      tradeCount: 7,
      comment: '물건 상태가 좋았고 거래도 깔끔했어요.',
      timeAgo: '1주 전',
    ),
  ];
}
