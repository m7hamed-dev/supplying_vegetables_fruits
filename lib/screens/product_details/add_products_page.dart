import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:grocery_app/random_id.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({Key? key}) : super(key: key);

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _pricetController = TextEditingController();
  Map<String, dynamic> _map = Map<String, dynamic>();
  bool _isLoading = false;
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
            Text('load image'),
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
            TextFormField(
              controller: _productNameController,
            ),
            TextFormField(
              controller: _pricetController,
            ),
            _isLoading
                ? Center(
                    child: Text(
                    "Add Product Success ",
                    style: TextStyle(color: Colors.green),
                  ))
                : MaterialButton(
                    onPressed: () {
                      _isLoading = true;
                      setState(() {});
                      // Navigator.of(context).pop();
                      _map = {
                        'product_id': randomId,
                        'product_price': _pricetController.text,
                        'product_name': _productNameController.text,
                        'img_path':
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXnGnYZMb2sJhJ1tlcUsA6VRfZM3NtdKMeig&usqp=CAU'
                      };
                      db
                          .collection('productsCollection')
                          .doc(randomId)
                          .set(_map)
                          .then((value) {
                        _isLoading = false;
                        setState(() {});
                      }).whenComplete(() {
                        _isLoading = false;
                        setState(() {});
                      }).catchError((onError) {
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
