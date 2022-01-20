import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.controller,
    this.hintText,
    this.isNumberKeyBoard,
    this.onChanged,
    this.validator,
    this.padding,
  }) : super(key: key);
  //
  final TextEditingController? controller;
  final String? hintText;
  final bool? isNumberKeyBoard;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TextFormField(
        controller: controller,
        keyboardType: isNumberKeyBoard == true ? TextInputType.number : null,
        onChanged: onChanged,
        validator: validator,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: hintText ?? '',
        ),
      ),
    );
  }
}
