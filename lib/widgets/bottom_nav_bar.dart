import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class BoroBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BoroBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavItem(
                  width: 96,
                  icon: 'assets/icons/ic_home.svg',
                  activeIcon: 'assets/icons/ic_home_active.svg',
                  label: '홈',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  width: 96,
                  icon: 'assets/icons/ic_trade.svg',
                  activeIcon: 'assets/icons/ic_trade_active.svg',
                  label: '거래',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  width: 96,
                  icon: 'assets/icons/ic_chat.svg',
                  activeIcon: 'assets/icons/ic_chat_active.svg',
                  label: '채팅',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  width: 96,
                  icon: 'assets/icons/ic_mypage.svg',
                  activeIcon: 'assets/icons/ic_mypage_active.svg',
                  label: '마이',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final double width;
  final String icon;
  final String activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.width,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textLight;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              isSelected ? activeIcon : icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.c2.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
