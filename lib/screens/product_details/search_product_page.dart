import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/common_widgets/input.dart';
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
  @override
  Widget build(BuildContext context) {
    final _cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
        child: Column(
          children: [
            Input(
              hintText: 'search',
              onChanged: (value) {
                _cartProvider.search(value);
              },
            ),
            ListView.separated(
              itemCount: _cartProvider.searchCartModels.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: AppText(
                    text: _cartProvider.searchCartModels[index].name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: _cartProvider.searchCartModels[index].price +
                            ' \R.S',
                        fontSize: 18,
                        color: Colors.green,
                      ),
                      AppText(
                        text:
                            _cartProvider.searchCartModels[index].description +
                                ' \R.S',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  leading: ImgNetwork(
                    imageUrl: _cartProvider.searchCartModels[index].imgPath,
                  ),
                  trailing: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      // _cartProvider.addProtductToCart(_cartProvider.searchCartModels[index]);
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
