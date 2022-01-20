import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/common_widgets/custom_container.dart';
import 'package:grocery_app/common_widgets/img_network.dart';
import 'package:grocery_app/local_storage/local_storage.dart';

class CurrentUserInfoWidget extends StatelessWidget {
  const CurrentUserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: ImgNetwork(
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLe5PABjXc17cjIMOibECLM7ppDwMmiDg6Dw&usqp=CAU'),
        title: AppText(text: LocalStorage.getEmail),
        subtitle: AppText(
          text: LocalStorage.getPhone,
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
