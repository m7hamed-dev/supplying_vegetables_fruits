import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/input.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/random_id.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({Key? key}) : super(key: key);

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _pricetController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  Map<String, dynamic> _map = Map<String, dynamic>();
  //
  Stream<QuerySnapshot> _getCategoriesName() {
    return db.collection("categoriesCollection").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getCategoriesName();
  }

  String catName = '';
  @override
  Widget build(BuildContext context) {
    // debugPrint('id = ${LocalStorage.getAccountID}');
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
          text: "AddProductsPage",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getCategoriesName(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //
                  if (!snapshot.hasData) return LoadingWidget();
                  //
                  final _data = snapshot.data!.docs;
                  return DropdownButton(
                    isDense: true,
                    isExpanded: true,
                    items: _data.map((item) {
                      return DropdownMenuItem(
                        value: item['cat_name'],
                        child: Text(item['cat_name']),
                      );
                    }).toList(),
                    hint: Text(catName),
                    onChanged: (val) {
                      catName = val.toString();
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Input(
              controller: _productNameController,
              hintText: 'product name',
            ),
            const SizedBox(height: 10.0),
            Input(
              controller: _pricetController,
              hintText: 'product price',
              isNumberKeyBoard: true,
            ),
            const SizedBox(height: 10.0),
            Input(
              controller: _qtyController,
              hintText: 'qty',
              isNumberKeyBoard: true,
            ),
            const SizedBox(height: 10.0),
            Input(
              controller: _productDescriptionController,
              hintText: 'product description',
            ),
            const SizedBox(height: 10.0),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                final List<String> _randomImgs = [
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXnGnYZMb2sJhJ1tlcUsA6VRfZM3NtdKMeig&usqp=CAU',
                  'https://www.google.com/imgres?imgurl=https%3A%2F%2Fhips.hearstapps.com%2Fdel.h-cdn.co%2Fassets%2F16%2F25%2Fbell-peppers_1.jpg&imgrefurl=https%3A%2F%2Fwww.delish.com%2Ffood-news%2Fg3443%2F10-vegetables-arent-good-for-you%2F&tbnid=AGiLbyeVBSiouM&vet=12ahUKEwjw54bp2L_1AhUTxeAKHUmQA7wQMygiegUIARCJAg..i&docid=MZMMrsu_0tglWM&w=1000&h=667&itg=1&q=images%20vegetables&ved=2ahUKEwjw54bp2L_1AhUTxeAKHUmQA7wQMygiegUIARCJAg',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMow-o-Lk8_cfc2YF0I5MsrU8luJF_haPfw&usqp=CAU',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2LyZeqfc6mzllmp2vqwt-ef5bplo2AQ33HQ&usqp=CAU',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWIGXrMUK0x55jWf84PFtVfG0PpNu3YbMlA&usqp=CAU',
                ];
                //
                if (catName.isEmpty) {
                  Toast.error(error: 'select category for product');
                  return;
                }
                _map = {
                  'product_id': randomId,
                  'cat_id': catName,
                  'product_name': _productNameController.text,
                  'product_description': _productDescriptionController.text,
                  'product_price': _pricetController.text,
                  'qty': _qtyController.text,
                  'img_path':
                      _randomImgs[Random().nextInt(_randomImgs.length - 1)],
                  'vendor_id': LocalStorage.getAccountID,
                };
                db
                    .collection('productsCollection')
                    .doc(randomId)
                    .set(_map)
                    .then((value) {
                  Toast.success();
                }).catchError((onError) {
                  // Toast.error(error: onError.toString());
                  debugPrint('onError = $onError');
                });
              },
              child: Text(
                "Add Product",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
