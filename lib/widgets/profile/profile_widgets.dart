import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ProfileHeroCard extends StatelessWidget {
  final UserProfile profile;
  final String profileAsset;

  const ProfileHeroCard({
    super.key,
    required this.profile,
    required this.profileAsset,
  });

  @override
  Widget build(BuildContext context) {
    final trustPercent = (profile.trustScore * 20).round().clamp(0, 100);
    final tradeCount = (profile.borrowCount + profile.lendCount).clamp(1, 999);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(profileAsset, fit: BoxFit.cover),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.nickname,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '최근 3일 이내 활동',
                  style: AppTypography.c2.copyWith(
                    color: const Color(0xFFF5FAFF),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${profile.regionName} / 거래 $tradeCount회',
                  style: AppTypography.c2.copyWith(
                    color: const Color(0xFFFDFDFD),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 74,
            child: Column(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          value: trustPercent / 100,
                          strokeWidth: 2.5,
                          backgroundColor: Colors.white.withValues(alpha: 0.28),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.person_outline,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '신뢰도 $trustPercent%',
                  textAlign: TextAlign.center,
                  style: AppTypography.c2.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h2.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.textDark, size: 20),
      ],
    );
  }
}

class ProfilePostCard extends StatelessWidget {
  static const String _postAsset = 'assets/images/search_result_powerbank.jpg';

  final PostItem post;

  const ProfilePostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              _postAsset,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.c2.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${_formatPrice(post.pricePerHour > 0 ? post.pricePerHour : 1100)}원',
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' / 1시간',
                  style: AppTypography.c2.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}

class ProfileReviewCard extends StatelessWidget {
  final ReviewItem review;
  final String profileAsset;

  const ProfileReviewCard({
    super.key,
    required this.review,
    required this.profileAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE9EAEB),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              profileAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.authorName,
                  style: AppTypography.b2.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '거래 ${review.tradeCount}회 완료',
                  style: AppTypography.c2.copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
