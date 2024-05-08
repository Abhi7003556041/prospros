import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/complete_user_profile_controller.dart';
import 'package:prospros/controller/login_screen_controller.dart';
import 'package:prospros/widgets/custom_dropdown.dart';

import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:prospros/widgets/internet_snackbar.dart';
import 'package:sizing/sizing.dart';

///This will be used to fill remaining profiledetails while user choose social login
class CompleteUserProfile extends StatelessWidget {
  CompleteUserProfile(
      {super.key,
      required this.completeProfileAttributes,
      required this.callBack});
  final CompleteProfileAttributes completeProfileAttributes;
  final formKey = GlobalKey<FormState>();
  final CompleteUserProfileController completeUserProfileController =
      Get.put(CompleteUserProfileController());

  ///this is used to track whether user has sumitted required value or not
  final Function callBack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
              child: Obx(
            () => GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ModalProgressHUD(
                  inAsyncCall:
                      completeUserProfileController.progressLoader.value,
                  progressIndicator: CircularProgressIndicator(
                    color: Color(0xff2643E5),
                  ),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Complete your profile details",
                                    style: AppStyle.loginTxtStyle),
                                completeProfileAttributes.isNameAvailable
                                    ? SizedBox()
                                    : nameField(),
                                completeProfileAttributes.isEmailAvailable
                                    ? SizedBox()
                                    : emailField(),
                                completeProfileAttributes.isPhoneNumberAvailable
                                    ? SizedBox()
                                    : phoneField(),
                                completeProfileAttributes.isCountryAvailable
                                    ? SizedBox()
                                    : countryField(),
                              ]),
                        ),
                      ),
                    ),
                  )),
            ),
          )),
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(left: 8.0.ss, right: 8.0.ss, bottom: 25.0.ss),
          child: ElevatedButton(
            child: Text("Update"),
            onPressed: () async {
              completeUserProfileController.registerValidate.value = true;
              if (formKey.currentState!.validate()) {
                bool result = await InternetConnectionChecker().hasConnection;
                if (result) {
                  callBack(
                      phoneNumber:
                          completeUserProfileController.contactNumber.value,
                      phoneCode:
                          completeUserProfileController.hasCountry.value !=
                                  false
                              ? completeUserProfileController
                                  .country.value.phonecode
                                  .toString()
                              : "",
                      mail: completeUserProfileController.emailController.text,
                      countryid:
                          completeUserProfileController.hasCountry.value !=
                                  false
                              ? completeUserProfileController.country.value.id
                                  .toString()
                              : "",
                      nameDet:
                          completeUserProfileController.nameController.text);
                } else {
                  noInternetConnection();
                }
              }
            },
          ),
        ),
      ),
    );
  }

  emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text("Email id"),
        const SizedBox(height: 8),
        CustomTextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@.]')),
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
            controller: completeUserProfileController.emailController,
            labelTxt: AppTitle.emailHintTxt,
            hintTxt: AppTitle.emailHintTxt),
      ],
    );
  }

  nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text("Email id"),
        const SizedBox(height: 8),
        CustomTextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
              LengthLimitingTextInputFormatter(22),
            ],
            keyboardType: TextInputType.name,
            validator: (String? value) => value!.isEmpty
                ? 'Enter Your Name'
                : RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)
                    ? 'Enter a Valid Name'
                    : null,
            controller: completeUserProfileController.nameController,
            labelTxt: AppTitle.fullNameHintTxt,
            hintTxt: AppTitle.fullNameHintTxt),
      ],
    );
  }

  phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(AppTitle.phoneNumber),
        const SizedBox(height: 8),
        phoneNumberField(),
      ],
    );
  }

  countryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(AppTitle.location),
        const SizedBox(height: 8),
        CustomDropDown(
          controller: completeUserProfileController,
        ),
      ],
    );
  }

  Widget phoneNumberField() {
    return Obx(
      () => IntlPhoneField(
          //controller: registerController.contactNumberController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: (text) => AppUtils.validatePhone(text?.number ?? ""),
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.allow(RegExp(r"[0-9]+|\s")),
          //   LengthLimitingTextInputFormatter(15)
          // ],
          textInputAction: TextInputAction.next,
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
              completeUserProfileController.hasCountry.value == true
                  ? 'AF'
                  : 'IN',
          style: const TextStyle(color: Colors.black, fontSize: 16),
          dropdownTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
          dropdownIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          onCountryChanged: (country) {
            completeUserProfileController.updateCountryCode(country.dialCode);
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (phone) {
            debugPrint(phone.countryCode);
            debugPrint(phone.completeNumber);
            completeUserProfileController.updateContactNumber(phone.number);
            completeUserProfileController.updateCountryCode(phone.countryCode);

            // registerController.contactNumberController.value =     phone.countryCode +  phone.completeNumber;
          }),
    );
  }
}
