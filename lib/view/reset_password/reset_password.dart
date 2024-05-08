import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/reset_password_controller.dart';
import 'package:prospros/view/reset_password/pages/page1.dart';
import 'package:prospros/view/reset_password/pages/page2.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: PageView(
        pageSnapping: false,
        allowImplicitScrolling: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          ResetPasswordPageOne(),
          ResetPasswordPageTwo(),
        ],
      )),
    );
  }
}
