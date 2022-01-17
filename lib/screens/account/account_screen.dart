import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/random_id.dart';

class SignInAndSignUpPage extends StatefulWidget {
  const SignInAndSignUpPage({Key? key}) : super(key: key);

  @override
  State<SignInAndSignUpPage> createState() => _SignInAndSignUpPageState();
}

class _SignInAndSignUpPageState extends State<SignInAndSignUpPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool visibleEmail = true;
  bool visiblePassword = true;

  ///
  Map<String, dynamic> _map = Map<String, dynamic>();
  bool _isLoading = false;
  bool _isSignIn = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  final _formKey = GlobalKey<FormState>();
  List<bool> _isSelected = [false, true];
  String _role = 'user';

  ///
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
          text: _isSignIn ? 'Login' : 'Register',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '_nameController',
                  filled: true,
                ),
              ),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  hintText: '_NumberController',
                  filled: true,
                ),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '_phoneController',
                  filled: true,
                ),
              ),
              Visibility(
                visible: visibleEmail,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '_emailController',
                    filled: true,
                  ),
                ),
              ),
              Visibility(
                visible: visiblePassword,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: '_passwordController',
                    filled: true,
                  ),
                  validator: (value) {
                    if (value != null) {
                      if (value.length < 6) {
                        return 'password must be greator than 6 chars';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  items: ['admin', 'user'].map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  hint: Text(_role),
                  onChanged: (val) {
                    _role = val.toString();
                    setState(() {});
                  },
                ),
              ),
              _isLoading
                  ? Center(
                      child: Text(
                      "Add _categoryNameController Success ",
                      style: TextStyle(color: Colors.green),
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaterialButton(
                          color: Colors.green,
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            // _isLoading = true;
                            // setState(() {});
                            final _response = await _firebaseAuth
                                .createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                            //
                            if (_response.user != null) {
                              _map = {
                                'account_id': randomId,
                                'name': _nameController.text,
                                'number_comercial': _numberController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'role': _role,
                              };
                              db
                                  .collection('accountCollection')
                                  .doc(randomId)
                                  .set(_map)
                                  .then((value) {
                                _isLoading = false;
                                setState(() {});
                              }).whenComplete(() {
                                debugPrint('_role = $_role');
                                LocalStorage.setRolePrfs(_role);
                                _isLoading = false;

                                setState(() {});
                              }).catchError((onError) {
                                debugPrint('onError = $onError');
                              });
                            }
                          },
                          child: Text(
                            _isSignIn ? 'Register' : 'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Center(
                          child: Text(
                            '- OR - ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        MaterialButton(
                          color: Colors.green,
                          onPressed: () {
                            _isSignIn = true;
                            setState(() {});
                            if (_isSignIn) {
                              //83d49cf2-c70e-4ef0-8bbf-0dd1ba03a2dd
                              db
                                  .collection('accountCollection/password')
                                  // .doc('accountCollection/password')
                                  .get()
                                  .then((value) {
                                debugPrint('value ${value}');
                              });
                              // debugPrint('r ${r}');
                            }
                          },
                          child: Text(
                            _isSignIn ? 'Register' : 'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
