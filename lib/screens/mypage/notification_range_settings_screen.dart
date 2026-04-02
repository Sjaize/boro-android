import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';

class NotificationRangeSettingsScreen extends StatefulWidget {
  const NotificationRangeSettingsScreen({super.key});

  @override
  State<NotificationRangeSettingsScreen> createState() =>
      _NotificationRangeSettingsScreenState();
}

class _NotificationRangeSettingsScreenState
    extends State<NotificationRangeSettingsScreen> {
  static const List<int> _rangeSteps = [1, 3, 5, 7, 10];
  double _sliderValue = 1;

  int get _selectedRangeKm => _rangeSteps[_sliderValue.round()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '알림 수신 범위 설정',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(child: _RangeMapPanel()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _RangeBottomSheet(
                    selectedRangeKm: _selectedRangeKm,
                    sliderValue: _sliderValue,
                    rangeSteps: _rangeSteps,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                    onApply: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('알림 수신 범위를 ${_selectedRangeKm}km로 설정했습니다.'),
                        ),
                      );
                    },
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

class _RangeMapPanel extends StatelessWidget {
  const _RangeMapPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFEFF4FA),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapBackdropPainter(),
                ),
              ),
              Positioned(
                left: -18,
                top: 0,
                right: -18,
                child: Transform.rotate(
                  angle: -0.02,
                  child: const _RoadStripe(
                    width: 420,
                    height: 26,
                    color: Color(0xFFF5E7AA),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  color: const Color(0xFFF9FBFE),
                ),
              ),
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: const Color(0xFFB9BEC5),
                ),
              ),
              const Positioned(
                left: -2,
                top: 214,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    '회색선길 / 경기대로 / 덕현로',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                top: 90,
                child: _MapLabel(text: '외국어대학관'),
              ),
              Positioned(
                right: 36,
                top: 68,
                child: _MapLabel(text: '공과대학'),
              ),
              Positioned(
                right: 6,
                top: 286,
                child: _MapLabel(text: '예술대학'),
              ),
              Positioned(
                right: 58,
                bottom: 104,
                child: _MapLabel(text: '교내호수'),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 76,
                bottom: 114,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(18, 4),
                      child: _RangeRing(
                        size: 336,
                        color: AppColors.primary.withValues(alpha: 0.10),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(18, 4),
                      child: _RangeRing(
                        size: 220,
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(18, 4),
                      child: _RangeRing(
                        size: 98,
                        color: AppColors.primary.withValues(alpha: 0.16),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(18, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 14,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0x331570EF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 38,
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(0, -2),
                            child: Text(
                              '경희대학교\n국제캠퍼스',
                              textAlign: TextAlign.center,
                              style: AppTypography.c1.copyWith(
                                color: const Color(0xFF6B7A90),
                                height: 1.28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RangeBottomSheet extends StatelessWidget {
  const _RangeBottomSheet({
    required this.selectedRangeKm,
    required this.sliderValue,
    required this.rangeSteps,
    required this.onChanged,
    required this.onApply,
  });

  final int selectedRangeKm;
  final double sliderValue;
  final List<int> rangeSteps;
  final ValueChanged<double> onChanged;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '범위 설정',
                  style: AppTypography.h2.copyWith(color: AppColors.textDark),
                ),
                const SizedBox(width: 16),
                Text(
                  '${selectedRangeKm}km',
                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '반경 ${selectedRangeKm}km 이내 새 물품 등록 시 알림을 받아요',
              style: AppTypography.c2.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: AppColors.border,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.10),
                      trackHeight: 2,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0,
                      max: (rangeSteps.length - 1).toDouble(),
                      divisions: rangeSteps.length - 1,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final step in rangeSteps)
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${step}km',
                        textAlign: TextAlign.center,
                        style: AppTypography.c2.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CommonButton(
              text: '적용하기',
              type: ButtonType.primary,
              height: 40,
              onPressed: onApply,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTypography.c2.copyWith(color: AppColors.textLight),
      ),
    );
  }
}

class _RangeRing extends StatelessWidget {
  const _RangeRing({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _RoadStripe extends StatelessWidget {
  const _RoadStripe({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.white, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD8E2EE)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE5ECF4)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final blockPaint = Paint()
      ..color = const Color(0xFFDCE5EF)
      ..style = PaintingStyle.fill;

    final waterPaint = Paint()
      ..color = const Color(0xFFB5D7FF)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFFFDFEFF)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    void drawRoad(Offset p1, Offset p2, Paint basePaint) {
      canvas.drawLine(p1, p2, outlinePaint);
      canvas.drawLine(p1, p2, basePaint);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.60, size.height * 0.10, 86, 62),
        const Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.45, size.height * 0.48, 106, 86),
        const Radius.circular(10),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.68, size.height * 0.71, 92, 60),
        const Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.80, size.height * 0.30, 16, 10),
        const Radius.circular(6),
      ),
      waterPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.88, size.height * 0.52, 14, 10),
        const Radius.circular(6),
      ),
      waterPaint,
    );

    drawRoad(
      Offset(size.width * 0.07, size.height * 0.18),
      Offset(size.width * 0.78, size.height * 0.08),
      roadPaint,
    );
    drawRoad(
      Offset(size.width * 0.22, size.height * 0.18),
      Offset(size.width * 0.12, size.height * 0.90),
      roadPaint,
    );
    drawRoad(
      Offset(size.width * 0.12, size.height * 0.56),
      Offset(size.width * 0.96, size.height * 0.72),
      roadPaint,
    );
    drawRoad(
      Offset(size.width * 0.34, size.height * 0.10),
      Offset(size.width * 0.33, size.height * 0.84),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.46, size.height * 0.20),
      Offset(size.width * 0.82, size.height * 0.28),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.52, size.height * 0.44),
      Offset(size.width * 0.95, size.height * 0.56),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.56, size.height * 0.66),
      Offset(size.width * 0.86, size.height * 0.90),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.14, size.height * 0.28),
      Offset(size.width * 0.28, size.height * 0.40),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.28, size.height * 0.40),
      Offset(size.width * 0.40, size.height * 0.34),
      minorRoadPaint,
    );
    drawRoad(
      Offset(size.width * 0.60, size.height * 0.62),
      Offset(size.width * 0.68, size.height * 0.82),
      minorRoadPaint,
    );

    final buildingStroke = Paint()
      ..color = const Color(0xFFC8D5E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, size.height * 0.30, 40, 32),
        const Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.18, size.height * 0.30, 40, 32),
        const Radius.circular(8),
      ),
      buildingStroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.72, size.height * 0.48, 34, 28),
        const Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.72, size.height * 0.48, 34, 28),
        const Radius.circular(8),
      ),
      buildingStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
