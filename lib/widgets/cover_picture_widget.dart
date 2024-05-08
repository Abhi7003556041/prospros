import 'package:flutter/material.dart';
import 'package:prospros/constants/constant.dart';

class DefaultCoverPictuteWidget extends StatelessWidget {
  const DefaultCoverPictuteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 155,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(AppImage.placeholderImage))),
    );
  }
}
