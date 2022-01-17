import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';

class HomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/farmer.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10.0,
            child: Center(
              child: AppText(
                text: "من المزارع مباشرة",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: -20.0,
            left: 30,
            right: 30,
            child: SearchBarWidget(),
          ),
        ],
      ),
    );
  }
}
