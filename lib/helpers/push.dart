import 'package:flutter/material.dart';

class Push {
  static void to(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
