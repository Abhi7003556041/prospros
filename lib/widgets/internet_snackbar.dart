import 'package:flutter/material.dart';
import 'package:get/get.dart';

noInternetConnection() {
  Get.closeAllSnackbars();
  Get.showSnackbar(GetSnackBar(
    snackPosition: SnackPosition.BOTTOM,
    message: "No Internet Connection, Please connect to Internet & try again!",
    duration: Duration(seconds: 2),
    margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
  ));
}
