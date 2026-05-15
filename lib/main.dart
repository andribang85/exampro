// ============================================================
//  ExamPro — main.dart (Complete Single File)
//  Semua screen dalam 1 file. Paste ke lib/main.dart
//  Flutter 3.22+ | Dart 3.3+
//  © 2026 EduTech Indonesia
// ============================================================
//
//  SCREEN LIST:
//  1.  SplashScreen          → Logo + loading bar animasi
//  2.  OnboardingScreen      → 3 langkah onboarding
//  3.  LoginScreen           → Role-based login (Siswa/Guru/Admin)
//  4.  StudentDashboardScreen → Dashboard siswa
//  5.  ExamTokenScreen       → Input token ujian
//  6.  ExamScreen            → Layar ujian + timer + anti-cheat UI
//  7.  ExamResultScreen      → Hasil + ranking + analisis
//  8.  TeacherDashboardScreen → Dashboard guru + monitoring
//  9.  AdminDashboardScreen  → Dashboard admin + statistik
//  10. ProfileScreen         → Profil + settings
//
//  CARA PAKAI:
//  1. flutter create exampro
//  2. Ganti lib/main.dart dengan file ini
//  3. flutter pub get
//  4. flutter run
//
//  Untuk aktivasi Firebase, ikuti panduan build APK.
// ============================================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ExamProApp());
}

// ─────────────────────────────────────────────
//  APP ROOT
// ─────────────────────────────────────────────
class ExamProApp extends StatelessWidget {
  const ExamProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.blue500,
          secondary: AppColors.purple500,
        ),
        fontFamily: 'PlusJakartaSans',
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  COLOR PALETTE
// ─────────────────────────────────────────────
class AppColors {
  static const Color bg       = Color(0xFF080C24);
  static const Color surface  = Color(0xFF0D1242);
  static const Color card     = Color(0xFF111836);

  static const Color blue500  = Color(0xFF2563EB);
  static const Color blue400  = Color(0xFF3B82F6);
  static const Color blue300  = Color(0xFF60A5FA);

  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple300 = Color(0xFFC4B5FD);

  static const Color cyan400   = Color(0xFF22D3EE);
  static const Color emerald   = Color(0xFF34D399);
  static const Color rose      = Color(0xFFFB7185);
  static const Color amber     = Color(0xFFFBBF24);

  static const Color gray700  = Color(0xFF374151);
  static const Color gray500  = Color(0xFF6B7280);
  static const Color gray400  = Color(0xFF9CA3AF);
  static const Color gray200  = Color(0xFFE5E7EB);

  static const Gradient primaryGrad = LinearGradient(
    colors: [blue500, purple600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient bgGrad = LinearGradient(
    colors: [Color(0xFF080C24), Color(0xFF0E1333)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// ─────────────────────────────────────────────
//  TEXT STYLES
// ─────────────────────────────────────────────
class AppText {
  static const TextStyle h1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2);
  static const TextStyle h2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white);
  static const TextStyle h3 = TextStyle(
    fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white);
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.gray400);
  static const TextStyle label = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray400,
    letterSpacing: 0.8);
}

// ─────────────────────────────────────────────
//  SHARED WIDGETS
// ─────────────────────────────────────────────

/// Glass-morphism card
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? borderColor;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 20,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white.withOpacity(0.06) : null,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Gradient primary button
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blue500, AppColors.purple600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue500.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(label, style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: Colors.white)),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Ghost button (glass outline)
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const GhostButton({
    super.key, required this.label, this.onTap, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (color ?? Colors.white).withOpacity(0.15)),
        ),
        child: Center(
          child: Text(label, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: color ?? AppColors.gray200)),
        ),
      ),
    );
  }
}

/// Stat mini card
class StatMiniCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const StatMiniCard({
    super.key, required this.value, required this.label, this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        gradient: const LinearGradient(
          colors: [Color(0x332563EB), Color(0x337C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w900,
              color: valueColor ?? AppColors.blue300)),
            const SizedBox(height: 2),
            Text(label, style: AppText.label,
              textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Section header row
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key, required this.title, this.action, this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppText.h3),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: AppColors.blue400)),
          ),
      ],
    );
  }
}

