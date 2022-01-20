import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';
import 'package:grocery_app/common_widgets/empty_widget.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/common_widgets/input.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/screens/cart/cart_provider.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:provider/src/provider.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getProducts(String? value) {
    if (value != null) {
      return db
          .collection("productsCollection")
          .where('product_name', isEqualTo: value)
          .snapshots();
    }
    // when you need to showing all products without filltering
    return db.collection("productsCollection").snapshots();
  }

  String _value = '';
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: Center(
          child: AppText(
            text: "Find Products",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Push.to(context, const CartPage()),
              child: Container(
                padding: EdgeInsets.only(left: 25),
                child: Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            //
            Input(
              onChanged: (val) {
                _value = val;
                setState(() {});
              },
            ),
            //
            StreamBuilder<QuerySnapshot>(
              stream: _getProducts(_value),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }
                final _data = snapshot.data!.docs;
                //
                if (_value.isEmpty) {
                  return EmptyWidget();
                }
                return ListView.separated(
                  itemCount: _data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomContainer(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        title: AppText(
                          text: _data[index]['product_name'],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: _data[index]['product_price'] + ' \R.S',
                              fontSize: 18,
                              color: Colors.green,
                            ),
                            AppText(
                              text:
                                  _data[index]['product_description'] + ' \R.S',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        leading: ImgNetwork(
                          imageUrl: _data[index]['img_path'],
                        ),
                        trailing: MaterialButton(
                          color: Colors.green,
                          onPressed: () {
                            final _cartProvider = context.read<CartProvider>();
                            _cartProvider.addProtductToCart(_data[index]);
                          },
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade200,
                    thickness: 4.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Padding _headerRow() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(widget.categoryID ?? ''),
  //         InkWell(
  //           onTap: () {
  //             widget.categoryID = null;
  //             setState(() {});
  //           },
  //           child: RoundedWidget(
  //             child: Text('Browse ALL '),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
