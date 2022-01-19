import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/empty_widget.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/rounded_widget.dart';
import 'package:grocery_app/screens/cart/cart_provider.dart';
import 'package:provider/src/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getCartProducts() {
    return db.collection("cartCollection").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: AppText(
          text: "Cart Page",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      //
      body: _cartProvider.cartModels.isEmpty
          ? EmptyWidget(data: 'no products on your cart !!')
          : ListView.separated(
              itemCount: _cartProvider.cartModels.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.shade100,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // img , name , remove product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // img
                          ImgNetwork(
                            imageUrl: _cartProvider.cartModels[index].imgPath,
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name , remove product
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: _cartProvider.cartModels[index].name,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 100.0),
                                ],
                              ),
                              // description
                              AppText(
                                text: _hundleString(_cartProvider
                                    .cartModels[index].description),
                                fontSize: 11,
                              ),
                              // price , increment and decrement qty
                              Row(
                                children: [
                                  AppText(
                                    text:
                                        '${_cartProvider.cartModels[index].qty}',
                                    fontSize: 22.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  //
                                  const SizedBox(width: 100.0),
                                  // add qty
                                  InkWell(
                                    onTap: () {
                                      _cartProvider.addQty(
                                          _cartProvider.cartModels[index]);
                                    },
                                    child: Icon(
                                      Icons.add_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  //  price
                                  AppText(
                                    text: _cartProvider.cartModels[index].price,
                                    fontSize: 22.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 10.0),
                                  // remove qty
                                  InkWell(
                                    onTap: () {
                                      _cartProvider.removeQty(
                                          _cartProvider.cartModels[index]);
                                    },
                                    child: Icon(
                                      Icons.exposure_minus_1_sharp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Positioned(
                        top: -25,
                        right: 10.0,
                        child: InkWell(
                          onTap: () {
                            _cartProvider.removeProtductFromCart(
                                _cartProvider.cartModels[index]);
                          },
                          child: RoundedWidget(
                            height: 40,
                            width: 40,
                            color: Colors.white,
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      // single price
                      Positioned(
                        bottom: -10.0,
                        left: 0.0,
                        right: 0.0,
                        child: Center(
                          child: Text(
                            'single Price = ${_cartProvider.singlePrice}',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(thickness: 10.0),
            ),
      bottomNavigationBar: Container(
        height: 60.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Text('total Price = ${_cartProvider.totalPrice}'),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  String removeTrailing(String pattern, String from) {
    int i = from.length;
    while (from.startsWith(pattern, i - pattern.length)) i -= pattern.length;
    return from.substring(0, i);
  }

  String _hundleString(String data) {
    String _newValue = '';
    if (data.length >= 10) {
      for (var i = 0; i < data.length; i++) {
        if (i < 50) {
          _newValue += data[i];
          debugPrint('_newValue = $_newValue');
        }
      }
      debugPrint('_newValue = $_newValue');
      return _newValue + ' ...';
    } else {
      return _newValue;
    }
  }
}
