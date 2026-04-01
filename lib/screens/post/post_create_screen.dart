import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_button.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController(text: '1,100');
  final _bodyController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('게시글 작성',
            style: AppTypography.b2.copyWith(color: AppColors.textDark)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  // 사진 등록
                  _SectionHeader(title: '사진 등록'),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Icon(Icons.camera_alt_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 게시글 이름
                  _SectionHeader(title: '게시글 이름'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _titleController,
                    hint: '게시글 이름을 입력해주세요',
                  ),
                  const SizedBox(height: 16),
                  // 카테고리
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('카테고리',
                            style: AppTypography.h3
                                .copyWith(color: AppColors.textDark)),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textDark, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text('전자기기',
                            style: AppTypography.c2
                                .copyWith(color: AppColors.textDark)),
                        const Icon(Icons.chevron_right,
                            size: 15, color: AppColors.textDark),
                        Text('충전기',
                            style: AppTypography.c2
                                .copyWith(color: AppColors.textDark)),
                        const Icon(Icons.chevron_right,
                            size: 15, color: AppColors.textDark),
                        Text('C타입 충전기',
                            style: AppTypography.c2
                                .copyWith(color: AppColors.textDark)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 대여 기간
                  _SectionHeader(title: '대여 기간'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _durationController,
                    hint: '대여 기간을 입력해주세요',
                    height: 37,
                  ),
                  const SizedBox(height: 16),
                  // 가격
                  _SectionHeader(title: '가격'),
                  const SizedBox(height: 8),
                  // AI 추천 배너
                  Container(
                    width: double.infinity,
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Text('AI 추천',
                              style: AppTypography.c2
                                  .copyWith(color: AppColors.white)),
                        ),
                        const SizedBox(width: 8),
                        Text('1시간 당 1,100원에 거래되고 있어요!',
                            style: AppTypography.c2
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 가격 입력
                  Container(
                    width: double.infinity,
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: AppTypography.c2
                          .copyWith(color: AppColors.textDark),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        suffixText: '원',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 게시글 본문
                  _SectionHeader(title: '게시글 본문'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 111,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: null,
                      expands: true,
                      style: AppTypography.c2
                          .copyWith(color: AppColors.textDark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: '본문을 입력해주세요',
                        hintStyle: AppTypography.c2
                            .copyWith(color: AppColors.textHint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // 확인 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 8, 17, 16),
            child: CommonButton(
              text: '확인',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: AppTypography.h3.copyWith(color: AppColors.textDark)),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double height;

  const _InputField({
    required this.controller,
    required this.hint,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        style: AppTypography.c2.copyWith(color: AppColors.textDark),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: AppTypography.c2.copyWith(color: AppColors.textHint),
        ),
      ),
    );
  }
}
