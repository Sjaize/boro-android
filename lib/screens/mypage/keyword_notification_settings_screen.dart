import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class KeywordNotificationSettingsScreen extends StatefulWidget {
  const KeywordNotificationSettingsScreen({super.key});

  @override
  State<KeywordNotificationSettingsScreen> createState() =>
      _KeywordNotificationSettingsScreenState();
}

class _KeywordNotificationSettingsScreenState
    extends State<KeywordNotificationSettingsScreen> {
  bool _keywordAlertEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(showBottomDivider: false, 
        title: '관심 키워드',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _KeywordArrowTile(
            title: '관심 키워드 등록',
            description: '관심 키워드 등록하기',
            onTap: () {
              Navigator.pushNamed(context, '/keyword-registration');
            },
          ),
          _KeywordSwitchTile(
            title: '관심 키워드 알림',
            description: '등록한 관심 키워드 알림 받기',
            value: _keywordAlertEnabled,
            onChanged: (value) {
              setState(() {
                _keywordAlertEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _KeywordArrowTile extends StatelessWidget {
  const _KeywordArrowTile({
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
      color: AppColors.white,
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
      ),
    );
  }
}

class _KeywordSwitchTile extends StatelessWidget {
  const _KeywordSwitchTile({
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
