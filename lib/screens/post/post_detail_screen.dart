import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../../data/mock_data.dart';
import '../../services/post_service.dart';
import '../chat/data/models/chat_room.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_button.dart';
import '../../widgets/skeleton.dart';

class PostDetailScreen extends StatefulWidget {
  final PostItem post;
  final bool isOfficialPartner;

  const PostDetailScreen({
    super.key,
    required this.post,
    this.isOfficialPartner = false,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static const String _detailImageAsset =
      'assets/images/search_result_powerbank.jpg';

  late PostItem _post;
  late bool _isLiked;
  late int _likeCount;
  bool _likeLoading = false;
  bool _chatLoading = false;
  bool _isFetchingDetail = false;
  KakaoMapController? _mapController;
  MarkerIcon? _markerIcon;
  bool _mapLoaded = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isLiked = _post.isLikedByMe;
    _likeCount = _post.likeCount;
    _loadPostDetail();
    _loadMarkerIcon();
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final icon = await MarkerIcon.fromAsset('assets/images/location_pin.png');
      if (!mounted) return;
      setState(() => _markerIcon = icon);
    } catch (_) {}
  }

  Future<void> _loadPostDetail() async {
    setState(() => _isFetchingDetail = true);
    final detail = await PostService.fetchPostDetail(widget.post.id);
    if (!mounted) return;
    if (detail == null) {
      setState(() => _isFetchingDetail = false);
      return;
    }

    setState(() {
      _post = detail;
      _isLiked = detail.isLikedByMe;
      _likeCount = detail.likeCount;
      _isFetchingDetail = false;
    });
  }

  Future<void> _toggleLike() async {
    setState(() => _likeLoading = true);
    final result = _isLiked
        ? await PostService.unlikePost(_post.id)
        : await PostService.likePost(_post.id);

    if (!mounted) return;
    setState(() {
      _likeLoading = false;
      if (result != null) {
        _isLiked = result['is_liked'] as bool? ?? !_isLiked;
        _likeCount = (result['like_count'] as num?)?.toInt() ?? _likeCount;
      } else {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      }
    });
  }

