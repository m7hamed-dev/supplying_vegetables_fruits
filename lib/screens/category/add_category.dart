import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/random_id.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _categoryNameController = TextEditingController();
  Map<String, dynamic> _map = Map<String, dynamic>();
  bool _isLoading = false;
  //
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
          text: "AddCategoryPage",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _categoryNameController,
            ),
            _isLoading
                ? Center(
                    child: Text(
                    "Add _categoryNameController Success ",
                    style: TextStyle(color: Colors.green),
                  ))
                : RaisedButton(
                    onPressed: () {
                      _isLoading = true;
                      setState(() {});
                      // Navigator.of(context).pop();
                      _map = {
                        'cat_id': randomId,
                        'cat_name': _categoryNameController.text,
                        'img_path':
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXnGnYZMb2sJhJ1tlcUsA6VRfZM3NtdKMeig&usqp=CAU'
                      };
                      db
                          .collection('categoriesCollection')
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
