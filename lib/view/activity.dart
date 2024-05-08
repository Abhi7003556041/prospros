import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as xyz;
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/activity_comment_controller.dart';
import 'package:prospros/controller/activity_like_controller.dart';

import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/custom_appbar.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarV2(
            enableBackgroundColor: false,
            title: AppTitle.activity,
            onTap: () {
              Get.toNamed(drawerNavigation);
            }),
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(children: [
            ActivityWidget(
                activityTitle: AppTitle.postActivity,
                imageString: AppImage.postIcon,
                onTap: () {
                  Get.toNamed(activityPost);
                }),
            ActivityWidget(
                activityTitle: AppTitle.commentsActivity,
                imageString: AppImage.messageActivity,
                onTap: () async {
                  await Get.delete<ActivityCommentController>();
                  Get.toNamed(activityComment);
                }),
            ActivityWidget(
                activityTitle: AppTitle.likeActivity,
                imageString: AppImage.likeActivity,
                onTap: () async {
                  // ActivityLikeController controller =
                  //     Get.put(ActivityLikeController());
                  // controller.page.value = 1;
                  // controller.likeData.clear();
                  await Get.delete<ActivityLikeController>();
                  Get.toNamed(activityLike);
                }),
          ]),
        ));
  }
}

class Activit
Widget extends StatelessWidget {
  const ActivityWidget(
      {super.key,
      required this.imageString,
      required this.activityTitle,
      required this.onTap});
  final String imageString;
  final String activityTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            height: 68,
            padding: const EdgeInsets.only(left: 16.0, right: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(imageString, width: 20, height: 20),
                const SizedBox(width: 16),
                Text(activityTitle, style: const TextStyle(fontSize: 14)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
        Container(height: 4, color: AppColor.homeDividerColor),
      ],
    );
  }
}
