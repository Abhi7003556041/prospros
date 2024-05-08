import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/change_password_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';
import 'package:prospros/widgets/custom_textformfield.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScaffold(
          activeTab: ActiveName.home,
          isProfile: true,
          appBar: CustomAppBar(
            const Text(AppTitle.changePassword,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w200)),
          ),
          body: ModalProgressHUD(
            inAsyncCall: controller.isDone.value,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserFormWidget(
                          validator: controller.oldPasswordValidator,
                          formName: AppTitle.oldPassword,
                          controller: controller.oldPassword,
                          visibility: controller.oldpasswordVisibility),
                      UserFormWidget(
                          validator: controller.newPasswordValidator,
                          formName: AppTitle.newPassword,
                          controller: controller.newPassword,
                          visibility: controller.newpasswordVisibility),
                      UserFormWidget(
                          validator: controller.confirmPasswordValidator,
                          formName: AppTitle.confirmPassword,
                          controller: controller.confirmPassword,
                          visibility: controller.confirmpasswordVisibility),
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

class UserFormWidget extends StatelessWidget {
  UserFormWidget({
    super.key,
    required this.formName,
    required this.controller,
    required this.validator,
    required this.visibility,
  });
  final String formName;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  RxBool visibility;
  ChangePasswordController changePasswordController =
      Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formName),
        SizedBox(height: 8),
        Obx(
          () => CustomTextFormField(
            inputFormatters: [LengthLimitingTextInputFormatter(16)],
            obscureText: !visibility.value,
            suffixIcon: IconButton(
              icon: Icon(
                visibility.value ? Icons.visibility : Icons.visibility_off,
                //color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                visibility.value = !visibility.value;
              },
            ),
            validator: validator,
            labelTxt: formName,
            hintTxt: formName,
            controller: controller,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
