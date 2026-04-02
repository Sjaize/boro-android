import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class LocationNotificationSettingsScreen extends StatefulWidget {
  const LocationNotificationSettingsScreen({super.key});

  @override
  State<LocationNotificationSettingsScreen> createState() =>
      _LocationNotificationSettingsScreenState();
}

class _LocationNotificationSettingsScreenState
    extends State<LocationNotificationSettingsScreen> {
  bool _emergencyAlertEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '위치',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _LocationArrowTile(
            title: '알림 수신 범위 설정',
            description: '알림을 받을 범위를 설정',
            onTap: () {
              Navigator.pushNamed(context, '/notification-range-settings');
            },
          ),
          _LocationSwitchTile(
            title: '긴급 알람 수신',
            description: '긴급 알람 수신 여부 설정',
            value: _emergencyAlertEnabled,
            onChanged: (value) {
              setState(() {
                _emergencyAlertEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LocationArrowTile extends StatelessWidget {
  const _LocationArrowTile({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationSwitchTile extends StatelessWidget {
  const _LocationSwitchTile({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.b4.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.c2.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.92,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.white,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.textHint,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
