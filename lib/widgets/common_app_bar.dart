import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final bool showBottomDivider;

  const CommonAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor = AppColors.white,
    this.showBottomDivider = true,
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
                  icon: SvgPicture.asset(
                    'assets/icons/ic_back.svg',
                    width: 18,
                    height: 18,
                  ),
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
      bottom: showBottomDivider
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, color: AppColors.divider),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (showBottomDivider ? 1 : 0),
      );
}
