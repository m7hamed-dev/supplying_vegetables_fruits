import 'package:grocery_app/common_widgets/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';
import 'package:grocery_app/helpers/validation.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/random_id.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  ///
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //
  bool visibleEmail = true;
  bool visiblePassword = true;
  //
  Map<String, dynamic> _map = Map<String, dynamic>();
  bool _isLoading = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  final _formKey = GlobalKey<FormState>();
  String _role = 'user';
  //
  Widget _paymentMethodsWidget() {
    return Column(
      children: [
        RadioListTile(
          title: Text('1'),
          value: true,
          groupValue: true,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('2'),
          value: true,
          groupValue: true,
          onChanged: (value) {},
        )
      ],
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppText(
          text: 'Register',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            //
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
              controller: _emailController,
              hintText: '_emailController',
              validator: (value) {
                Validation.isEmail(value);
              },
            ),
            const SizedBox(height: 10.0),
            Input(
                controller: _passwordController, hintText: 'passwordController'
                // validator: (value) {
                //   if (value != null) {
                //     if (value.length < 6) {
                //       return 'password must be greator than 6 chars';
                //     }
                //   }
                //   return null;
                // },
                ),
            const SizedBox(height: 20.0),
            _paymentMethodsWidget(),
            Row(
              children: [
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {},
                  child: Text(
                    'Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {},
                  child: Text(
                    'Back To Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: CircleAvatar(),
          title: Text('_firebaseAuth.currentUser!.displayName!'),
          subtitle: Text(_firebaseAuth.currentUser!.email!),
        ),
        MaterialButton(
          color: Colors.green,
          onPressed: () async {
            await _firebaseAuth.signOut();
            LocalStorage.setRolePrfs('');
            Push.to(context, const PaymentPage());
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
