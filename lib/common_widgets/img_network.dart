import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImgNetwork extends StatelessWidget {
  const ImgNetwork({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: 60,
      height: 70,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          // border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    );
  }
}
