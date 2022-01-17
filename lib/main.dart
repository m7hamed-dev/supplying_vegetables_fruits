import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'screens/product_details/add_products_page.dart';
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      // home: AddProductsPage(),
      // home: AddCategoryPage(),
      // home: ProductsPage(productID: 'JtgFjmprdjTRoz9K5Fex'),
      home: DashboardScreen(),
    );
  }
}
