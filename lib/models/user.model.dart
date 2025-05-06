class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? position;
  final String? companyCode;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.position,
    this.companyCode,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? position,
    String? companyCode,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      position: position ?? this.position,
      companyCode: companyCode ?? this.companyCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'position': position,
      'companyCode': companyCode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      position: map['position'],
      companyCode: map['companyCode'],
    );
  }
}
