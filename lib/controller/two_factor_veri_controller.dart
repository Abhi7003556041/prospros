import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/email_verification_model/email_verification_response_model.dart';
import 'package:prospros/model/email_verification_model/resend_otp_email_response.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/util/app_util.dart';

class TwoFactVeriController extends GetxController {
  TwoFactVeriController({required this.email, required this.password});
  TextEditingController otpTextController = TextEditingController();
  Timer? resendTimer;
  var isResendEnable = false.obs;
  static const int RESEND_TIME = 180; //in seconds
  final elasedSeconds = 0.obs;
  final timeElapsedString = "3:00".obs;
  Duration _totalTime = Duration(seconds: RESEND_TIME);

  var isOtpEntered = false.obs;

  @override
  void onReady() {
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      isResendEnable.value = false;
      elasedSeconds.value = timer.tick;

      var remainingTime = _totalTime - Duration(seconds: elasedSeconds.value);
      var remainingTimeinMinuts = remainingTime.inMinutes;
      var remainingTimeinSec =
          remainingTime.inSeconds - remainingTime.inMinutes;

      timeElapsedString.value =
          "${formatMinute(remainingTimeinMinuts)}:${formatSeconds(remainingTimeinSec)}";
      if (timer.tick == RESEND_TIME) {
        timer.cancel();
        resendTimer?.cancel();
        isResendEnable.value = true;
      }
    });
    super.onReady();
  }

  final formKey = GlobalKey<FormState>();

  final String email;
  final String password;
  Future<void> resendOtp() async {
    try {
      Apputil.showProgressDialouge();
      final Map<String, dynamic> data = {"type": "email", "email": email};
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: data,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
          },
          method: METHOD.POST,
          endpoint: Url.resendEmailOtp);

      final resendEmailOTPResponseModel =
          ResendEmailOTPResponseModel.fromJson(result);
      Apputil.closeProgressDialouge();
      if (resendEmailOTPResponseModel.success!) {
        setupResendTimer();
        Get.showSnackbar(GetSnackBar(
            // message: resendEmailOTPResponseModel.message ?? "Server Error",
            message: "OTP sent successfully",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.showSnackbar(GetSnackBar(
            message: resendEmailOTPResponseModel.message ?? "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error, try again!",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  setupResendTimer() {
    resendTimer?.cancel();
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      isResendEnable.value = false;
      elasedSeconds.value = timer.tick;

      var remainingTime = _totalTime - Duration(seconds: elasedSeconds.value);
      var remainingTimeinMinuts = remainingTime.inMinutes;
      var remainingTimeinSec =
          remainingTime.inSeconds - remainingTime.inMinutes;

      timeElapsedString.value =
          "${formatMinute(remainingTimeinMinuts)}:${formatSeconds(remainingTimeinSec)}";
      if (timer.tick == RESEND_TIME) {
        timer.cancel();
        resendTimer?.cancel();
        isResendEnable.value = true;
      }
    });
  }

  Future<void> verifyOtp(Function callback) async {
    Apputil.showProgressDialouge();

    final Map<String, dynamic> data = {
      "otp": otpTextController.text,
      "email": email,
      "password": password
    };
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: data,
          // header: {
          //   'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
          //   // 'Content-type': 'application/json',
          // },
          method: METHOD.POST,
          endpoint: Url.twoFactorLogin);
      Apputil.closeProgressDialouge();
      if (result != null) {
        final loginResponseModel = LoginResponseModel.fromJson(result);

        if (loginResponseModel.success ?? false) {
          Get.closeAllSnackbars();
          callback(loginResponseModel);
          await Get.showSnackbar(GetSnackBar(
              message: "You are authorized successfully.",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          Get.back();
          return;
        } else {
          await Future.delayed(Duration.zero);
          await Get.showSnackbar(GetSnackBar(
              message: loginResponseModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          // printRed(Get.previousRoute + "#######");
          await Future.delayed(Duration.zero);
        }
        // await Get.showSnackbar(GetSnackBar(
        //     message: loginResponseModel.message,
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: Duration(seconds: 2),
        //     margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      Get.showSnackbar(GetSnackBar(
          message: "Wrong OTP, try again!!",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  @override
  void onClose() {
    resendTimer?.cancel();
    super.onClose();
  }

  String formatMinute(int minute) {
    return (minute % 60).toString().padLeft(2, '0');
  }

  String formatSeconds(int sec) {
    return (sec % 60).toString().padLeft(2, '0');
  }
}
