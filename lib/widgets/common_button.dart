import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ButtonType { primary, secondary, outline }

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isFullWidth;
  final double? height;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buildStyle(),
        child: Text(text, style: _buildTextStyle()),
      ),
    );
  }

  ButtonStyle _buildStyle() {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.bgPage,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          side: const BorderSide(color: AppColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        );
      case ButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        );
    }
  }

  TextStyle _buildTextStyle() {
    switch (type) {
      case ButtonType.primary:
        return AppTypography.b2.copyWith(color: AppColors.white);
      case ButtonType.secondary:
        return AppTypography.b2.copyWith(color: AppColors.textDark);
      case ButtonType.outline:
        return AppTypography.b2.copyWith(color: AppColors.primary);
    }
  }
}
