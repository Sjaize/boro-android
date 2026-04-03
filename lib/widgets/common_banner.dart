import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final banner = SizedBox(
      height: 80,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF67B99A),
            ),
          ),
          Positioned(
            left: -22,
            top: -9,
            child: Container(
              width: 134,
              height: 134,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFDF0D5),
              ),
            ),
          ),
          Positioned(
            left: 2,
            top: 4,
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA97C50), width: 4),
                color: const Color(0xFFFFF3DE),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 19,
                    top: 27,
                    child: Transform.rotate(
                      angle: -0.12,
                      child: Container(
                        width: 65,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0B2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 24,
                    top: 24,
                    child: Icon(
                      Icons.local_florist,
                      color: Color(0xFF37A567),
                      size: 18,
                    ),
                  ),
                  const Positioned(
                    left: 52,
                    top: 20,
                    child: Icon(
                      Icons.lens,
                      color: Color(0xFFFF4A4A),
                      size: 22,
                    ),
                  ),
                  const Positioned(
                    left: 42,
                    top: 42,
                    child: Icon(
                      Icons.restaurant,
                      color: Color(0xFF9C6B3F),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 6,
            top: 8,
            child: _ZigZagMark(),
          ),
          const Positioned(
            right: 7,
            top: 8,
            child: _ZigZagMark(reverse: true),
          ),
          const Positioned(
            right: 7,
            bottom: 11,
            child: _DotGrid(),
          ),
          Positioned(
            left: 136,
            top: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GRAND OPENING',
                  style: AppTypography.h1.copyWith(
                    color: const Color(0xFFFFE72F),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Breakfast Restaurant',
                  style: AppTypography.b1.copyWith(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec',
                  style: AppTypography.c2.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 6.5,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'fringilla lacus blandit volutpat cursus, vestibulum at pharetra.',
                  style: AppTypography.c2.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 6.5,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 8,
            child: Container(
              width: 42,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(17),
              ),
              alignment: Alignment.center,
              child: Text(
                'AD',
                style: AppTypography.c2.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return banner;
    return InkWell(onTap: onTap, child: banner);
  }
}

class _ZigZagMark extends StatelessWidget {
  final bool reverse;

  const _ZigZagMark({this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(reverse ? 3.1415926535 : 0),
      child: Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: List.generate(
                4,
                (index) => Container(
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 2),
                  width: 8,
                  height: 4,
                  color: const Color(0xFFFFE72F),
                  transform: Matrix4.skewX(-0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Row(
            children: List.generate(
              7,
              (index) => Container(
                margin: EdgeInsets.only(right: index == 6 ? 0 : 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
