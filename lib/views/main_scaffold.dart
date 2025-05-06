import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';
import 'my_courses_screen.dart';
import 'company_courses_screen.dart';
import 'profile_screen.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final FloatingActionButton? floatingActionButton;

  const MainScaffold({
    Key? key,
    required this.child,
    this.currentIndex = 0,
    this.floatingActionButton,
  }) : super(key: key);

  void _onTap(BuildContext context, int idx) {
    final code = Provider.of<UserProvider>(context, listen: false).user.companyCode ?? '';
    switch (idx) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyCoursesScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => CompanyCoursesScreen(companyCode: code)));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CursApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Mis cursos'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Disponibles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
