import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/current_user_info_widget.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/admin/manager_orders_page.dart';
import 'package:grocery_app/screens/admin/tab_users_page.dart';
import 'package:grocery_app/screens/dashboard/manager_users_page.dart';
import '../tab_pharms_page.dart';

///
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class DashboardDdminPage extends StatelessWidget {
  const DashboardDdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                'DashBoard - Admin',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              CurrentUserInfoWidget(
                title: 'mohamed',
                subtitle: 'moh94syed@g.com',
                imageUrl: 'imageUrl',
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  crossAxisCount: 2,
                  children: <Widget>[
                    _item(
                      'manager Pharm',
                      Icons.grid_view_rounded,
                      onTap: () {
                        Push.to(context, const TabPharmsPage());
                      },
                    ),
                    _item(
                      'manager orders',
                      Icons.home,
                      color: Colors.amber.shade100,
                      onTap: () {
                        Push.to(context, const ManagerOrdersPage());
                      },
                    ),
                    _item(
                      'manger users',
                      Icons.home,
                      color: Colors.purple.shade100,
                      onTap: () {
                        Push.to(context, const TabUsersPage());
                      },
                    ),
                    _item(
                      'logout',
                      Icons.logout,
                      onTap: () async {
                        await _firebaseAuth.signOut();
                        Push.to(context, const AccountPage());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _item(String title, IconData icon,
      {Function()? onTap, Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.green.shade100,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.black.withOpacity(.40),
              child: Icon(
                icon,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
