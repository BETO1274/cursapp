class UnitModel {
  final String id;
  final String name;
  final String description;
  final List<String> pdfUrls;

  UnitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pdfUrls,
  });

  factory UnitModel.fromMap(String id, Map<String, dynamic> data) {
    return UnitModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      pdfUrls: List<String>.from(data['pdfUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'pdfUrls': pdfUrls,
    };
  }
}
