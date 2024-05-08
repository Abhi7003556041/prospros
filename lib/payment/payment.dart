import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/select_plan_controller.dart';
import 'package:prospros/model/paypal/braintree/braintree_payment_processing.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntent;

  final BuildContext context;
  // final String paymentAmount;
  // PaymentController({required this.context, required this.paymentAmount});
  PaymentController({required this.context});

  final SECRETKEY =
      "sk_test_51NEAXcSE9ZKLpQCniyGSm7lJyJWqmSdDSGhgHNVbQgF1gRZuRiumsg5a5GsTTq8iwYdSTHt7FtjHhyI2i820TPRj00iAkNIuof";
  // "sk_test_51NEAXcSE9ZKLpQCniyGSm7lJyJWqmSdDSGhgHNVbQgF1gRZuRiumsg5a5GsTTq8iwYdSTHt7FtjHhyI2i820TPRj00iAkNIuof";
  // final currency = "INR";
  // final country = 'IN';

  final country = HiveStore().get(Keys.country);
  final city = '';
  final line1 = '';
  final line2 = '';
  final state = '';
  final postalCode = '';

  final SelectPlanController selectPlanController =
      Get.find<SelectPlanController>();

  ///Handles Stripe Payment processing process
  Future<void> makePayment(
      {bool showApplePay = false, required int planId}) async {
    try {
      printRed("###1.6 ${selectPlanController.activeId.value}");
      await selectPlanController.createPaymentIndent(planId);
      // paymentIntent = await createPaymentIntent("8", "INR");
      // print("======= stripePaymentIntentResp?.data?.clientSecret");
      // print(selectPlanController.stripePaymentIntentResp?.data?.clientSecret);

      //STEP 2: Initialize Payment Sheet
      // TODO Client Secret & MerchantDisplay Name should be Modified/use API
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: selectPlanController
                  .stripePaymentIntentResp?.data?.clientSecret ??
              "",
          // paymentIntentClientSecret:
          //     paymentIntent!['client_secret'], //Gotten from payment intent
          style: ThemeMode.dark,
          merchantDisplayName: "Projunctura",
          // customFlow: true,

          applePay: showApplePay
              ? PaymentSheetApplePay(
                  merchantCountryCode: 'US',
                )
              : null,
          googlePay: null,

          // billingDetails: BillingDetails(
          //     address: Address(
          //   country: "IN", //country,
          //   city: city,
          //   line1: line1,
          //   line2: line2,
          //   state: state,
          //   postalCode: postalCode,
          // ))
        ),
      );
      displayPaymentSheet();
    } catch (err) {
      selectPlanController.activeId.value = HiveStore().get(Keys.activePlanId);
      printRed(err);
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: Get.context!,
            builder: (_) => AlertDialog(
                  content: GestureDetector(
                    onTap: () => Get.back(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        Text("Payment Successful!"),
                      ],
                    ),
                  ),
                )).then((value) {
          paymentIntent = null;
          selectPlanController.retrieveStripePaymentIntent();
        });
      }).onError((error, stackTrace) {
        selectPlanController.activeId.value =
            HiveStore().get(Keys.activePlanId);
        throw Exception(error);
      });
    } on StripeException catch (e) {
      selectPlanController.activeId.value = HiveStore().get(Keys.activePlanId);
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      printRed('${e.toString()}');
      selectPlanController.activeId.value = HiveStore().get(Keys.activePlanId);
    }
  }

  Future<void> makePaypalPayment() async {
    try {
      ///fetch and update client token inside SelectPlanController
      await selectPlanController.getClientToken();

      var selectedPlan = selectPlanController
          .subscriptionResponseModel?.data?.subscriptionData
          ?.where((plan) =>
              plan.id.toString() ==
              selectPlanController.activeId.value.toString());
      printRed("Selected plan Amount : ${selectedPlan!.first.planAmount}");

      if (selectPlanController.braintreeClientTokenRes != null &&
          selectPlanController.braintreeClientTokenRes?.data != null &&
          selectPlanController
              .braintreeClientTokenRes!.data.client_token.isNotEmpty) {
        printRed(
            "makePaypalPayment call ${selectPlanController.braintreeClientTokenRes!.data.client_token} ");
        final request = BraintreeDropInRequest(
          // clientToken: 'sandbox_5rqcxdbf_c2rsth7qwhbywrjq', //sandbox token
          clientToken:
              selectPlanController.braintreeClientTokenRes!.data.client_token,
          collectDeviceData: true,
          amount: selectedPlan.first.planAmount,

          googlePaymentRequest: BraintreeGooglePaymentRequest(
            totalPrice: selectedPlan.first.planAmount.toString(),
            currencyCode: 'USD',
            billingAddressRequired: false,
          ),
          paypalRequest: BraintreePayPalRequest(
            amount: selectedPlan.first.planAmount.toString(),
            displayName: 'Projunctura',
          ),
        );

        BraintreeDropInResult? result = await BraintreeDropIn.start(request);
        if (result != null) {
          printRed(
              "Device data ${result.deviceData}: Payment Nonce : ${result.paymentMethodNonce.nonce}");
          submitBrainTreeNonce(
            amount: selectedPlan.first.planAmount.toString(),
            deviceData: result.deviceData!,
            paymentMethodNonce: result.paymentMethodNonce.nonce,
            subscriptionId: selectedPlan.first.id.toString(),
          );
        } else {
          Get.showSnackbar(GetSnackBar(
            message: "Something went wrong. Please try again.",
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
        message: "Something went wrong. Please try again.",
        duration: Duration(seconds: 2),
      ));
    }
  }

  ///After getting sucessfull braintree drop in result, we need to send these details to server for payment processing.
  ///This function sends paymentNonce and device key to server.
  submitBrainTreeNonce(
      {required String paymentMethodNonce,
      required String deviceData,
      required String subscriptionId,
      required String amount}) async {
    try {
      Apputil.showProgressDialouge();
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          body: {
            "payment_method_nonce": paymentMethodNonce,
            "device_data": deviceData,
            "amount": amount,
            "subscription_id": subscriptionId
          },
          method: METHOD.POST,
          endpoint: Url.processBraintreePayment);
      Apputil.closeProgressDialouge();
      if (result != null) {
        var brainTreePaymentProcessingRes =
            BraintreePaymentProcessRes.fromMap(result);
        if (brainTreePaymentProcessingRes.success == true &&
            brainTreePaymentProcessingRes.data.success == true) {
          //check for payment status
          if (brainTreePaymentProcessingRes.data.transaction.status
              .containsEither(
                  ["submitted_for_settlement", "authorized", "settlling"])) {
            //payment is under process
            Get.showSnackbar(GetSnackBar(
                message:
                    "Your payment is under process. Please revisit this page after some time",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
          if (brainTreePaymentProcessingRes.data.transaction.status
              .containsEither(["settled"])) {
            //payment completed successfully
            Get.showSnackbar(GetSnackBar(
                message: "Your have successfully subscribed to plan",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
          // //reload the subscription list
          // selectPlanController.userSubscriptionList();

          // homeController.activeSelection.value = ActiveName.home;
          HiveStore()
              .put(Keys.activePlanId, selectPlanController.activeId.value);
          if (selectPlanController.callbackActionForLoginScreen != null) {
            printRed("Subscription callback is not null");
            selectPlanController.callbackActionForLoginScreen!();
            printRed(Get.previousRoute);
            if (Get.previousRoute == "/login") {
              Get.close(1);
            }
          } else {
            // homeController.activeSelection.value = ActiveName.home;
            Apputil.refreshProfileDetails().then((value) => Get.toNamed(home));
          }
        }
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message:
              "Something went wrong: ${Apputil.showOnlyInDebugMode(e.toString())}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };

  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer $SECRETKEY',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );

  //     print("Client ==============");
  //     print(json.decode(response.body));

  //     return json.decode(response.body);
  //   } catch (err) {
  //     print("errrroo ===========");
  //     print(err);
  //     throw Exception(err.toString());
  //   }
  // }

  // calculateAmount(String amount) {
  //   //TODO only int is allowed
  //   final calculatedAmout = ((double.parse(amount) ?? 0) * 100).toInt() * 100;
  //   // print("=========calculated amount ");
  //   // print(calculatedAmout);
  //   return calculatedAmout.toString();
  // }
}
