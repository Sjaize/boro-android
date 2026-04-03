import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CommonUnderlineTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double height;

  const CommonUnderlineTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final isSelected = index == selectedIndex;
        return Expanded(
          child: InkWell(
            onTap: () => onTap(index),
            child: Container(
              height: height,
              color: AppColors.bgPage,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                labels[index],
                style: AppTypography.b4.copyWith(
                  color: isSelected ? AppColors.textDark : AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
