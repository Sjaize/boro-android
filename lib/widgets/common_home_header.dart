import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CommonHomeHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTitleTap;
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationTap;

  const CommonHomeHeader({
    super.key,
    this.title = '지역명',
    this.onTitleTap,
    required this.onSearchTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleRow = Row(
      children: [
        Text(
          title,
          style: AppTypography.h1.copyWith(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: SvgPicture.asset(
            'assets/icons/ic_chevron_down.svg',
            width: 14,
            height: 8,
          ),
        ),
      ],
    );

    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        child: Row(
          children: [
            if (onTitleTap == null)
              titleRow
            else
              GestureDetector(
                onTap: onTitleTap,
                behavior: HitTestBehavior.opaque,
                child: titleRow,
              ),
            const Spacer(),
            InkWell(
              onTap: onSearchTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/icons/ic_search.svg',
                  width: 19,
                  height: 19,
                ),
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: onNotificationTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/icons/ic_bell.svg',
                  width: 20,
                  height: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
