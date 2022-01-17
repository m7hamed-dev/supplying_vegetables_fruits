import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsInvoicePage extends StatefulWidget {
  const DetailsInvoicePage({Key? key}) : super(key: key);

  @override
  State<DetailsInvoicePage> createState() => _DetailsInvoicePageState();
}

class _DetailsInvoicePageState extends State<DetailsInvoicePage> {
  final db = FirebaseFirestore.instance;

  bool visibleEmail = true;
  bool visiblePassword = true;

  ///
  Map<String, dynamic> _map = Map<String, dynamic>();
  //
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
          text: 'Details Invoice',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thanks You !!',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            Text(
              'I hope U Enjoy !!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: List.generate(
                5,
                (index) => Text(
                  'Product No. $index',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ).toList(),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Text(
                'Print Invoice',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
