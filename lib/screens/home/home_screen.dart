import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/firebase_messaging_service.dart';
import '../../services/notification_service.dart' show NotificationService;
import '../../services/post_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_banner.dart';
import '../../widgets/common_cards.dart';
import '../../widgets/common_carousel.dart';
import '../../widgets/common_home_header.dart';
import '../../widgets/primary_add_fab.dart';
import '../../widgets/skeleton.dart';
import '../chat/data/models/chat_room.dart';
import '../chat/data/services/chat_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  bool _isFabOpen = false;
  String _currentRegionName = '지역명';
  List<PostItem> _urgentItems = [];
  bool _urgentLoading = true;
  int _unreadCount = 0;
  int _unreadChatCount = 0;

  static const List<String> _frequentItems = [
    '보조배터리',
    '충전기',
    '우산',
    '교재',
  ];

  @override
  void initState() {
    super.initState();
    _loadRegionName();
    _loadUrgentPosts();
    _loadUnreadCount();
    _loadUnreadChatCount();
  }

  Future<void> _loadRegionName() async {
    debugPrint('REGION_NAME: start');
    final fromLocation = await FirebaseMessagingService.updateLocationOnce();
    debugPrint('REGION_NAME: updateLocationOnce=$fromLocation');
    final regionName = (fromLocation != null && fromLocation.isNotEmpty)
        ? fromLocation
        : await PostService.fetchRegionName();
    debugPrint('REGION_NAME: final=$regionName mounted=$mounted');
    if (!mounted || regionName == null || regionName.isEmpty) return;
    setState(() => _currentRegionName = regionName);
  }

  Future<void> _loadUnreadCount() async {
    final items = await NotificationService.fetchNotifications();
    if (!mounted) return;
    final count = items.where((n) => !n.isRead).length;
    NotificationService.cachedUnreadCount = count;
    setState(() => _unreadCount = count);
  }

  Future<void> _loadUnreadChatCount() async {
    final count = await ChatService.fetchTotalUnreadCount();
    if (!mounted) return;
    setState(() => _unreadChatCount = count);
  }

  Future<void> _loadUrgentPosts() async {
    setState(() => _urgentLoading = true);
    final posts = await PostService.fetchUrgentPosts();
    if (!mounted) return;
    setState(() {
      _urgentItems = posts;
      _urgentLoading = false;
    });
  }

  Future<void> _toggleLike(PostItem post) async {
    final wasLiked = post.isLikedByMe;
    setState(() {
      _urgentItems = _urgentItems.map((p) {
        if (p.id != post.id) return p;
        return PostItem(
          id: p.id, title: p.title, category: p.category,
          pricePerHour: p.pricePerHour, location: p.location,
          timeAgo: p.timeAgo, imageUrl: p.imageUrl,
          authorName: p.authorName, authorId: p.authorId,
          description: p.description, isAvailable: p.isAvailable,
          distance: p.distance,
          likeCount: p.likeCount + (wasLiked ? -1 : 1),
          chatCount: p.chatCount,
          isLikedByMe: !wasLiked,
          authorProfileUrl: p.authorProfileUrl,
          authorTrustScore: p.authorTrustScore,
          meetingPlaceText: p.meetingPlaceText,
          rentalPeriodText: p.rentalPeriodText,
          postType: p.postType,
          lat: p.lat,
          lng: p.lng,
        );
      }).toList();
    });

    final result = wasLiked
        ? await PostService.unlikePost(post.id)
        : await PostService.likePost(post.id);

    if (result == null && mounted) {
      setState(() {
        _urgentItems = _urgentItems.map((p) {
          if (p.id != post.id) return p;
          return PostItem(
            id: p.id, title: p.title, category: p.category,
            pricePerHour: p.pricePerHour, location: p.location,
            timeAgo: p.timeAgo, imageUrl: p.imageUrl,
            authorName: p.authorName, authorId: p.authorId,
            description: p.description, isAvailable: p.isAvailable,
            distance: p.distance,
            likeCount: p.likeCount + (wasLiked ? 1 : -1),
            chatCount: p.chatCount,
            isLikedByMe: wasLiked,
            authorProfileUrl: p.authorProfileUrl,
            authorTrustScore: p.authorTrustScore,
            meetingPlaceText: p.meetingPlaceText,
            rentalPeriodText: p.rentalPeriodText,
            postType: p.postType,
            lat: p.lat,
            lng: p.lng,
          );
        }).toList();
      });
    }
  }

  Future<void> _startChat(PostItem post) async {
    final roomId = await PostService.createChatRoom(post.id);
    if (!mounted || roomId == null) return;
    final chatRoom = ChatRoom(
      chatRoomId: roomId,
      postId: int.tryParse(post.id) ?? 0,
      postTitle: post.title,
      postType: post.postType,
      nickname: post.authorName,
      profileImageUrl: post.authorProfileUrl,
      message: '',
      timeAgo: '방금 전',
      unreadCount: 0,
      isHighlighted: false,
    );
    Navigator.pushNamed(context, '/chat-room', arguments: chatRoom);
  }

  Future<void> _openPostDetail(PostItem post) async {
    final detail = await PostService.fetchPostDetail(post.id);
    if (!mounted || detail == null) return;
    Navigator.pushNamed(context, '/post-detail', arguments: detail);
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _isFabOpen = false);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/trade');
        break;
      case 2:
        Navigator.pushNamed(context, '/chat-list').then((_) {
          _loadUnreadCount();
          _loadUnreadChatCount();
        });
        break;
      case 3:
        Navigator.pushNamed(context, '/mypage');
        break;
    }
  }

  void _closeFabMenu() {
    if (!_isFabOpen) return;
    setState(() => _isFabOpen = false);
  }

  void _openPostCreateByType(String type) {
    setState(() => _isFabOpen = false);
    Navigator.pushNamed(context, '/post-create', arguments: {'type': type});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        chatBadgeCount: _unreadChatCount,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 1, bottom: 0),
        child: Transform.translate(
          offset: const Offset(2, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isFabOpen) ...[
                _SplitFabMenuPanel(
                  onUrgentTap: () => _openPostCreateByType('urgent'),
                  onBorrowTap: () => _openPostCreateByType('borrow'),
                  onLendTap: () => _openPostCreateByType('lend'),
                ),
                const SizedBox(height: 12),
              ],
              PrimaryAddFab(
                onTap: () => setState(() => _isFabOpen = !_isFabOpen),
                icon: _isFabOpen ? Icons.close : Icons.add,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHomeHeader(
                    title: _currentRegionName,
                    onSearchTap: () => Navigator.pushNamed(context, '/search'),
                    onNotificationTap: () =>
                        Navigator.pushNamed(context, '/notification')
                            .then((_) => _loadUnreadCount()),
                    unreadCount: _unreadCount,
                  ),
                  const PromoBanner(),
                  const SizedBox(height: 30),
                  const _SectionHeader(
                    title: '긴급',
                    actionLabel: '더보기',
                  ),
                  const SizedBox(height: 28),
                  _urgentLoading
                      ? CommonHorizontalCarousel(
                          height: 176,
                          itemCount: 4,
                          spacing: 10,
                          itemBuilder: (_, __) => const UrgentCardSkeleton(),
                        )
                      : _urgentItems.isEmpty
                          ? const SizedBox(
                              height: 176,
                              child: Center(
                                child: Text('주변 긴급 요청이 없습니다.'),
                              ),
                            )
                          : CommonHorizontalCarousel(
                              height: 176,
                              itemCount: _urgentItems.length,
                              spacing: 10,
                              itemBuilder: (_, index) {
                                final item = _urgentItems[index];
                                return UrgentRequestCard(
                                  timeText: item.timeAgo,
                                  title: item.title,
                                  duration: item.rentalPeriodText ?? '',
                                  liked: item.isLikedByMe,
                                  onTap: () => _openPostDetail(item),
                                  onLikeTap: () => _toggleLike(item),
                                  onChatTap: () => _startChat(item),
                                );
                              },
                            ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '회원님이 자주 찾는 물건',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textDark,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ..._frequentItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: _FrequentItem(
                        label: item,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/search',
                          arguments: item,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 82),
                ],
              ),
            ),
            if (_isFabOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeFabMenu,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SplitFabMenuPanel extends StatelessWidget {
  final VoidCallback onUrgentTap;
  final VoidCallback onBorrowTap;
  final VoidCallback onLendTap;

  const _SplitFabMenuPanel({
    required this.onUrgentTap,
    required this.onBorrowTap,
    required this.onLendTap,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration panelDecoration() => BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 121,
          decoration: panelDecoration(),
          child: _SplitFabMenuItem(
            iconAsset: 'assets/icons/ic_urgent_outline.svg',
            label: '긴급',
            onTap: onUrgentTap,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 121,
          decoration: panelDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SplitFabMenuItem(
                iconAsset: 'assets/icons/ic_borrow_outline.svg',
                label: '빌려주세요',
                onTap: onBorrowTap,
              ),
              const Divider(height: 1, color: AppColors.divider),
              _SplitFabMenuItem(
                iconAsset: 'assets/icons/ic_lend_outline.svg',
                label: '빌려드려요',
                onTap: onLendTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SplitFabMenuItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const _SplitFabMenuItem({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: 14, height: 14),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: AppTypography.b4.copyWith(color: AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.h2.copyWith(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                actionLabel!,
                style: AppTypography.c2.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FrequentItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FrequentItem({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Text(
              label,
              style: AppTypography.b4.copyWith(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 13,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
