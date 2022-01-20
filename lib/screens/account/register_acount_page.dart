import 'package:grocery_app/common_widgets/btn.dart';
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
import 'login_page.dart';

class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({Key? key, this.isShowAppBar}) : super(key: key);

  ///
  final bool? isShowAppBar;
  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
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

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isShowAppBar == null
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              // leading: GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.only(left: 25),
              //     child: Icon(
              //       Icons.arrow_back_ios,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              title: AppText(
                text: 'Register',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
      body: _firebaseAuth.currentUser != null
          ? _userInfo()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  _headerProfile(),
                  const SizedBox(height: 40.0),
                  //
                  Input(
                    controller: _nameController,
                    hintText: '_nameController',
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  const SizedBox(height: 10.0),
                  Input(
                    controller: _numberController,
                    hintText: '_NumberController',
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  const SizedBox(height: 10.0),
                  Input(
                    controller: _phoneController,
                    hintText: '_phoneController',
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  const SizedBox(height: 10.0),
                  Input(
                    controller: _emailController,
                    hintText: '_emailController',
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    validator: (value) {
                      Validation.isEmail(value);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Input(
                    controller: _passwordController,
                    hintText: 'passwordController',
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: DropdownButton(
                        dropdownColor: Colors.grey,
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
                  ),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final _response =
                          await _firebaseAuth.createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                      //
                      try {
                        if (_response.user != null) {
                          _map = {
                            'account_id': randomId,
                            'name': _nameController.text,
                            'number_comercial': _numberController.text,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                            'role': _role,
                            'isActive': false,
                          };
                          db
                              .collection('accountCollection')
                              .doc(randomId)
                              .set(_map)
                              .then((value) {
                            Toast.success();
                            LocalStorage.setUserInfoPrfs(_map);
                            bool _isSame =
                                LocalStorage.getAccountID == _map['account_id'];
                            debugPrint('is same = $_isSame');
                          }).catchError((onError) {
                            Toast.error(error: onError.toString());
                            debugPrint('onError = $onError');
                          });
                        }
                      } catch (e) {
                        Toast.error(error: e.toString());
                      }
                    },
                    child: Text(
                      'Register',
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
                  Btn(
                    onPressed: () {
                      Push.to(context, const LoginPage());
                    },
                    title: 'Login',
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
            Push.to(context, const RegisterAccountPage());
          },
          child: Text('Logout'),
        ),
      ],
    );
  }

  InkWell _headerProfile() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 90.0,
        color: Colors.grey.shade300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -30.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: CircleAvatar(
                  radius: 50.0,
                  child: Icon(
                    Icons.person_outline_sharp,
                    size: 45.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
