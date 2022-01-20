import 'package:flutter/material.dart';
import 'package:grocery_app/screens/admin/add_pharm_page.dart';
import 'package:grocery_app/screens/admin/manager_pharm_page.dart';

import 'manager_orders_page.dart';

class TabManagerOrdersPage extends StatefulWidget {
  const TabManagerOrdersPage({Key? key}) : super(key: key);

  @override
  State<TabManagerOrdersPage> createState() => _TabManagerOrdersPageState();
}

class _TabManagerOrdersPageState extends State<TabManagerOrdersPage>
    with SingleTickerProviderStateMixin {
  ///
  late TabController _tabController;

  ///
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tab Pharms Page",
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
                  icon: Text("all"),
                ),
                Tab(
                  icon: Text("new"),
                ),
                Tab(
                  icon: Text("history"),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // tab 1
                  const ManagerOrdersPage(),
                  // tab 2
                  const ManagerOrdersPage(), // tab 2
                  const ManagerOrdersPage()
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
