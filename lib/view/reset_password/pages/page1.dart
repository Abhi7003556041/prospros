import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/reset_password_controller.dart';
import 'package:prospros/view/reset_password/reset_widget.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class ResetPasswordPageOne extends StatelessWidget {
  ResetPasswordPageOne({super.key});
  ResetPasswordController controller = Get.find<ResetPasswordController>();
  final formKey = GlobalKey<FormState>();

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
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * .84),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      ResetWidget(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Email id is required";
                            }
                            return null;
                          },
                          formName: AppTitle.emailId,
                          controller: controller.emailId),
                      SizedBox(height: 16),
                      Spacer(),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  controller.forgetOTPApi();
                                }
                              },
                              child: Text(AppTitle.submit)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
    ;
  }
}
