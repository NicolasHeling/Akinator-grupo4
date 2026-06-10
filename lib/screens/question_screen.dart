import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../controllers/game_controller.dart';
import '../models/question.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});
  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl, _pulseCtrl, _qCtrl;
  late Animation<double> _floatAnim, _pulseAnim, _qFadeAnim;
  late Animation<Offset> _qSlideAnim;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _qCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _floatAnim = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _pulseAnim = Tween<double>(
      begin: 0.92,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _qFadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _qCtrl, curve: Curves.easeOut));
    _qSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _qCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _qCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (ctx, controller, _) {
        if (controller.currentQuestionIndex != _lastIndex &&
            !controller.isGameOver) {
          _lastIndex = controller.currentQuestionIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _qCtrl.reset();
              _qCtrl.forward();
            }
          });
        }
        return Scaffold(
          body: Container(
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
                CustomPaint(
                  painter: _StaticStarsPainter(),
                  size: MediaQuery.of(context).size,
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(context, controller),
                      _buildProgress(controller),
                      Expanded(child: _buildMascot(controller)),
                      _buildButtons(context, controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext ctx, GameController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFAA00FF).withOpacity(0.15),
              border: Border.all(
                color: const Color(0xFFAA00FF).withOpacity(0.3),
              ),
            ),
            child: Text(
              'Pergunta ${ctrl.isGameOver ? ctrl.questions.length : ctrl.currentQuestionIndex + 1}',
              style: const TextStyle(
                color: Color(0xFFCE93D8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgress(GameController ctrl) {
    final total = ctrl.questions.isEmpty ? 1 : ctrl.questions.length;
    final progress =
        (ctrl.isGameOver ? total : ctrl.currentQuestionIndex + 1) / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.08),
          valueColor: const AlwaysStoppedAnimation(Color(0xFFAA00FF)),
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildMascot(GameController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (ctx, child) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (ctx, _) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFAA00FF).withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Image.network(
                  'https://raw.githubusercontent.com/googlefonts/noto-emoji/main/png/512/emoji_u1f9d9_200d_2642_fe0f.png',
                  height: 120,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.psychology,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _qFadeAnim,
            child: SlideTransition(
              position: _qSlideAnim,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFAA00FF).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  !ctrl.isGameOver && ctrl.questions.isNotEmpty
                      ? ctrl.currentQuestion.text
                      : 'Consultando o oráculo...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext ctx, GameController ctrl) {
    final btns = [
      _Btn(
        'Sim',
        AnswerOption.yes,
        const Color(0xFF00C853),
        Icons.check_circle_outline,
      ),
      _Btn(
        'Provavelmente sim',
        AnswerOption.probablyYes,
        const Color(0xFF69F0AE),
        Icons.check,
      ),
      _Btn(
        'Não sei',
        AnswerOption.dontKnow,
        const Color(0xFFFFD740),
        Icons.help_outline,
      ),
      _Btn(
        'Provavelmente não',
        AnswerOption.probablyNo,
        const Color(0xFFFF6D00),
        Icons.close,
      ),
      _Btn(
        'Não',
        AnswerOption.no,
        const Color(0xFFFF1744),
        Icons.cancel_outlined,
      ),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: const Color(0xFFAA00FF).withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: btns
            .map(
              (b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      ctrl.answerCurrentQuestion(b.opt);
                      if (ctrl.isGameOver)
                        Navigator.pushReplacement(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => const ResultScreen(),
                          ),
                        );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: b.color.withOpacity(0.1),
                        border: Border.all(color: b.color.withOpacity(0.35)),
                      ),
                      child: Row(
                        children: [
                          Icon(b.icon, color: b.color, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            b.label,
                            style: TextStyle(
                              color: b.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Btn {
  final String label;
  final AnswerOption opt;
  final Color color;
  final IconData icon;
  _Btn(this.label, this.opt, this.color, this.icon);
}

class _StaticStarsPainter extends CustomPainter {
  static final _stars = List.generate(45, (i) {
    final rng = math.Random(i * 13 + 7);
    return [
      rng.nextDouble(),
      rng.nextDouble(),
      rng.nextDouble() * 1.4 + 0.4,
      rng.nextDouble() * 0.5 + 0.2,
    ];
  });
  @override
  void paint(Canvas c, Size s) {
    for (var st in _stars) {
      c.drawCircle(
        Offset(st[0] * s.width, st[1] * s.height),
        st[2],
        Paint()..color = Colors.white.withOpacity(st[3]),
      );
    }
  }

  @override
  bool shouldRepaint(_StaticStarsPainter old) => false;
}
