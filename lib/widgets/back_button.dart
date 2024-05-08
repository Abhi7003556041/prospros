import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBackButton {
  static Widget stackBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffF2F3F6),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget prefferedSizeBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffF2F3F6),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              FocusScope.of(Get.context!).unfocus();
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
