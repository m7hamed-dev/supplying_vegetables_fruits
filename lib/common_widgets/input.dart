import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.controller,
    this.hintText,
    this.isNumberKeyBoard,
    this.onChanged,
  }) : super(key: key);
  //
  final TextEditingController? controller;
  final String? hintText;
  final bool? isNumberKeyBoard;
  final void Function(String)? onChanged;
  //
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumberKeyBoard == true ? TextInputType.number : null,
      onChanged: onChanged,
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
