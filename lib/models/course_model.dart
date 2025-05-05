class CourseModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String companyCode;
  final String creatorId;
  final List<String> enrolledUserIds;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.companyCode,
    required this.creatorId,
    this.enrolledUserIds = const [],
  });

CourseModel copyWith({
  String? id,
  String? title,
  String? description,
  String? imageUrl,
  String? companyCode,
  String? creatorId,
  List<String>? enrolledUserIds,
}) {
  return CourseModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    companyCode: companyCode ?? this.companyCode,
    creatorId: creatorId ?? this.creatorId,
    enrolledUserIds: enrolledUserIds ?? this.enrolledUserIds,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'companyCode': companyCode,
      'creatorId': creatorId,
      'enrolledUserIds': enrolledUserIds,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      companyCode: map['companyCode'] ?? '',
      creatorId: map['creatorId'] ?? '',
      enrolledUserIds: List<String>.from(map['enrolledUserIds'] ?? []),
    );
  }
}
