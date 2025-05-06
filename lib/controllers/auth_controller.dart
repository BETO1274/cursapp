import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.model.dart';
import '../services/firebase_auth_service.dart';
import '../services/user_service.dart';

class AuthController {
  final _auth = FirebaseAuthService();
  final _users = UserService();

  Future<UserModel?> signIn(String email, String password) async {
    User? u = await _auth.login(email, password);
    if (u == null) return null;
    UserModel profile = await _users.getProfile(u.uid);
    return profile;
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required String position,
    required String companyCode,
  }) async {
    User? u = await _auth.register(email, password);
    if (u == null) return null;
    UserModel profile = UserModel(
      uid: u.uid,
      email: email,
      name: name,
      position: position,
      companyCode: companyCode,
    );
    await _users.createProfile(profile);
    return profile;
  }

  Future<void> logout(BuildContext context) async {
    await _auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
