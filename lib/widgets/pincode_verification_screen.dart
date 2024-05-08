import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/email_verification_controller.dart';
import 'package:prospros/controller/phone_verification_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';

import 'internet_snackbar.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  PinCodeVerificationScreen(
      {Key? key,
      this.isEmail = true,
      this.onVerificationCompleted,
      this.email,
      this.phone,
      this.countryCode})
      : assert(isEmail == true ? email != null : phone != null),
        super(key: key);
  VoidCallback? onVerificationCompleted;

  final bool isEmail;
  final String? email;
  final String? phone;
  final String? countryCode;

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  //bool hasError = false;
  //String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EmailVerificationController emailVerificationController =
        Get.put(EmailVerificationController());
    PhoneVerificationController phoneVerificationController =
        Get.put(PhoneVerificationController());

    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 160),
              SvgPicture.asset(
                  widget.isEmail ? AppImage.email : AppImage.phone),
              const SizedBox(height: 32),
              Text(
                widget.isEmail
                    ? AppTitle.emailVerification
                    : AppTitle.phoneVerification,
                style: const TextStyle(
                    fontFamily: AppTitle.fontMedium, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(AppTitle.receivedCode1,
                  style:
                      TextStyle(fontSize: 14, color: AppColor.emailFontColor)),
              Text(
                  widget.isEmail
                      ? AppTitle.receivedCodeEmail
                      : AppTitle.receivedCodePhone,
                  style: const TextStyle(
                      fontSize: 14, color: AppColor.emailFontColor)),
              const SizedBox(height: 40),
              const Text(AppTitle.enterCode,
                  style:
                      TextStyle(fontSize: 14, color: AppColor.emailFontColor)),
              const SizedBox(height: 8),
              Form(
                key: formKey,
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
                  errorAnimationController: errorController,
                  controller: textEditingController,
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
                  },

                  onChanged: (value) async {
                    if (value.length == 4) {
                      //below textEditingController is redundant
                      // textEditingController.text = value;
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result) {
                        if (widget.isEmail) {
                          emailVerificationController.verifiy(
                              value, widget.email!,
                              callback: widget.onVerificationCompleted);
                        } else {
                          phoneVerificationController.verifiy(
                              value, widget.phone!, widget.countryCode!,
                              callback: widget.onVerificationCompleted);
                        }
                      } else {
                        noInternetConnection();
                      }
                    }
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppTitle.didNotReceiveCode,
                    style: TextStyle(
                        color: AppColor.emailFontColor2, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result) {
                        widget.isEmail
                            ? emailVerificationController.resendOtpEmail()
                            : phoneVerificationController.resendOtpPhone(
                                widget.phone!, widget.countryCode!);
                      } else {
                        noInternetConnection();
                      }
                    },
                    child: const Text(
                      AppTitle.resendCode,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                side: const BorderSide(
                                    color: AppColor
                                        .emailCancelFontColor), //border width and color
                              ),
                              onPressed: () {
                                // if (widget.onVerificationCompleted != null) {
                                //   Get.back();
                                // } else {
                                //   Get.toNamed(register);
                                // }
                                Get.offAndToNamed(login);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.emailCancelFontColor),
                              ))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (textEditingController.text.length != 4) {
                              Get.closeAllSnackbars();
                              Get.showSnackbar(GetSnackBar(
                                  message: "Enter valid OTP",
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.only(
                                      bottom: 20, left: 0, right: 0)));
                            }
                          },
                          child: const Center(
                              child: Text(
                            AppTitle.continueBtn,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
