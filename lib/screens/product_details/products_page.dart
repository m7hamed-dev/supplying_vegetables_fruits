import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/common_widgets/rounded_widget.dart';
import 'package:grocery_app/random_id.dart';
import 'package:grocery_app/screens/cart/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/src/provider.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({
    Key? key,
    this.isShowScaffold,
    this.categoryID,
  }) : super(key: key);
  final bool? isShowScaffold;
  String? categoryID;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getProducts() {
    if (widget.categoryID != null) {
      return db
          .collection("productsCollection")
          .where('cat_id', isEqualTo: widget.categoryID)
          .snapshots();
    }
    // when you need to showing all products without filltering
    return db.collection("productsCollection").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = context.read<CartProvider>();

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
          text: "Products Page",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: ListView(
        children: [
          _headerRow(),
          const SizedBox(height: 10.0),
          Divider(
            color: Colors.grey.shade200,
            thickness: 4.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _getProducts(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              }
              final _data = snapshot.data!.docs;
              //
              return ListView.separated(
                itemCount: _data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
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
                          text: _data[index]['product_description'] + ' \R.S',
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
                        _cartProvider.addProtductToCart(_data[index]);
                        return;
                        Map<String, dynamic> _map = {
                          'id': randomId,
                          'name': _data[index]['product_name'],
                          'img_path': _data[index]['img_path'],
                          // when add product to cart init qty equal one
                          'qty': '1',
                          'date_to_cart': '${DateTime.now()}',
                        };
                        db
                            .collection('cartCollection')
                            .doc(randomId)
                            .set(_map)
                            .then((value) {})
                            .whenComplete(() {})
                            .catchError((onError) {
                          debugPrint('onError = $onError');
                        });
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
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
    );
  }

  Padding _headerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.categoryID ?? ''),
          InkWell(
            onTap: () {
              widget.categoryID = null;
              setState(() {});
            },
            child: RoundedWidget(
              child: Text('Browse ALL '),
            ),
          )
        ],
      ),
    );
  }
}
