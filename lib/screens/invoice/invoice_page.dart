import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';
import 'package:grocery_app/screens/cart/cart_provider.dart';
import 'package:provider/src/provider.dart';

class DetailsInvoicePage extends StatefulWidget {
  const DetailsInvoicePage({Key? key}) : super(key: key);

  @override
  State<DetailsInvoicePage> createState() => _DetailsInvoicePageState();
}

class _DetailsInvoicePageState extends State<DetailsInvoicePage> {
  final db = FirebaseFirestore.instance;

  bool visibleEmail = true;
  bool visiblePassword = true;

  ///
  Map<String, dynamic> _map = Map<String, dynamic>();
  //
  @override
  Widget build(BuildContext context) {
    final _cartProvider = context.watch<CartProvider>();
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
          text: 'Details Invoice',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thanks You !!',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            Text(
              'I hope U Enjoy !!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
            const SizedBox(height: 30),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _cartProvider.cartModels.map((e) {
                return CustomContainer(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.name),
                      const SizedBox(width: 10.0),
                      Text(e.price),
                      InkWell(
                          onTap: () {
                            _cartProvider.removeProtductFromCart(e);
                          },
                          child: Icon(Icons.delete_forever)),
                    ],
                  ),
                );
              }).toList(),
            ),
            IconButton(
              onPressed: () {},
              icon: Text(
                'Print Invoice',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
