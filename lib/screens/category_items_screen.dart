import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/screens/product_details/products_page.dart';

class CategoryItemsScreen extends StatefulWidget {
  const CategoryItemsScreen({Key? key, this.isShowScaffold}) : super(key: key);
  final bool? isShowScaffold;

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getCategories() {
    return db.collection("categoriesCollection").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    // if (widget.isShowScaffold == true) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.transparent,
    //       elevation: 0,
    //       centerTitle: true,
    //       automaticallyImplyLeading: false,
    //       leading: GestureDetector(
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //         child: Container(
    //           padding: EdgeInsets.only(left: 25),
    //           child: Icon(
    //             Icons.arrow_back_ios,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //       actions: [
    //         GestureDetector(
    //           onTap: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => FilterScreen()),
    //             );
    //           },
    //           child: Container(
    //             padding: EdgeInsets.only(right: 25),
    //             child: Icon(
    //               Icons.sort,
    //               color: Colors.black,
    //             ),
    //           ),
    //         ),
    //       ],
    //       title: Container(
    //         padding: EdgeInsets.symmetric(
    //           horizontal: 25,
    //         ),
    //         child: AppText(
    //           text: "Beverages",
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ),
    //     body: GridView.count(
    //       crossAxisCount: 4,
    //       // I only need two card horizontally
    //       children: beverages.asMap().entries.map<Widget>((e) {
    //         // GroceryItem groceryItem = e.value;
    //         return GestureDetector(
    //           onTap: () {
    //             // onItemClicked(context, groceryItem);
    //           },
    //           child: Container(
    //             padding: EdgeInsets.all(10),
    //             child: GroceryItemCardWidget(
    //               item: groceryItem,
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //       // staggeredTiles:
    //       //     beverages.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
    //       mainAxisSpacing: 3.0,
    //       crossAxisSpacing: 0.0, // add some space
    //     ),
    //   );
    // }
    return Container(
      color: Colors.green,
      child: StreamBuilder<QuerySnapshot>(
        stream: _getCategories(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoadingWidget();
          final _data = snapshot.data!.docs;
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _data.asMap().entries.map<Widget>((e) {
              return GestureDetector(
                onTap: () {
                  onItemClicked(context, e.value['cat_id']);
                },
                child: Container(
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          e.value['img_path'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        child: Center(
                          child: AppText(
                            text: e.value['cat_name'],
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            mainAxisSpacing: 3.0,
            crossAxisSpacing: 0.0, // add some space
          );
        },
      ),
    );
  }

  void onItemClicked(BuildContext context, String productID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          isShowScaffold: true,
          productID: productID,
        ),
      ),
    );
  }
}
