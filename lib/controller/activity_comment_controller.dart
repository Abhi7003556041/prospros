import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/activity_comment_list/activity_comment_list_response.dart';
import 'package:prospros/util/app_util.dart';

import '../Service/Url.dart';

class ActivityCommentController extends GetxController {
  var iscommentLoading = false.obs;

  ActivityCommentListRespModel? activityCommentListRespModel;

  RxList<CommentData> commentData = <CommentData>[].obs;

  var totalCount = 0.obs;

  var page = 1.obs;
  var isNewPage = false.obs;

  @override
  onReady() {
    getActivityComments();
    super.onReady();
  }

  NextPageActivityComment() {
    final data = activityCommentListRespModel?.data;
    if (data?.total != commentData.length &&
        // page.value <= (data?.lastPage ?? 0) &&
        isNewPage.value == false) {
      isNewPage.value = true;
      page += 1;
      getActivityComments();
    }
  }

  getActivityComments() async {
    try {
      iscommentLoading.value = true;
      // Apputil.showProgressDialouge();
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: {"page": page.value},
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.activityCommentList);

      print("activityCommentList ==============");
      log(response.toString());

      activityCommentListRespModel =
          ActivityCommentListRespModel.fromJson(response);
      totalCount.value = activityCommentListRespModel?.data?.total ?? 0;

      if (activityCommentListRespModel?.data?.commentData != null) {
        commentData.addAll(activityCommentListRespModel!.data!.commentData!);
      }
      if (activityCommentListRespModel!.success!) {
        iscommentLoading.value = false;
        isNewPage.value = false;
      } else {
        Get.closeAllSnackbars();
        iscommentLoading.value = false;
        isNewPage.value = false;

        Get.showSnackbar(GetSnackBar(
            message: activityCommentListRespModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
      // Apputil.closeProgressDialouge();
    } catch (e) {
      Get.closeAllSnackbars();
      Apputil.closeProgressDialouge();
      iscommentLoading.value = false;
      isNewPage.value = false;
      Get.showSnackbar(GetSnackBar(
          message: activityCommentListRespModel!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
