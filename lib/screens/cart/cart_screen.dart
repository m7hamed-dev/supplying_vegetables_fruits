import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
    this.isShowScaffold,
    this.productID,
  }) : super(key: key);
  final bool? isShowScaffold;
  final String? productID;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getProducts() {
    // if (widget.productID != null) {
    return db
        .collection("productsCollection")
        // .where('id', isEqualTo: widget.productID ?? 'JtgFjmprdjTRoz9K5Fex')
        // .where('id', isEqualTo: widget.productID ?? 'JtgFjmprdjTRoz9K5Fex')
        .snapshots();
    // await db
    //     .collection("productsCollection")
    //     .where('id', isEqualTo: widget.productID ?? 'JtgFjmprdjTRoz9K5Fex')
    //     .get()
    //     .then((value) {
    //   return value;
    // });
    // }
    // return await db.collection("productsCollection").get().then((value) {
    //   return value;
    // });
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
          actions: [
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => FilterScreen()),
                // );
              },
              child: Container(
                padding: EdgeInsets.only(right: 25),
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          title: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: AppText(
              text: "Beverages",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: GridView.count(
          crossAxisCount: 4,
          // I only need two card horizontally
          children: beverages.asMap().entries.map<Widget>((e) {
            GroceryItem groceryItem = e.value;
            return GestureDetector(
              onTap: () {
                onItemClicked(context, groceryItem);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: GroceryItemCardWidget(
                  item: groceryItem,
                ),
              ),
            );
          }).toList(),
          // staggeredTiles:
          //     beverages.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 0.0, // add some space
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
