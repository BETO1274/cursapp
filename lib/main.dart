import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/main_scaffold.dart';
import 'views/my_courses_screen.dart';
import 'views/company_courses_screen.dart';
import 'views/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CursApp());
}

class CursApp extends StatelessWidget {
  const CursApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'CursApp',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),    
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MyCoursesScreen(),
          '/company-courses': (context) {
            final code = Provider.of<UserProvider>(context, listen: false).user.companyCode ?? '';
            return CompanyCoursesScreen(companyCode: code);
          },
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
