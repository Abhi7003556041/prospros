import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/disc_terms/disc_terms_model.dart';
import 'package:prospros/util/app_util.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class DisclaimerAndTermsController extends GetxController {
  DisclaimerTermsRes? disclaimerTermsRes;
  var isResLoaded = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    loadDiscalimerContent();
    getTimeZoneInformation();
    super.onReady();
  }

  getTimeZoneInformation() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    printRed(currentTimeZone);
  }

  loadDiscalimerContent() async {
    try {
      isResLoaded.value = false;
      Apputil.showProgressDialouge();
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.GET,
        endpoint: Url.disclaimer_terms,
      );

      Apputil.closeProgressDialouge();
      if (result != null) {
        disclaimerTermsRes = DisclaimerTermsRes.fromJson(result);
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
