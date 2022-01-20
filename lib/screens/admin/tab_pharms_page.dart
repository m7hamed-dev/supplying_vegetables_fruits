import 'package:flutter/material.dart';
import 'package:grocery_app/screens/admin/add_pharm_page.dart';
import 'package:grocery_app/screens/admin/manager_pharm_page.dart';

class TabPharmsPage extends StatefulWidget {
  const TabPharmsPage({Key? key}) : super(key: key);

  @override
  State<TabPharmsPage> createState() => _TabPharmsPageState();
}

class _TabPharmsPageState extends State<TabPharmsPage>
    with SingleTickerProviderStateMixin {
  ///
  late TabController _tabController;

  ///
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
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
                  icon: Text("Add Pharm"),
                ),
                Tab(
                  icon: Text("Manage Pharm"),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // tab 1
                  const AddPharmPage(),
                  // tab 2
                  const ManagerPhramPage()
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
