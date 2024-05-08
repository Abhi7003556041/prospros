import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/create_profile_details_controller.dart';
import 'package:prospros/view/create_profile_details/pages/page1.dart';
import 'package:prospros/view/create_profile_details/pages/page2.dart';
import 'package:prospros/view/create_profile_details/pages/page3.dart';
import 'package:prospros/view/create_profile_details/pages/page4.dart';
import 'package:prospros/view/create_profile_details/pages/page5.dart';

class CreateProfileDetailsScreen extends StatelessWidget {
  CreateProfileDetailsScreen({super.key, this.callbackActionForLoginScreen});

  ///this callback is being used by login screen to verify wheter user category selected or not
  final Function? callbackActionForLoginScreen;
  final controller = Get.put(CreateProfileDetailsController());
  @override
  Widget build(BuildContext context) {
    controller.setCallBack(callbackActionForLoginScreen);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: PageView(
        pageSnapping: false,
        allowImplicitScrolling: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          CreateProfilePage1(),
          CreateProfilePage2(),
          CreateProfilePage3(),
          CreateProfilePage4(),
          CreateProfilePage5()
        ],
      )),
    );
  }
}
