import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/home_screen.dart';
import 'models/user.model.dart';

class AppRoutes {
  static const String login    = '/login';
  static const String register = '/register';
  static const String home     = '/home';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.register: (context) => const RegisterScreen(),
  AppRoutes.home: (context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return HomeScreen(user: user);
  },
};
