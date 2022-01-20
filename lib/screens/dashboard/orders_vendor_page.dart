import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/btn.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/rounded_widget.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';

class OrdersVendorPage extends StatefulWidget {
  const OrdersVendorPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersVendorPage> createState() => _OrdersVendorPageState();
}

class _OrdersVendorPageState extends State<OrdersVendorPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getOrders() {
    return db
        .collection("orderCollection")
        .where('account_id', isEqualTo: '663637b7-2373-4c6e-924e-19690828f47d')
        .snapshots();
  }

  String _statusOrder = '';
  fillterByOrderStatus() {}

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: AppText(
          text: "Orders Page",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _statusOrder.isEmpty ? _getOrders() : _getOrdersByStatus(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            final _data = snapshot.data!.docs;
            return Column(
              children: [
                _buttonsFiltterWidget(),
                _headerInfo(_data[0], 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (BuildContext context, int index) {
                      //
                      return CustomContainer(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            //
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // column1
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_data[index]['name']),
                                    const SizedBox(height: 10.0),
                                    Text(_data[index]['email']),
                                    const SizedBox(height: 10.0),
                                    Text(_data[index]['status']),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),

                            //
                            _buttonsFooter(_data[index]),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buttonsFiltterWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Btn(
            onPressed: () {
              setState(() {});
              _statusOrder = '';
            },
            title: 'all',
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey,
          ),
          Btn(
            onPressed: () {
              setState(() {});
              _statusOrder = 'rejected';
            },
            title: 'rejected',
            color: Colors.grey,
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey,
          ),
          Btn(
            onPressed: () {
              setState(() {});
              _statusOrder = 'new';
            },
            title: 'new',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Padding _headerInfo(QueryDocumentSnapshot<Object?> data, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppText(
                text: 'Order.No ${index == 0 ? index + 1 : index}',
                fontSize: 13.0,
                color: Colors.green,
              ),
              AppText(
                text: data.get('email'),
                fontSize: 13.0,
                color: Colors.green,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppText(
                text: 'total \$ 100 R.S',
                fontSize: 13.0,
                color: Colors.green,
              ),
              AppText(
                text: data.get('date_to_cart'),
                fontSize: 13.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonsFooter(QueryDocumentSnapshot<Object?> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _orderStatus(data),
          Btn(
            onPressed: () {
              final Map<String, dynamic> _map = {
                'order_id': data['order_id'],
                'name': data['name'],
                'price': data['price'],
                'date_to_cart': DateTime.now().toString(),
                'status': 'accepted',
                'account_id': data['account_id'],
                'phone': data['phone'],
                'email': data['email'],
              };
              db
                  .collection('orderCollection')
                  .doc(data.id)
                  .update(_map)
                  .then((value) {
                Toast.success();
              }).catchError((onError) {
                Toast.error();
              });
            },
            title: 'accept',
          ),
          Btn(
            color: Colors.red,
            title: 'delete',
            onPressed: () {
              db
                  .collection('orderCollection')
                  .doc(data.id)
                  .delete()
                  .then((value) {
                Toast.success();
              }).catchError((onError) {
                Toast.error();
              });
            },
          ),
          Btn(
            color: Colors.red,
            title: 'reject',
            onPressed: () {
              final Map<String, dynamic> _map = {
                'order_id': data['order_id'],
                'name': data['name'],
                'price': data['price'],
                'date_to_cart': DateTime.now().toString(),
                'status': 'rejected',
                'account_id': data['account_id'],
                'phone': data['phone'],
                'email': data['email'],
              };
              db
                  .collection('orderCollection')
                  .doc(data.id)
                  .set(_map)
                  .then((value) {
                Toast.success();
              }).catchError((onError) {
                Toast.error();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _orderStatus(QueryDocumentSnapshot<Object?> data) {
    Widget child = const SizedBox();
    if (data.get('status') == 'new') {
      child = AppText(
        text: 'new',
        color: Colors.blue,
        fontSize: 15.0,
      );
    }
    if (data.get('status') == 'accepted') {
      child = AppText(
        text: 'accepted',
        color: Colors.green,
        fontSize: 15.0,
      );
    }
    child = AppText(
      text: 'rejected',
      color: Colors.red,
      fontSize: 15.0,
    );
    return RoundedWidget(
      child: child,
      color: Colors.grey,
      width: 60.0,
      height: 40.0,
    );
  }

  Stream<QuerySnapshot> _getOrdersByStatus() {
    return db
        .collection("orderCollection")
        .where('account_id', isEqualTo: '663637b7-2373-4c6e-924e-19690828f47d')
        .where('status', isEqualTo: _statusOrder)
        .snapshots();
  }
}
