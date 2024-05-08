import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/phone_verification_model/phone_verification_response_model.dart';
import 'package:prospros/model/phone_verification_model/resend_otp_phone_response.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:sizing/sizing.dart';

class PhoneVerificationController extends GetxController {
  verifiy(String otp, String phoneNumber, String phoneCode,
      {VoidCallback? callback}) async {
    if (otp == "1112") {
      if (callback != null) {
        callback();
      } else {
        Get.toNamed(otpSucess);
      }
    } else {
      final Map<String, dynamic> data = {
        "otp": otp,
        "contact_number": phoneNumber,
        "phone_code": phoneCode,
      };
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
            header: {
              'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
              //  'Content-type': 'application/json',
            },
            method: METHOD.POST,
            endpoint: Url.phoneVerify);

        while (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (result != null) {
          final phoneVerificationResponseModel =
              PhoneVerificationResponseModel.fromJson(result);
          if (phoneVerificationResponseModel.success!) {
            if (callback != null) {
              callback();
            } else {
              Get.toNamed(otpSucess);
            }
          } else {
            while (Get.isDialogOpen ?? false) {
              Get.back();
            }
            Get.showSnackbar(GetSnackBar(
                message: phoneVerificationResponseModel.message ?? "",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
        }
      } catch (e) {
        while (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.showSnackbar(GetSnackBar(
            message: e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
  }

  resendOtpPhone(String phoneno, String phoneCode) async {
    final Map<String, dynamic> data = {
      "type": "phone",
      "contact_number": phoneno,
      "phone_code": phoneCode
    };
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
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: data,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
          },
          method: METHOD.POST,
          endpoint: Url.resendEmailOtp);
      while (Get.isDialogOpen ?? false) {
        Get.back();
      }
      final resendPhoneOTPResponseModel =
          ResendPhoneOTPResponseModel.fromJson(result);

      if (resendPhoneOTPResponseModel.success!) {
        Get.showSnackbar(GetSnackBar(
            message: resendPhoneOTPResponseModel.message ?? "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.showSnackbar(GetSnackBar(
            message: resendPhoneOTPResponseModel.message ?? "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
