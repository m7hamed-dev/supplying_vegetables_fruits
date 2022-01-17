import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/admin/add_pharm_page.dart';
import 'screens/admin/sellers_page.dart';
import 'screens/invoice/invoice_page.dart';
import 'screens/product_details/add_products_page.dart';
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
      // home: AddProductsPage(),
      // home: AddCategoryPage(),
      // home: ProductsPage(productID: 'JtgFjmprdjTRoz9K5Fex'),
      // home: DashboardScreen(),
      // home: SellersPage(),
      home: _firebaseAuth.currentUser != null
          ? DashboardScreen()
          : SignInAndSignUpPage(),
    );
  }
}
