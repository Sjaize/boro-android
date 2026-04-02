import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/common_button.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  static const _profile = _ProfileSummary(
    nickname: '닉네임',
    location: '영통동',
    tradeCount: 1,
    trustPercent: 60,
  );

  static const List<_MyStat> _stats = [
    _MyStat(label: '빌린 횟수', value: '0'),
    _MyStat(label: '빌려준 횟수', value: '0'),
    _MyStat(label: '관심목록', value: '0'),
  ];

  static const List<_MenuSectionData> _sections = [
    _MenuSectionData(
      title: '나의 활동',
      items: ['거래내역', '내가 쓴 글', '관심목록'],
    ),
    _MenuSectionData(
      title: '설정',
      items: ['내 위치 설정', '알림 설정'],
    ),
    _MenuSectionData(
      title: '고객 지원',
      items: ['고객 센터', '파손 문의', '보로 케어 공지'],
    ),
  ];

  static const List<String> _locationOptions = ['위치 1', '위치 2'];

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('해당 화면은 아직 준비 중입니다.')),
        );
        break;
      case 3:
        break;
    }
  }

  void _showPendingMessage(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label 기능은 아직 준비 중입니다.')),
    );
  }

  Future<void> _showLocationSettingsSheet(BuildContext context) async {
    var selectedLocation = _locationOptions.first;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 위치 설정',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '현재 위치를 변경할 수 있어요.',
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 22),
                    for (final option in _locationOptions)
                      _LocationOptionTile(
                        label: option,
                        isSelected: selectedLocation == option,
                        onTap: () {
                          setModalState(() {
                            selectedLocation = option;
                          });
                        },
                      ),
                    const SizedBox(height: 22),
                    CommonButton(
                      text: '위치 변경하기',
                      type: ButtonType.primary,
                      height: 44,
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$selectedLocation 위치로 변경했습니다.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleMenuTap(BuildContext context, String label) {
    if (label == '거래내역') {
      Navigator.pushNamed(context, '/trade-history');
      return;
    }

    if (label == '내가 쓴 글') {
      Navigator.pushNamed(context, '/my-posts');
      return;
    }

    if (label == '관심목록') {
      Navigator.pushNamed(context, '/favorites');
      return;
    }

    if (label == '내 위치 설정') {
      _showLocationSettingsSheet(context);
      return;
    }

    if (label == '알림 설정') {
      Navigator.pushNamed(context, '/notification-settings');
      return;
    }

    _showPendingMessage(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Text(
          '마이페이지',
          style: AppTypography.h1.copyWith(color: AppColors.textDark),
        ),
        actions: [
          IconButton(
            onPressed: () => _showPendingMessage(context, '알림'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _ProfileHeader(
            profile: _profile,
            onEditPressed: () => _showPendingMessage(context, '프로필 수정'),
          ),
          const _StatsSection(stats: _stats),
          for (final section in _sections)
            _MenuSection(
              section: section,
              onTap: (label) => _handleMenuTap(context, label),
            ),
        ],
      ),
      bottomNavigationBar: BoroBottomNavBar(
        currentIndex: 3,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.onEditPressed,
  });

  final _ProfileSummary profile;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5C38B), Color(0xFF9C5D34)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.nickname,
                        style: AppTypography.b2.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${profile.location} / 거래 ${profile.tradeCount}회',
                        style: AppTypography.c2.copyWith(
                          color: AppColors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.white,
                    size: 42,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '신뢰도 ${profile.trustPercent}%',
                    style: AppTypography.c1.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          CommonButton(
            text: '프로필 수정',
            type: ButtonType.outline,
            height: 44,
            onPressed: onEditPressed,
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.stats});

  final List<_MyStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: const BorderSide(color: AppColors.border),
                    bottom: const BorderSide(color: AppColors.border),
                    right: i == stats.length - 1
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.border),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stats[i].value,
                      style: AppTypography.b2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stats[i].label,
                      style: AppTypography.c2.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.section,
    required this.onTap,
  });

  final _MenuSectionData section;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            section.title,
            style: AppTypography.h3.copyWith(
              color: AppColors.textDark,
              fontSize: 18,
            ),
          ),
        ),
        for (final item in section.items)
          _MenuTile(
            label: item,
            onTap: () => onTap(item),
          ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.b4.copyWith(color: AppColors.textDark),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationOptionTile extends StatelessWidget {
  const _LocationOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.b4.copyWith(color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSummary {
  final String nickname;
  final String location;
  final int tradeCount;
  final int trustPercent;

  const _ProfileSummary({
    required this.nickname,
    required this.location,
    required this.tradeCount,
    required this.trustPercent,
  });
}

class _MyStat {
  final String label;
  final String value;

  const _MyStat({
    required this.label,
    required this.value,
  });
}

class _MenuSectionData {
  final String title;
  final List<String> items;

  const _MenuSectionData({
    required this.title,
    required this.items,
  });
}
