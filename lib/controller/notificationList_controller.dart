import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/notificationlist_model/chat_request/chat_request_model.dart';
import 'package:prospros/model/notificationlist_model/chat_request/chat_request_response_model.dart';
import 'package:prospros/model/notificationlist_model/notificationlist_response_mode.dart';
import 'package:prospros/model/notificationlist_model/read_notification_model/read_notification_model.dart';
import 'package:prospros/model/notificationlist_model/read_notification_model/read_notification_response_model.dart';
import 'package:prospros/util/app_util.dart';

class NotificationListController extends GetxController {
  ///used to show progress of api call
  var hasNotification = false.obs;
  var isThereAnyNotifications = false.obs;
  var isRequestDone = false.obs;
  var isReadNotificationDone = false.obs;

  NotificationListResponseModel? notificationListResponseModel;
  ChatRequestResponseModel? chatRequestResponseModel;
  ReadNotificationResponseModel? readNotificationResponseModel;
  var notificationList = <Data>[].obs;

  @override
  onReady() {
    getNotificationList();
    super.onReady();
  }

  acceptRejectChatRequest(
      {required int receiverId,
      required int senderId,
      required String isAccept}) async {
    isRequestDone.value = true;

    try {
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: ChatRequestModel(
                  receiverId: receiverId,
                  senderId: senderId,
                  isAccept: isAccept)
              .toJson(),
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.chatRequest);

      print("acceptRejectChatRequest ==============");
      log(response.toString());

      chatRequestResponseModel = ChatRequestResponseModel.fromJson(response);

      if (chatRequestResponseModel!.success!) {
        isRequestDone.value = false;
      } else {
        Get.closeAllSnackbars();
        isRequestDone.value = false;
        Get.showSnackbar(GetSnackBar(
            message: notificationListResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isRequestDone.value = false;
      Get.showSnackbar(GetSnackBar(
          message: notificationListResponseModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  getNotificationList() async {
    hasNotification.value = true;
    Apputil.showProgressDialouge();
    try {
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.notificationList);

      print("getNotificationList ==============");
      log(response.toString());

      notificationListResponseModel =
          NotificationListResponseModel.fromJson(response);

      if (notificationListResponseModel!.success!) {
        hasNotification.value = false;
        if (notificationListResponseModel?.data?.isNotEmpty ?? false) {
          isThereAnyNotifications.value = true;
        }
      } else {
        Get.closeAllSnackbars();
        hasNotification.value = false;
        Get.showSnackbar(GetSnackBar(
            message: notificationListResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
      Apputil.closeProgressDialouge();
    } catch (e) {
      Get.closeAllSnackbars();
      hasNotification.value = false;
      Apputil.closeProgressDialouge();
      Get.showSnackbar(GetSnackBar(
          message: notificationListResponseModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  Future<bool> readNotifications(int notificationId) async {
    //Receving 404 as response
    isReadNotificationDone.value = true;

    try {
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: ReadNotificationModel(notificationId: notificationId).toJson(),
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.readNotification);

      print("readNotificationResponseModel ==============");
      log(response.toString());

      readNotificationResponseModel =
          ReadNotificationResponseModel.fromJson(response);

      if (readNotificationResponseModel!.success!) {
        isReadNotificationDone.value = false;

        Get.showSnackbar(GetSnackBar(
            message: "Successfully marked as read",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        return true;
      } else {
        Get.closeAllSnackbars();
        isReadNotificationDone.value = false;
        Get.showSnackbar(GetSnackBar(
            message: readNotificationResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        return false;
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isReadNotificationDone.value = false;
      Get.showSnackbar(GetSnackBar(
          message: readNotificationResponseModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return false;
    }
  }
}
