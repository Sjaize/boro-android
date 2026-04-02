import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class TradeNotificationSettingsScreen extends StatefulWidget {
  const TradeNotificationSettingsScreen({super.key});

  @override
  State<TradeNotificationSettingsScreen> createState() =>
      _TradeNotificationSettingsScreenState();
}

class _TradeNotificationSettingsScreenState
    extends State<TradeNotificationSettingsScreen> {
  final Map<String, bool> _settings = {
    '조회 게시글 가격 설정 알림': true,
    '채팅 게시글 가격 하락 알림': true,
    '거래 후기 알림': true,
    '최근 본 물품 추천 알림': true,
    '신뢰도 변화 알림': true,
  };

  static const Map<String, String> _descriptions = {
    '조회 게시글 가격 설정 알림': '조회한 물건 게시글의 가격 하락 알림',
    '채팅 게시글 가격 하락 알림': '채팅한 물건 게시글의 가격 하락 알림',
    '거래 후기 알림': '진행한 거래 후기 등록 알림',
    '최근 본 물품 추천 알림': '최근 본 물품과 관련된 물품 추천 알림',
    '신뢰도 변화 알림': '신뢰도 등급 변화 알림',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '거래',
        showBackButton: true,
      ),
      body: Column(
        children: [
          for (final entry in _settings.entries)
            _TradeNotificationSwitchTile(
              title: entry.key,
              description: _descriptions[entry.key] ?? '',
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  _settings[entry.key] = value;
                });
              },
            ),
        ],
      ),
    );
  }
}

class _TradeNotificationSwitchTile extends StatelessWidget {
  const _TradeNotificationSwitchTile({
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
