import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/login_screen_controller.dart';
import 'package:prospros/main.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:prospros/widgets/internet_snackbar.dart';
import '../constants/color.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: loginController.isCallingLoginApi.value,
          progressIndicator: CircularProgressIndicator(
            color: Color(0xff2643E5),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const Text(AppTitle.login, style: AppStyle.loginTxtStyle),
                      const SizedBox(height: 16),
                      const Text(AppTitle.welcome),
                      const SizedBox(height: 32),
                      const Text(AppTitle.emailId),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                          controller: loginController.emailController,
                          labelTxt: "Enter your email",
                          hintTxt: "Enter your email"),
                      const SizedBox(height: 16),
                      const Text(AppTitle.password),
                      const SizedBox(height: 12),
                      Obx(
                        () => CustomTextFormField(
                          controller: loginController.passwordController,
                          labelTxt: "Enter your password",
                          hintTxt: "Enter your password",
                          obscureText:
                              !loginController.passwordVisibility.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                                loginController.passwordVisibility.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark),
                            onPressed: () {
                              loginController.togglePasswordVisibility();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () {
                                Get.toNamed(resetPassword);
                              },
                              child: Text(AppTitle.forgotPass))),
                      const SizedBox(height: 32),
                      Center(
                          child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () async {
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (result) {
                                loginController.login();
                              } else {
                                noInternetConnection();
                              }
                            },
                            child: const Text(AppTitle.login)),
                      )),
                      const SizedBox(height: 32),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // height: 100,
                                color: AppColor.loginDividerColor,
                                width: 32,
                                height: 1.5),
                            const SizedBox(width: 12.5),
                            const Center(child: Text(AppTitle.orLogin)),
                            const SizedBox(width: 12.5),
                            Container(
                                // height: 100,
                                color: AppColor.loginDividerColor,
                                width: 32,
                                height: 1.5),
                            const SizedBox(width: 12.5),
                          ]),
                      const SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                loginController.googleSignIn();
                              },
                              child: googleLoginIcon()),
                          const SizedBox(width: 14),
                          // GestureDetector(
                          //     onTap: () {
                          //       loginController.fbSignIn();
                          //     },
                          //     child: fbLoginIcon()),
                          Offstage(
                            offstage: Platform.isIOS ? false : true,
                            child: GestureDetector(
                                onTap: () {
                                  loginController.appleSignIn();
                                },
                                child: appleLoginIcon()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 31),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: AppTitle.account,
                            style: const TextStyle(
                                color: Colors
                                    .black), //DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(text: " "),
                              TextSpan(
                                text: AppTitle.register,
                                style: const TextStyle(color: Colors.red),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(register);
                                  },
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container fbLoginIcon() {
    return Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: AppColor.loginGmailBorder)),
        child: SvgPicture.asset(
          AppImage.facebook,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ));
  }

  Container appleLoginIcon() {
    return Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: AppColor.loginGmailBorder)),
        child: SvgPicture.asset(
          AppImage.apple,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ));
  }

  Container googleLoginIcon() {
    return Container(
        height: 42,
        width: 42,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: AppColor.loginGmailBorder)),
        child: SvgPicture.asset(
          AppImage.gmail,
          fit: BoxFit.scaleDown,
        ));
  }
}
