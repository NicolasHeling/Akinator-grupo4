import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/professor.dart';
import '../models/question.dart';

class GameController extends ChangeNotifier {
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  List<Professor> professors = [];

  final List<Question> questions = [
    Question(id: 1, text: "O(a) professor(a) é do gênero feminino?"),
    Question(id: 2, text: "O(a) professor(a) usa óculos habitualmente?"),
    Question(id: 3, text: "O(a) professor(a) tem barba?"),
    Question(
      id: 4,
      text:
          "O(a) professor(a) escreve bastante no quadro durante as explicações?",
    ),
    Question(
      id: 5,
      text: "O(a) professor(a) dá ou já deu aulas no laboratório?",
    ),
    Question(
      id: 6,
      text:
          "O(a) professor(a) costuma utilizar slides com frequência nas explicações?",
    ),
    Question(
      id: 7,
      text:
          "O(a) professor(a) cobra a entrega dos trabalhos utilizando repositórios no GitHub?",
    ),
    Question(
      id: 8,
      text:
          "O(a) professor(a) ministra disciplinas cujo foco principal é o desenvolvimento de software (criação de código)?",
    ),
    Question(
      id: 9,
      text:
          "O(a) professor(a) ensina a parte visual da tecnologia (Interfaces Gráficas, Sites ou Mobile)?",
    ),
    Question(
      id: 10,
      text:
          "O(a) professor(a) ensina o armazenamento, modelagem e manipulação de informações (Banco de Dados / Persistência)?",
    ),
    Question(
      id: 11,
      text:
          "O(a) professor(a) atua na área física ou de base da TI (Hardware, Manutenção ou Redes)?",
    ),
    Question(
      id: 12,
      text:
          "O(a) professor(a) foca em metodologias e processos (Engenharia de Requisitos, Projetos Ágeis, Orientação a Objetos ou Projeto Integrador)?",
    ),
    Question(
      id: 13,
      text:
          "O(a) professor(a) aborda o ciclo de vida e a qualidade do software (Testes, Evolução ou Versionamento/Git)?",
    ),
    Question(
      id: 14,
      text:
          "O(a) professor(a) costuma cobrar a documentação de projetos com diagramas (casos de uso, classes ou entidade-relacionamento)?",
    ),
    Question(
      id: 15,
      text:
          "O(a) professor(a) é responsável por disciplinas flexíveis ou mais teóricas (Tecnologias Emergentes ou Eletiva)?",
    ),
    Question(
      id: 16,
      text:
          "O(a) professor(a) tem o costume de fazer demonstrações práticas programando ao vivo ('live coding') em aula?",
    ),
  ];

  GameController() {
    _loadProfessorsFromJson();
    questions.shuffle();
  }

  Future<void> _loadProfessorsFromJson() async {
    final response = await rootBundle.loadString(
      'assets/data/professores.json',
    );
    professors = (json.decode(response) as List)
        .map((j) => Professor.fromJson(j))
        .toList();
    notifyListeners();
  }

  Question get currentQuestion => questions[currentQuestionIndex];

  Professor get guessedProfessor {
    final sorted = List<Professor>.from(professors)
      ..sort((a, b) => b.currentScore.compareTo(a.currentScore));
    return sorted.first;
  }

  void answerCurrentQuestion(AnswerOption answer) {
    for (var p in professors) {
      p.currentScore += (p.traits[currentQuestion.id] ?? 0.0) * answer.value;
    }
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
    } else {
      isGameOver = true;
    }
    notifyListeners();
  }

  void resetGame() {
    currentQuestionIndex = 0;
    isGameOver = false;
    for (var p in professors) p.currentScore = 0.0;
    questions.shuffle();
    notifyListeners();
  }
}
