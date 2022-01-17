import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/random_id.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({Key? key}) : super(key: key);

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  final db = FirebaseFirestore.instance;

  ///
  Map<String, dynamic> _map = Map<String, dynamic>();
  bool _isLoading = false;
  //
  final _tabs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              alignment: Alignment.center,
              child: Center(
                child: Text('Sellers'),
              ),
              color: Colors.blue,
            ),
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              tabs: [
                Tab(
                  icon: Text('Orders'),
                ),
                Tab(
                  icon: Text('Orders'),
                ),
                Tab(
                  icon: Text('Orders'),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // tab 2
                  Container(
                    color: Colors.red.shade100,
                    child: _orderDetails(),
                  ),
                  // tab 2
                  Container(color: Colors.green.shade100),
                  // tab 2
                  Container(color: Colors.amber.shade100)
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

Widget _orderDetails() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('no'),
            Text('no'),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('total .'),
            Text('5000'),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('date .'),
            Text('${DateTime.now()}'),
          ],
        ),
      ],
    ),
  );
}
