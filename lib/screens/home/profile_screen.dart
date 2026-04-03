import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/mock_data.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/profile/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _profileAsset = 'assets/images/boro.png';

  static const List<String> _reviewTags = [
    '거래 약속을 잘 지켜요',
    '친절하고 매너가 좋아요',
    '응답이 빨라요',
    '꼭 필요한 문의만 해요',
    '물건 상태가 좋아요',
    '또 거래하고 싶어요',
  ];

  UserProfile? _profile;
  List<PostItem> _posts = [];
  List<ReviewItem> _reviews = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userId != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    _userId = args is String ? args : '';
    _loadData();
  }

  Future<void> _loadData() async {
    const fallbackProfile = UserProfile(
      id: 1,
      nickname: '닉네임',
      regionName: '영통동',
      trustScore: 3.0,
      borrowCount: 1,
      lendCount: 0,
    );

    final fallbackPosts = List<PostItem>.generate(
      4,
      (index) => PostItem(
        id: 'profile_post_$index',
        title: '보조배터리 구해요',
        category: '전자기기',
        pricePerHour: 1100,
        location: '영통동',
        timeAgo: '2분 전',
        authorName: '닉네임',
        authorId: 'profile_user',
        description: '보조배터리 있으신 분 계신가요? 오늘 한 시간만 빌리려고요',
        distance: '250m',
        authorTrustScore: 3.0,
        postType: 'BORROW',
      ),
    );

    const fallbackReviews = [
      ReviewItem(
        authorName: '닉네임',
        tradeCount: 10,
        comment: '꼭 필요했는데 빌릴 수 있었어요.\n감사합니다.',
        timeAgo: '',
      ),
      ReviewItem(
        authorName: '닉네임',
        tradeCount: 10,
        comment: '꼭 필요했는데 빌릴 수 있었어요.\n감사합니다.',
        timeAgo: '',
      ),
      ReviewItem(
        authorName: '닉네임',
        tradeCount: 10,
        comment: '꼭 필요했는데 빌릴 수 있었어요.\n감사합니다.',
        timeAgo: '',
      ),
    ];

    if (_userId == null || _userId!.isEmpty) {
      final profile = await UserService.fetchMyProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile ?? fallbackProfile;
        _posts = fallbackPosts;
        _reviews = fallbackReviews;
        _isLoading = false;
      });
      return;
    }

    final results = await Future.wait([
      UserService.fetchUserProfile(_userId!),
      UserService.fetchUserPosts(_userId!),
      UserService.fetchUserReviews(_userId!),
    ]);

    if (!mounted) return;
    setState(() {
      _profile = results[0] as UserProfile? ?? fallbackProfile;
      _posts = (results[1] as List<PostItem>).isNotEmpty
          ? results[1] as List<PostItem>
          : fallbackPosts;
      _reviews = (results[2] as List<ReviewItem>).isNotEmpty
          ? results[2] as List<ReviewItem>
          : fallbackReviews;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          '프로필',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeroCard(
                    profile: _profile!,
                    profileAsset: _profileAsset,
                  ),
                  const SizedBox(height: 10),
                  _ProfilePostsSection(posts: _posts),
                  const SizedBox(height: 10),
                  _ProfileReviewsSection(
                    tags: _reviewTags,
                    reviews: _reviews,
                    profileAsset: _profileAsset,
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProfilePostsSection extends StatelessWidget {
  final List<PostItem> posts;

  const _ProfilePostsSection({
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionTitle(title: '올린 게시글'),
          const SizedBox(height: 14),
          SizedBox(
            height: 146,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final post = posts[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/post-detail',
                    arguments: post,
                  ),
                  child: ProfilePostCard(post: post),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileReviewsSection extends StatelessWidget {
  final List<String> tags;
  final List<ReviewItem> reviews;
  final String profileAsset;

  const _ProfileReviewsSection({
    required this.tags,
    required this.reviews,
    required this.profileAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ProfileSectionTitle(title: '받은 후기'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...reviews.map(
            (review) => ProfileReviewCard(
              review: review,
              profileAsset: profileAsset,
            ),
          ),
        ],
      ),
    );
  }
}
