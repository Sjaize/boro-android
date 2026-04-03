import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_button.dart';
import '../../widgets/post/post_create_widgets.dart';

enum _PostCreateType {
  urgent('긴급', 'BORROW', true),
  borrow('빌려주세요', 'BORROW', false),
  lend('빌려드려요', 'LEND', false);

  const _PostCreateType(this.label, this.postType, this.isUrgent);

  final String label;
  final String postType;
  final bool isUrgent;
}

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _bodyController = TextEditingController();

  final String _selectedCategory = '전자기기 > 충전기 > C타입 충전기';
  String _rentalPeriod = '선택하기';
  bool _isSubmitting = false;
  _PostCreateType? _selectedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedType != null) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['type'] is String) {
      _selectedType = _typeFromArg(args['type'] as String);
    } else if (args is String) {
      _selectedType = _typeFromArg(args);
    } else {
      _selectedType = _PostCreateType.borrow;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  _PostCreateType _typeFromArg(String raw) {
    switch (raw) {
      case 'urgent':
        return _PostCreateType.urgent;
      case 'lend':
        return _PostCreateType.lend;
      case 'borrow':
      default:
        return _PostCreateType.borrow;
    }
  }

  Future<void> _submitPost() async {
    final selectedType = _selectedType ?? _PostCreateType.borrow;
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final rawPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(rawPrice) ?? 0;

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글 제목을 입력해 주세요.')));
      return;
    }
    if (body.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글 본문을 입력해 주세요.')));
      return;
    }
    if (price == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('가격을 입력해 주세요.')));
      return;
    }
    if (_rentalPeriod == '선택하기') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('대여 기간을 선택해 주세요.')));
      return;
    }

    setState(() => _isSubmitting = true);
    final regionName = await PostService.fetchRegionName() ?? '상현동';

    double lat = 37.2397;
    double lng = 127.0833;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
        ).timeout(const Duration(seconds: 5));
        lat = pos.latitude;
        lng = pos.longitude;
      }
    } catch (_) {}

    final postId = await PostService.createPost({
      'post_type': selectedType.postType,
      'title': title,
      'content': body,
      'price': price,
      'category': '전자기기',
      'is_urgent': selectedType.isUrgent,
      'rental_period_text': _rentalPeriod,
      'region_name': regionName,
      'lat': lat,
      'lng': lng,
      'image_urls': <String>[],
    });

    if (!mounted) return;
    if (postId == null) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글 등록에 실패했습니다.')));
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
    final selectedType = _selectedType ?? _PostCreateType.borrow;

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
        title: PopupMenuButton<_PostCreateType>(
          initialValue: selectedType,
          onSelected: (type) => setState(() => _selectedType = type),
          color: AppColors.white,
          elevation: 8,
          offset: const Offset(0, 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          itemBuilder: (context) => _PostCreateType.values
              .map(
                (type) => PopupMenuItem<_PostCreateType>(
                  value: type,
                  child: Text(
                    type.label,
                    style: AppTypography.b4.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedType.label,
                style: AppTypography.b2.copyWith(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                'assets/icons/ic_chevron_down.svg',
                width: 14,
                height: 8,
              ),
            ],
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
                  const CreateSectionTitle(title: '게시글 제목'),
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
