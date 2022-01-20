import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';
import 'package:grocery_app/common_widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerPhramPage extends StatefulWidget {
  const ManagerPhramPage({Key? key, this.isShowAppBar}) : super(key: key);
  final bool? isShowAppBar;
  //
  @override
  State<ManagerPhramPage> createState() => _ManagerPhramPageState();
}

class _ManagerPhramPageState extends State<ManagerPhramPage> {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getPharms() {
    return db.collection("pharmCollection").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getPharms(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        final _data = snapshot.data!.docs;
        //
        return ListView.separated(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            // ui
            return CustomContainer(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: _data[index]['name'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        text: _data[index]['number_comercial'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: _data[index]['name'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        text: _data[index]['number_comercial'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: _data[index]['phone'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        text: _data[index]['location'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      db
                          .collection('pharmCollection')
                          .doc(_data[index].id)
                          .delete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.shade200,
            thickness: 4.0,
          ),
        );
      },
    );
  }
}
