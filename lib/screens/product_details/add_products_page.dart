import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/input.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';
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
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXnGnYZMb2sJhJ1tlcUsA6VRfZM3NtdKMeig&usqp=CAU'
                };
                db
                    .collection('productsCollection')
                    .doc(randomId)
                    .set(_map)
                    .then((value) {
                  Toast.success();
                }).catchError((onError) {
                  Toast.error(error: onError.toString());
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
