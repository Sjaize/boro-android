import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  static const String _baseUrl =
      'https://boro-backend-production.up.railway.app';

  static const List<_MenuSectionData> _sections = [
    _MenuSectionData(title: '나의 활동', items: ['거래내역', '내가 쓴 글', '관심목록']),
    _MenuSectionData(title: '설정', items: ['내 위치 설정', '알림 설정']),
    _MenuSectionData(title: '고객 지원', items: ['고객 센터', '파손 문의', '보로 케어 공지']),
  ];

  static const List<String> _locationOptions = ['위치 1', '위치 2'];
  static const List<String> _profileImageOptions = [
    'https://picsum.photos/seed/boro-profile-1/240/240',
    'https://picsum.photos/seed/boro-profile-2/240/240',
    'https://picsum.photos/seed/boro-profile-3/240/240',
    'https://picsum.photos/seed/boro-profile-4/240/240',
    'https://picsum.photos/seed/boro-profile-5/240/240',
    'https://picsum.photos/seed/boro-profile-6/240/240',
  ];

  late Future<_MyPageData> _myPageFuture;

  @override
  void initState() {
    super.initState();
    _myPageFuture = _loadMyPageData();
  }

  Future<_MyPageData> _loadMyPageData() async {
    try {
      await _syncMyLocation().timeout(const Duration(seconds: 2));
    } catch (_) {
      // 위치 동기화 실패 시에도 마이페이지 조회는 계속 진행합니다.
    }
    return _fetchMyPageData().timeout(const Duration(seconds: 3));
  }

  Future<void> _syncMyLocation() async {
    if (!PostService.isAuthenticated) return;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    ).timeout(const Duration(seconds: 2));

    final client = HttpClient();
    try {
      final request = await client.putUrl(
        Uri.parse('$_baseUrl/api/users/me/location'),
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );
      request.write(
        jsonEncode({'lat': position.latitude, 'lng': position.longitude}),
      );

      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('위치 업데이트에 실패했습니다. (${response.statusCode})');
      }
      await response.drain<void>();
    } finally {
      client.close(force: true);
    }
  }

  Future<_MyPageData> _fetchMyPageData() async {
    if (!PostService.isAuthenticated) {
      throw const HttpException('JWT_REQUIRED');
    }
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/api/users/me'));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      final response = await request.close().timeout(
        const Duration(seconds: 3),
      );
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 3));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('마이페이지 정보를 불러오지 못했습니다. (${response.statusCode})');
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      return _MyPageData.fromJson(data);
    } finally {
      client.close(force: true);
    }
  }

  Future<_MyPageData> _updateProfile({
    required _MyPageData currentData,
    required String nickname,
    required String profileImageUrl,
  }) async {
    debugPrint(
      'MYPAGE_PROFILE_PATCH_START nickname=$nickname image=${profileImageUrl.isNotEmpty} auth=${PostService.isAuthenticated}',
    );
    if (!PostService.isAuthenticated) {
      debugPrint('MYPAGE_PROFILE_PATCH_ABORT reason=JWT_REQUIRED');
      throw const HttpException('JWT_REQUIRED');
    }
    final client = HttpClient();
    try {
      final payload = jsonEncode({
        'nickname': nickname,
        'profile_image_url': profileImageUrl,
      });
      debugPrint('MYPAGE_PROFILE_PATCH_URL=$_baseUrl/api/users/me');
      debugPrint('MYPAGE_PROFILE_PATCH_PAYLOAD=$payload');

      final request = await client.patchUrl(
        Uri.parse('$_baseUrl/api/users/me'),
      );
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=utf-8',
      );
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${PostService.accessToken}',
      );

      request.add(utf8.encode(payload));
      debugPrint('MYPAGE_PROFILE_PATCH_REQUEST_WRITTEN=true');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      debugPrint('MYPAGE_PROFILE_PATCH_STATUS=${response.statusCode}');
      debugPrint('MYPAGE_PROFILE_PATCH_BODY=$body');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          body.isNotEmpty
              ? '프로필 수정에 실패했습니다. (${response.statusCode})'
              : '프로필 수정에 실패했습니다.',
        );
      }

      if (body.isEmpty) {
        return currentData.copyWith(
          nickname: nickname,
          profileImageUrl: profileImageUrl.isEmpty ? null : profileImageUrl,
        );
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final updatedJson = decoded['data'] as Map<String, dynamic>? ?? {};
      debugPrint('MYPAGE_PROFILE_PATCH_SUCCESS=true');
      return currentData.copyWith(
        id: (updatedJson['id'] as num?)?.toInt(),
        nickname: (updatedJson['nickname'] as String?)?.trim(),
        profileImageUrl: (updatedJson['profile_image_url'] as String?)?.trim(),
      );
    } catch (error, stackTrace) {
      debugPrint('MYPAGE_PROFILE_PATCH_ERROR=$error');
      debugPrint('$stackTrace');
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  void _reloadMyPage() {
    setState(() {
      _myPageFuture = _loadMyPageData();
    });
  }

  Future<void> _showEditProfileDialog(_MyPageData data) async {
    final updated = await showDialog<_MyPageData>(
      context: context,
      builder: (_) => _EditProfileDialog(
        initialData: data,
        profileImageOptions: _profileImageOptions,
        onSubmit: (nickname, profileImageUrl) => _updateProfile(
          currentData: data,
          nickname: nickname,
          profileImageUrl: profileImageUrl,
        ),
      ),
    );

    if (!mounted || updated == null) return;
    setState(() {
      _myPageFuture = Future.value(updated);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필을 수정했습니다.')));
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/trade');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat-list'); /*
          const SnackBar(content: Text('해당 화면은 아직 준비 중입니다.')),
        ); */
        break;
      case 3:
        break;
    }
  }

  void _showPendingMessage(BuildContext context, String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')));
  }

  Future<void> _showLocationSettingsSheet(BuildContext context) async {
    var selectedLocation = _locationOptions.first;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 위치 설정',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '현재 위치를 변경할 수 있어요.',
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 22),
                    for (final option in _locationOptions)
                      _LocationOptionTile(
                        label: option,
                        isSelected: selectedLocation == option,
                        onTap: () {
                          setModalState(() {
                            selectedLocation = option;
                          });
                        },
                      ),
                    const SizedBox(height: 22),
                    CommonButton(
                      text: '위치 변경하기',
                      type: ButtonType.primary,
                      height: 44,
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$selectedLocation 위치로 변경했습니다.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleMenuTap(BuildContext context, String label) {
    if (label == '거래내역') {
      Navigator.pushNamed(context, '/trade-history');
      return;
    }

    if (label == '내가 쓴 글') {
      Navigator.pushNamed(context, '/my-posts');
      return;
    }

    if (label == '관심목록') {
      Navigator.pushNamed(context, '/favorites');
      return;
    }

    if (label == '내 위치 설정') {
      _showLocationSettingsSheet(context);
      return;
    }

    if (label == '알림 설정') {
      Navigator.pushNamed(context, '/notification-settings');
      return;
    }

    _showPendingMessage(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
          child: Text(
            '마이페이지',
            style: AppTypography.h1.copyWith(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showPendingMessage(context, '알림'),
            icon: SvgPicture.asset(
              'assets/icons/ic_mypage_bell.svg',
              width: 19,
              height: 19,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FutureBuilder<_MyPageData>(
        future: _myPageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return _MyPageErrorState(
              message: '마이페이지 정보를 불러오지 못했습니다.',
              onRetry: _reloadMyPage,
            );
          }

          final data = snapshot.data ?? _MyPageData.empty();
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _ProfileHeader(
                data: data,
                onEditPressed: () => _showEditProfileDialog(data),
              ),
              _StatsSection(stats: data.stats),
              for (final section in _sections)
                _MenuSection(
                  section: section,
                  onTap: (label) => _handleMenuTap(context, label),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: 3,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.data, required this.onEditPressed});

  final _MyPageData data;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileAvatar(imageUrl: data.profileImageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nickname,
                        style: AppTypography.b2.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${data.location} / 거래 ${data.tradeCount}회',
                        style: AppTypography.c2.copyWith(
                          color: AppColors.white.withValues(alpha: 0.92),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  _TrustFillIcon(fillPercent: data.trustFillRatio),
                  const SizedBox(height: 6),
                  Text(
                    '신뢰도 ${data.trustPercentText}%',
                    style: AppTypography.c1.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onEditPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                '프로필 수정',
                style: AppTypography.b2.copyWith(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2.5),
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: hasImage
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFF5C38B), Color(0xFF9C5D34)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: hasImage
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const _DefaultProfileAvatarIcon(),
                )
              : const _DefaultProfileAvatarIcon(),
        ),
      ),
    );
  }
}

class _DefaultProfileAvatarIcon extends StatelessWidget {
  const _DefaultProfileAvatarIcon();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5C38B), Color(0xFF9C5D34)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.person, color: AppColors.white, size: 32),
      ),
    );
  }
}

