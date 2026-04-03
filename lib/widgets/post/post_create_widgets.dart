import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common_button.dart';

class CreateSectionTitle extends StatelessWidget {
  final String title;

  const CreateSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTypography.h3.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PhotoUploadBox extends StatelessWidget {
  const PhotoUploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: AppColors.primary.withValues(alpha: 0.8),
        radius: 5,
      ),
      child: Container(
        width: double.infinity,
        height: 106,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '사진을 첨부하세요',
                style: AppTypography.c2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '카테고리',
          style: AppTypography.h3.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        SvgPicture.asset(
          'assets/icons/ic_chevron_right_small.svg',
          width: 8,
          height: 15,
        ),
      ],
    );
  }
}

class PriceHintBanner extends StatelessWidget {
  const PriceHintBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'AI 추천',
              style: AppTypography.c2.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '1시간 당 1,100원에 거래되고 있어요',
              overflow: TextOverflow.ellipsis,
              style: AppTypography.c2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateInputField extends StatelessWidget {
  final TextEditingController controller;

  const CreateInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: AppTypography.c2.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class ReadonlyField extends StatelessWidget {
  final String value;
  final Color? valueColor;

  const ReadonlyField({
    super.key,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: AppTypography.c2.copyWith(
          color: valueColor ?? AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BodyInputField extends StatelessWidget {
  final TextEditingController controller;

  const BodyInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 111,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        style: AppTypography.c2.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: '게시글 내용을 입력해 주세요',
          hintStyle: AppTypography.c2.copyWith(
            color: AppColors.textHint,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class RentalPeriodBottomSheet extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSelected;

  const RentalPeriodBottomSheet({
    super.key,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<RentalPeriodBottomSheet> createState() => _RentalPeriodBottomSheetState();
}

class _RentalPeriodBottomSheetState extends State<RentalPeriodBottomSheet> {
  static const List<String> _units = ['시간', '일', '개월'];

  late String _selectedUnit;
  int _selectedValue = 1;

  @override
  void initState() {
    super.initState();
    _selectedUnit = _parseUnit(widget.initialValue);
  }

  String _parseUnit(String value) {
    if (value.contains('개월')) {
      return '개월';
    }
    if (value.contains('일')) {
      return '일';
    }
    return '시간';
  }

  String get _displayValue => '$_selectedValue$_selectedUnit';

  void _decreaseValue() {
    if (_selectedValue <= 1) return;
    setState(() => _selectedValue -= 1);
  }

  void _increaseValue() {
    setState(() => _selectedValue += 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      decoration: const BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '대여 기간',
            style: AppTypography.h2.copyWith(
              color: AppColors.textDark,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '현재 위치를 변경할 수 있어요.',
            style: AppTypography.b4.copyWith(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            height: 41,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: _units.map((unit) {
                final isSelected = unit == _selectedUnit;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedUnit = unit),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        unit,
                        style: AppTypography.b4.copyWith(
                          color: isSelected ? AppColors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54),
            child: Row(
              children: [
              _PeriodAdjustButton(
                label: '-',
                onTap: _decreaseValue,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$_selectedValue',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.textDark,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              _PeriodAdjustButton(
                label: '+',
                onTap: _increaseValue,
              ),
              ],
            ),
          ),
          const SizedBox(height: 54),
          CommonButton(
            text: '확인',
            height: 40,
            onPressed: () {
              widget.onSelected(_displayValue);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _PeriodAdjustButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PeriodAdjustButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.h3.copyWith(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1.5, 1.5, size.width - 3, size.height - 3),
      Radius.circular(radius - 0.5),
    );
    final path = Path()..addRRect(rect);

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
