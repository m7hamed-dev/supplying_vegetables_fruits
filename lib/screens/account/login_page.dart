import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/helpers/toasts/toast.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/screens/admin/dashboard_admin_page/dashboard_admin_page.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final db = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  final _formKey = GlobalKey<FormState>();
  String _role = '';

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
          text: 'Login',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _firebaseAuth.currentUser != null
            ? _userInfo()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: '_emailController',
                        filled: true,
                      ),
                    ),
                    TextFormField(
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
                    MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        if (_role.isEmpty) {
                          EasyLoading.showError('Select Your Role');
                          return;
                        }
                        EasyLoading.showProgress(0.3, status: 'loading...');
                        //
                        final _firebaseAuth = FirebaseAuth.instance;
                        _firebaseAuth
                            .signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )
                            .catchError((onError) {
                          Future.error(onError);
                        });
                        //
                        if (_firebaseAuth.currentUser != null) {
                          Toast.success();
                          debugPrint('_role = $_role');
                          Push.to(
                              context,
                              _role == 'user'
                                  ? DashboardScreen()
                                  : DashboardDdminPage());
                        } else {
                          EasyLoading.showError('Login Failed with Error');
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
          title: Text(_firebaseAuth.currentUser!.displayName!),
          subtitle: Text(_firebaseAuth.currentUser!.email!),
        ),
        MaterialButton(
          color: Colors.green,
          onPressed: () async {
            await _firebaseAuth.signOut();
            LocalStorage.setRolePrfs('');
            Push.to(context, const LoginPage());
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
