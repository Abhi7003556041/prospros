import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/reset_password_controller.dart';
import 'package:prospros/view/reset_password/reset_widget.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class ResetPasswordPageTwo extends StatelessWidget {
  ResetPasswordPageTwo({super.key});
  ResetPasswordController controller = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: controller.isDone.value,
          child: CustomScaffold(
            activeTab: ActiveName.home,
            isProfile: true,
            appBar: CustomAppBar(
              const Text("Forgot Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w200)),
            ),
            body: Form(
              key: controller.formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      ResetWidget(
                          validator: (String? value) {
                            return null;
                          },
                          formName: AppTitle.otp,
                          controller: controller.otpController),
                      ResetWidget(
                          isNotPassword: false,
                          validator: controller.oldPasswordValidator,
                          formName: AppTitle.password,
                          controller: controller.password,
                          visibility: controller.passwordVisibility.value,
                          onPressed: () {
                            controller.passwordVisibility.value =
                                !controller.passwordVisibility.value;
                          }),
                      ResetWidget(
                          isNotPassword: false,
                          validator: controller.newPasswordValidator,
                          formName: AppTitle.confirmPassword,
                          controller: controller.confirmPassword,
                          visibility:
                              controller.confirmPasswordVisibility.value,
                          onPressed: () {
                            controller.confirmPasswordVisibility.value =
                                !controller.confirmPasswordVisibility.value;
                          }),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                              onPressed: controller.submit,
                              child: Text(AppTitle.submit)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
