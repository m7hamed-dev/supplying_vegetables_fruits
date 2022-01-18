import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/dashboard/manager_users_page.dart';

///
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class DashboardDdminPage extends StatelessWidget {
  const DashboardDdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Control - Panle'),
            _item('title', Icons.home),
            Divider(height: 20),
            _item('manager orders', Icons.home),
            Divider(height: 20),
            _item(
              'manger users',
              Icons.home,
              onTap: () {
                Push.to(context, const ManagerUsersPage());
              },
            ),
            const Spacer(),
            _item(
              'logout',
              Icons.logout,
              onTap: () async {
                await _firebaseAuth.signOut();
                Push.to(context, const SignInAndSignUpPage());
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  ListTile _item(String title, IconData icon, {Function()? onTap}) {
    return ListTile(
      onTap: onTap ?? () {},
      title: Text(title),
      leading: Icon(icon),
    );
  }
}
