class UnitModel {
  final String id;
  final String courseId;
  final String title;
  final String pdfUrl;

  UnitModel({required this.id, required this.courseId, required this.title, required this.pdfUrl});

  Map<String, dynamic> toMap() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'pdfUrl': pdfUrl,
  };

  static UnitModel fromMap(Map<String, dynamic> map) => UnitModel(
    id: map['id'],
    courseId: map['courseId'],
    title: map['title'],
    pdfUrl: map['pdfUrl'],
  );
}
