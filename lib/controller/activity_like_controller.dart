import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/acitivity_like_list/activitylike_list_resp_model.dart';
import 'package:prospros/util/app_util.dart';
import '../Service/Url.dart';

class ActivityLikeController extends GetxController {
  var isLikesLoading = false.obs;

  ActivityLikeListRespModel? activityLikeListRespModel;

  RxList<LikeData> likeData = <LikeData>[].obs;

  var totalCount = 0.obs;

  var page = 1.obs;
  var isNewPage = false.obs;

  @override
  onReady() {
    getActivityLikes();
    super.onReady();
  }

  @override
  void dispose() {
    Get.delete<ActivityLikeController>();
    super.dispose();
  }

  NextPageActivityLike() {
    final data = activityLikeListRespModel?.data;
    if (data?.total != likeData.length && isNewPage.value == false) {
      isNewPage.value = true;
      page += 1;
      getActivityLikes();
    }
  }

  getActivityLikes() async {
    try {
      isLikesLoading.value = true;
      //Apputil.showProgressDialouge();
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: {"page": page.value},
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.activityLikeList);

      print("activityLikeList ==============");
      log(response.toString());

      activityLikeListRespModel = ActivityLikeListRespModel.fromJson(response);
      totalCount.value = activityLikeListRespModel?.data?.total ?? 0;

      if (activityLikeListRespModel?.data?.likeData != null) {
        likeData.addAll(activityLikeListRespModel!.data!.likeData!);
        likeData.refresh();
        update();
      }
      if (activityLikeListRespModel!.success!) {
        isLikesLoading.value = false;
        isNewPage.value = false;
      } else {
        Get.closeAllSnackbars();
        isLikesLoading.value = false;
        isNewPage.value = false;

        Get.showSnackbar(GetSnackBar(
            message: activityLikeListRespModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
      // Apputil.closeProgressDialouge();
    } catch (e) {
      Get.closeAllSnackbars();
      Apputil.closeProgressDialouge();
      isLikesLoading.value = false;
      isNewPage.value = false;
      Get.showSnackbar(GetSnackBar(
          message: activityLikeListRespModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
