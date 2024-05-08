import 'package:get/get.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/SubscriptionModel/subscription_response_model.dart';
import 'package:prospros/model/get_subscription_model/get_subscription_model.dart';
import 'package:prospros/model/get_subscription_model/get_subscription_response_model.dart';
import 'package:prospros/model/paypal/braintree/braintree_client_token.dart';
import 'package:prospros/model/stripe_payment_model/stripe_payment_response.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';

class SelectPlanController extends GetxController {
  SubscriptionResponseModel? subscriptionResponseModel;
  StripePaymentIntentResp? stripePaymentIntentResp;
  BraintreeClientTokenRes? braintreeClientTokenRes;

  var hasPlanResponse = false.obs;
  var hasSubscribedResponse = false.obs;

  var isBackButtonEnabled = false.obs;

  var hasPaymentResponse = false.obs;

  var activeId = 1.obs;
  var previousId = 1.obs;
  // final homeController = Get.find<HomeController>();

  @override
  onInit() {
    isBackButtonEnabled.value = true;
    setSubscriptionPlan();
    userSubscriptionList();
    super.onInit();
  }

  Function? callbackActionForLoginScreen;

  setSubscriptionPlan() {
    final id = int.tryParse(HiveStore().get(Keys.activePlanId) ?? "1") ?? 1;
    previousId.value = id;
    activeId.value = id;
  }

  void setCallBack(Function? callbackAction) {
    callbackActionForLoginScreen = callbackAction;
  }

  addSubscription() async {
    hasSubscribedResponse.value = true;
    try {
      final model = GetSubscriptionModel(subscriptionId: activeId.value);

      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        body: model.toJson(),
        endpoint: Url.getSubscription,
      );

      if (result != null) {
        final getSubscriptionResponseModel =
            GetSubscriptionResponseModel.fromJson(result);
        print("subscriptionResponseModel=================");
        log(result.toString());

        if (getSubscriptionResponseModel.success!) {
          hasSubscribedResponse.value = false;

          Get.closeAllSnackbars();
          await Future.delayed(Duration(milliseconds: 200));
          Get.showSnackbar(GetSnackBar(
              message: "Subscriptions added successfully.",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          await Future.delayed(Duration(milliseconds: 200));
          if (callbackActionForLoginScreen != null) {
            printRed("Subscription callback is not null");
            callbackActionForLoginScreen!();
            printRed(Get.previousRoute);
            if (Get.previousRoute == "/login") {
              Get.close(1);
            }
          } else {
            // homeController.activeSelection.value = ActiveName.home;
            Apputil.refreshProfileDetails().then((value) => Get.toNamed(home));
          }
        } else {
          hasSubscribedResponse.value = false;
          activeId.value = previousId.value;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasSubscribedResponse.value = false;
      activeId.value = previousId.value;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  userSubscriptionList() async {
    hasPlanResponse.value = true;
    try {
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.subscriptions,
      );

      if (result != null) {
        subscriptionResponseModel = SubscriptionResponseModel.fromJson(result);
        print("subscriptionResponseModel=================");
        log(result.toString());

        if (subscriptionResponseModel!.success!) {
          hasPlanResponse.value = false;
        } else {
          hasPlanResponse.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPlanResponse.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  ///for Stripe Payment
  createPaymentIndent(int planId) async {
    hasPaymentResponse.value = true;

    printRed("#### 2Active Id : ${activeId.value}");
    try {
      Apputil.showProgressDialouge();
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          // body: {"subscription_id": activeId.value},
          body: {"subscription_id": planId},
          method: METHOD.POST,
          endpoint: Url.stripePaymentIntent);
      Apputil.closeProgressDialouge();
      if (result != null) {
        stripePaymentIntentResp = StripePaymentIntentResp.fromJson(result);
        print("subscriptionResponseModel=================");
        log(result.toString());

        if (subscriptionResponseModel!.success!) {
          hasPaymentResponse.value = false;
        } else {
          hasPaymentResponse.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: stripePaymentIntentResp?.message ?? "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPaymentResponse.value = false;
      Apputil.closeProgressDialouge();
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  ///for paypal payment
  getClientToken() async {
    hasPaymentResponse.value = true;
    try {
      Apputil.showProgressDialouge();
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.braintreeClientToken);
      Apputil.closeProgressDialouge();
      if (result != null) {
        braintreeClientTokenRes = BraintreeClientTokenRes.fromMap(result);
        print("subscriptionResponseModel=================");
        log(result.toString());

        if (subscriptionResponseModel!.success!) {
          hasPaymentResponse.value = false;
        } else {
          hasPaymentResponse.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: stripePaymentIntentResp?.message ?? "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPaymentResponse.value = false;
      Apputil.closeProgressDialouge();
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  retrieveStripePaymentIntent() async {
    hasSubscribedResponse.value = true;
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          body: {"stripe_payment_id": stripePaymentIntentResp?.data?.id ?? ""},
          method: METHOD.POST,
          endpoint: Url.retrieveStripePayment);

      if (result != null) {
        stripePaymentIntentResp = StripePaymentIntentResp.fromJson(result);
        print("stripePaymentIntentResp=================");
        log(result.toString());

        if (stripePaymentIntentResp!.success!) {
          hasSubscribedResponse.value = false;
          // homeController.activeSelection.value = ActiveName.home;
          if (callbackActionForLoginScreen != null) {
            printRed("Subscription callback is not null");
            callbackActionForLoginScreen!();
            printRed(Get.previousRoute);
            if (Get.previousRoute == "/login") {
              Get.close(1);
            }
          } else {
            Apputil.refreshProfileDetails().then((value) {
              Get.toNamed(home);
            });
          }

          Get.showSnackbar(GetSnackBar(
              message: stripePaymentIntentResp?.message ?? "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        } else {
          hasSubscribedResponse.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: stripePaymentIntentResp?.message ?? "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasSubscribedResponse.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}

class PlanDetails {
  final String planTitle;
  final String planId;
  final String? planPrice;
  final String planDetails;
  final bool isSelected;
  PlanDetails(
      {required this.planTitle,
      required this.planId,
      this.planPrice,
      required this.planDetails,
      this.isSelected = false});
}