/// Animated background orbs
class AnimatedBg extends StatefulWidget {
  const AnimatedBg({super.key});
  @override
  State<AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg>
    with TickerProviderStateMixin {
  late AnimationController _c1, _c2, _c3;
  late Animation<double> _a1, _a2, _a3;

  @override
  void initState() {
    super.initState();
    _c1 = AnimationController(vsync: this,
        duration: const Duration(seconds: 8))..repeat(reverse: true);
    _c2 = AnimationController(vsync: this,
        duration: const Duration(seconds: 11))..repeat(reverse: true);
    _c3 = AnimationController(vsync: this,
        duration: const Duration(seconds: 7))..repeat(reverse: true);
    _a1 = CurvedAnimation(parent: _c1, curve: Curves.easeInOut);
    _a2 = CurvedAnimation(parent: _c2, curve: Curves.easeInOut);
    _a3 = CurvedAnimation(parent: _c3, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: Listenable.merge([_c1, _c2, _c3]),
        builder: (_, __) => CustomPaint(
          painter: _OrbPainter(_a1.value, _a2.value, _a3.value, size),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double v1, v2, v3;
  final Size screen;
  _OrbPainter(this.v1, this.v2, this.v3, this.screen);

  void _orb(Canvas c, double x, double y, double r, Color col) {
    c.drawCircle(Offset(x, y), r,
      Paint()..shader = RadialGradient(
        colors: [col.withOpacity(0.35), Colors.transparent],
      ).createShader(Rect.fromCircle(
        center: Offset(x, y), radius: r)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    _orb(canvas, w * 0.8 + v1 * 30, h * 0.1 + v1 * 20, 260,
        AppColors.purple600);
    _orb(canvas, w * -0.1 + v2 * 20, h * 0.7 + v2 * 25, 220,
        AppColors.blue500);
    _orb(canvas, w * 0.5 + v3 * 15, h * 0.45 + v3 * 10, 150,
        AppColors.cyan400);
  }

  @override
  bool shouldRepaint(_OrbPainter old) => true;
}

/// Blink dot widget
class BlinkDot extends StatefulWidget {
  final Color color;
  final double size;
  const BlinkDot({super.key, this.color = AppColors.emerald, this.size = 8});
  @override
  State<BlinkDot> createState() => _BlinkDotState();
}

class _BlinkDotState extends State<BlinkDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Opacity(
        opacity: 0.3 + _c.value * 0.7,
        child: Container(
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(
            color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// Score ring painter
class ScoreRing extends StatelessWidget {
  final double score; // 0-100
  final double size;
  final String label;

  const ScoreRing({
    super.key, required this.score,
    this.size = 120, this.label = 'Nilai',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(score / 100),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.blue300, AppColors.purple300],
                ).createShader(b),
                child: Text(
                  score.toInt().toString(),
                  style: TextStyle(
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(label, style: AppText.label),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final track = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..shader = const SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [AppColors.blue500, AppColors.purple500, AppColors.cyan400],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────
//  1. SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale, _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 2000));
    _fade = CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5));
    _scale = CurvedAnimation(parent: _ctrl,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut));
    _progress = CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) _navigate();
    });
  }

  void _navigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const OnboardingScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Center(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo ring
                  Opacity(
                    opacity: _fade.value,
                    child: Transform.scale(
                      scale: 0.5 + _scale.value * 0.5,
                      child: Container(
                        width: 110, height: 110,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.blue500, AppColors.purple600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue500.withOpacity(0.5),
                              blurRadius: 40, spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🎓',
                              style: TextStyle(fontSize: 54))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Opacity(
                    opacity: _fade.value,
                    child: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [
                          AppColors.blue300,
                          AppColors.purple300,
                          AppColors.cyan400,
                        ],
                      ).createShader(b),
                      child: const Text('ExamPro',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Opacity(
                    opacity: _fade.value,
                    child: const Text(
                      'Platform Ujian Cerdas Indonesia',
                      style: TextStyle(
                        fontSize: 13, color: AppColors.gray400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Progress bar
                  Opacity(
                    opacity: _fade.value,
                    child: SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progress.value,
                          backgroundColor:
                              Colors.white.withOpacity(0.08),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.blue400),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: _fade.value * _progress.value,
                    child: Text(
                      _progress.value < 0.5
                          ? 'Memuat komponen...'
                          : _progress.value < 0.85
                              ? 'Menyiapkan data...'
                              : 'Hampir selesai...',
                      style: AppText.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Version footer
          Positioned(
            bottom: 32, left: 0, right: 0,
            child: Text('v1.0.0 • Made in Indonesia 🇮🇩',
                textAlign: TextAlign.center,
                style: AppText.caption.copyWith(
                    color: AppColors.gray500.withOpacity(0.7))),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  2. ONBOARDING SCREEN
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  late AnimationController _anim;
  late Animation<double> _fadeSlide;

  final _pages = [
    _OnboardData(
      emoji: '🎯',
      title: 'Ujian Online\nLebih Mudah',
      desc: 'Kerjakan ujian kapan saja dan di mana saja langsung dari smartphone. Antarmuka bersih dan intuitif.',
      gradient: [AppColors.blue500, AppColors.purple600],
    ),
    _OnboardData(
      emoji: '🛡️',
      title: 'Anti-Curang\nBerbasis AI',
      desc: 'Deteksi otomatis pindah aplikasi, screenshot, screen record. Kamera selfie monitoring real-time.',
      gradient: [AppColors.purple600, Color(0xFF0EA5E9)],
    ),
    _OnboardData(
      emoji: '📊',
      title: 'Analisis Hasil\nMendalam',
      desc: 'Nilai, ranking, dan analisis per topik secara real-time. Export PDF & Excel dengan sekali klik.',
      gradient: [Color(0xFF0EA5E9), AppColors.emerald],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 400));
    _fadeSlide = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  void _next() {
    if (_page < 2) {
      _anim.reverse().then((_) {
        setState(() => _page++);
        _anim.forward();
      });
    } else {
      _toLogin();
    }
  }

  void _toLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const LoginScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _pages[_page];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 20, 0),
                    child: GestureDetector(
                      onTap: _toLogin,
                      child: Text('Lewati',
                          style: AppText.caption.copyWith(
                              color: AppColors.gray400)),
                    ),
                  ),
                ),

                // Illustration
                Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeSlide,
                    builder: (_, __) => Opacity(
                      opacity: _fadeSlide.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _fadeSlide.value)),
                        child: Center(
                          child: Container(
                            width: size.width * 0.55,
                            height: size.width * 0.55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: p.gradient
                                    .map((c) => c.withOpacity(0.25))
                                    .toList(),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(p.emoji,
                                  style: TextStyle(
                                      fontSize: size.width * 0.22)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content card
                AnimatedBuilder(
                  animation: _fadeSlide,
                  builder: (_, __) => Opacity(
                    opacity: _fadeSlide.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _fadeSlide.value)),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with gradient
                            ShaderMask(
                              shaderCallback: (b) => LinearGradient(
                                colors: p.gradient,
                              ).createShader(b),
                              child: Text(
                                p.title,
                                style: AppText.h1.copyWith(
                                    color: Colors.white, height: 1.25),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(p.desc, style: AppText.body.copyWith(
                              color: AppColors.gray400, height: 1.65)),
                            const SizedBox(height: 28),

                            // Dots
                            Row(
                              children: [
                                Row(
                                  children: List.generate(3, (i) {
                                    final active = i == _page;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 300),
                                      margin: const EdgeInsets.only(right: 6),
                                      width: active ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? AppColors.blue400
                                            : Colors.white
                                                .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    );
                                  }),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _next,
                                  child: Container(
                                    width: 52, height: 52,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: p.gradient),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: p.gradient.first
                                              .withOpacity(0.4),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _page == 2
                                          ? Icons.rocket_launch_rounded
                                          : Icons.arrow_forward_rounded,
                                      color: Colors.white, size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final String emoji, title, desc;
  final List<Color> gradient;
  _OnboardData({
    required this.emoji, required this.title,
    required this.desc, required this.gradient,
  });
}

// ─────────────────────────────────────────────
//  3. LOGIN SCREEN
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _role = 'siswa';
  final _nisCtrl = TextEditingController(text: '0031234567');
  final _passCtrl = TextEditingController(text: 'Demo@2026');
  bool _loading = false;
  bool _obscure = true;

  final _roles = [
    ('siswa', '🎒', 'Siswa'),
    ('guru', '👩‍🏫', 'Guru'),
    ('admin', '⚙️', 'Admin'),
  ];

  @override
  void dispose() {
    _nisCtrl.dispose(); _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _loading = false);

    Widget dest;
    switch (_role) {
      case 'guru': dest = const TeacherDashboardScreen(); break;
      case 'admin': dest = const AdminDashboardScreen(); break;
      default: dest = const StudentDashboardScreen();
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => dest,
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.of(context).padding.top + 32,
              24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo mini
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.blue500, AppColors.purple600]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('🎓',
                            style: TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [AppColors.blue300, AppColors.purple300],
                      ).createShader(b),
                      child: const Text('ExamPro',
                          style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                const Text('Selamat\nDatang! 👋', style: AppText.h1),
                const SizedBox(height: 8),
                const Text('Masuk ke akun ExamPro Anda',
                    style: AppText.caption),
                const SizedBox(height: 28),

                // Role selector
                Row(
                  children: _roles.map((r) {
                    final isActive = _role == r.$1;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _role = r.$1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.only(right: 8),
                          padding:
                              const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? const LinearGradient(
                                    colors: [
                                      Color(0x441E40AF),
                                      Color(0x446D28D9)
                                    ],
                                  )
                                : null,
                            color: isActive
                                ? null
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.blue400
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(r.$2,
                                  style: const TextStyle(fontSize: 22)),
                              const SizedBox(height: 4),
                              Text(r.$3,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.gray400,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // NIS field
                _FieldLabel('NIS / Username'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _nisCtrl,
                  hint: 'Masukkan NIS atau Username',
                  prefix: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),

                // Password field
                _FieldLabel('Password'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _passCtrl,
                  hint: '••••••••',
                  prefix: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.gray500, size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Lupa Password?',
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: AppColors.blue400)),
                ),
                const SizedBox(height: 28),

                // Login button
                PrimaryButton(
                  label: 'Masuk ke ExamPro',
                  loading: _loading,
                  onTap: _login,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(
                        color: Colors.white.withOpacity(0.08))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('atau', style: AppText.caption),
                    ),
                    Expanded(child: Divider(
                        color: Colors.white.withOpacity(0.08))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: GhostButton(
                        label: '🏫  SSO Sekolah')),
                    const SizedBox(width: 10),
                    Expanded(child: GhostButton(
                        label: '🔵  Google')),
                  ],
                ),
                const SizedBox(height: 28),
                Center(
                  child: Text(
                    'ExamPro v1.0.0 • © 2026 EduTech Indonesia',
                    style: AppText.caption.copyWith(
                        color: AppColors.gray500.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: AppText.label,
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefix;
  final Widget? suffix;
  final bool obscure;

  const _InputField({
    required this.controller, required this.hint,
    this.prefix, this.suffix, this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppText.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.gray500),
        prefixIcon: prefix != null
            ? Icon(prefix, color: AppColors.gray500, size: 20)
            : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: AppColors.blue400, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  4. STUDENT DASHBOARD
// ─────────────────────────────────────────────
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});
  @override
  State<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends State<StudentDashboardScreen> {
  int _tab = 0;
  bool _showNotif = true;

  final _upcomingExams = [
    _ExamData(
      subject: 'Fisika',
      type: 'Ulangan Harian',
      className: 'XII IPA 1',
      time: 'Besok, 08:00',
      duration: 60,
      questionCount: 30,
      tags: ['PG', 'Essay'],
      status: ExamStatus.upcoming,
    ),
    _ExamData(
      subject: 'Bahasa Indonesia',
      type: 'UAS Semester 2',
      className: 'XII IPA 1',
      time: "Jum'at, 10:00",
      duration: 90,
      questionCount: 50,
      tags: ['HOTS'],
      status: ExamStatus.upcoming,
    ),
  ];

  final _doneExams = [
    _ExamData(
      subject: 'Kimia',
      type: 'Ulangan Harian',
      className: 'XII IPA 1',
      time: '3 hari lalu',
      duration: 75,
      questionCount: 40,
      status: ExamStatus.done,
      score: 88,
    ),
    _ExamData(
      subject: 'Biologi',
      type: 'Kuis',
      className: 'XII IPA 1',
      time: '1 minggu lalu',
      duration: 60,
      questionCount: 25,
      status: ExamStatus.done,
      score: 82,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    if (_showNotif) _buildNotifBanner(),
                    _buildStatRow(),
                    const SizedBox(height: 8),
                    _buildMiniChart(),
                    const SizedBox(height: 20),
                    _buildActiveExam(),
                    const SizedBox(height: 20),
                    SectionHeader(
                      title: 'Jadwal Ujian',
                      action: 'Lihat Semua',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    ..._upcomingExams.map(_buildUpcomingCard),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'Riwayat Ujian'),
                    const SizedBox(height: 12),
                    ..._doneExams.map(_buildDoneCard),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blue600.withOpacity(0.25),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat pagi, 👋',
                    style: AppText.caption),
                const SizedBox(height: 2),
                const Text('Ahmad Fauzi',
                    style: AppText.h2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.blue500.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.blue400.withOpacity(0.3)),
                      ),
                      child: const Text('XII IPA 1',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: AppColors.blue300,
                          )),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.emerald.withOpacity(0.3)),
                      ),
                      child: const Text('Peringkat #3',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Avatar
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue500, AppColors.purple600]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue500.withOpacity(0.3),
                  blurRadius: 10, offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Text('AF',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800,
                    color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifBanner() {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: AppColors.emerald.withOpacity(0.3),
      gradient: LinearGradient(
        colors: [
          AppColors.emerald.withOpacity(0.12),
          AppColors.cyan400.withOpacity(0.08),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text('🔔', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ujian Matematika Dimulai!',
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.emerald,
                    )),
                SizedBox(height: 2),
                Text('Segera masukkan token ujian. Waktu: 90 mnt',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.gray400)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showNotif = false),
            child: const Icon(Icons.close, color: AppColors.gray500, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: const [
          StatMiniCard(value: '87', label: 'Rata-rata'),
          SizedBox(width: 10),
          StatMiniCard(value: '12', label: 'Selesai',
              valueColor: AppColors.purple300),
          SizedBox(width: 10),
          StatMiniCard(value: '3', label: 'Jadwal',
              valueColor: AppColors.amber),
        ],
      ),
    );
  }

  Widget _buildMiniChart() {
    final vals = [40, 60, 50, 75, 65, 80, 90];
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Perkembangan Nilai', style: AppText.h3),
              Text('7 Hari', style: AppText.caption),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: vals.asMap().entries.map((e) {
                final isLast = e.key == vals.length - 1;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500 + e.key * 80),
                      height: 56 * e.value / 100,
                      decoration: BoxDecoration(
                        gradient: isLast
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                    AppColors.blue400,
                                    AppColors.purple500
                                ])
                            : null,
                        color: isLast
                            ? null
                            : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: isLast
                            ? [
                                BoxShadow(
                                    color: AppColors.blue500
                                        .withOpacity(0.5),
                                    blurRadius: 8)
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveExam() {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExamTokenScreen())),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        borderColor: AppColors.emerald.withOpacity(0.35),
        gradient: LinearGradient(
          colors: [
            AppColors.emerald.withOpacity(0.15),
            AppColors.cyan400.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BlinkDot(color: AppColors.emerald),
                const SizedBox(width: 6),
                const Text('Sedang Berlangsung',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: AppColors.emerald,
                    )),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.blue500, AppColors.purple600]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Masuk Ujian →',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Matematika Wajib',
                style: AppText.h2),
            const SizedBox(height: 4),
            const Text('XII IPA 1 • Ujian Tengah Semester',
                style: AppText.caption),
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaChip(icon: Icons.timer_outlined, label: '45 mnt tersisa'),
                const SizedBox(width: 10),
                _MetaChip(icon: Icons.help_outline_rounded, label: '40 soal'),
              ],
            ),
            const SizedBox(height: 14),
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 6),
            const Text('24 / 40 soal dijawab',
                style: TextStyle(fontSize: 11, color: AppColors.gray400,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(_ExamData e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderColor: AppColors.blue400.withOpacity(0.2),
        gradient: LinearGradient(
          colors: [
            AppColors.blue500.withOpacity(0.12),
            AppColors.purple600.withOpacity(0.08),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('📅', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 4),
                      Text(e.time, style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: AppColors.amber,
                      )),
                    ],
                  ),
                ),
                const Spacer(),
                ...e.tags.map((t) => Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.purple500.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t, style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        color: AppColors.purple300)),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 10),
            Text(e.subject, style: AppText.h3),
            const SizedBox(height: 2),
            Text('${e.className} • ${e.type}',
                style: AppText.caption),
            const SizedBox(height: 10),
            Row(
              children: [
                _MetaChip(icon: Icons.timer_outlined,
                    label: '${e.duration} mnt'),
                const SizedBox(width: 10),
                _MetaChip(icon: Icons.help_outline_rounded,
                    label: '${e.questionCount} soal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneCard(_ExamData e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ExamResultScreen())),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('✅ Selesai',
                          style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: AppColors.gray400,
                          )),
                    ),
                    const SizedBox(height: 8),
                    Text(e.subject, style: AppText.h3),
                    const SizedBox(height: 2),
                    Text(e.time, style: AppText.caption),
                  ],
                ),
              ),
              ScoreRing(score: e.score!.toDouble(), size: 64, label: 'Nilai'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Beranda'),
      (Icons.edit_note_rounded, 'Ujian'),
      (Icons.bar_chart_rounded, 'Hasil'),
      (Icons.person_rounded, 'Profil'),
    ];
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 10, 16,
            MediaQuery.of(context).padding.bottom + 8),
        decoration: BoxDecoration(
          color: AppColors.bg.withOpacity(0.96),
          border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((e) {
            final active = e.key == _tab;
            return GestureDetector(
              onTap: () {
                if (e.key == 3) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const ProfileScreen()));
                  return;
                }
                setState(() => _tab = e.key);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.blue500.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(e.value.$1,
                        color: active
                            ? AppColors.blue400
                            : AppColors.gray500,
                        size: 22),
                    const SizedBox(height: 4),
                    Text(e.value.$2,
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.blue400
                              : AppColors.gray500,
                        )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.gray400),
        const SizedBox(width: 4),
        Text(label, style: AppText.caption),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  DATA MODELS (local)
// ─────────────────────────────────────────────
enum ExamStatus { upcoming, active, done }

class _ExamData {
  final String subject, type, className, time;
  final int duration, questionCount;
  final List<String> tags;
  final ExamStatus status;
  final int? score;

  _ExamData({
    required this.subject, required this.type, required this.className,
    required this.time, required this.duration, required this.questionCount,
    this.tags = const [], required this.status, this.score,
  });
}

// ─────────────────────────────────────────────
//  5. EXAM TOKEN SCREEN
// ─────────────────────────────────────────────
class ExamTokenScreen extends StatefulWidget {
  const ExamTokenScreen({super.key});
  @override
  State<ExamTokenScreen> createState() => _ExamTokenScreenState();
}

class _ExamTokenScreenState extends State<ExamTokenScreen> {
  final List<TextEditingController> _digits =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focuses = List.generate(6, (_) => FocusNode());
  bool _loading = false;

  @override
  void dispose() {
    for (final c in _digits) c.dispose();
    for (final f in _focuses) f.dispose();
    super.dispose();
  }

  void _onDigit(int i, String val) {
    if (val.isNotEmpty && i < 5) {
      _focuses[i + 1].requestFocus();
    } else if (val.isEmpty && i > 0) {
      _focuses[i - 1].requestFocus();
    }
    final full = _digits.map((c) => c.text).join();
    if (full.length == 6) _verify();
  }

  Future<void> _verify() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const ExamScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.gray400),
                  ),
                  const SizedBox(height: 32),
                  const Text('🔑', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  const Text('Masukkan Token\nUjian', style: AppText.h1),
                  const SizedBox(height: 8),
                  const Text(
                    'Token 6 digit diberikan oleh guru/pengawas\nsebelum ujian dimulai.',
                    style: AppText.caption,
                  ),
                  const SizedBox(height: 36),

                  // Token input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 48,
                        child: TextField(
                          controller: _digits[i],
                          focusNode: _focuses[i],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (v) => _onDigit(i, v),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.purple500.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: AppColors.purple500.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                  color: AppColors.purple500.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.purple400, width: 2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Verifikasi Token',
                    loading: _loading,
                    onTap: _verify,
                    icon: Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline_rounded,
                            color: AppColors.blue400, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pastikan koneksi internet stabil sebelum memulai ujian.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.gray400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  6. EXAM SCREEN
// ─────────────────────────────────────────────
class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});
  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _current = 0;
  final Map<int, String> _answers = {};
  late Timer _timer;
  int _seconds = 44 * 60 + 32;

  final _questions = [
    _Question(
      text: 'Turunan dari f(x) = 3x² − 2x + 5 pada x = 2 adalah...',
      options: ['A. 8', 'B. 10', 'C. 12 ✓', 'D. 14', 'E. 16'],
      correct: 'C',
    ),
    _Question(
      text: 'Nilai ∫₀¹ (2x + 3) dx adalah...',
      options: ['A. 2', 'B. 3', 'C. 4 ✓', 'D. 5', 'E. 6'],
      correct: 'C',
    ),
    _Question(
      text: 'Limit dari (x² − 4)/(x − 2) saat x → 2 adalah...',
      options: ['A. 0', 'B. 2', 'C. 4 ✓', 'D. ∞', 'E. Tidak ada'],
      correct: 'C',
    ),
    _Question(
      text: 'Persamaan lingkaran dengan pusat (3, -2) dan jari-jari 5 adalah...',
      options: [
        'A. (x-3)² + (y+2)² = 25 ✓',
        'B. (x+3)² + (y-2)² = 25',
        'C. (x-3)² + (y-2)² = 5',
        'D. x² + y² = 25',
        'E. (x+3)² + (y+2)² = 25',
      ],
      correct: 'A',
    ),
    _Question(
      text: 'Jika matriks A = [[2,1],[3,4]], maka det(A) adalah...',
      options: ['A. 5 ✓', 'B. 8', 'C. 11', 'D. -5', 'E. 14'],
      correct: 'A',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Block status bar during exam
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _autoSubmit();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _autoSubmit() {
    _timer.cancel();
    _submit();
  }

  void _submit() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ExamResultScreen()));
  }

  String get _timeStr {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isLowTime => _seconds <= 300;

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current % _questions.length];

    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF050A1E),
        body: Column(
          children: [
            _buildHeader(),
            _buildDots(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    // Camera indicator
                    GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      borderColor: AppColors.emerald.withOpacity(0.25),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.emerald.withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.videocam,
                                color: AppColors.emerald, size: 16),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Kamera aktif — AI monitoring berjalan',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.gray400),
                            ),
                          ),
                          const BlinkDot(color: AppColors.emerald),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question card
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.purple500.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Soal ${_current + 1} dari ${_questions.length}',
                                  style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700,
                                    color: AppColors.purple300,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text('📝',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(q.text,
                              style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600,
                                color: Colors.white, height: 1.65,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Answers
                    ...q.options.asMap().entries.map((e) {
                      final letter = String.fromCharCode(65 + e.key);
                      final selected = _answers[_current] == letter;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _answers[_current] = letter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0x331E40AF),
                                        Color(0x336D28D9)
                                      ],
                                    )
                                  : null,
                              color: selected
                                  ? null
                                  : Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? AppColors.blue400
                                    : Colors.white.withOpacity(0.08),
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                      milliseconds: 200),
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.blue500
                                        : Colors.white.withOpacity(0.08),
                                    borderRadius:
                                        BorderRadius.circular(9),
                                  ),
                                  child: Center(
                                    child: Text(letter,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    e.value.replaceAll(' ✓', ''),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.gray200,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.blue400, size: 18,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Nav footer
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20,
                  MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: const Color(0xFF050A1E).withOpacity(0.95),
                border: Border(
                    top: BorderSide(
                        color: Colors.white.withOpacity(0.07))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      label: '← Sebelumnya',
                      onTap: _current > 0
                          ? () => setState(() => _current--)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _current < _questions.length - 1
                        ? PrimaryButton(
                            label: 'Selanjutnya →',
                            onTap: () =>
                                setState(() => _current++),
                          )
                        : PrimaryButton(
                            label: 'Kumpulkan 🏁',
                            onTap: () => _showSubmitDialog(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 10, 20, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x447C3AED), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('XII IPA 1 • UTS Ganjil 2026',
              style: AppText.caption),
          const SizedBox(height: 2),
          const Text('Matematika Wajib', style: AppText.h2),
          const SizedBox(height: 12),
          Row(
            children: [
              // Timer
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: (_isLowTime ? AppColors.rose : AppColors.rose)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.rose.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    _isLowTime
                        ? const BlinkDot(
                            color: AppColors.rose, size: 7)
                        : const Icon(Icons.timer_outlined,
                            color: AppColors.rose, size: 16),
                    const SizedBox(width: 8),
                    Text(_timeStr,
                        style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800,
                          color: AppColors.rose,
                          fontFeatures: [FontFeature.tabularFigures()],
                        )),
                  ],
                ),
              ),
              const Spacer(),
              GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Text(
                  '${_answers.length} / ${_questions.length} dijawab',
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppColors.gray200,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _questions.length,
        itemBuilder: (_, i) {
          final isCurrent = i == _current;
          final answered = _answers.containsKey(i);
          return GestureDetector(
            onTap: () => setState(() => _current = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32, height: 32,
              margin: const EdgeInsets.symmetric(
                  horizontal: 3, vertical: 6),
              decoration: BoxDecoration(
                gradient: isCurrent
                    ? const LinearGradient(
                        colors: [AppColors.blue500, AppColors.purple600])
                    : null,
                color: isCurrent
                    ? null
                    : answered
                        ? AppColors.blue500.withOpacity(0.3)
                        : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.blue400
                      : answered
                          ? AppColors.blue400.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.blue500.withOpacity(0.4),
                          blurRadius: 8,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text('${i + 1}',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      color: (isCurrent || answered)
                          ? Colors.white
                          : AppColors.gray500,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        title: const Text('Kumpulkan Ujian?',
            style: AppText.h3),
        content: Text(
          '${_answers.length} dari ${_questions.length} soal sudah dijawab.\n\nJawaban tidak dapat diubah setelah dikumpulkan.',
          style: AppText.body.copyWith(color: AppColors.gray400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.gray400)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              _submit();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blue500, AppColors.purple600]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Kumpulkan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        title: const Text('⚠️ Keluar dari Ujian?',
            style: AppText.h3),
        content: Text(
          'Keluar dari layar ujian akan dicatat sebagai pelanggaran.',
          style: AppText.body.copyWith(color: AppColors.gray400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tetap di Ujian',
                style: TextStyle(color: AppColors.blue400,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _Question {
  final String text;
  final List<String> options;
  final String correct;
  _Question({
    required this.text, required this.options, required this.correct,
  });
}

// ─────────────────────────────────────────────
//  7. EXAM RESULT SCREEN
// ─────────────────────────────────────────────
class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});
  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scoreAnim;

  final _topics = [
    ('Kalkulus', 0.90),
    ('Trigonometri', 0.75),
    ('Aljabar', 0.85),
    ('Statistika', 0.60),
    ('Geometri', 0.78),
  ];

  final _ranking = [
    ('🥇', 'Siti Rahayu', '96', AppColors.amber),
    ('🥈', 'Budi Santoso', '91', AppColors.gray400),
    ('🥉', 'Ahmad Fauzi', '88', AppColors.amber),
    ('4', 'Dian Pratiwi', '85', AppColors.gray500),
    ('5', 'Rini Susanti', '83', AppColors.gray500),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200));
    _scoreAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).padding.top + 12, 20, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const StudentDashboardScreen()),
                        (_) => false),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.gray400),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hasil Ujian', style: AppText.caption),
                        Text('Matematika Wajib', style: AppText.h3),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    children: [
                      // Score ring
                      AnimatedBuilder(
                        animation: _scoreAnim,
                        builder: (_, __) => ScoreRing(
                          score: 88 * _scoreAnim.value,
                          size: 140,
                          label: 'Nilai Akhir',
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Grade badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.emerald.withOpacity(0.3)),
                        ),
                        child: const Text('Grade A — Sangat Baik',
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: AppColors.emerald,
                            )),
                      ),
                      const SizedBox(height: 4),
                      const Text('Lulus KKM ✅',
                          style: AppText.caption),
                      const SizedBox(height: 20),

                      // Summary grid
                      Row(
                        children: [
                          _SummaryItem('35', 'Benar',
                              AppColors.emerald),
                          const SizedBox(width: 10),
                          _SummaryItem('5', 'Salah',
                              AppColors.rose),
                          const SizedBox(width: 10),
                          _SummaryItem('0', 'Skip',
                              AppColors.gray400),
                          const SizedBox(width: 10),
                          _SummaryItem('72m', 'Waktu',
                              AppColors.blue300),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Ranking
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        borderColor: AppColors.amber.withOpacity(0.2),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.amber.withOpacity(0.1),
                            AppColors.amber.withOpacity(0.05),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('🏆',
                                style: TextStyle(fontSize: 36)),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('PERINGKAT KELAS',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.amber,
                                        letterSpacing: 1,
                                      )),
                                  SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text('#3',
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.amber,
                                          )),
                                      SizedBox(width: 6),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 6),
                                        child: Text('dari 32 siswa',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.gray400,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: const [
                                Text('Top 10%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.gray400,
                                    )),
                                SizedBox(height: 4),
                                Text('⭐ Excellent',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.amber,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Topic analysis
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(
                                title: 'Analisis per Topik'),
                            const SizedBox(height: 14),
                            ..._topics.map((t) => _TopicBar(
                                  label: t.$1, progress: t.$2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ranking list
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(title: '🏅 Ranking Kelas'),
                            const SizedBox(height: 12),
                            ..._ranking.asMap().entries.map((e) {
                              final r = e.value;
                              final isMe = e.key == 2;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isMe
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0x22FCD34D),
                                            Color(0x11F59E0B),
                                          ],
                                        )
                                      : null,
                                  color: isMe
                                      ? null
                                      : Colors.white.withOpacity(0.04),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isMe
                                        ? AppColors.amber.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.06),
                                    width: isMe ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      child: Text(r.$1,
                                          style: const TextStyle(
                                              fontSize: 16)),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text('👤',
                                            style: TextStyle(
                                                fontSize: 18)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r.$2,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              )),
                                          if (isMe)
                                            const Text('Anda',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.amber,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                        ],
                                      ),
                                    ),
                                    Text(r.$3,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: r.$4,
                                        )),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Export buttons
                      Row(
                        children: [
                          Expanded(
                            child: GhostButton(
                              label: '📄 Export PDF',
                              onTap: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('PDF sedang diproses...'),
                                backgroundColor: AppColors.blue500,
                              )),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Kembali 🏠',
                              onTap: () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const StudentDashboardScreen()),
                                    (_) => false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String val, label;
  final Color color;
  const _SummaryItem(this.val, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(val,
                style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900,
                  color: color,
                )),
            const SizedBox(height: 3),
            Text(label, style: AppText.label),
          ],
        ),
      ),
    );
  }
}