class _TrustFillIcon extends StatelessWidget {
  const _TrustFillIcon({required this.fillPercent});

  final double fillPercent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 42),
      painter: _TrustIconPainter(fillPercent: fillPercent),
    );
  }
}

class _TrustIconPainter extends CustomPainter {
  const _TrustIconPainter({required this.fillPercent});

  final double fillPercent;

  @override
  void paint(Canvas canvas, Size size) {
    final clampedFill = fillPercent.clamp(0.0, 1.0);

    final headPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * (11.25 / 42)),
          radius: size.width * (8.75 / 42),
        ),
      );

    final bodyPath = Path()
      ..moveTo(size.width * (2.46 / 42), size.height * (40.5 / 42))
      ..quadraticBezierTo(
        size.width * (5.8 / 42),
        size.height * (29.2 / 42),
        size.width / 2,
        size.height * (26.98 / 42),
      )
      ..quadraticBezierTo(
        size.width * (36.2 / 42),
        size.height * (29.2 / 42),
        size.width * (39.54 / 42),
        size.height * (40.5 / 42),
      )
      ..lineTo(size.width * (2.46 / 42), size.height * (40.5 / 42))
      ..close();

    final fillPath = Path()
      ..addPath(headPath, Offset.zero)
      ..addPath(bodyPath, Offset.zero);

    final fillTop = size.height * (1 - clampedFill);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, fillTop, size.width, size.height));
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0x80FAFAFA)
        ..style = PaintingStyle.fill,
    );
    canvas.restore();

    final strokePaint = Paint()
      ..color = const Color(0xFFFAFAFA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (2.5 / 42)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(headPath, strokePaint);
    canvas.drawPath(bodyPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _TrustIconPainter oldDelegate) {
    return oldDelegate.fillPercent != fillPercent;
  }
}

