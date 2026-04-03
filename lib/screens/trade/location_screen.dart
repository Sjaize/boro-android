import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  static const List<String> _nearbyAreas = [
    '경기도 수원시 영통구 신동',
    '경기도 수원시 영통구 망포1동',
    '경기도 용인시 기흥구 보라동',
    '경기도 수원시 영통구 망포동',
    '경기도 용인시 기흥구 하갈동',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openMapScreen() async {
    final result = await Navigator.pushNamed(context, '/location-map');
    if (!mounted) return;
    if (result is String) {
      Navigator.pop(context, result);
    }
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
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/ic_back.svg',
            width: 18,
            height: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          '위치 등록',
          style: AppTypography.b2.copyWith(color: AppColors.textDark),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 9, 17, 0),
            child: Column(
              children: [
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: AppTypography.c2.copyWith(
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: '지번, 도로명, 건물명으로 검색',
                            hintStyle: AppTypography.c2.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.search,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                if (false) const SizedBox(height: 8),
                GestureDetector(
                  onTap: _openMapScreen,
                  child: Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.bgPage,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.primary),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '현재 위치로 찾기',
                      style: AppTypography.c2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '근처 동네',
              style: AppTypography.h3.copyWith(color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _nearbyAreas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _openMapScreen,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _nearbyAreas[index],
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  static const double _lat = 37.2565;
  static const double _lng = 127.0519;

  bool _isRegistering = false;

  Future<void> _registerLocation() async {
    setState(() => _isRegistering = true);
    final regionName = await UserService.updateLocation(_lat, _lng);
    if (!mounted) return;
    setState(() => _isRegistering = false);
    Navigator.pop(context, regionName ?? '영통동');
    Navigator.pop(context, regionName ?? '영통동');
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
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/ic_back.svg',
            width: 18,
            height: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          '지도에서 위치 확인',
          style: AppTypography.b2.copyWith(color: AppColors.textDark),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 520,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: const Color(0xFFE9EFF7),
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                    size: Size.infinite,
                  ),
                ),
                _buildRadiusCircles(),
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 36,
                ),
                Positioned(
                  right: 14,
                  bottom: 15,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.gps_fixed,
                      size: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 30, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '경기도 용인시 기흥구 덕영대로 1732',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (false) const SizedBox(height: 8),
                if (false) Text(
                  '경기도 용인시 기흥구 하갈동 520',
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 17, 45),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _isRegistering ? null : _registerLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: _isRegistering
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        '이 위치로 주소 등록',
                        style: AppTypography.b3.copyWith(
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusCircles() {
    return SizedBox(
      width: 406,
      height: 406,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 406,
            height: 406,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.05),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          Container(
            width: 244,
            height: 244,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD7E1EF)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 8;
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.45),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
