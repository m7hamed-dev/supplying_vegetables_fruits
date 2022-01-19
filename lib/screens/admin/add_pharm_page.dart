import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/random_id.dart';
import 'package:grocery_app/screens/admin/manager_pharm_page.dart';

class AddPharmPage extends StatefulWidget {
  const AddPharmPage({Key? key}) : super(key: key);

  @override
  State<AddPharmPage> createState() => _AddPharmPageState();
}

class _AddPharmPageState extends State<AddPharmPage>
    with SingleTickerProviderStateMixin {
  ///
  late TabController _tabController;

  ///
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              alignment: Alignment.center,
              child: Center(
                child: Text("Mange Pharm"),
              ),
              color: Colors.blue,
            ),
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              tabs: [
                Tab(
                  icon: Text("Add Pharm"),
                ),
                Tab(
                  icon: Text("Delete Pharm"),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: '_nameController',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _numberController,
                          decoration: InputDecoration(
                            hintText: '_NumberController',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: '_phoneController',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _numberCommercialController,
                          decoration: InputDecoration(
                            hintText: '_numberCommercialController',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: '_locationController',
                            filled: true,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MaterialButton(
                              color: Colors.green,
                              onPressed: () {
                                _map = {
                                  'pharm_id': randomId,
                                  'name': _nameController.text,
                                  'number_comercial':
                                      _numberCommercialController.text,
                                  'location': _locationController.text,
                                  'phone': _phoneController.text,
                                  'woner_admin': _addminController.text,
                                };
                                db
                                    .collection('pharmCollection')
                                    .doc(randomId)
                                    .set(_map)
                                    .then((value) {})
                                    .whenComplete(() {})
                                    .catchError((onError) {
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
                      ],
                    ),
                  ),

                  /// tab 2
                  Container(
                    child: const ManagerPhramPage(),
                  )
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
