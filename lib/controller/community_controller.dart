import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/community_model/community_model.dart';
import 'package:prospros/model/community_model/community_response_model.dart';

class CommunityController extends GetxController {
  CommunityResponseModel? communityResponseModel;

  RxList<CommunityData> communityData = <CommunityData>[].obs;

  var linearProgressBar = false.obs;
  var isDebouncerActive = false.obs;

  var page = 1.obs;
  var isNewPage = false.obs;
  var itemCount = 0.obs;

  TextEditingController search = TextEditingController(text: "");

  @override
  onInit() {
    super.onInit();
    getCommunityMemberList();
  }

  debounce() {
    communityData.clear();
    page.value = 1;
    linearProgressBar.value = true;
    Timer(Duration(milliseconds: 300), () {
      if (isDebouncerActive.value) {
        getCommunityMemberList();
      }
    });
  }

  updateNextPage() {
    final data = communityResponseModel?.data;
    if (data?.total != communityData.length &&
        page.value <= (data?.lastPage ?? 0) &&
        isNewPage.value == false) {
      isNewPage.value = true;
      page += 1;
      getCommunityMemberList();
    }
  }

  getCommunityMemberList() async {
    try {
      if (page == 1) {
        //if (search.text.isNotEmpty && page == 1) {
        communityData.clear();
        if (search.text.isNotEmpty) {
          linearProgressBar.value = true;
        }
      }

      final model =
          CommunityModel(searchKeyword: search.text, page: page.value);
      print("Community Model ========");
      print(model.toString());
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.communityMemberList,
      );

      communityResponseModel = CommunityResponseModel.fromJson(result);

      //print("communityResponseModel ===========");
      //log(result.toString());

      itemCount.value = communityResponseModel?.data?.total ?? 0;

      if (communityResponseModel!.success!) {
        // communityResponseModel!.data!.communityData!
        //     .sort((a, b) => a.name!.compareTo(b.name!));
        communityData.addAll(communityResponseModel!.data!.communityData!);
        // communityData.sort((a, b) => a.name!.compareTo(b.name!));

        isNewPage.value = false;
        linearProgressBar.value = false;
        isDebouncerActive.value = false;

        if (model.searchKeyword != search.text) {
          linearProgressBar.value = true;
          getCommunityMemberList();
        }
      } else {
        isNewPage.value = false;
        linearProgressBar.value = false;
        isDebouncerActive.value = false;

        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
            message: communityResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      isNewPage.value = false;
      linearProgressBar.value = false;
      isDebouncerActive.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
