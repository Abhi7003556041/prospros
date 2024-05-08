import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/view/profile/user_post_widget.dart';
import 'package:prospros/widgets/custom_appbar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class ActivityPost extends StatelessWidget {
  const ActivityPost({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        activeTab: ActiveName.home,
        isProfile: true,
        appBar: CustomAppBarV2(
            enableBackgroundColor: false,
            title: AppTitle.activityPost,
            onTap: () {
              Get.toNamed(activity);
            }),
        body: UserPostWidget());
  }
}
