import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers/print.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:prospros/controller/two_factor_veri_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_appbar.dart';
import 'package:prospros/widgets/internet_snackbar.dart';
import 'package:sizing/sizing.dart';

class TwoFactorVerificationScreen extends StatelessWidget {
  TwoFactorVerificationScreen(
      {super.key,
      required this.onVerify,
      required this.email,
      required this.password});
  //when user will be verified then this will be called to set trigger state to true
  Function onVerify;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(TwoFactVeriController(email: email, password: password));
    return Scaffold(
      appBar: CustomAppBarV2(
        title: "",
        enableBackgroundColor: true,
        onTap: () {
          Get.back(result: false);
        },
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 50,
                color: Apputil.getActiveColor(),
              ),
              SizedBox(
                height: 20.ss,
              ),
              Text(
                "Two-Factor Authentication",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.ss),
              ),
              Text(
                "Please enter the verification code sent to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.ss),
              ),
              SizedBox(
                height: 30.ss,
              ),
              Form(
                key: controller.formKey,
                child: PinCodeTextField(
                  mainAxisAlignment: MainAxisAlignment.center,
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  obscureText: true,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    // if (v!.length < 3) {
                    //   return "I'm from validator";
                    // } else {
                    return null;
                    // }
                  },
                  pinTheme: PinTheme(
                      fieldOuterPadding: const EdgeInsets.only(right: 20),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40,
                      fieldWidth: 40,
                      inactiveColor: const Color(0XFFE4E6EC),
                      selectedColor: const Color(0XFFE4E6EC),
                      activeColor: const Color(0XFFE4E6EC),
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      errorBorderColor: Colors.red),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: controller.otpTextController,
                  keyboardType: TextInputType.numberWithOptions(),
                  // boxShadows: const [
                  //   BoxShadow(
                  //     offset: Offset(0, 1),
                  //     color: Colors.black12,
                  //     blurRadius: 10,
                  //   )
                  // ],
                  onCompleted: (v) {
                    debugPrint("Completed");
                    controller.isOtpEntered.value = true;
                    controller.otpTextController.text = v;
                  },

                  onChanged: (value) async {
                    printBlack("on change");
                    controller.isOtpEntered.value = false;
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          onPressed: controller.isResendEnable.value
                              ? controller.resendOtp
                              : null,
                          child: Text("Resend")),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                      width: 120,
                      child: Obx(
                        () => ElevatedButton(
                            onPressed: controller.isOtpEntered.value
                                ? () async {
                                    //below textEditingController is redundant
                                    // textEditingController.text = value;
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result) {
                                      await controller.verifyOtp(onVerify);
                                    } else {
                                      noInternetConnection();
                                    }
                                  }
                                : null,
                            child: Text("Verify")),
                      ))
                ],
              ),
              SizedBox(
                height: 10.ss,
              ),
              Obx(() => controller.isResendEnable.value
                  ? Text("")
                  : Text(
                      "Resend OTP in ${controller.timeElapsedString}",
                      style: TextStyle(color: Colors.grey),
                    ))
            ]),
      ),
    );
  }
}
