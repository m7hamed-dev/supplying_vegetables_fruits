import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/common_widgets/btn.dart';
import 'package:grocery_app/common_widgets/input.dart';
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
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage(
                        'assets/images/logo_me.jpeg',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Input(
                      controller: _emailController,
                      hintText: 'الايميل',
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      validator: (value) {
                        // Validation.isEmail(value);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Input(
                      controller: _passwordController,
                      hintText: 'كلمة المرور',
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
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Btn(
                            onPressed: () {},
                            title: 'Login',
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Btn(
                            onPressed: () {},
                            title: 'Login',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    Btn(
                      color: Colors.grey,
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
                            .then((value) {
                          Toast.success();
                          Push.to(context, DashboardScreen());
                        }).catchError((onError) {});
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
                      title: 'Login',
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
