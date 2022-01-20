import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';

class CurrentUserInfoWidget extends StatelessWidget {
  const CurrentUserInfoWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imageUrl})
      : super(key: key);

  final String title;
  final String subtitle;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(),
        title: AppText(text: title),
        subtitle: AppText(
          text: subtitle,
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
