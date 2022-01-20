import 'package:flutter/material.dart';
import 'package:grocery_app/screens/account/register_acount_page.dart';
import 'package:grocery_app/screens/dashboard/manager_users_page.dart';

class TabUsersPage extends StatefulWidget {
  const TabUsersPage({Key? key}) : super(key: key);

  @override
  State<TabUsersPage> createState() => _TabUsersPageState();
}

class _TabUsersPageState extends State<TabUsersPage>
    with SingleTickerProviderStateMixin {
  ///
  late TabController _tabController;

  ///
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  ///
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tab Users Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              unselectedLabelColor: Colors.black,
              // labelColor: Colors.red,
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  icon: Text("Add User"),
                ),
                Tab(
                  icon: Text("Delete User"),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // tab 1
                  const RegisterAccountPage(),

                  /// tab 2
                  const ManagerUsersPage()
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
