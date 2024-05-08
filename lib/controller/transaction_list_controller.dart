import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/transaction_list/transaction_list_resp.dart';

class TransactionListController extends GetxController {
  var hasTransactionList = false.obs;

  TransactionListResp? transactionListResp;

  RxList<TransactionData> transactionData = <TransactionData>[].obs;

  var totalCount = 0.obs;

  var page = 1.obs;
  var isNewPage = false.obs;

  @override
  onInit() {
    super.onInit();
    transactionList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  NextPageTransactionList() {
    final data = transactionListResp?.data;
    if (data?.total != transactionData.length && isNewPage.value == false) {
      isNewPage.value = true;
      page += 1;
      transactionList();
    }
  }

  transactionList() async {
    if (page == 1) {
      hasTransactionList.value = true;
    }

    try {
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: {"page": page.value},
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.transactionList,
      );

      if (result != null) {
        transactionListResp = TransactionListResp.fromJson(result);
        print("transactionListResp=================");
        log(result.toString());

        totalCount.value = transactionListResp?.data?.total ?? 0;

        if (transactionListResp?.data?.transactionData != null) {
          transactionData.addAll(transactionListResp!.data!.transactionData!);
          update();
        }

        if (transactionListResp?.success ?? false) {
          hasTransactionList.value = false;
          isNewPage.value = false;

          // Get.closeAllSnackbars();
          // Get.showSnackbar(GetSnackBar(
          //     message: transactionListResp?.message ?? "Server Error",
          //     snackPosition: SnackPosition.BOTTOM,
          //     duration: Duration(seconds: 2),
          //     margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          // await Future.delayed(Duration(milliseconds: 200));
        } else {
          hasTransactionList.value = false;
          isNewPage.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: transactionListResp?.message ?? "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasTransactionList.value = false;
      isNewPage.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
