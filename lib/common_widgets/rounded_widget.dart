import 'package:flutter/material.dart';

class RoundedWidget extends StatelessWidget {
  final Widget child;

  const RoundedWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.green,
      ),
      child: child,
    );
  }
}
