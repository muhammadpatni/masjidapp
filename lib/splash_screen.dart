import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjidapp/auth/login_screen.dart';
import 'package:masjidapp/screens/main_screen.dart';
import '../constants/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _rotateCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _exitCtrl;

  // Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _dividerWidth;
  late final Animation<double> _badgeFade;
  late final Animation<double> _shimmer;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    // Slow orbit ring
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Glow pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Entry sequence
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Gold shimmer on text
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // Exit fade
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Entry animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.55, 0.75, curve: Curves.easeIn),
      ),
    );
    _dividerWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.6, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _shimmer = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    _exitFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInCubic));

    // Start entry, then check auth and navigate
    _entryCtrl.forward();
    Future.delayed(const Duration(milliseconds: 3000), _checkAuthAndNavigate);
  }

  // ── AUTH CHECK ─────────────────────────────────────────
  Future<void> _checkAuthAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;

    // Agar user login hai aur email verify hai
    final bool isLoggedIn = user != null && user.emailVerified;

    await _exitCtrl.forward();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) =>
            isLoggedIn ? const MainScreen() : const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    _entryCtrl.dispose();
    _shimmerCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _exitCtrl,
      builder: (context, _) => Opacity(
        opacity: _exitFade.value,
        child: Scaffold(
          backgroundColor: kPrimaryDark,
          body: Stack(
            children: [
              // ── Layer 1: Radial gradient background ──────────
              Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0, -0.3),
                    radius: 1.0,
                    colors: [
                      Color(0xFF0F3D2E),
                      Color(0xFF071E16),
                      kPrimaryDark,
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),

              // ── Layer 2: Animated orbit rings ─────────────────
              AnimatedBuilder(
                animation: _rotateCtrl,
                builder: (_, _) => Center(
                  child: Transform.rotate(
                    angle: _rotateCtrl.value * 2 * math.pi,
                    child: CustomPaint(
                      size: Size(size.width * 0.85, size.width * 0.85),
                      painter: _OrbitRingPainter(progress: _rotateCtrl.value),
                    ),
                  ),
                ),
              ),

              // ── Layer 3: Pulsing glow behind logo ─────────────
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, _) {
                  final glow = 0.06 + _pulseCtrl.value * 0.10;
                  return Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kGold.withOpacity(glow),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // ── Layer 4: Main content ─────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    AnimatedBuilder(
                      animation: _entryCtrl,
                      builder: (_, _) => FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: _GoldMosqueLogo(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App title with shimmer
                    AnimatedBuilder(
                      animation: _entryCtrl,
                      builder: (_, _) => FadeTransition(
                        opacity: _titleFade,
                        child: Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: AnimatedBuilder(
                            animation: _shimmerCtrl,
                            builder: (_, _) => ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment(_shimmer.value - 1, 0),
                                end: Alignment(_shimmer.value + 1, 0),
                                colors: const [
                                  kGold,
                                  Colors.white,
                                  kGold,
                                  Color(0xFFEDD97A),
                                  kGold,
                                ],
                                stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                'Masjid Management',
                                style: GoogleFonts.cairo(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Arabic subtitle
                    AnimatedBuilder(
                      animation: _entryCtrl,
                      builder: (_, _) => FadeTransition(
                        opacity: _subtitleFade,
                        child: Text(
                          'نظام إدارة المسجد',
                          style: GoogleFonts.amiri(
                            fontSize: 18,
                            color: kGold.withOpacity(0.75),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Gold divider line
                    AnimatedBuilder(
                      animation: _entryCtrl,
                      builder: (_, _) => Opacity(
                        opacity: _dividerWidth.value,
                        child: SizedBox(
                          width: 220 * _dividerWidth.value,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        kGold.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: kGold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        kGold.withOpacity(0.6),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Version / tagline badge
                    AnimatedBuilder(
                      animation: _entryCtrl,
                      builder: (_, _) => FadeTransition(
                        opacity: _badgeFade,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: kGold.withOpacity(0.25),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.mosque_rounded,
                                    color: kGold.withOpacity(0.8),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Donations  •  Expenses  •  Projects',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: Colors.white54,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Layer 5: Bottom tagline ────────────────────────
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _entryCtrl,
                  builder: (_, _) => FadeTransition(
                    opacity: _badgeFade,
                    child: Column(
                      children: [
                        _PulsingDots(),
                        const SizedBox(height: 16),
                        Text(
                          'Powered by Firebase',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.white24,
                            letterSpacing: 0.5,
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

// ── Gold Mosque Logo ──────────────────────────────────────────────
class _GoldMosqueLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF1A4D38), Color(0xFF0A2E24)],
        ),
        border: Border.all(color: kGold.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kGold.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kGold.withOpacity(0.1), width: 1),
            ),
          ),
          const Icon(Icons.mosque_rounded, color: kGold, size: 52),
        ],
      ),
    );
  }
}

// ── Orbit Ring Painter ─────────────────────────────────────────────
class _OrbitRingPainter extends CustomPainter {
  final double progress;
  _OrbitRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius1 = size.width / 2;
    final radius2 = size.width / 2.6;

    final paint1 = Paint()
      ..color = kGold.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius1, paint1);

    final paint2 = Paint()
      ..color = kGold.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(center, radius2, paint2);

    final dotPaint = Paint()
      ..color = kGold.withOpacity(0.55)
      ..style = PaintingStyle.fill;
    final dotAngle = progress * 2 * math.pi;
    final dotX = center.dx + radius1 * math.cos(dotAngle);
    final dotY = center.dy + radius1 * math.sin(dotAngle);
    canvas.drawCircle(Offset(dotX, dotY), 3.5, dotPaint);

    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: dotAngle - 0.8,
        endAngle: dotAngle,
        colors: [Colors.transparent, kGold.withOpacity(0.3)],
      ).createShader(Rect.fromCircle(center: center, radius: radius1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius1),
      dotAngle - 0.8,
      0.8,
      false,
      arcPaint,
    );

    final dot2Paint = Paint()
      ..color = kGold.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    final dot2Angle = -progress * 2 * math.pi + math.pi;
    final dot2X = center.dx + radius2 * math.cos(dot2Angle);
    final dot2Y = center.dy + radius2 * math.sin(dot2Angle);
    canvas.drawCircle(Offset(dot2X, dot2Y), 2.5, dot2Paint);
  }

  @override
  bool shouldRepaint(_OrbitRingPainter old) => old.progress != progress;
}

// ── Pulsing Loading Dots ───────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _ctrls[i].repeat(reverse: true);
      });
    }
    _anims = _ctrls
        .map(
          (c) => Tween<double>(
            begin: 0.3,
            end: 1.0,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, _) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: kGold.withOpacity(_anims[i].value),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
