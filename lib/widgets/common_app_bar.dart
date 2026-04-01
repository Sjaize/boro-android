import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;

  const CommonAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      automaticallyImplyLeading: showBackButton,
      title: title != null
          ? Text(
              title!,
              style: AppTypography.h3.copyWith(color: AppColors.textDark),
            )
          : null,
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.divider),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
