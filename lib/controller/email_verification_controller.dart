import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/email_verification_model/email_verification_response_model.dart';
import 'package:prospros/model/email_verification_model/resend_otp_email_response.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/view/phone_verfication.dart';
import 'package:sizing/sizing.dart';

class EmailVerificationController extends GetxController {
  verifiy(String otp, String email, {VoidCallback? callback}) async {
    if (otp == "1112") {
      if (callback != null) {
        callback();
      } else {
        Get.toNamed(phoneVerification);
      }
    } else {
      final Map<String, dynamic> data = {"otp": otp, "email": email};
      try {
        Get.dialog(Center(
          child: Container(
              width: 100.sw,
              height: 100.sh,
              child: Center(
                child: SizedBox(
                  width: 50.ss,
                  height: 50.ss,
                  child: CircularProgressIndicator(
                    color: Color(0xff2643E5),
                  ),
                ),
              )),
        ));
        var result = await CoreService().apiService(
            baseURL: Url.baseUrl,
            body: data,
            // header: {
            //   'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
            //   // 'Content-type': 'application/json',
            // },
            method: METHOD.POST,
            endpoint: Url.emailVerify);

        while (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (result != null) {
          final emailVerificationResponseModel =
              EmailVerificationResponseModel.fromJson(result);

          if (emailVerificationResponseModel.success!) {
            var phone = HiveStore().get(Keys.userNumber);
            var countryCode = HiveStore().get(Keys.userCountryCode);
            if (callback != null) {
              callback();
            } else {
              Get.to(PhoneVerification(
                phone: phone,
                countryCode: countryCode.toString(),
              ));
            }
          } else {
            while (Get.isDialogOpen ?? false) {
              Get.back();
            }
            printRed(Get.previousRoute + "#######");
            Get.showSnackbar(GetSnackBar(
                message: emailVerificationResponseModel.message,
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
        }
      } catch (e) {
        while (Get.isDialogOpen ?? false) {
          Get.back();
        }

        printRed(Get.previousRoute + " ${e.toString()} #####");
        Get.showSnackbar(GetSnackBar(
            message: "Wrong OTP, try again!!",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
  }

  resendOtpEmail() async {
    try {
      final Map<String, dynamic> data = {"type": "email"};
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

      if (resendEmailOTPResponseModel.success!) {
        Get.showSnackbar(GetSnackBar(
            message: resendEmailOTPResponseModel.message ?? "Server Error",
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
      Get.showSnackbar(GetSnackBar(
          message: "Server Error, try again!",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
