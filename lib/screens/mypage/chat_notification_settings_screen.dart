import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class ChatNotificationSettingsScreen extends StatefulWidget {
  const ChatNotificationSettingsScreen({super.key});

  @override
  State<ChatNotificationSettingsScreen> createState() =>
      _ChatNotificationSettingsScreenState();
}

class _ChatNotificationSettingsScreenState
    extends State<ChatNotificationSettingsScreen> {
  bool _chatMessageEnabled = true;
  bool _mentionReplyEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '채팅',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _NotificationSwitchTile(
            title: '채팅 알림',
            description: '채팅 메세지 알림',
            value: _chatMessageEnabled,
            onChanged: (value) {
              setState(() {
                _chatMessageEnabled = value;
              });
            },
          ),
          _NotificationSwitchTile(
            title: '멘션 및 답장 알림',
            description: '나를 언급하거나 나에게 답장이 온 경우 알림',
            value: _mentionReplyEnabled,
            onChanged: (value) {
              setState(() {
                _mentionReplyEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  const _NotificationSwitchTile({
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