  Future<void> _startChat() async {
    setState(() => _chatLoading = true);
    final roomId = await PostService.createChatRoom(_post.id);
    if (!mounted) return;
    setState(() => _chatLoading = false);
    if (roomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('채팅방 생성에 실패했습니다.')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/chat-room',
      arguments: ChatRoom(
        chatRoomId: roomId,
        postId: int.tryParse(_post.id) ?? 0,
        postTitle: _post.title,
        postType: 'BORROW',
        nickname: _post.authorName,
        profileImageUrl: null,
        message: '',
        timeAgo: '방금 전',
        unreadCount: 0,
        isHighlighted: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;
    final isOfficialPartner = widget.isOfficialPartner;
    final displayTitle =
        isOfficialPartner ? '전동드릴 빌려드립니다.' : post.title;
    final title = post.title.isNotEmpty ? post.title : '보조배터리 구해요';
    final category = post.category.isNotEmpty ? post.category : '전자기기';
    final distance = post.distance.isNotEmpty ? post.distance : '250m';
    final timeAgo = post.timeAgo.isNotEmpty ? post.timeAgo : '2분 전';
    final price = post.pricePerHour > 0 ? post.pricePerHour : 1100;
    final displayPrice = isOfficialPartner ? 1200 : price;
    final locationName =
        (post.meetingPlaceText?.isNotEmpty ?? false) ? post.meetingPlaceText! : '경희대 정문';
    final description = post.description.isNotEmpty
        ? post.description
        : '보조배터리 있으신 분 계신가요?\n오늘 한 시간만 빌리려고요';

    final displayDescription =
        isOfficialPartner ? '전동드릴 빌려드립니다.' : description;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/ic_back.svg',
            width: 18,
            height: 18,
          ),
        ),
        title: Text(
          '글 상세',
          style: AppTypography.b2.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 304,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildDetailImage(post.imageUrl),
                        if (isOfficialPartner)
                          const Positioned(
                            right: 16,
                            bottom: 16,
                            child: _OfficialPartnerPill(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            timeAgo,
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isOfficialPartner) ...[
                              const _OfficialPartnerCheckBadge(),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                displayTitle,
                                style: AppTypography.h2.copyWith(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ],
                          ),
                        if (_isFetchingDetail) ...[
                          const SizedBox(height: 8),
                          const LinearProgressIndicator(minHeight: 2),
                        ],
                        const SizedBox(height: 2),
                        if (isOfficialPartner)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '1,200원',
                                style: AppTypography.h1.copyWith(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  '/ 1시간',
                                  style: AppTypography.b2.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!isOfficialPartner)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_formatPrice(price)}원',
                              style: AppTypography.h1.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                '/ 1시간',
                                style: AppTypography.b2.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              category,
                              style: AppTypography.c2.copyWith(
                                color: AppColors.textHint,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$distance · $timeAgo',
                              style: AppTypography.c2.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        if (isOfficialPartner)
                          Text(
                            displayDescription,
                            style: AppTypography.b4.copyWith(
                              color: AppColors.textDark,
                              height: 1.55,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (!isOfficialPartner)
                        Text(
                          description,
                          style: AppTypography.b4.copyWith(
                            color: AppColors.textDark,
                            height: 1.55,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(
                          color: AppColors.divider,
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 176,
                                    child: _buildMeetingMap(),
                                  ),
                                  if (!_mapLoaded && _post.lat != null && _post.lng != null && _markerIcon != null)
                                    const Positioned.fill(
                                      child: SkeletonBox(height: 176, radius: 0),
                                    ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                color: AppColors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '거래 희망 장소',
                                          style: AppTypography.c2.copyWith(
                                            color: AppColors.textHint,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          locationName,
                                          style: AppTypography.b4.copyWith(
                                            color: AppColors.textDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppColors.bgPage,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _likeLoading ? null : _toggleLike,
                  child: SizedBox(
                    width: 30,
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : AppColors.textLight,
                          size: 28,
                        ),
                        if (_likeCount > 0)
                          Text(
                            '$_likeCount',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CommonButton(
                    text: _chatLoading ? '연결 중...' : '채팅하기',
                    onPressed: _chatLoading ? null : _startChat,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingMap() {
    final lat = _post.lat;
    final lng = _post.lng;
    if (lat == null || lng == null || _markerIcon == null) {
      return const SkeletonBox(height: 176, radius: 0);
    }
    final center = LatLng(lat, lng);
    return AnimatedOpacity(
      opacity: _mapLoaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: KakaoMap(
      key: ValueKey('detail_map_${_post.id}'),
      center: center,
      onMapCreated: (controller) {
        _mapController = controller;
        controller.setLevel(3);
        controller.addMarker(markers: [
          Marker(
            markerId: 'meeting',
            latLng: center,
            width: 42,
            height: 56,
            offsetX: 21,
            offsetY: 56,
            icon: _markerIcon,
          ),
        ]);
        if (mounted) setState(() => _mapLoaded = true);
      },
      markers: [
        Marker(
          markerId: 'meeting',
          latLng: center,
          width: 42,
          height: 56,
          offsetX: 21,
          offsetY: 56,
          icon: _markerIcon,
        ),
      ],
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  Widget _buildDetailImage(String? imageUrl) {
    final normalizedImageUrl = _normalizedImageUrl(imageUrl);
    if (normalizedImageUrl == null) {
      return Image.asset(
        _detailImageAsset,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      normalizedImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        _detailImageAsset,
        fit: BoxFit.cover,
      ),
    );
  }

  String? _normalizedImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final lower = imageUrl.toLowerCase();
    if (lower.contains('dummy') ||
        lower.contains('example.com') ||
        lower.contains('picsum.photos')) {
      return null;
    }
    return imageUrl;
  }
}

class _OfficialPartnerCheckBadge extends StatelessWidget {
  const _OfficialPartnerCheckBadge();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ic_partner_badge.svg',
      width: 19,
      height: 24,
    );
  }
}

class _OfficialPartnerPill extends StatelessWidget {
  const _OfficialPartnerPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_partner_badge_check.svg',
            width: 6,
            height: 4,
          ),
          const SizedBox(width: 4),
          Text(
            '공식 파트너',
            style: AppTypography.c2.copyWith(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

