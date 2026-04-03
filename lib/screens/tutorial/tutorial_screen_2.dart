import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TutorialScreen2 extends StatefulWidget {
  const TutorialScreen2({super.key});

  @override
  State<TutorialScreen2> createState() => _TutorialScreen2State();
}

class _TutorialScreen2State extends State<TutorialScreen2>
    with SingleTickerProviderStateMixin {

  static const List<String> _routes = [
    '/tutorial-1',
    '/tutorial-2',
    '/tutorial-3',
    '/tutorial-4',
    '/tutorial-5',
  ];

  late final AnimationController _motionController;
  late final Animation<double> _outerScale;
  late final Animation<double> _middleScale;
  late final Animation<double> _innerScale;
  late final Animation<double> _pinLift;
  late final Animation<double> _bubbleLift;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _outerScale = Tween<double>(begin: 0.96, end: 1.03).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOutCubic),
    );
    _middleScale = Tween<double>(begin: 0.97, end: 1.04).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _innerScale = Tween<double>(begin: 0.98, end: 1.05).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOutCubic),
    );
    _pinLift = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _bubbleLift = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-3');
  }

  void _skip(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _goPrevious(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-1');
  }

  void _goToPage(BuildContext context, int index) {
    if (index == 1) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -150) {
      _goNext(context);
    } else if (velocity > 150) {
      _goPrevious(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) => _handleSwipe(context, details),
        child: SafeArea(
          bottom: false,
          child: Stack(
          children: [
            Positioned(
              top: 44,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _PageIndicator(
                    currentIndex: 1,
                    totalCount: 5,
                    onDotTap: (index) => _goToPage(context, index),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _skip(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      'Skip',
                      style: AppTypography.b4.copyWith(
                        color: const Color(0xFFA4A7AE),
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 98,
              bottom: 304,
              child: _TutorialMapGraphic(
                outerScale: _outerScale,
                middleScale: _middleScale,
                innerScale: _innerScale,
                pinLift: _pinLift,
                bubbleLift: _bubbleLift,
                animation: _motionController,
              ),
            ),
            Positioned(
              left: 1,
              right: 0,
              bottom: 0,
              child: Container(
                height: 304,
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 50,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 37, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '보로는 가까이 있는 사람들에게\n물건을 빌리고, 빌려주며\n도움을 받을 수 있는 서비스에요.',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _goNext(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            '다음',
                            style: AppTypography.b3.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _TutorialMapGraphic extends StatelessWidget {
  const _TutorialMapGraphic({
    required this.outerScale,
    required this.middleScale,
    required this.innerScale,
    required this.pinLift,
    required this.bubbleLift,
    required this.animation,
  });

  final Animation<double> outerScale;
  final Animation<double> middleScale;
  final Animation<double> innerScale;
  final Animation<double> pinLift;
  final Animation<double> bubbleLift;
  final Listenable animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -24,
              child: Transform.scale(
                scale: outerScale.value,
                child: Container(
                  width: 560,
                  height: 560,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 88,
              child: Transform.scale(
                scale: middleScale.value,
                child: Container(
                  width: 337,
                  height: 337,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 136,
              child: Transform.scale(
                scale: innerScale.value,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 182 + pinLift.value,
              child: Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, bubbleLift.value),
                    child: Container(
                      width: 112,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.22),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'HELP!',
                            style: AppTypography.c2.copyWith(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            child: CustomPaint(
                              size: const Size(12, 8),
                              painter: _TrianglePainter(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Icon(
                    Icons.location_on,
                    size: 48,
                    color: AppColors.primary,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final ValueChanged<int> onDotTap;

  const _PageIndicator({
    required this.currentIndex,
    required this.totalCount,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalCount,
        (index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDotTap(index),
          child: Container(
            width: 5,
            height: 5,
            margin: EdgeInsets.only(right: index == totalCount - 1 ? 0 : 7),
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? AppColors.primary
                  : const Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
