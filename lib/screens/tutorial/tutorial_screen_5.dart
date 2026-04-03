import 'package:flutter/material.dart';

class TutorialScreen5 extends StatefulWidget {
  const TutorialScreen5({super.key});

  @override
  State<TutorialScreen5> createState() => _TutorialScreen5State();
}

class _TutorialScreen5State extends State<TutorialScreen5>
    with SingleTickerProviderStateMixin {
  static const List<String> _routes = [
    '/tutorial-1',
    '/tutorial-2',
    '/tutorial-3',
    '/tutorial-4',
    '/tutorial-5',
  ];

  AnimationController? _motionController;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _motionController?.dispose();
    super.dispose();
  }

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _goPrevious(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/tutorial-4');
  }

  void _goToPage(BuildContext context, int index) {
    if (index == 4) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > 150) {
      _goPrevious(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
                    _TutorialDots(
                      currentIndex: 4,
                      onDotTap: (index) => _goToPage(context, index),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 154,
                left: 0,
                right: 0,
                child: _motionController == null
                    ? const SizedBox.shrink()
                    : _MovingChipCollage(animation: _motionController!),
              ),
              Positioned(
                left: 1,
                right: 0,
                bottom: 0,
                child: _BottomPanel(
                  onNext: () => _goHome(context),
                ),
              ),
              Positioned(
                top: 32,
                right: 20,
                child: GestureDetector(
                  onTap: () => _goHome(context),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFFA4A7AE),
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      height: 1.1,
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

class _TutorialDots extends StatelessWidget {
  const _TutorialDots({
    required this.currentIndex,
    required this.onDotTap,
  });

  final int currentIndex;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDotTap(index),
          child: Container(
            width: 5,
            height: 5,
            margin: EdgeInsets.only(right: index == 4 ? 0 : 7),
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? const Color(0xFF1570EF)
                  : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 304,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.14),
            blurRadius: 50,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 37, 16, 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '그럼, 보로를 시작해볼까요?',
              style: TextStyle(
                color: Color(0xFF0A0D12),
                fontFamily: 'Pretendard',
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
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1570EF),
                  foregroundColor: const Color(0xFFFAFAFA),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

class _MovingChipCollage extends StatelessWidget {
  const _MovingChipCollage({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final row1 = Tween<double>(
          begin: -16,
          end: 16,
        ).transform(Curves.easeInOutCubic.transform(animation.value));
        final row2 = Tween<double>(
          begin: 16,
          end: -16,
        ).transform(Curves.easeInOut.transform(animation.value));
        final row3 = Tween<double>(
          begin: -14,
          end: 14,
        ).transform(Curves.easeInOutCubic.transform(animation.value));
        final row4 = Tween<double>(
          begin: 14,
          end: -14,
        ).transform(Curves.easeInOut.transform(animation.value));

        return SizedBox(
          width: double.infinity,
          height: 246,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -14 + row1,
                top: 0,
                child: const _KeywordChip(
                  label: '급할 때',
                  filled: true,
                  width: 128,
                ),
              ),
              Positioned(
                left: 127 + row1,
                top: 0,
                child: const _KeywordChip(
                  label: '지금 필요해요',
                  width: 204,
                ),
              ),
              Positioned(
                left: 343 + row1,
                top: 0,
                child: const _KeywordChip(
                  label: '긴급',
                  width: 118,
                ),
              ),
              Positioned(
                left: -1 + row2,
                top: 56,
                child: const _KeywordChip(
                  label: '근처',
                  width: 88,
                ),
              ),
              Positioned(
                left: 101 + row2,
                top: 56,
                child: const _KeywordChip(
                  label: '빌려줄게요',
                  width: 149,
                ),
              ),
              Positioned(
                left: 264 + row2,
                top: 56,
                child: const _KeywordChip(
                  label: '지금 당장',
                  width: 146,
                ),
              ),
              Positioned(
                left: -4 + row3,
                top: 112,
                child: const _KeywordChip(
                  label: '물건',
                  width: 111,
                ),
              ),
              Positioned(
                left: 121 + row3,
                top: 112,
                child: const _KeywordChip(
                  label: '빌릴 수 있어요',
                  filled: true,
                  width: 183,
                ),
              ),
              Positioned(
                left: 318 + row3,
                top: 112,
                child: const _KeywordChip(
                  label: '보로',
                  width: 111,
                ),
              ),
              Positioned(
                left: -7 + row4,
                top: 168,
                child: const _KeywordChip(
                  label: '필요한 이웃에게',
                  width: 204,
                ),
              ),
              Positioned(
                left: 211 + row4,
                top: 168,
                child: const _KeywordChip(
                  label: '빌려주는',
                  filled: true,
                  width: 149,
                ),
              ),
              Positioned(
                left: 374 + row4,
                top: 168,
                child: const _KeywordChip(
                  label: '보로',
                  width: 111,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({
    required this.label,
    required this.width,
    this.filled = false,
  });

  final String label;
  final double width;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFF1570EF);
    return Container(
      width: width + 6,
      height: 51,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? borderColor : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(31),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? const Color(0xFFFAFAFA) : borderColor,
          fontFamily: 'Pretendard',
          fontSize: 25,
          fontWeight: FontWeight.w500,
          height: 0.36,
        ),
      ),
    );
  }
}
