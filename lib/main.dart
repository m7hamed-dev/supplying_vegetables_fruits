import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin/add_pharm_page.dart';
import 'package:grocery_app/screens/admin/dashboard_admin_page/dashboard_admin_page.dart';
import 'package:grocery_app/screens/admin/manager_orders_page.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/dashboard/manager_users_page.dart';
import 'package:grocery_app/screens/invoice/invoice_page.dart';
import 'package:grocery_app/screens/product_details/add_products_page.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'screens/account/register_acount_page.dart';
import 'screens/admin/manager_pharm_page.dart';
import 'screens/admin/tab_pharms_page.dart';
import 'screens/admin/tab_users_page.dart';
import 'screens/admin/tabs_manager_orders.dart';
import 'screens/cart/cart_provider.dart';
import 'screens/dashboard/orders_vendor_page.dart';
import 'screens/payment_page.dart';
import 'screens/splash_screen.dart';
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.initalizationSharedPrefs();
  String _role = LocalStorage.getRolePrfs();
  // entry point
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider())
      ],
      child: MyApp(role: _role),
    ),
  );
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  final String role;
  MyApp({required this.role});
  @override
  Widget build(BuildContext context) {
    //
    return MaterialApp(
      theme: themeData,
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      // home: _firebaseAuth.currentUser == null
      //     ? RegisterAccountPage()
      //     : role == 'user'
      //         ? DashboardScreen()
      //         : DashboardDdminPage(),
      builder: EasyLoading.init(),
    );
  }
}
