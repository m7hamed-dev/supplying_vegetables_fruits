import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/common_widgets/input.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/helpers/push.dart';
import 'package:grocery_app/local_storage/local_storage.dart';
import 'package:grocery_app/random_id.dart';
import 'package:image_picker/image_picker.dart';

import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
  FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 300,
      );

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

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
          text: 'Register',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _upload('camera'),
                          icon: const Icon(Icons.camera),
                          label: const Text(
                            'camera',
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _upload('gallery'),
                          icon: const Icon(Icons.library_add),
                          label: const Text(
                            'Gallery',
                          ),
                        ),
                      ],
                    ),

                    ///
                    FutureBuilder(
                      future: _loadImages(),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> image =
                                  snapshot.data![index];

                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  dense: false,
                                  leading: Image.network(image['url']),
                                  title: Text(image['uploaded_by']),
                                  subtitle: Text(image['description']),
                                  trailing: IconButton(
                                    onPressed: () => _delete(image['path']),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),

                    ///
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
                      controller: _emailController,
                      hintText: '_emailController',
                    ),
                    const SizedBox(height: 10.0),
                    Input(
                        controller: _passwordController,
                        hintText: 'passwordController'
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
                                      'number_comercial':
                                          _numberController.text,
                                      'email': _emailController.text,
                                      'password': _passwordController.text,
                                      'role': _role,
                                    };
                                    db
                                        .collection('accountCollection')
                                        .doc(randomId)
                                        .set(_map)
                                        .then((value) {
                                      LocalStorage.setUserInfoPrfs(_map);
                                    }).whenComplete(() {
                                      debugPrint('_role = $_role');
                                      LocalStorage.setRolePrfs(_role);
                                    }).catchError((onError) {
                                      debugPrint('onError = $onError');
                                    });
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
                              MaterialButton(
                                color: Colors.green,
                                onPressed: () {
                                  Push.to(context, const LoginPage());
                                },
                                child: Text(
                                  'Login',
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
            Push.to(context, const AccountPage());
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
