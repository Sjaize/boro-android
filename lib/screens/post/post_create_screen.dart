import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_button.dart';
import '../../widgets/post/post_create_widgets.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController(text: '보조배터리 구해요');
  final _priceController = TextEditingController(text: '1,100원');
  final _bodyController = TextEditingController();

  final String _selectedCategory = '전자기기 > 충전기 > C타입 충전기';
  String _rentalPeriod = '선택하기';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글 이름을 입력해 주세요')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final rawPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(rawPrice) ?? 1100;
    final regionName = await PostService.fetchRegionName() ?? '영통동';

    final postId = await PostService.createPost({
      'post_type': 'BORROW',
      'title': title,
      'content': _bodyController.text.trim(),
      'price': price,
      'category': '전자기기',
      'is_urgent': false,
      'rental_period_text': _rentalPeriod,
      'region_name': regionName,
      'lat': 37.2565,
      'lng': 127.0519,
      'image_urls': <String>[],
    });

    if (!mounted) return;
    if (postId == null) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글 등록에 실패했습니다.')),
      );
      return;
    }

    final createdPost = await PostService.fetchPostDetail(postId);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (createdPost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글은 등록됐지만 상세 정보를 불러오지 못했습니다.')),
      );
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/post-detail',
      arguments: createdPost,
    );
  }

  void _openRentalPeriodSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RentalPeriodBottomSheet(
          initialValue: _rentalPeriod,
          onSelected: (value) => setState(() => _rentalPeriod = value),
        );
      },
    );
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
        title: Text(
          '게시글 작성',
          style: AppTypography.b2.copyWith(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CreateSectionTitle(title: '사진 등록'),
                  const SizedBox(height: 8),
                  const PhotoUploadBox(),
                  const SizedBox(height: 24),
                  const CreateSectionTitle(title: '게시글 이름'),
                  const SizedBox(height: 8),
                  CreateInputField(controller: _titleController),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/category'),
                    child: const CategoryHeader(),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/category'),
                    child: ReadonlyField(value: _selectedCategory),
                  ),
                  const SizedBox(height: 24),
                  const CreateSectionTitle(title: '대여 기간'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _openRentalPeriodSheet,
                    child: ReadonlyField(
                      value: _rentalPeriod,
                      valueColor: _rentalPeriod == '선택하기'
                          ? AppColors.textHint
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CreateSectionTitle(title: '가격'),
                  const SizedBox(height: 8),
                  const PriceHintBanner(),
                  const SizedBox(height: 8),
                  CreateInputField(controller: _priceController),
                  const SizedBox(height: 24),
                  const CreateSectionTitle(title: '게시글 본문'),
                  const SizedBox(height: 8),
                  BodyInputField(controller: _bodyController),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 8, 17, 16),
            child: CommonButton(
              text: _isSubmitting ? '등록 중...' : '확인',
              onPressed: _isSubmitting ? null : _submitPost,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
