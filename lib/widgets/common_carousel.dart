import 'package:flutter/material.dart';

class CommonHorizontalCarousel extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final double? height;

  const CommonHorizontalCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final listView = ListView.separated(
      padding: padding,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      separatorBuilder: (_, index) => SizedBox(width: spacing),
      itemBuilder: itemBuilder,
    );

    if (height == null) {
      return listView;
    }

    return SizedBox(
      height: height,
      child: listView,
    );
  }
}
