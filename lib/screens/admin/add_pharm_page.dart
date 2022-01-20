import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/input.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';
import 'package:grocery_app/random_id.dart';

class AddPharmPage extends StatefulWidget {
  //
  const AddPharmPage({Key? key, this.isShowAppBar}) : super(key: key);
  final bool? isShowAppBar;
  //
  @override
  State<AddPharmPage> createState() => _AddPharmPageState();
}

class _AddPharmPageState extends State<AddPharmPage> {
  ///

  final db = FirebaseFirestore.instance;

  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _numberCommercialController = TextEditingController();
  TextEditingController _addminController = TextEditingController();

  ///
  Map<String, dynamic> _map = Map<String, dynamic>();
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isShowAppBar == null
          ? null
          : AppBar(
              title: Text("Mange Pharm"),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Input(
                controller: _nameController,
                hintText: '_nameController',
              ),
              const SizedBox(height: 10.0),
              Input(
                controller: _numberController,
                hintText: '_NumberController',
              ),
              const SizedBox(height: 10.0),
              Input(
                controller: _phoneController,
                hintText: '_phoneController',
              ),
              const SizedBox(height: 10.0),
              Input(
                controller: _numberCommercialController,
                hintText: '_numberCommercialController',
              ),
              const SizedBox(height: 10.0),
              Input(
                controller: _locationController,
                hintText: '_locationController',
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  _map = {
                    'pharm_id': randomId,
                    'name': _nameController.text,
                    'number_comercial': _numberCommercialController.text,
                    'location': _locationController.text,
                    'phone': _phoneController.text,
                    'woner_admin': _addminController.text,
                  };
                  db
                      .collection('pharmCollection')
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
                  'add new pharm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
