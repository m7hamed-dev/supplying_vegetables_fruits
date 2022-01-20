import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  const Btn({Key? key, this.onPressed, this.title, this.color})
      : super(key: key);
  final void Function()? onPressed;
  final String? title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        color: color ?? Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: onPressed,
        child: Text(
          title ?? 'title',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'cairo-bold',
          ),
        ),
      ),
    );
  }
}
