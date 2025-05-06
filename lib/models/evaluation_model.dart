class EvaluationModel {
  final String id;
  final String title;
  final double percentage;
  final double score;

  EvaluationModel({
    required this.id,
    required this.title,
    required this.percentage,
    this.score = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'percentage': percentage,
      'score': score,
    };
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: map['id'],
      title: map['title'],
      percentage: map['percentage'],
      score: map['score'] ?? 0.0,
    );
  }
}
