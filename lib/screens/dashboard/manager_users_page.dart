import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerUsersPage extends StatefulWidget {
  const ManagerUsersPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ManagerUsersPage> createState() => _ManagerUsersPageState();
}

class _ManagerUsersPageState extends State<ManagerUsersPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getUsers() {
    return db.collection("accountCollection").snapshots();
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
          stream: _getUsers(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            final _data = snapshot.data!.docs;
            if (_data.isEmpty) {
              return Center(
                child: Text(
                  'no users',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              );
            }
            return ListView.separated(
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(_data[index]['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_data[index]['email']),
                        Text(_data[index]['role']),
                      ],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        db
                            .collection('accountCollection')
                            .doc(_data[index].id)
                            .delete();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ));
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 10.0,
                color: Colors.grey.shade200,
              ),
            );
          },
        ),
      ),
    );
  }
}
