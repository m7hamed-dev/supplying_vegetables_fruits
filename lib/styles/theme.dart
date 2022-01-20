import 'package:flutter/material.dart';
import 'package:grocery_app/styles/colors.dart';

String gilroyFontFamily = "Gilroy";

ThemeData themeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  fontFamily: gilroyFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 0.5,
    centerTitle: true,
  ),
);
