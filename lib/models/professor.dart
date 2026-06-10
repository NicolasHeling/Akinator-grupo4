class Professor {
  final String name;
  final Map<int, double> traits;
  double currentScore;

  Professor({
    required this.name,
    required this.traits,
    this.currentScore = 0.0,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    Map<int, double> parsedTraits = {};
    (json['traits'] as Map<String, dynamic>).forEach((k, v) {
      parsedTraits[int.parse(k)] = (v as num).toDouble();
    });
    return Professor(name: json['name'], traits: parsedTraits);
  }
}
