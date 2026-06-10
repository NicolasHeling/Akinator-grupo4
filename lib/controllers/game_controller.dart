import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/professor.dart';
import '../models/question.dart';

class GameController extends ChangeNotifier {
  int currentQuestionIndex = 0;
  bool isGameOver = false;

  List<Professor> allProfessors = [];
  List<Professor> activeProfessors =
      []; // Professores que ainda são possibilidades
  List<Question> remainingQuestions = []; // Perguntas na fila

  // Lista original mantida intacta para controle da barra de progresso na UI
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
    remainingQuestions = List.from(questions);
    remainingQuestions.shuffle();
    _loadProfessorsFromJson();
  }

  Future<void> _loadProfessorsFromJson() async {
    final response = await rootBundle.loadString(
      'assets/data/professores.json',
    );
    allProfessors = (json.decode(response) as List)
        .map((j) => Professor.fromJson(j))
        .toList();
    activeProfessors = List.from(allProfessors);
    notifyListeners();
  }

  Question get currentQuestion => remainingQuestions.isNotEmpty
      ? remainingQuestions.first
      : questions.first;

  Professor get guessedProfessor {
    // Se a lista esvaziar (por respostas contraditórias do usuário), usa a lista geral como backup
    List<Professor> sourceList = activeProfessors.isNotEmpty
        ? activeProfessors
        : allProfessors;

    final sorted = List<Professor>.from(sourceList)
      ..sort((a, b) => b.currentScore.compareTo(a.currentScore));
    return sorted.first;
  }

  void answerCurrentQuestion(AnswerOption answer) {
    // Restabelecido o tipo forte AnswerOption
    double answerValue = answer.value.toDouble();
    int currentQId = currentQuestion.id;

    // 1. Atualiza os pontos de quem ainda está no jogo (lista filtrada)
    for (var p in activeProfessors) {
      double traitVal =
          (p.traits[currentQId.toString()] ?? p.traits[currentQId] ?? 0.0)
              .toDouble();
      p.currentScore += traitVal * answerValue;
    }

    // Atualiza também o backup em caso de contradições no final
    for (var p in allProfessors) {
      if (!activeProfessors.contains(p)) {
        double traitVal =
            (p.traits[currentQId.toString()] ?? p.traits[currentQId] ?? 0.0)
                .toDouble();
        p.currentScore += traitVal * answerValue;
      }
    }

    // 2. Filtra os professores eliminados moldando o caminho (Árvore de Decisão)
    if (answerValue >= 0.8) {
      // Resposta "Sim" ou "Provavelmente sim"
      activeProfessors.removeWhere(
        (p) =>
            (p.traits[currentQId.toString()] ?? p.traits[currentQId] ?? 0.0) ==
            -1.0,
      );
    } else if (answerValue <= -0.8) {
      // Resposta "Não" ou "Provavelmente não"
      activeProfessors.removeWhere(
        (p) =>
            (p.traits[currentQId.toString()] ?? p.traits[currentQId] ?? 0.0) ==
            1.0,
      );
    }

    // 3. Remove a pergunta atual da fila
    if (remainingQuestions.isNotEmpty) {
      remainingQuestions.removeAt(0);
    }
    currentQuestionIndex++;

    // 4. Limpeza inteligente de perguntas irrelevantes
    if (activeProfessors.isNotEmpty) {
      remainingQuestions.removeWhere((q) {
        double firstTrait =
            (activeProfessors.first.traits[q.id.toString()] ??
                    activeProfessors.first.traits[q.id] ??
                    0.0)
                .toDouble();
        bool allSame = activeProfessors.every(
          (p) =>
              (p.traits[q.id.toString()] ?? p.traits[q.id] ?? 0.0).toDouble() ==
              firstTrait,
        );
        return allSame;
      });
    }

    // 5. Verifica as condições de fim de jogo
    if (activeProfessors.length <= 1 || remainingQuestions.isEmpty) {
      isGameOver = true;
    }

    notifyListeners();
  }

  void resetGame() {
    currentQuestionIndex = 0;
    isGameOver = false;

    // Zera pontuações
    for (var p in allProfessors) {
      p.currentScore = 0.0;
    }

    // Reinicia o grupo e recalcula as perguntas
    activeProfessors = List.from(allProfessors);
    remainingQuestions = List.from(questions);
    remainingQuestions.shuffle();

    notifyListeners();
  }
}