class _TopicBar extends StatelessWidget {
  final String label;
  final double progress;
  const _TopicBar({required this.label, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppText.caption),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.07),
                valueColor: AlwaysStoppedAnimation(
                  progress >= 0.8
                      ? AppColors.emerald
                      : progress >= 0.6
                          ? AppColors.blue400
                          : AppColors.amber,
                ),
                minHeight: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  8. TEACHER DASHBOARD
// ─────────────────────────────────────────────
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});
  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends State<TeacherDashboardScreen> {
  int _tab = 0;

  final _quickActions = [
    ('📥', 'Import Soal', 'Upload Excel/CSV', AppColors.blue500),
    ('➕', 'Buat Ujian', 'Atur jadwal baru', AppColors.purple600),
    ('🔑', 'Token Ujian', 'Generate token', AppColors.cyan400),
    ('📊', 'Nilai & Analisis', 'Statistik', AppColors.emerald),
  ];

  final _students = [
    ('😊', 'Aktif'), ('🧑', 'Aktif'), ('😐', '⚠ Tab'),
    ('👩', 'Aktif'), ('🧒', 'Aktif'), ('😴', '⛔ Off'),
    ('👧', 'Aktif'), ('🙎', 'Aktif'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    _buildStats(),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'Aksi Cepat'),
                    const SizedBox(height: 12),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monitoring Live', style: AppText.h3),
                        Row(
                          children: [
                            const BlinkDot(color: AppColors.rose),
                            const SizedBox(width: 5),
                            const Text('LIVE',
                                style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800,
                                  color: AppColors.rose,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMonitorCard(),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'Token Ujian Aktif'),
                    const SizedBox(height: 12),
                    _buildTokenCard(),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'Pengumpulan Terakhir'),
                    const SizedBox(height: 12),
                    _buildSubmissions(),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x337C3AED), Color(0x222563EB)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.purple600, AppColors.blue500]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
                child: Text('👩‍🏫', style: TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bu. Sari Dewi', style: AppText.h3),
                Text('Matematika • SMA Nusantara',
                    style: AppText.caption),
              ],
            ),
          ),
          Stack(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 22),
              ),
              Positioned(
                top: 0, right: 0,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.rose,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: const [
        StatMiniCard(value: '5', label: 'Ujian Aktif',
            valueColor: AppColors.purple300),
        SizedBox(width: 10),
        StatMiniCard(value: '128', label: 'Siswa'),
        SizedBox(width: 10),
        StatMiniCard(value: '84', label: 'Rata Nilai',
            valueColor: AppColors.emerald),
      ],
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: _quickActions.map((a) {
        return GestureDetector(
          onTap: () {},
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            borderColor: a.$4.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(a.$1,
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(a.$2,
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                Text(a.$3, style: AppText.caption),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonitorCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Matematika • XII IPA 1',
                        style: AppText.h3),
                    SizedBox(height: 2),
                    Text('28/32 hadir • 44 mnt tersisa',
                        style: AppText.caption),
                  ],
                ),
              ),
              const Text('👁', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: _students.map((s) {
              final isWarn = s.$2.startsWith('⚠');
              final isOff = s.$2.startsWith('⛔');
              return Container(
                decoration: BoxDecoration(
                  color: isWarn
                      ? AppColors.amber.withOpacity(0.1)
                      : isOff
                          ? AppColors.rose.withOpacity(0.1)
                          : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isWarn
                        ? AppColors.amber.withOpacity(0.3)
                        : isOff
                            ? AppColors.rose.withOpacity(0.3)
                            : Colors.white.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.$1,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text(s.$2,
                        style: TextStyle(
                          fontSize: 8, fontWeight: FontWeight.w700,
                          color: isWarn
                              ? AppColors.amber
                              : isOff
                                  ? AppColors.rose
                                  : AppColors.emerald,
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatusDot(AppColors.emerald, '26 aktif'),
              const SizedBox(width: 12),
              _StatusDot(AppColors.amber, '1 peringatan'),
              const SizedBox(width: 12),
              _StatusDot(AppColors.rose, '1 offline'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: AppColors.purple500.withOpacity(0.3),
      gradient: const LinearGradient(
        colors: [Color(0x337C3AED), Color(0x222563EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        children: [
          const Text('TOKEN UJIAN',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: AppColors.purple300, letterSpacing: 2,
              )),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.purple300, AppColors.blue300,
                AppColors.cyan400],
            ).createShader(b),
            child: const Text('A7X9B2',
                style: TextStyle(
                  fontSize: 44, fontWeight: FontWeight.w900,
                  color: Colors.white, letterSpacing: 14,
                )),
          ),
          const SizedBox(height: 8),
          const Text('⏱ Berlaku 28 menit lagi • Auto-refresh',
              style: AppText.caption),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: GhostButton(label: '🔄 Generate Baru')),
              const SizedBox(width: 10),
              Expanded(child: PrimaryButton(
                  label: '📋 Salin', onTap: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissions() {
    final subs = [
      ('😊', 'Siti Rahayu', 'Selesai • 2 mnt lalu', '96',
          AppColors.emerald),
      ('🧑', 'Budi Santoso', 'Selesai • 5 mnt lalu', '91',
          AppColors.blue300),
      ('👩', 'Dian Pratiwi', 'Selesai • 8 mnt lalu', '85',
          AppColors.blue300),
    ];
    return Column(
      children: subs.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GlassCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(s.$1, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.$2, style: AppText.body.copyWith(
                        fontWeight: FontWeight.w700)),
                    Text(s.$3, style: AppText.caption),
                  ],
                ),
              ),
              Text(s.$4,
                  style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900,
                    color: s.$5,
                  )),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Beranda'),
      (Icons.edit_note_rounded, 'Ujian'),
      (Icons.download_rounded, 'Import'),
      (Icons.person_rounded, 'Profil'),
    ];
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 10, 16,
            MediaQuery.of(context).padding.bottom + 8),
        decoration: BoxDecoration(
          color: AppColors.bg.withOpacity(0.96),
          border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((e) {
            final active = e.key == _tab;
            return GestureDetector(
              onTap: () {
                if (e.key == 3) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const ProfileScreen()));
                  return;
                }
                setState(() => _tab = e.key);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e.value.$1,
                      color: active
                          ? AppColors.blue400 : AppColors.gray500,
                      size: 22),
                  const SizedBox(height: 4),
                  Text(e.value.$2,
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: active
                            ? AppColors.blue400 : AppColors.gray500,
                      )),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final String label;
  const _StatusDot(this.color, this.label);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7, height: 7,
          decoration: BoxDecoration(
              color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  9. ADMIN DASHBOARD
// ─────────────────────────────────────────────
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {

  final _stats = [
    ('🎒', '847', 'Total Siswa', '↑ 12 baru bulan ini',
        [AppColors.blue500, const Color(0xFF1D4ED8)]),
    ('👩‍🏫', '48', 'Total Guru', 'Aktif semester ini',
        [AppColors.purple600, const Color(0xFF6D28D9)]),
    ('📝', '156', 'Ujian Digelar', '↑ 23 bulan ini',
        [const Color(0xFF0891B2), AppColors.cyan400]),
    ('📊', '82.4', 'Rata Nilai', '↑ 4.2 vs semester lalu',
        [const Color(0xFF059669), AppColors.emerald]),
  ];

  final _activity = [
    (AppColors.emerald, 'Bu Sari memulai ujian Matematika XII IPA 1',
        '2 mnt lalu'),
    (AppColors.amber,
        '⚠ Kecurangan: Doni XII IPS 2 pindah tab',
        '8 mnt lalu'),
    (AppColors.blue400, 'Pak Ahmad import 45 soal Fisika via Excel',
        '15 mnt lalu'),
    (AppColors.purple400,
        '156 siswa menyelesaikan UTS Semester Ganjil',
        '1 jam lalu'),
    (AppColors.gray500, 'Backup otomatis database berhasil',
        '2 jam lalu'),
  ];

  final _quickActions = [
    ('📥', 'Import Data', 'Siswa, Soal, Jadwal', AppColors.blue500),
    ('📤', 'Export Nilai', 'PDF & Excel', AppColors.emerald),
    ('👥', 'Kelola User', 'Siswa & Guru', AppColors.purple500),
    ('🏫', 'Kelas & Mapel', 'Struktur sekolah', AppColors.cyan400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    _buildStatsGrid(),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'Manajemen Data'),
                    const SizedBox(height: 12),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    const SectionHeader(title: '⚡ Aktivitas Sistem'),
                    const SizedBox(height: 12),
                    _buildActivity(),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x22DC2626), Color(0x227C3AED)],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Panel Admin', style: AppText.caption),
                Text('SMA Nusantara 1', style: AppText.h2),
                SizedBox(height: 2),
                Text('Tahun Ajaran 2025/2026',
                    style: AppText.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.emerald.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BlinkDot(color: AppColors.emerald),
                const SizedBox(width: 6),
                const Text('SISTEM AKTIF',
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w800,
                      color: AppColors.emerald,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: _stats.map((s) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: s.$5,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.$1, style: const TextStyle(fontSize: 28)),
              const Spacer(),
              Text(s.$2,
                  style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w900,
                    color: Colors.white,
                  )),
              Text(s.$3,
                  style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  )),
              const SizedBox(height: 4),
              Text(s.$4,
                  style: const TextStyle(
                    fontSize: 10, color: Colors.white54)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: _quickActions.map((a) => GlassCard(
        padding: const EdgeInsets.all(14),
        borderColor: a.$4.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(a.$1, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(a.$2, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: Colors.white)),
            Text(a.$3, style: AppText.caption),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildActivity() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: _activity.asMap().entries.map((e) {
          final a = e.value;
          final last = e.key == _activity.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: last ? 0 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: a.$1, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(a.$2,
                      style: const TextStyle(
                        fontSize: 12, color: AppColors.gray200,
                        height: 1.5,
                      )),
                ),
                const SizedBox(width: 8),
                Text(a.$3, style: AppText.caption),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.dashboard_rounded, 'Dashboard'),
      (Icons.people_rounded, 'Users'),
      (Icons.download_rounded, 'Import'),
      (Icons.settings_rounded, 'Pengaturan'),
    ];
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 10, 16,
            MediaQuery.of(context).padding.bottom + 8),
        decoration: BoxDecoration(
          color: AppColors.bg.withOpacity(0.96),
          border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((e) {
            final active = e.key == 0;
            return GestureDetector(
              onTap: () {
                if (e.key == 3) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const ProfileScreen()));
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e.value.$1,
                      color: active
                          ? AppColors.blue400 : AppColors.gray500,
                      size: 22),
                  const SizedBox(height: 4),
                  Text(e.value.$2,
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: active
                            ? AppColors.blue400 : AppColors.gray500,
                      )),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  10. PROFILE SCREEN
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = true;
  bool _notif = true;
  bool _offline = true;

  final _settings = [
    (Icons.person_outline_rounded, 'Edit Profil', 'toggle', null),
    (Icons.lock_outline_rounded, 'Ubah Password', 'arrow', null),
    (Icons.language_rounded, 'Bahasa', 'value', 'Indonesia'),
    (Icons.shield_outlined, 'Privasi & Keamanan', 'arrow', null),
    (Icons.info_outline_rounded, 'Tentang ExamPro', 'arrow', null),
    (Icons.help_outline_rounded, 'Bantuan', 'arrow', null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const AnimatedBg(),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  children: [
                    _buildStats(),
                    const SizedBox(height: 20),
                    const Text('Pengaturan Akun', style: AppText.h3),
                    const SizedBox(height: 12),
                    _buildToggleSetting(
                      Icons.notifications_outlined, 'Notifikasi',
                      _notif, (v) => setState(() => _notif = v)),
                    const SizedBox(height: 8),
                    _buildToggleSetting(
                      Icons.dark_mode_outlined, 'Dark Mode',
                      _darkMode, (v) => setState(() => _darkMode = v)),
                    const SizedBox(height: 8),
                    _buildToggleSetting(
                      Icons.wifi_off_rounded, 'Offline Sync',
                      _offline, (v) => setState(() => _offline = v)),
                    const SizedBox(height: 8),
                    ..._settings.map(_buildSettingItem),
                    const SizedBox(height: 16),
                    GhostButton(
                      label: '🚪  Keluar dari Akun',
                      color: AppColors.rose,
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (_) => false),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'ExamPro v1.0.0 • © 2026 EduTech Indonesia',
                        style: AppText.caption.copyWith(
                            color: AppColors.gray500.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x337C3AED), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.gray400),
              ),
              const Expanded(
                child: Center(
                  child: Text('Profil Saya', style: AppText.h3),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.blue500, AppColors.purple600]),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple600.withOpacity(0.4),
                      blurRadius: 20, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('AF',
                      style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w900,
                        color: Colors.white,
                      )),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 11, color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Ahmad Fauzi', style: AppText.h2),
          const SizedBox(height: 4),
          const Text('NIS: 0031234567 • XII IPA 1',
              style: AppText.caption),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip('Siswa Aktif', AppColors.blue400),
              const SizedBox(width: 8),
              _Chip('Ranking #3', AppColors.amber),
              const SizedBox(width: 8),
              _Chip('⭐ Berprestasi', AppColors.emerald),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: const [
        StatMiniCard(value: '12', label: 'Ujian'),
        SizedBox(width: 10),
        StatMiniCard(value: '87', label: 'Rata Nilai',
            valueColor: AppColors.emerald),
        SizedBox(width: 10),
        StatMiniCard(value: '#3', label: 'Peringkat',
            valueColor: AppColors.amber),
      ],
    );
  }

  Widget _buildToggleSetting(
      IconData icon, String label, bool val, ValueChanged<bool> cb) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.gray400, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppText.body),
          ),
          GestureDetector(
            onTap: () => cb(!val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 46, height: 26,
              decoration: BoxDecoration(
                gradient: val
                    ? const LinearGradient(
                        colors: [AppColors.blue500, AppColors.purple600])
                    : null,
                color: val ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                alignment: val
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
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
    );
  }

  Widget _buildSettingItem(List<dynamic> s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(s[0] as IconData,
                    color: AppColors.gray400, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(s[1] as String, style: AppText.body),
              ),
              if (s[3] != null)
                Text(s[3] as String, style: AppText.caption)
              else
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.gray500, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: color,
          )),
    );
  }
}

// ─────────────────────────────────────────────
//  END OF FILE
// ─────────────────────────────────────────────
