import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/admin/dashboard_admin_page/dashboard_admin_page.dart';
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.initalizationSharedPrefs();
  String _role = LocalStorage.getRolePrfs();
  debugPrint('role = $_role');
  runApp(MyApp(role: _role));
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  final String role;
  MyApp({required this.role});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: _firebaseAuth.currentUser == null
          ? AccountPage()
          : role == 'user'
              ? DashboardScreen()
              : DashboardDdminPage(),
    );
  }
}
