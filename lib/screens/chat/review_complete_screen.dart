import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/common_app_bar.dart';

class ReviewCompleteScreen extends StatelessWidget {
  const ReviewCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const CommonAppBar(
        title: '후기 작성',
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 170),
                child: Column(
                  children: [
                    const _ClipboardSuccessIcon(),
                    const SizedBox(height: 56),
                    Text(
                      '후기가 등록되었어요!',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textDark,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '소중한 후기 감사합니다',
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/chat-room'));
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
          ],
        ),
      ),
    );
  }
}

class _ClipboardSuccessIcon extends StatelessWidget {
  const _ClipboardSuccessIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: CustomPaint(
        painter: _ClipboardSuccessPainter(),
      ),
    );
  }
}

class _ClipboardSuccessPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(18, 28, 74, 68),
      const Radius.circular(10),
    );
    canvas.drawRRect(body, stroke);

    final clip = RRect.fromRectAndRadius(
      Rect.fromLTWH(38, 14, 34, 14),
      const Radius.circular(8),
    );
    canvas.drawRRect(clip, stroke);

    final path = Path()
      ..moveTo(38, 58)
      ..lineTo(49, 69)
      ..lineTo(72, 42);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
