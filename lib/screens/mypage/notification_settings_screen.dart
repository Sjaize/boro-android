import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  static const List<String> _pushItems = [
    '채팅',
    '거래',
    '위치',
    '관심 키워드',
  ];

  void _showPendingMessage(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 알림 설정은 아직 준비 중입니다.')),
    );
  }

  void _handleTap(BuildContext context, String label) {
    if (label == '채팅') {
      Navigator.pushNamed(context, '/chat-notification-settings');
      return;
    }

    if (label == '거래') {
      Navigator.pushNamed(context, '/trade-notification-settings');
      return;
    }

    if (label == '위치') {
      Navigator.pushNamed(context, '/location-notification-settings');
      return;
    }

    if (label == '관심 키워드') {
      Navigator.pushNamed(context, '/keyword-notification-settings');
      return;
    }

    _showPendingMessage(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '알림 설정',
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Text(
              '푸시 알림',
              style: AppTypography.h3.copyWith(
                color: AppColors.textDark,
                fontSize: 18,
              ),
            ),
          ),
          for (final item in _pushItems)
            _NotificationMenuTile(
              label: item,
              onTap: () => _handleTap(context, item),
            ),
        ],
      ),
    );
  }
}

class _NotificationMenuTile extends StatelessWidget {
  const _NotificationMenuTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.b4.copyWith(color: AppColors.textDark),
          ),
        ),
      ),
    );
  }
}
