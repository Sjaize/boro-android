import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class NotificationLockScreen extends StatelessWidget {
  const NotificationLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34106D),
              Color(0xFF235DAB),
              Color(0xFF23C7CE),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: 20,
                child: Text(
                  '9:41',
                  style: AppTypography.b2.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Positioned(
                top: 10,
                right: 18,
                child: _StatusIcons(),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '9:41',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.white,
                        fontSize: 76,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '2026년 3월 29일',
                      style: AppTypography.b3.copyWith(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 86),
                    const _LockNotificationCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcons extends StatelessWidget {
  const _StatusIcons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.signal_cellular_alt, size: 18, color: Colors.white),
        const SizedBox(width: 6),
        const Icon(Icons.wifi, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Container(
          width: 24,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 16,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LockNotificationCard extends StatelessWidget {
  const _LockNotificationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      padding: const EdgeInsets.fromLTRB(16, 21, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 2.8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Boro',
              style: AppTypography.c1.copyWith(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'BORO',
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '2분 전',
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '150m - 수익 기회가 생겼어요!',
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '노트북 충전기 (C타입), 2000원, 지금 당장 필요해요',
                  style: AppTypography.c2.copyWith(
                    color: AppColors.textDark,
                    height: 1.25,
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
