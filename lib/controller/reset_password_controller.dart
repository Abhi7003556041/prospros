import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/forget_password/forget_password_resp.dart';
import 'package:prospros/model/reset_password/reset_password_model.dart';
import 'package:prospros/model/reset_password/reset_password_resp.dart';
import 'package:prospros/router/navrouter_constants.dart';

class ResetPasswordController extends GetxController {
  var isDone = false.obs;
  var passwordVisibility = false.obs;
  var confirmPasswordVisibility = false.obs;
  var email = "".obs;
  var otp = "".obs;

  ResetPasswordResp? resetPasswordResp;
  ForgetOTPResp? forgetOTPResp;

  PageController pageController = PageController();

  final TextEditingController password = TextEditingController(text: "");
  final TextEditingController confirmPassword = TextEditingController(text: "");
  final TextEditingController otpController = TextEditingController(text: "");
  final TextEditingController emailId = TextEditingController(text: "");

  final formKey = GlobalKey<FormState>();

  submit() {
    if (formKey.currentState!.validate()) {
      resetPasswordApi();
    }
  }

  String? oldPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "Old Password is required";
    }
    // else if (passwordValidator(value)) {
    //   return "invalid password";
    // }
    return null;
  }

  String? newPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "New Password is required";
    }
    // else if (passwordValidator(value)) {
    //   return "invalid password";
    // }
    return null;
  }

  confirmDialog(String msg) {
    showDialog(
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              height: 150,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        msg,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(Get.context!);
                              pageController.animateToPage(1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeIn);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          );
        },
        context: Get.context!);
  }

  forgetOTPApi() async {
    try {
      isDone.value = true;

      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: {"email": emailId.text},
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.forgotPassword);
      print("changePasswordApi ==============");
      log(response.toString());
      forgetOTPResp = ForgetOTPResp.fromJson(response);

      if (forgetOTPResp?.success ?? false) {
        isDone.value = false;
        confirmDialog(forgetOTPResp?.message ?? "Server Error");
      } else {
        Get.closeAllSnackbars();
        isDone.value = false;
        Get.showSnackbar(GetSnackBar(
            message: forgetOTPResp?.message ?? "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isDone.value = false;
      Get.showSnackbar(GetSnackBar(
          message: forgetOTPResp?.message ?? "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  resetPasswordApi() async {
    try {
      isDone.value = true;

      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: ResetPasswordModel(
              email: emailId.text,
              otp: otpController.text,
              password: password.text,
              passwordConfirmation: confirmPassword.text),
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.resetPassword);

      print("resetPassword ==============");
      log(response.toString());
      resetPasswordResp = ResetPasswordResp.fromJson(response);
      if (resetPasswordResp!.success!) {
        await HiveStore().put(Keys.accessToken, "");
        GoogleSignInApi.logout();
        FacebookSignInApi.logout();
        isDone.value = false;
        Get.offAllNamed(login);
        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
            message:
                resetPasswordResp?.message ?? "Password changed successfully",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.closeAllSnackbars();
        isDone.value = false;
        Get.showSnackbar(GetSnackBar(
            message: (resetPasswordResp?.message ?? "Server Error") +
                " " +
                (resetPasswordResp?.data ?? ""),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      isDone.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: (resetPasswordResp?.message ?? "Server Error") +
              " " +
              (resetPasswordResp?.data ?? ""),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
