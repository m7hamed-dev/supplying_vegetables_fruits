import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerOrdersPage extends StatefulWidget {
  const ManagerOrdersPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ManagerOrdersPage> createState() => _ManagerOrdersPageState();
}

class _ManagerOrdersPageState extends State<ManagerOrdersPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getOrders() {
    return db.collection("orderCollection").snapshots();
  }

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

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
          text: "Manager Users Page",
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _getOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            final _data = snapshot.data!.docs;
            return ListView(
              children: _data.asMap().entries.map<Widget>((e) {
                return ListTile(
                  title: Text(e.value['name']),
                  subtitle: Text(e.value['email']),
                  // leading: Text(e.value['role']),
                  trailing: IconButton(
                    onPressed: () {
                      debugPrint('id = ${e.value['account_id']}');
                      db
                          .collection('accountCollection')
                          .doc(e.value['account_id'])
                          .delete()
                          .whenComplete(() {})
                          .catchError(
                        (onError) {
                          debugPrint('onError $onError');
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
