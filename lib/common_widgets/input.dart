import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.controller,
    this.hintText,
    this.isNumberKeyBoard,
  }) : super(key: key);
  //
  final TextEditingController? controller;
  final String? hintText;
  final bool? isNumberKeyBoard;
  //
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumberKeyBoard == true ? TextInputType.number : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: hintText ?? '',
      ),
    );
  }
}
