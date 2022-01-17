import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/shared_datd/categories.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'filter_screen.dart';

class CategoryItemsScreen extends StatelessWidget {
  const CategoryItemsScreen({Key? key, this.isShowScaffold}) : super(key: key);
  final bool? isShowScaffold;

  @override
  Widget build(BuildContext context) {
    if (isShowScaffold == true) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterScreen()),
                );
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
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // I only need two card horizontally
      children: allCategories.asMap().entries.map<Widget>((e) {
        Category category = e.value;
        return GestureDetector(
          onTap: () {
            // onItemClicked(context, groceryItem);
          },
          child: Container(
            height: 100,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    category.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10.0,
                  child: Center(
                    child: AppText(
                      text: category.name,
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
      // staggeredTiles:
      //     beverages.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
      mainAxisSpacing: 3.0,
      crossAxisSpacing: 0.0, // add some space
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(groceryItem)),
    );
  }
}
