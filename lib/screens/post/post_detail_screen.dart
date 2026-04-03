import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'package:boro_android/data/mock_data.dart';
import '../../widgets/common_button.dart';

class PostDetailScreen extends StatefulWidget {
  final PostItem post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('글 상세',
            style: AppTypography.b2.copyWith(color: AppColors.textDark)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품 이미지
                  Container(
                    height: 255,
                    width: double.infinity,
                    color: AppColors.bgCard,
                    child: const Center(
                      child: Icon(Icons.image_outlined,
                          size: 60, color: AppColors.textHint),
                    ),
                  ),
                  // 본문 정보
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.timeAgo,
                            style: AppTypography.c2
                                .copyWith(color: AppColors.textHint)),
                        const SizedBox(height: 4),
                        Text(post.title,
                            style: AppTypography.h2
                                .copyWith(color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        // 가격
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_formatPrice(post.pricePerHour)}원',
                              style: AppTypography.h1.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text('/ 1시간',
                                  style: AppTypography.b2
                                      .copyWith(color: AppColors.textLight)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 카테고리 · 거리 · 시간
                        Row(
                          children: [
                            Text(
                              post.category,
                              style: AppTypography.c2.copyWith(
                                color: AppColors.textHint,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text('250m',
                                style: AppTypography.c2
                                    .copyWith(color: AppColors.textHint)),
                            const SizedBox(width: 3),
                            Text('·',
                                style: AppTypography.c2
                                    .copyWith(color: AppColors.textHint)),
                            const SizedBox(width: 3),
                            Text(post.timeAgo,
                                style: AppTypography.c2
                                    .copyWith(color: AppColors.textHint)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 설명
                        Text(
                          post.description,
                          style: AppTypography.b4.copyWith(
                            color: AppColors.textDark,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // 지도 영역
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 134,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Icon(Icons.map_outlined,
                          size: 40, color: AppColors.textHint),
                    ),
                  ),
                  // 거래 희망 장소
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        Text(
                          '거래 희망 장소',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(post.location,
                            style: AppTypography.c1
                                .copyWith(color: AppColors.textMedium)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 저자 섹션
                  const Divider(height: 1, color: AppColors.border),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bgCard,
                          ),
                          child: const Icon(Icons.person,
                              color: AppColors.textHint, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.authorName,
                                  style: AppTypography.b2
                                      .copyWith(color: AppColors.textDark)),
                              const SizedBox(height: 2),
                              Text('거래 10회 완료',
                                  style: AppTypography.c2
                                      .copyWith(color: AppColors.textHint)),
                            ],
                          ),
                        ),
                        Text(
                          '신뢰도 60%',
                          style: AppTypography.c1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // 하단 바
          Container(
            padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
            decoration: const BoxDecoration(
              color: AppColors.bgPage,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isLiked = !_isLiked),
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : AppColors.textHint,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CommonButton(
                    text: '채팅하기',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/chat-room',
                      arguments: post,
                    ),
                  ),
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
      (m) => '${m[1]},',
    );
  }
}
