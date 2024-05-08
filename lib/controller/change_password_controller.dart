import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/change_password/change_password_model.dart';
import 'package:prospros/model/change_password/change_password_resp.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';

class ChangePasswordController extends GetxController {
  var isDone = false.obs;
  var oldpasswordVisibility = false.obs;
  var newpasswordVisibility = false.obs;
  var confirmpasswordVisibility = false.obs;

  ChangePasswordResp? changePasswordResp;

  final TextEditingController oldPassword = TextEditingController(text: "");
  final TextEditingController newPassword = TextEditingController(text: "");
  final TextEditingController confirmPassword = TextEditingController(text: "");

  final formKey = GlobalKey<FormState>();

  submit() {
    if (formKey.currentState!.validate()) {
      changePasswordApi();
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

  String? confirmPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "Confirm Password is required";
    }
    // else if (passwordValidator(value)) {
    //   return "invalid password";
    // }

    else if (newPassword.text != confirmPassword.text) {
      return "New password & old password not matching";
    }

    return null;
  }

  changePasswordApi() async {
    try {
      isDone.value = true;

      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: ChangePasswordModel(
              oldPassword: oldPassword.text,
              password: newPassword.text,
              passwordConfirmation: confirmPassword.text),
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.changePassword);

      print("changePasswordApi ==============");
      log(response.toString());
      changePasswordResp = ChangePasswordResp.fromJson(response);
      if (changePasswordResp?.success ?? false) {
        await HiveStore().put(Keys.accessToken, "");
        GoogleSignInApi.logout();
        FacebookSignInApi.logout();
        isDone.value = false;
        Get.offAllNamed(login);
        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
            message: changePasswordResp?.message ?? "",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.closeAllSnackbars();
        isDone.value = false;

        Get.showSnackbar(GetSnackBar(
            message: (changePasswordResp?.message ?? "Server Error") +
                " " +
                (changePasswordResp?.data ?? ""),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isDone.value = false;
      Get.showSnackbar(GetSnackBar(
          message: (changePasswordResp?.message ?? "Server Error") +
              " " +
              (changePasswordResp?.data ?? ""),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
