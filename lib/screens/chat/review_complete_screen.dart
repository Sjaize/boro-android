import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class ReviewCompleteScreen extends StatelessWidget {
  const ReviewCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CommonAppBar(
        title: '후기 작성',
        showBackButton: true,
        showBottomDivider: false, // 회색 선 제거
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 중앙 콘텐츠 그룹 (아이콘 + 텍스트)
            // '소중한 후기 감사합니다' 텍스트의 위치를 아래에서 325px에 맞춤
            Positioned(
              bottom: 340, // 375에서 20px 내려서 355로 변경
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_review_success.svg',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 67), // 57에서 10px 더 늘려 67로 변경
                  Text(
                    '후기가 등록되었어요!',
                    style: TextStyle(
                      color: Color(0xFF0A0D12),
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 5 / 18,
                    ),
                  ),
                  const SizedBox(height: 21), // 14에서 7px 내려서 21로 변경
                  Text(
                    '소중한 후기 감사합니다',
                    style: TextStyle(
                      color: Color(0xFF535862),
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 5 / 14, // line-height 5px 반영
                    ),
                  ),
                ],
              ),
            ),
            // 하단 확인 버튼
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                color: AppColors.white, // 배경 흰색으로 변경
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/chat-room'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: AppTypography.b2.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
