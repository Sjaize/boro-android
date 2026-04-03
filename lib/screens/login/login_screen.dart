import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _actionsOpacity;
  late final Animation<Offset> _actionsOffset;
  bool _isLoading = false;

  Future<void> _handleKakaoLogin() async {
    setState(() => _isLoading = true);
    final result = await AuthService.loginWithKakao();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!result.isSuccess ||
        result.kakaoAccessToken == null ||
        !result.backendLoginSucceeded) {
      debugPrint('LOGIN_SCREEN_KAKAO_FAILURE=${result.errorMessage ?? 'unknown'}');
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/tutorial-1');
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _actionsOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );
    _actionsOffset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
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
    const String tagline = '급할 때 바로, 필요할 땐 보로';
    const String logoAsset = 'assets/images/boro.png';
    const Color primaryBlue = Color(0xFF1570EF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scaleX = constraints.maxWidth / designW;
          final scaleY = constraints.maxHeight / designH;
          final uniformScale =
              ((constraints.maxWidth / designW) +
                      (constraints.maxHeight / designH)) /
                  2;

          return Stack(
            children: [
              Positioned(
                top: 306 * scaleY,
                left: 0,
                right: 0,
                child: Center(
                  child: Hero(
                    tag: 'brand-tagline',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        tagline,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: AppTypography.b3.copyWith(
                          fontSize: 16 * uniformScale,
                          color: primaryBlue,
                          fontWeight: FontWeight.w500,
                          height: 1,
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
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        primaryBlue,
                        BlendMode.srcIn,
                      ),
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
              Positioned(
                left: 20 * scaleX,
                right: 20 * scaleX,
                bottom: 34 * scaleY,
                child: FadeTransition(
                  opacity: _actionsOpacity,
                  child: SlideTransition(
                    position: _actionsOffset,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8 * scaleY),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 * scaleX,
                                vertical: 8 * scaleY,
                              ),
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'SNS 계정으로 간편 가입하기',
                                style: AppTypography.b3.copyWith(
                                  fontSize: 14 * scaleY,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: CustomPaint(
                                size: const Size(12, 8),
                                painter: _TrianglePainter(color: primaryBlue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12 * scaleY),
                        _LoginButton(
                          text: _isLoading ? '로그인 중...' : '카카오로 바로 시작',
                          backgroundColor: primaryBlue,
                          textColor: Colors.white,
                          onPressed: _isLoading ? null : _handleKakaoLogin,
                          scaleY: scaleY,
                        ),
                        SizedBox(height: 12 * scaleY),
                        _LoginButton(
                          text: '이메일로 로그인',
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFF344054),
                          borderColor: const Color(0xFFD0D5DD),
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  ),
                          scaleY: scaleY,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final double scaleY;

  const _LoginButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.onPressed,
    required this.scaleY,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56 * scaleY,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: AppTypography.b2.copyWith(
            fontSize: 18 * scaleY,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
