import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/widgets/image_viewer.dart';

class ShowImageMsg extends StatelessWidget {
  const ShowImageMsg({super.key, required this.isReply, required this.imgUrl});

  final bool isReply;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isReply ? AppColor.chatMsgColor : AppColor.appColor,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
      child: GestureDetector(
          onTap: () {
            Get.to(InterActiveImageViewer(fileUrl: imgUrl));
          },
          child: CachedNetworkImage(imageUrl: imgUrl)),
    );
  }
}
