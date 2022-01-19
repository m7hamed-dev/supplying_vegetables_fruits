import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({Key? key}) : super(key: key);

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage>
    with SingleTickerProviderStateMixin {
  ///
  late TabController _tabController;
  //
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      chnageOrderType(_tabController.index);
      _getOrders();
      // debugPrint('_tabController = ${_tabController.index}');
    });
  }

  void chnageOrderType(int index) {
    switch (index) {
      case 0:
        _orderType = 'all';
        setState(() {});
        break;
      case 1:
        _orderType = 'history';
        setState(() {});
        break;
      case 2:
        _orderType = 'new';
        setState(() {});
        break;
    }
  }

  //
  final db = FirebaseFirestore.instance;
  String _orderType = 'all';
  //  Future<QuerySnapshot>
  //Stream<Map<String, dynamic>>
  Stream<QuerySnapshot<Map<String, dynamic>>> _getOrders() {
    ///$_orderType
    final _streamRes = db.collection('orderCollection').snapshots();
    return _streamRes;
    //     .where((event) {
    //   // debugPrint('event.get(status) = ${event.get('status')}');
    //   // get('status')
    //   if (event.id == '550d9624-a2f2-4662-b2eb-6400542a813f') {
    //     return true;
    //   }
    //   return false;
    // });

    // return _streamRes.map((event) {
    //   return event.data()!;
    // });
  }

  // Map<String, dynamic> _map = Map<String, dynamic>();

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
              onTap: chnageOrderType,
              labelColor: Colors.red,
              tabs: [
                Tab(
                  icon: Text('All Orders'),
                ),
                Tab(
                  icon: Text('History Orders'),
                ),
                Tab(
                  icon: Text('New Orders'),
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

  Widget _body = const SizedBox();

  ///
  Widget _orderProducts() {
    // return StreamBuilder<Map<dynamic, dynamic>>(
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getOrders(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        // snapshot.data!.map((key, value) {
        //   debugPrint('value $value');
        //   return value;
        // });
        final _data = snapshot.data!;
        //
        for (var item in _data.docs) {
          if (item.get('status') == 'history') {
            _body = ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(item.get('name'));
              },
            );
          }
          if (item.get('status') == 'all') {
            _body = ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(item.get('name'));
              },
            );
          }
          if (item.get('status') == 'pending') {
            _body = ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(item.get('name'));
              },
            );
          }
        }
        return _body;
      },
    );
  }

  ListTile _item(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  //
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
              Text('date order .'),
              Text('${DateTime.now()}'),
            ],
          ),
          _orderProducts(),
        ],
      ),
    );
  }
}
