import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // alignment: Alignment.center,
      margin: margin ?? const EdgeInsets.all(0.0),
      padding: padding ?? const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.10),
              offset: Offset(0.2, 2.0),
              blurRadius: 8.0,
            )
          ]),
      child: child,
    );
  }
}
