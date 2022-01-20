import 'package:flutter/material.dart';

class RoundedWidget extends StatelessWidget {
  const RoundedWidget({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: padding ?? const EdgeInsets.all(0.0),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color ?? Colors.green,
      ),
      child: child,
    );
  }
}
