import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryAddFab extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final double iconSize;
  final double elevationBlur;

  const PrimaryAddFab({
    super.key,
    required this.onTap,
    this.icon = Icons.add,
    this.size = 64,
    this.iconSize = 36,
    this.elevationBlur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: elevationBlur,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
