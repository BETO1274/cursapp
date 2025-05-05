import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createProfile(UserModel user) {
    return _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateProfile(UserModel user) {
    return _db.collection('users').doc(user.uid).update(user.toMap());
  }
}
