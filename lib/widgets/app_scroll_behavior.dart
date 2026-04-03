import 'package:flutter/material.dart';

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 여백은 막으면서(Clamping), 늘어나는 정도는 아주 작게(Subtle) 제한
    return const AppSubtleClampingPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // 물리적으로 억제된 에너지만큼만 화면이 아주 살짝 늘어남
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}

class AppSubtleClampingPhysics extends ClampingScrollPhysics {
  const AppSubtleClampingPhysics({super.parent});

  @override
  AppSubtleClampingPhysics applyTo(ScrollPhysics? ancestor) {
    return AppSubtleClampingPhysics(parent: buildParent(ancestor));
  }

  // 사용자가 끝에서 당길 때 발생하는 오버스크롤 에너지를 
  // 기존의 10% 수준으로 대폭 낮추어, 스트레칭이 아주 조금만 일어나게 함
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset == 0) return 0;
    // 당기는 힘의 0.22(22%)만 시각적 효과로 전달
    return super.applyPhysicsToUserOffset(position, offset * 0.22);
  }
}
