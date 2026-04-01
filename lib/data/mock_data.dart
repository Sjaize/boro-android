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
  });
}

class MockData {
  static const List<PostItem> posts = [
    PostItem(
      id: '1',
      title: '노트북 충전기 C타입 빌려드려요',
      category: '전자기기',
      pricePerHour: 2000,
      location: '서울대입구역',
      timeAgo: '3분 전',
      authorName: '민준',
      authorId: 'user_1',
      description: '맥북 충전기 C타입입니다. 급하게 필요하신 분 연락주세요. 카페 근처에 있어요.',
    ),
    PostItem(
      id: '2',
      title: '우산 빌려드립니다 (자동우산)',
      category: '생활용품',
      pricePerHour: 500,
      location: '강남역',
      timeAgo: '10분 전',
      authorName: '지현',
      authorId: 'user_2',
      description: '자동 우산 하나 있어요. 갑자기 비 오시는 분 연락주세요!',
    ),
    PostItem(
      id: '3',
      title: '보조배터리 20000mAh',
      category: '전자기기',
      pricePerHour: 1000,
      location: '홍대입구역',
      timeAgo: '25분 전',
      authorName: '서연',
      authorId: 'user_3',
      description: '20000mAh 대용량 보조배터리입니다. USB-C, 라이트닝 지원.',
    ),
    PostItem(
      id: '4',
      title: '자전거 잠깐 빌려드려요',
      category: '이동수단',
      pricePerHour: 3000,
      location: '잠실역',
      timeAgo: '1시간 전',
      authorName: '현우',
      authorId: 'user_4',
      description: '접이식 자전거입니다. 헬멧도 같이 드려요.',
    ),
    PostItem(
      id: '5',
      title: '카메라 미러리스 빌려드립니다',
      category: '전자기기',
      pricePerHour: 5000,
      location: '이태원역',
      timeAgo: '2시간 전',
      authorName: '예린',
      authorId: 'user_5',
      description: '소니 A6400 + 번들렌즈 세트입니다. 취급 주의 부탁드려요.',
    ),
  ];
}
