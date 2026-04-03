import 'package:flutter/material.dart';

class TutorialScreen5 extends StatelessWidget {
  const TutorialScreen5({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 34),
              child: Column(
                children: [
                  _TutorialDots(currentIndex: 4),
                  const SizedBox(height: 74),
                  const _ChipCollage(),
                  const Spacer(),
                  _BottomPanel(
                    onNext: () => _goHome(context),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 22,
              right: 16,
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

class _TutorialDots extends StatelessWidget {
  const _TutorialDots({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Container(
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

class _ChipCollage extends StatelessWidget {
  const _ChipCollage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(
            left: -14,
            top: 0,
            child: _KeywordChip(
              label: '급할 때',
              filled: true,
              width: 128,
            ),
          ),
          Positioned(
            left: 121,
            top: 0,
            child: _KeywordChip(
              label: '당장 필요할 때',
              width: 204,
            ),
          ),
          Positioned(
            left: 331,
            top: 0,
            child: _KeywordChip(
              label: '지금',
              width: 118,
            ),
          ),
          Positioned(
            left: -1,
            top: 56,
            child: _KeywordChip(
              label: '언제',
              width: 88,
            ),
          ),
          Positioned(
            left: 95,
            top: 56,
            child: _KeywordChip(
              label: '어디서나',
              width: 149,
            ),
          ),
          Positioned(
            left: 252,
            top: 56,
            child: _KeywordChip(
              label: '지금 당장',
              width: 146,
            ),
          ),
          Positioned(
            left: -4,
            top: 112,
            child: _KeywordChip(
              label: '물건을',
              width: 111,
            ),
          ),
          Positioned(
            left: 115,
            top: 112,
            child: _KeywordChip(
              label: '빌릴 수 있는',
              filled: true,
              width: 183,
            ),
          ),
          Positioned(
            left: 306,
            top: 112,
            child: _KeywordChip(
              label: '플랫폼',
              width: 111,
            ),
          ),
          Positioned(
            left: -7,
            top: 168,
            child: _KeywordChip(
              label: '필요한 사람에게',
              width: 204,
            ),
          ),
          Positioned(
            left: 205,
            top: 168,
            child: _KeywordChip(
              label: '빌려주는',
              filled: true,
              width: 149,
            ),
          ),
          Positioned(
            left: 362,
            top: 168,
            child: _KeywordChip(
              label: '플랫폼',
              width: 111,
            ),
          ),
        ],
      ),
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
      width: width,
      height: 47,
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
