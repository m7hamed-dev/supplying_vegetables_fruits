import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/empty_widget.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: _cartProvider.cartItems.isEmpty
          ? EmptyWidget(data: 'no products on your cart !!')
          : ListView.separated(
              itemCount: _cartProvider.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: AppText(
                    text: _cartProvider.cartItems[index]['product_name'],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppText(
                      //   text: _cartProvider.cartItems[index]['qty'] + ' \R.S',
                      //   fontSize: 18,
                      //   color: Colors.green,
                      // ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                          ),
                          AppText(
                            text: _cartProvider.cartItems[index]['qty']
                                .toString(),
                            fontSize: 18,
                            color: Colors.green,
                          ),
                          IconButton(
                            onPressed: () {
                              _cartProvider
                                  .addQty(_cartProvider.cartItems[index]);
                              // int i = _cartProvider.cartItems[index]['qty'];
                              // i = i + 1;
                              // setState(() {});
                              // debugPrint('i = $i');
                            },
                            icon: Icon(Icons.minimize_outlined),
                          ),
                        ],
                      ),
                      // AppText(
                      //   text:  _cartProvider.cartItems[index]['product_description'] + ' \R.S',
                      //   fontSize: 14,
                      //   color: Colors.grey,
                      // ),
                    ],
                  ),
                  leading: ImgNetwork(
                    imageUrl: _cartProvider.cartItems[index]['img_path'],
                  ),
                  trailing: IconButton(
                    color: Colors.green,
                    onPressed: () {
                      _cartProvider.removeProtductFromCart(
                          _cartProvider.cartItems[index]);
                    },
                    icon: const Icon(
                      Icons.remove_circle_sharp,
                      color: Colors.red,
                    ),
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
            Text('totalPrice = ${_cartProvider.totalPrice}'),
          ],
        ),
      ),
    );
  }
}
