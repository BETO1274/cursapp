import 'package:flutter/material.dart';
import '../models/user.model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(uid: '', email: '');

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = UserModel(uid: '', email: '');
    notifyListeners();
  }
}
