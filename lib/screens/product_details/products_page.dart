import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.isShowScaffold,
    this.productID,
  }) : super(key: key);
  final bool? isShowScaffold;
  final String? productID;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getProducts() {
    debugPrint('widget.productID = ${widget.productID}');
    if (widget.productID == null) {
      return db.collection("productsCollection").snapshots();
    }

    return db.collection("productsCollection").snapshots().where((event) {
      if (event.docs.length > 0) {
        return true;
      }
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isShowScaffold == true) {
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getProducts(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              }
              final _data = snapshot.data!.docs;
              return ListView(
                children: _data.asMap().entries.map<Widget>((e) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImgNetwork(imageUrl: e.value['img_path']),
                          SizedBox(
                            height: 20,
                          ),
                          AppText(
                            text: e.value['product_name'],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          AppText(
                            text: e.value['product_name'],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C7C7C),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Row(
                          //   children: [
                          //     AppText(
                          //       text: "\$${item!.price!.toStringAsFixed(2)}",
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //     Spacer(),
                          //     // addWidget()
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      );
    }

    return Container(
      height: 100,
      color: Colors.red.shade100,
      child: StreamBuilder<QuerySnapshot>(
        stream: _getProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoadingWidget();
          final _data = snapshot.data!.docs;
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _data.map((e) {
              // return Text(e['product_id']);
              return Container(
                height: 140.0,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Image.network(
                      e['img_path'],
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: e['product_name'],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        AppText(
                          text: e['product_price'],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        AppText(
                          text: e['product_price'],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // InkWell(
                    //   onTap: () {},
                    //   child: AppText(
                    //     text: 'Add To Cart',
                    //     fontSize: 12.0,
                    //   ),
                    // ),
                  ],
                ),
              );
            }).toList(),
          );
        },
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
