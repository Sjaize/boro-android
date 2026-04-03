import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const _recentPath = ['전자기기', '충전기', 'C타입 충전기'];

  static const List<_CategoryCardData> _categories = [
    _CategoryCardData(
      name: '생활용품',
      colors: [Color(0xFF6A7C5D), Color(0xFF263229)],
    ),
    _CategoryCardData(
      name: '전자기기',
      colors: [Color(0xFFE56F2E), Color(0xFF353A44)],
    ),
    _CategoryCardData(
      name: '전시소품',
      colors: [Color(0xFF5E9A76), Color(0xFF8C553D)],
    ),
    _CategoryCardData(
      name: '패션/의류',
      colors: [Color(0xFFB8B3AA), Color(0xFF707786)],
    ),
    _CategoryCardData(
      name: '도서/교육',
      colors: [Color(0xFFB68858), Color(0xFF593A23)],
    ),
    _CategoryCardData(
      name: '스포츠/레저',
      colors: [Color(0xFF964239), Color(0xFF2E1B1A)],
    ),
    _CategoryCardData(
      name: '악기/잡화',
      colors: [Color(0xFF54575E), Color(0xFF17191E)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/ic_back.svg',
            width: 18,
            height: 18,
          ),
        ),
        title: Text(
          '카테고리',
          style: AppTypography.b2.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: '최근'),
          InkWell(
            onTap: () => Navigator.pop(context, _recentPath.join(' > ')),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (var i = 0; i < _recentPath.length; i++) ...[
                    Text(
                      _recentPath[i],
                      style: AppTypography.b4.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (i != _recentPath.length - 1)
                      SvgPicture.asset(
                        'assets/icons/ic_chevron_right_small.svg',
                        width: 8,
                        height: 15,
                      ),
                  ],
                ],
              ),
            ),
          ),
          const _SectionHeader(title: '전체'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _CategoryBannerCard(
                  data: category,
                  onTap: () => Navigator.pop(context, category.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: AppTypography.h3.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBannerCard extends StatelessWidget {
  final _CategoryCardData data;
  final VoidCallback onTap;

  const _CategoryBannerCard({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          height: 74,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: data.colors,
                  ),
                ),
              ),
              CustomPaint(painter: _CategoryTexturePainter()),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.45, 1],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 12,
                child: Text(
                  data.name,
                  style: AppTypography.b2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.white,
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

class _CategoryTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final softPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width * 0.16, size.height * 0.32),
      size.height * 0.52,
      softPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.52, size.height * 0.75),
      size.height * 0.46,
      softPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, 0),
      Offset(size.width * 0.43, size.height),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.73, 0),
      Offset(size.width * 0.60, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CategoryCardData {
  final String name;
  final List<Color> colors;

  const _CategoryCardData({
    required this.name,
    required this.colors,
  });
}
