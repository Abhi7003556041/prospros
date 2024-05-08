import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/controller/account_screen_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final controller = Get.put(AccountScreenController());

  String? countryDropDownValue = "Australia";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        const Text("Account",
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w200)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 48,
              ),
              const Text("Name"),
              Obx(
                () => controller.isNameEditable.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: CustomTextFormField(
                                onChanged: (String? val) {
                                  controller.name.value = val!;
                                },
                                labelTxt:
                                    controller.name.value, //"Robert John",
                                initialValue:
                                    controller.name.value, //"Robert John",
                                hintTxt: controller.name.value,
                                labelTextStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: FittedBox(
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0))),
                                  onPressed: () {
                                    controller.UpdateAccount();
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff2643E5)),
                                  )),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.name.value,
                            style: TextStyle(color: Color(0xff797979)),
                          ),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: FittedBox(
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0))),
                                  onPressed: () {
                                    controller.isNameEditable.value = true;
                                  },
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff2643E5)),
                                  )),
                            ),
                          )
                        ],
                      ),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text("Email"),
              Container(
                height: 40,
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(controller.email.value,
                    style: TextStyle(color: Color(0xff797979))),
              ),

              // Obx(
              //   () => controller.isEmailEditable.value
              //       ? Padding(
              //           padding: EdgeInsets.only(top: 8.0),
              //           child: CustomTextFormField(
              //             labelTxt:
              //                 controller.email.value, //"robertjohn@gmail.com",
              //             initialValue:
              //                 controller.email.value, //"robertjohn@gmail.com",
              //             hintTxt:
              //                 controller.email.value, //"robertjohn@gmail.com",
              //             labelTextStyle: TextStyle(fontSize: 12),
              //           ),
              //         )
              //       : Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(controller.email.value,
              //                 style: TextStyle(color: Color(0xff797979))),
              //             SizedBox(
              //               width: 60,
              //               height: 40,
              //               child: FittedBox(
              //                 child: TextButton(
              //                     style: ButtonStyle(
              //                         padding: MaterialStateProperty.all(
              //                             EdgeInsets.all(0))),
              //                     onPressed: () {
              //                       controller.isEmailEditable.value = true;
              //                     },
              //                     child: const Text(
              //                       "Edit",
              //                       style: TextStyle(
              //                           fontSize: 14, color: Color(0xff2643E5)),
              //                     )),
              //               ),
              //             )
              //           ],
              //         ),
              // ),
              const SizedBox(
                height: 32,
              ),
              const Text("Phone Number"),
              Container(
                height: 40,
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  controller.phone.value,
                  // "+91 ▼ 1234567890",
                  style: TextStyle(color: Color(0xff797979)),
                ),
              ),
              // Obx(
              //   () => controller.isPhoneEditable.value
              //       ? Padding(
              //           padding: const EdgeInsets.only(top: 8.0),
              //           child: phoneNumberField(),
              //         )
              //       : Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               controller.phone.value,
              //               // "+91 ▼ 1234567890",
              //               style: TextStyle(color: Color(0xff797979)),
              //             ),
              //             SizedBox(
              //               width: 60,
              //               height: 40,
              //               child: FittedBox(
              //                 child: TextButton(
              //                     style: ButtonStyle(
              //                         padding: MaterialStateProperty.all(
              //                             const EdgeInsets.all(0))),
              //                     onPressed: () {
              //                       controller.isPhoneEditable.value = true;
              //                     },
              //                     child: const Text(
              //                       "Edit",
              //                       style: TextStyle(
              //                           fontSize: 14, color: Color(0xff2643E5)),
              //                     )),
              //               ),
              //             )
              //           ],
              //         ),
              // ),
              const SizedBox(
                height: 32,
              ),
              const Text("Location"),
              Container(
                height: 40,
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  controller.location.value,
                  style: TextStyle(color: Color(0xff797979)),
                ),
              ),
              // Obx(
              //   () => controller.isLocationEditable.value
              //       ? Padding(
              //           padding: const EdgeInsets.only(top: 8.0),
              //           child: dropDownBtn(),
              //         )
              //       : Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               controller.location.value,
              //               //   "Australia",
              //               style: TextStyle(color: Color(0xff797979)),
              //             ),
              //             SizedBox(
              //               width: 60,
              //               height: 40,
              //               child: FittedBox(
              //                 child: TextButton(
              //                     style: ButtonStyle(
              //                         padding: MaterialStateProperty.all(
              //                             const EdgeInsets.all(0))),
              //                     onPressed: () {
              //                       controller.isLocationEditable.value = true;
              //                     },
              //                     child: const Text(
              //                       "Edit",
              //                       style: TextStyle(
              //                           fontSize: 14, color: Color(0xff2643E5)),
              //                     )),
              //               ),
              //             )
              //           ],
              //         ),
              // ),
              const SizedBox(
                height: 32,
              ),
              controller.isSocialLoginUser.value
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        const BorderSide(color: Colors.black))),
                                onPressed: () {
                                  Get.toNamed(changePassword);
                                },
                                child: const Text(
                                  "Change Password",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.redAccent.withOpacity(.5))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Obx(() => ModalProgressHUD(
                              inAsyncCall: controller.isDeleting.value,
                              child: AlertDialog(
                                title: const Text('Account Deletion'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Are you sure you want to Delete your Account?'),
                                      CheckboxMenuButton(
                                          value:
                                              controller.isAdminCheckBox.value,
                                          onChanged: controller.toggleCheckBox,
                                          child: Text(
                                              "Allow Admin to delete your Data.")),
                                      CheckboxMenuButton(
                                          value:
                                              !controller.isAdminCheckBox.value,
                                          onChanged: controller.toggleCheckBox,
                                          child: Text("I will delete my Data."))
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      controller.deleteAccount();
                                    },
                                  ),
                                ],
                              )));
                        });
                  },
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Container dropDownBtn() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(3)),
      child: DropdownButton<String>(
        value: countryDropDownValue,
        borderRadius: BorderRadius.circular(3),
        hint: const Text("Select Country"),
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: Colors.black,
        ),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        isExpanded: true,
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            countryDropDownValue = value!;
          });
        },
        items: ["Australia", "U.S.A", "India", "New Zealand", "Pakistan"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget phoneNumberField() {
    return IntlPhoneField(
      controller: controller.phoneTextController,
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
      initialCountryCode: 'IN',
      style: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),
      onChanged: (phone) {
        debugPrint(phone.countryCode);
        debugPrint(phone.completeNumber);
      },
    );
  }
}
