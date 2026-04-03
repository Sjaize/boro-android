import 'package:flutter/material.dart';

import '../../services/firebase_messaging_service.dart';
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
  bool _emergencyAlertEnabled = false;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await FirebaseMessagingService.isNearbyUrgentAlertsEnabled();
    if (!mounted) return;
    setState(() {
      _emergencyAlertEnabled = enabled;
      _isLoading = false;
    });
  }

  Future<void> _updateToggle(bool value) async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    final success =
        await FirebaseMessagingService.setNearbyUrgentAlertsEnabled(value);

    if (!mounted) return;

    setState(() {
      _isUpdating = false;
      if (success) {
        _emergencyAlertEnabled = value;
      }
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('알림 권한 또는 설정 저장에 실패했습니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        showBottomDivider: false,
        title: '위치',
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
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
                              '주변 긴급 알림 받기',
                              style: AppTypography.b4.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '내 주변에서 긴급하게 빌려주세요 글이 등록되면 알림을 받아볼 수 있어요.',
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
                          value: _emergencyAlertEnabled,
                          onChanged: _isUpdating ? null : _updateToggle,
                          activeColor: AppColors.white,
                          activeTrackColor: AppColors.primary,
                          inactiveThumbColor: AppColors.white,
                          inactiveTrackColor: AppColors.textHint,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