class _EditProfileImagePlaceholder extends StatelessWidget {
  const _EditProfileImagePlaceholder({this.isCircular = false});

  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F7),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.textHint,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            isCircular ? '사진 추가' : '프로필 이미지',
            style: AppTypography.c2.copyWith(color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.initialData,
    required this.profileImageOptions,
    required this.onSubmit,
  });

  final _MyPageData initialData;
  final List<String> profileImageOptions;
  final Future<_MyPageData> Function(String nickname, String profileImageUrl)
  onSubmit;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  late String _imageUrl;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(
      text: widget.initialData.nickname,
    );
    _imageUrl = widget.initialData.profileImageUrl ?? '';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;
    debugPrint(
      'MYPAGE_PROFILE_SUBMIT_TAP nickname=${_nicknameController.text.trim()} image=${_imageUrl.isNotEmpty}',
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      debugPrint('MYPAGE_PROFILE_SUBMIT_CALLING_PATCH=true');
      final updatedData = await widget.onSubmit(
        _nicknameController.text.trim(),
        _imageUrl.trim(),
      );
      debugPrint('MYPAGE_PROFILE_SUBMIT_PATCH_RETURNED=true');
      if (!mounted) return;
      Navigator.of(context).pop(updatedData);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      debugPrint('MYPAGE_PROFILE_SUBMIT_FAILED=true');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필 수정에 실패했습니다.')));
    }
  }

  Future<void> _editImageUrl() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Text(
            '프로필 사진 선택',
            style: AppTypography.h3.copyWith(color: AppColors.textDark),
          ),
          content: SizedBox(
            width: 296,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final option in widget.profileImageOptions)
                  _ProfileImageOptionTile(
                    imageUrl: option,
                    isSelected: _imageUrl == option,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(''),
              child: const Text('기본 이미지'),
            ),
          ],
        );
      },
    );

    if (result == null || !mounted) return;
    setState(() {
      _imageUrl = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 57),
        child: Form(
          key: _formKey,
          child: Container(
            width: 270,
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textMedium,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isSubmitting ? null : _editImageUrl,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF2F4F7),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _imageUrl.isNotEmpty
                                ? Image.network(
                                    _imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const _EditProfileImagePlaceholder(
                                          isCircular: true,
                                        ),
                                  )
                                : const _EditProfileImagePlaceholder(
                                    isCircular: true,
                                  ),
                          ),
                          if (_imageUrl.isNotEmpty)
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.textDark.withValues(
                                  alpha: 0.38,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.photo_camera_outlined,
                                color: AppColors.white,
                                size: 22,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: AppColors.textMedium,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '프로필 사진 수정',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.textMedium,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextFormField(
                    controller: _nicknameController,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    style: AppTypography.b2.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: '닉네임',
                      hintStyle: AppTypography.b2.copyWith(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xFFD92D20)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xFFD92D20)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '닉네임을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            '저장',
                            style: AppTypography.b2.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileImageOptionTile extends StatelessWidget {
  const _ProfileImageOptionTile({
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE4E7EC),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const _EditProfileImagePlaceholder(isCircular: true),
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.stats});

  final List<_MyStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: const BorderSide(color: AppColors.border),
                    bottom: const BorderSide(color: AppColors.border),
                    right: i == stats.length - 1
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stats[i].value,
                      style: AppTypography.b2.copyWith(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stats[i].label,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MyPageErrorState extends StatelessWidget {
  const _MyPageErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.textHint,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.b4.copyWith(color: AppColors.textMedium),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 140,
              child: CommonButton(
                text: '다시 시도',
                type: ButtonType.primary,
                isFullWidth: true,
                height: 44,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.section, required this.onTap});

  final _MenuSectionData section;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            section.title,
            style: AppTypography.h3.copyWith(
              color: AppColors.textDark,
              fontSize: 18,
            ),
          ),
        ),
        for (final item in section.items)
          _MenuTile(label: item, onTap: () => onTap(item)),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.b4.copyWith(color: AppColors.textDark),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationOptionTile extends StatelessWidget {
  const _LocationOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textHint,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.b4.copyWith(color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPageData {
  final int id;
  final String nickname;
  final String? profileImageUrl;
  final String location;
  final double trustScore;
  final int borrowCount;
  final int lendCount;
  final int likeCount;

  const _MyPageData({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.location,
    required this.trustScore,
    required this.borrowCount,
    required this.lendCount,
    required this.likeCount,
  });

  factory _MyPageData.fromJson(Map<String, dynamic> json) {
    return _MyPageData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nickname: (json['nickname'] as String?)?.trim().isNotEmpty == true
          ? json['nickname'] as String
          : '닉네임',
      profileImageUrl: json['profile_image_url'] as String?,
      location: (json['region_name'] as String?)?.trim().isNotEmpty == true
          ? json['region_name'] as String
          : '위치 미설정',
      trustScore: (json['trust_score'] as num?)?.toDouble() ?? 0,
      borrowCount: (json['borrow_count'] as num?)?.toInt() ?? 0,
      lendCount: (json['lend_count'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
    );
  }

  factory _MyPageData.empty() {
    return const _MyPageData(
      id: 0,
      nickname: '닉네임',
      profileImageUrl: null,
      location: '위치 미설정',
      trustScore: 0,
      borrowCount: 0,
      lendCount: 0,
      likeCount: 0,
    );
  }

  int get tradeCount => borrowCount + lendCount;

  double get trustPercent => ((trustScore.clamp(0.0, 5.0) / 5) * 100);

  double get trustFillRatio => trustPercent / 100;

  String get trustPercentText => trustPercent.round().toString();

  _MyPageData copyWith({
    int? id,
    String? nickname,
    String? profileImageUrl,
    String? location,
    double? trustScore,
    int? borrowCount,
    int? lendCount,
    int? likeCount,
  }) {
    return _MyPageData(
      id: id ?? this.id,
      nickname: nickname == null || nickname.isEmpty ? this.nickname : nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      trustScore: trustScore ?? this.trustScore,
      borrowCount: borrowCount ?? this.borrowCount,
      lendCount: lendCount ?? this.lendCount,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  List<_MyStat> get stats => [
    _MyStat(label: '빌린 횟수', value: '$borrowCount'),
    _MyStat(label: '빌려준 횟수', value: '$lendCount'),
    _MyStat(label: '관심목록', value: '$likeCount'),
  ];
}

class _MyStat {
  final String label;
  final String value;

  const _MyStat({required this.label, required this.value});
}

class _MenuSectionData {
  final String title;
  final List<String> items;

  const _MenuSectionData({required this.title, required this.items});
}
