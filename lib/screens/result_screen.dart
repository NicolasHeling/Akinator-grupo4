import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context, listen: false);
    final guessedName = controller.guessedProfessor.name;

    return Scaffold(
      backgroundColor: const Color(0xFF1E0040),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0015), Color(0xFF1E0040)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_fix_high,
                size: 80,
                color: Color(0xFFEA80FC),
              ),
              const SizedBox(height: 20),
              const Text(
                'O Oráculo diz que é...',
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFAA00FF).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  guessedName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Eu acertei?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeedbackButton(
                    context,
                    'Sim!',
                    const Color(0xFF00C853),
                    true,
                  ),
                  const SizedBox(width: 20),
                  _buildFeedbackButton(
                    context,
                    'Não',
                    const Color(0xFFFF1744),
                    false,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              TextButton.icon(
                onPressed: () {
                  controller.resetGame();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.refresh, color: Color(0xFFEA80FC)),
                label: const Text(
                  'Jogar Novamente',
                  style: TextStyle(color: Color(0xFFEA80FC), fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(
    BuildContext context,
    String text,
    Color color,
    bool correct,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color),
        ),
        elevation: 0,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              correct
                  ? 'A mágica nunca falha! 🔮'
                  : 'Preciso calibrar minha bola de cristal... 🔮',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
