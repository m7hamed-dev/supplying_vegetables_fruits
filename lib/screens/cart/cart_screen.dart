import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/random_id.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getProductsCart() {
    return db.collection("cartCollection").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getProductsCart();
  }

  int qty = 1;
  List<QueryDocumentSnapshot<Object?>> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
          text: "Cart Page",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProductsCart(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingWidget();
                  }

                  final _data = snapshot.data!.docs;
                  _list = _data;
                  debugPrint('_list = ${_list.length}');
                  if (_list.isEmpty) {
                    return Center(child: Text('no product on your cart !!'));
                  }
                  return ListView(
                    children: _list.asMap().entries.map<Widget>((e) {
                      return Stack(
                        children: [
                          // content cart
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImgNetwork(
                                    imageUrl: e.value['img_path'],
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: e.value['name'],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      AppText(
                                        text: e.value['qty'],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF7C7C7C),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            color: Colors.green,
                                            onPressed: () {
                                              if (qty > 0) {
                                                qty = int.parse(e.value['qty']);
                                                qty++;
                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(Icons.minimize),
                                          ),
                                          Text(
                                            '$qty',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          IconButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                qty++;
                                                setState(() {});
                                              },
                                              icon: Icon(Icons.add)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10.0,
                            child: IconButton(
                              color: Colors.green,
                              onPressed: () {
                                _list.remove(0);
                              },
                              icon: Icon(
                                Icons.remove_circle_outline_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                // _isLoading = true;
                // setState(() {});
                // Navigator.of(context).pop();

                for (var item in _list) {
                  Map<String, dynamic> _map = {
                    'id': randomId,
                    'name': item.get('name'),
                    'img_path': item.get('img_path'),
                    'qty': item.get('qty'),
                    'date_to_cart': '${DateTime.now()}',
                  };
                  db
                      .collection('orderCollection')
                      .doc(randomId)
                      .set(_map)
                      .then((value) {
                    // setState(() {});
                  }).whenComplete(() {
                    // setState(() {});
                  }).catchError((onError) {
                    debugPrint('onError = $onError');
                  });
                }
              },
              child: Text(
                'finish order',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          groceryItem,
        ),
      ),
    );
  }
}
