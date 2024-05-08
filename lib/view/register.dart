import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/register_screen_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/validator.dart';
import 'package:prospros/widgets/custom_dropdown.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import '../constants/color.dart';
import '../widgets/internet_snackbar.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Obx(
      () => ModalProgressHUD(
        inAsyncCall: registerController.isCountryListLoaded.value,
        progressIndicator: CircularProgressIndicator(
          color: Color(0xff2643E5),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: AppStyle.spacerHeight),
                    const Text(AppTitle.registerNow,
                        style: AppStyle.loginTxtStyle),
                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    const Text(AppTitle.enterInformation),
                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    const Text(AppTitle.fullName),
                    const Material(child: SizedBox(height: 8)),
                    CustomTextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z ]')),
                          LengthLimitingTextInputFormatter(22),
                        ],
                        validator: (String? value) => value!.isEmpty
                            ? 'Enter Your Name'
                            : RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                    .hasMatch(value)
                                ? 'Enter a Valid Name'
                                : null,
                        controller: registerController.nameController,
                        labelTxt: AppTitle.fullNameHintTxt,
                        hintTxt: AppTitle.fullNameHintTxt),
                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    const Text(AppTitle.emailId),
                    const Material(
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                      ),
                    ),
                    CustomTextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9@.]')),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          }
                          // if (!(value.length > 5 &&
                          //     value.contains('@') &&
                          //     value.endsWith('.com'))) {
                          //   return "Enter valid Email";
                          // }
                          if (EmailValidator.validate(value.trim()) == false) {
                            return "Enter a Valid Email";
                          }

                          return null;
                        },
                        controller: registerController.emailController,
                        labelTxt: AppTitle.emailHintTxt,
                        hintTxt: AppTitle.emailHintTxt),
                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    const Material(child: Text(AppTitle.phoneNumber)),
                    const Material(
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                      ),
                    ),
                    phoneNumberField(),
                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    const Material(child: Text(AppTitle.location)),
                    const Material(
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                      ),
                    ),
                    CustomDropDown(
                      controller: registerController,
                    ),
                    const Material(
                        child: SizedBox(
                      height: 16,
                      width: double.infinity,
                    )),
                    const Text(AppTitle.password),
                    const Material(
                        child: SizedBox(
                      height: 8,
                      width: double.infinity,
                    )),

                    CustomTextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      validator: (String? value) =>
                          validator(value, "Password is required"),
                      controller: registerController.passwordController,
                      obscureText: !registerController.passwordVisibility.value,
                      labelTxt: AppTitle.passwordHintTxt,
                      hintTxt: AppTitle.passwordHintTxt,
                      suffixIcon: IconButton(
                        icon: Icon(
                          registerController.passwordVisibility.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          //color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          print("Icon Pressed.......");
                          registerController.togglePasswordVisibility();
                        },
                      ),
                    ),

                    const Material(
                        child: SizedBox(
                      height: 16,
                      width: double.infinity,
                    )),
                    const Text(AppTitle.confirmPassword),
                    const Material(
                      child: SizedBox(
                        height: 8,
                        width: double.infinity,
                      ),
                    ),
                    CustomTextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Confirm Password is required";
                          } else if (registerController.validatePassword() ==
                              false) {
                            return "Confirm Password should match with password";
                          }
                          return null;
                        },
                        //validator(value, "Confirm Password is required"),
                        controller: registerController.cPasswordController,
                        obscureText:
                            !registerController.confPasswordVisibility.value,
                        labelTxt: AppTitle.confirmPasswordHintTxt,
                        suffixIcon: IconButton(
                            icon: Icon(
                              registerController.confPasswordVisibility.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              //color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              print("Icon Pressed.......");
                              registerController.confPasswordVisibility.value =
                                  !registerController
                                      .confPasswordVisibility.value;
                            }),
                        hintTxt: AppTitle.confirmPasswordHintTxt),

                    const Material(
                      child: SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () async {
                            registerController.registerValidate.value = true;
                            if (formKey.currentState!.validate()) {
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (result) {
                                registerController.register();
                              } else {
                                noInternetConnection();
                              }
                            }
                          },
                          child: const Text(AppTitle.submit)),
                    ),
                    const SizedBox(height: AppStyle.spacerHeight),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: AppTitle.haveAccount,
                          style: const TextStyle(
                              color: Colors
                                  .black), //DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(text: " "),
                            TextSpan(
                              text: AppTitle.login,
                              style: const TextStyle(color: Colors.red),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(login);
                                },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )));
  }
}

Widget phoneNumberField() {
  RegisterController registerController = Get.find<RegisterController>();

  return Obx(
    () => IntlPhoneField(
        //controller: registerController.contactNumberController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: (text) => AppUtils.validatePhone(text?.number ?? ""),
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.allow(RegExp(r"[0-9]+|\s")),
        //   LengthLimitingTextInputFormatter(15)
        // ],
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            // errorStyle: AppTextStyles().valErrorTextStyle,
            hintText: AppTitle.phoneNumberHintTxt,
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    width: 1,
                    color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    width: 1,
                    color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    style: BorderStyle.solid,
                    width: 1,
                    color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.all(0)),
        cursorColor: Colors.black,
        initialCountryCode:
            registerController.hasCountry.value == true ? 'AF' : 'IN',
        style: const TextStyle(color: Colors.black, fontSize: 16),
        dropdownTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
        dropdownIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        onCountryChanged: (country) {
          registerController.updateCountryCode(country.dialCode);
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (str) {
          printRed("#### Submitted");
        },
        onSaved: (val) {
          printRed("#### onsaved called");
        },
        onChanged: (phone) {
          debugPrint(phone.countryCode);
          debugPrint(phone.completeNumber);
          registerController.updateContactNumber(phone.number);
          registerController.updateCountryCode(phone.countryCode);

          // registerController.contactNumberController.value =     phone.countryCode +  phone.completeNumber;
        }),
  );
}
