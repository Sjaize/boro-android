import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'common_button.dart';

class PostListCard extends StatelessWidget {
  final Widget thumbnail;
  final String title;
  final String meta;
  final String priceText;
  final String rentalText;
  final int chatCount;
  final int likeCount;
  final bool liked;
  final VoidCallback? onTap;

  const PostListCard({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.meta,
    required this.priceText,
    required this.rentalText,
    this.chatCount = 0,
    this.likeCount = 0,
    this.liked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 127,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(width: 95, height: 95, child: thumbnail),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: SizedBox(
              height: 95,
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    left: 0,
                    right: 20,
                    child: Text(
                      title,
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 26,
                    left: 0,
                    child: Text(
                      meta,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: AppColors.textHint,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          priceText,
                          style: AppTypography.b1.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' / $rentalText',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 2,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 11,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$chatCount',
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          size: 11,
                          color: liked ? AppColors.primary : AppColors.textLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$likeCount',
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}

class UrgentRequestCard extends StatelessWidget {
  final String timeText;
  final String title;
  final String duration;
  final bool liked;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onChatTap;

  const UrgentRequestCard({
    super.key,
    required this.timeText,
    required this.title,
    required this.duration,
    this.liked = false,
    this.onTap,
    this.onLikeTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: 144,
      height: 176,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 12, 11, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  timeText,
                  style: AppTypography.c2.copyWith(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onLikeTap,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 13,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.c1.copyWith(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              duration,
              style: AppTypography.c2.copyWith(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onChatTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
              width: double.infinity,
              height: 21,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                '채팅하기',
                style: AppTypography.c2.copyWith(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String timeText;
  final bool highlighted;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.timeText,
    this.highlighted = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      color: highlighted ? AppColors.primaryLight : AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                timeText,
                style: AppTypography.c2.copyWith(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: AppTypography.c2.copyWith(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}

class ReviewCard extends StatelessWidget {
  final String nickname;
  final String tradeSummary;
  final String comment;
  final Widget avatar;

  const ReviewCard({
    super.key,
    required this.nickname,
    required this.tradeSummary,
    required this.comment,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(width: 38, height: 38, child: avatar),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: AppTypography.b2.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tradeSummary,
                  style: AppTypography.c2.copyWith(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  comment,
                  style: AppTypography.c2.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
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

class ProfileSummaryCard extends StatelessWidget {
  final Widget avatar;
  final String nickname;
  final String subtitle;
  final String regionAndTrade;
  final String trustText;
  final String buttonText;
  final VoidCallback? onPressed;

  const ProfileSummaryCard({
    super.key,
    required this.avatar,
    required this.nickname,
    required this.subtitle,
    required this.regionAndTrade,
    required this.trustText,
    this.buttonText = '프로필 수정',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: SizedBox(width: 65, height: 65, child: avatar),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: AppTypography.b1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      regionAndTrade,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: AppColors.white,
                    size: 34,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trustText,
                    style: AppTypography.c1.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          CommonButton(
            text: buttonText,
            type: ButtonType.outline,
            height: 40,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
