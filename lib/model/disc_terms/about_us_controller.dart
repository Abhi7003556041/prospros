import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/disc_terms/disc_terms_model.dart';
import 'package:prospros/util/app_util.dart';

class AboutUsController extends GetxController {
  DisclaimerTermsRes? aboutUs;
  var isResLoaded = true.obs;

  @override
  void onReady() {
    loadAboutUsContent();
    super.onReady();
  }

  loadAboutUsContent() async {
    try {
      isResLoaded.value = false;
      Apputil.showProgressDialouge();
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.GET,
        endpoint: Url.about_us,
      );

      Apputil.closeProgressDialouge();
      if (result != null) {
        aboutUs = DisclaimerTermsRes.fromJson(result);
        isResLoaded.value = true;
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Something went wrong. Please try again after some time",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      isResLoaded.value = false;
      Apputil.closeProgressDialouge();
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
