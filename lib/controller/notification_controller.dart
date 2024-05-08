import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/model/notification_model/notification_model.dart';
import 'package:prospros/model/notification_model/notification_response_model.dart';
import 'package:prospros/model/view_notification_preference/view_notification_preference_response.dart';

class NotificationController extends GetxController {
  var pushMessage = false.obs;
  var smsMessage = false.obs;

  var pushPayment = false.obs;
  var smsPayment = false.obs;

  var pushQueries = false.obs;

  var pushlike = false.obs;

  var pushForget = false.obs;

  var notificationType = "".obs;
  var pushNotification = "".obs;
  var smsNotification = "".obs;

  var isPushNotification = true.obs;
  var hasPreferenceUpdated = false.obs;
  var hasPreferenceLoaded = false.obs;

  NotificationResponseModel? notificationResponseModel;
  ViewNotificationPreferenceResponse? viewNotificationPreferenceResponse;
  ScrollController scrollController = ScrollController();

  @override
  onInit() {
    super.onInit();
    setPreference();
  }

  bool stringToBool(String? str) {
    if (str == null || str.toLowerCase() == "null") {
      return false;
    }
    return str == "no" ? false : true;
  }

  setPreference() async {
    try {
      hasPreferenceLoaded.value = true;
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.viewNotificationPreference,
      );

      log('Authorization: Bearer  ${HiveStore().get(Keys.accessToken)}');

      if (result != null) {
        viewNotificationPreferenceResponse =
            ViewNotificationPreferenceResponse.fromJson(result);
        print("ViewNotificationPreferenceResponse=================");
        log(result.toString());

        if (viewNotificationPreferenceResponse!.success!) {
          final data = viewNotificationPreferenceResponse!.data ?? [];

          for (int i = 0; i < data.length; i++) {
            if (data[i].notificationType! == AppTitle.messageCommunityUsers) {
              pushMessage.value = stringToBool(data[i].pushNotification);
              smsMessage.value = stringToBool(data[i].smsNotification);
            } else if (data[i].notificationType! ==
                AppTitle.paymentSubscription) {
              pushPayment.value = stringToBool(data[i].pushNotification);
              smsPayment.value = stringToBool(data[i].smsNotification);
            } else if (data[i].notificationType! == AppTitle.queries) {
              pushQueries.value = stringToBool(data[i].pushNotification);
            } else if (data[i].notificationType! == AppTitle.likeComment) {
              pushlike.value = stringToBool(data[i].pushNotification);
            } else if (data[i].notificationType! == AppTitle.forgotPassword) {
              pushForget.value = stringToBool(data[i].pushNotification);
            }
          }

          hasPreferenceLoaded.value = false;
        } else {
          hasPreferenceLoaded.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: viewNotificationPreferenceResponse!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPreferenceLoaded.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: viewNotificationPreferenceResponse!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  updatePreference() async {
    try {
      final model = isPushNotification.value
          ? NotificationModel(
              notificationType: notificationType.value,
              pushNotification: pushNotification.value)
          : NotificationModel(
              notificationType: notificationType.value,
              smsNotification: smsNotification.value,
              isPushNotification: isPushNotification.value);

      print("model notification preference ===========");
      log(model.toString());

      hasPreferenceUpdated.value = true;
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.noticationPreference,
      );

      if (result != null) {
        notificationResponseModel = NotificationResponseModel.fromJson(result);
        print("notificationResponseModel=================");
        log(result.toString());

        if (notificationResponseModel!.success!) {
          hasPreferenceUpdated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: notificationResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        } else {
          hasPreferenceUpdated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: notificationResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPreferenceUpdated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: notificationResponseModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
