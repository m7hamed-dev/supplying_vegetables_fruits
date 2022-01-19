import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/empty_widget.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
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
    return db
        .collection("categoriesCollection")
        // .where('cat_name', isEqualTo: 'cat 3')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
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
    return StreamBuilder<QuerySnapshot>(
      stream: _getCategories(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoadingWidget();
        final _data = snapshot.data!.docs;
        //
        debugPrint('_data = $_data');
        if (_data.isEmpty) {
          return EmptyWidget();
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // debugPrint(' on CLik on ${_data[index]['cat_name']}');
                // return;
                onItemClicked(context, _data[index]['cat_name']);
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(10.0),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: ImgNetwork(
                        imageUrl: _data[index]['img_path'],
                        // fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: AppText(
                          text: _data[index]['cat_name'],
                          fontSize: 22,
                          color: Colors.black.withOpacity(.90),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onItemClicked(BuildContext context, String productID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          isShowScaffold: true,
          categoryID: productID,
        ),
      ),
    );
  }
}
