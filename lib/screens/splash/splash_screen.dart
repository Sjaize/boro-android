import 'package:flutter/material.dart';

import '../login/login_screen.dart';
import '../../theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _glowScale;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineOffset;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoFloatOffset;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _taglineOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _glowOpacity = Tween<double>(
      begin: 0,
      end: 0.2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _glowScale = Tween<double>(
      begin: 0.86,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _taglineOffset = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );
    _logoFloatOffset = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.25, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
              ),
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double designW = 384;
    const double designH = 824;

    const String tagline = '급할 때 바로, 필요할 때 보로';
    const String logoAsset = 'assets/images/boro.png';

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / designW;
        final scaleY = constraints.maxHeight / designH;
        final uniformScale =
            ((constraints.maxWidth / designW) + (constraints.maxHeight / designH)) /
                2;

        return Scaffold(
          backgroundColor: const Color(0xFF1570EF),
          body: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _glowOpacity.value,
                          child: Transform.scale(
                            scale: _glowScale.value,
                            child: child,
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 260 * scaleX,
                          height: 260 * scaleY,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color(0x66FFFFFF),
                                Color(0x1FFFFFFF),
                                Color(0x00FFFFFF),
                              ],
                              stops: [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 306 * scaleY,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Hero(
                      tag: 'brand-tagline',
                      child: Material(
                        type: MaterialType.transparency,
                        child: FadeTransition(
                          opacity: _taglineOpacity,
                          child: SlideTransition(
                            position: _taglineOffset,
                            child: Text(
                              tagline,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: AppTypography.b3.copyWith(
                                fontSize: 16 * uniformScale,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFFAFAFA),
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 344 * scaleY,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Hero(
                      tag: 'brand-logo',
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: SlideTransition(
                          position: _logoFloatOffset,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Image.asset(
                              logoAsset,
                              width: 236 * scaleX,
                              height: 66 * scaleY,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
