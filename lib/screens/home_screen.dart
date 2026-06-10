import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'question_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl, _pulseCtrl, _starsCtrl;
  late Animation<double> _floatAnim, _pulseAnim, _starsAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _starsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _starsAnim = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _starsCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _starsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0015),
              Color(0xFF120025),
              Color(0xFF1E0040),
              Color(0xFF150030),
            ],
            stops: [0.0, 0.3, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _starsAnim,
              builder: (ctx, _) => CustomPaint(
                painter: StarFieldPainter(_starsAnim.value),
                size: size,
              ),
            ),
            Positioned(
              top: size.height * 0.12,
              left: size.width / 2 - 120,
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (ctx, _) => Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAA00FF).withOpacity(0.25),
                          blurRadius: 80,
                          spreadRadius: 30,
                        ),
                        BoxShadow(
                          color: const Color(0xFF6200EA).withOpacity(0.15),
                          blurRadius: 120,
                          spreadRadius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [
                          Color(0xFFEA80FC),
                          Color(0xFFCE93D8),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(b),
                      child: const Text(
                        'ProfAdivinho',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMascot(),
                            const SizedBox(height: 36),
                            _buildAction(context),
                          ],
                        ),
                      ),
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

  Widget _buildMascot() {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFAA00FF).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 185,
                height: 185,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEA80FC).withOpacity(0.15),
                    width: 1,
                  ),
                ),
              ),
              Image.network(
                'https://raw.githubusercontent.com/googlefonts/noto-emoji/main/png/512/emoji_u1f9d9_200d_2642_fe0f.png',
                height: 180,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.psychology, size: 90, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFAA00FF).withOpacity(0.4),
              ),
              color: const Color(0xFFAA00FF).withOpacity(0.1),
            ),
            child: const Text(
              'O ORÁCULO',
              style: TextStyle(
                color: Color(0xFFCE93D8),
                fontSize: 11,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFAA00FF).withOpacity(0.35),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Color(0xFFEA80FC),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Posso ler sua mente...',
                      style: TextStyle(
                        color: const Color(0xFFEA80FC).withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pense em um professor do ADS e eu descobrirei quem é!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'ESCOLHA A TEMÁTICA',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 10,
                letterSpacing: 3.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuestionScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6200EA), Color(0xFFAA00FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAA00FF).withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Professor ADS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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

class StarFieldPainter extends CustomPainter {
  final double animValue;
  StarFieldPainter(this.animValue);
  static final List<List<double>> _stars = List.generate(60, (i) {
    final rng = math.Random(i * 7 + 3);
    return [
      rng.nextDouble(),
      rng.nextDouble(),
      rng.nextDouble() * 1.8 + 0.4,
      rng.nextDouble(),
    ];
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (final s in _stars) {
      final opacity =
          ((math.sin((animValue * math.pi * 2) + s[3] * math.pi * 2) + 1) / 2) *
              0.6 +
          0.1;
      canvas.drawCircle(
        Offset(s[0] * size.width, s[1] * size.height),
        s[2],
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter old) => old.animValue != animValue;
}
