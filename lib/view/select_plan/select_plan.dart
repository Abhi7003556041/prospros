import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/select_plan_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prospros/payment/payment.dart';
import 'package:prospros/util/app_util.dart';
import 'package:sizing/sizing.dart';

class SelectPlanScreen extends StatelessWidget {
  SelectPlanScreen({super.key, this.callbackActionForLoginScreen});

  ///this callback is being used by login screen to verify whether user plan is selected or not
  final Function? callbackActionForLoginScreen;

  final controller = Get.put(SelectPlanController());

  @override
  Widget build(BuildContext context) {
    controller.setCallBack(callbackActionForLoginScreen);
    return Scaffold(
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: controller.hasPlanResponse.value,
          progressIndicator: CircularProgressIndicator(
            color: Color(0xff2643E5),
          ),
          child: controller.hasPlanResponse.value
              ? Container()
              : ModalProgressHUD(
                  inAsyncCall: controller.hasSubscribedResponse.value,
                  child: Column(children: [
                    Stack(
                      children: [
                        Container(height: 289, color: const Color(0xff2643E5)),
                        Positioned.fill(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppImage.kingIcon),
                            const Text("Go Premium",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            const SizedBox(height: 17),
                            const SizedBox(
                                width: 252,
                                child: Text(
                                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    textAlign: TextAlign.center))
                          ],
                        )),
                        controller.isBackButtonEnabled.value
                            ? Positioned(
                                left: 20.ss,
                                top: 45.ss,
                                child: GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: const Icon(Icons.arrow_back_ios,
                                            size: 10))))
                            : Container(),
                      ],
                    ),
                    Expanded(
                        child: ListView(
                            children: controller.subscriptionResponseModel!
                                .data!.subscriptionData!
                                .map((e) {
                      // if (Apputil.isPlanSelected(
                      //     planID: e.id!, getSubscription: e.getSubscription)) {
                      //   controller.activeId.value = e.id!;
                      // } else {
                      //   controller.activeId.value = 0;
                      // }
                      return PlanCard(
                        onPressed: () async {
                          print("plan id ======================");
                          print(e.id);
                          print(controller.activeId.value);

                          if (e.id == 1) {
                            //user is subscribing to free plan
                            controller.activeId.value = e.id!;

                            controller.addSubscription();
                          } else {
                            //user is subscribing to premium plan

                            controller.activeId.value = e.id!;
                            printRed(
                                "#### 1Active Id : ${controller.activeId.value}");
                            if (Platform.isIOS) {
                              ///if platform is ios then we don't need to show paypal option we just showing the stripe payment request along with apple pay option

                              final PaymentController paymentController =
                                  Get.put(PaymentController(context: context));
                              paymentController.makePayment(
                                  showApplePay: true,
                                  planId: controller.activeId.value);
                            } else {
                              Get.bottomSheet(SelectPaymentProvider(),
                                  elevation: 10.ss);
                            }
                          }
                        },
                        isActivePlan: controller.activeId.value == e.id,
                        getSubscription: e.getSubscription,
                        planId: e.id!,
                        planName: e.planName!,
                        planDescription: e.planDerscription!,
                        planPrice: e.planAmount ?? "",
                      );
                    }).toList()))
                  ]),
                ),
        ),
      ),
    );
  }
}

class SelectPaymentProvider extends StatelessWidget {
  const SelectPaymentProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SelectPlanController controller = Get.find();

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 100.sw, minHeight: 150.ss),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      width: 2.ss, color: Apputil.getActiveColor()))),
          padding: EdgeInsets.all(10.ss),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.ss,
              ),
              Text(
                "Select a payment provider",
                style: TextStyle(fontSize: 18.ss),
              ),
              SizedBox(
                height: 5.ss,
              ),
              Divider(
                height: 3,
                color: Colors.grey,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        final PaymentController paymentController =
                            Get.put(PaymentController(context: context));
                        printRed("###1.5 ${controller.activeId.value}");
                        paymentController.makePayment(
                            showApplePay: true,
                            planId: controller.activeId.value);
                      },
                      child: Material(
                        child: SvgPicture.asset(
                          AppImage.stripe,
                          width: 100.ss,
                          height: 70.ss,
                          color: Color(0xff635BFF),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        final PaymentController paymentController =
                            Get.put(PaymentController(context: context));
                        paymentController.makePaypalPayment();
                      },
                      child: Material(
                        child: SvgPicture.asset(
                          AppImage.paypal,
                          width: 100.ss,
                          height: 50.ss,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Material(
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ))
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard(
      {super.key,
      required this.planName,
      required this.planDescription,
      required this.planPrice,
      required this.planId,
      required this.getSubscription,
      required this.isActivePlan,
      required this.onPressed});
  final String planName;
  final String planDescription;
  final String planPrice;
  final int planId;
  final bool isActivePlan;
  final String? getSubscription;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isFreePlan = (planName.toLowerCase() == "free");
    final activePlanColor = isActivePlan //(planName.toLowerCase() != "free")
        ? AppColor.appColor
        : Color(0xffE4E6EC);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: activePlanColor),
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              planName.capitalizeFirst!,
              style: TextStyle(color: Color(0xff707070)),
            ),
            Checkbox(
                shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 0.1, color: Color(0xff707070)),
                    borderRadius: BorderRadius.circular(20)),
                value: isActivePlan ? true : false,
                fillColor: MaterialStateProperty.all(activePlanColor),
                onChanged: (val) {})
          ]),
          isFreePlan
              ? Container()
              : Row(
                  children: [
                    Text(
                      "\$${planPrice}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("/month",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff797979),
                        ))
                  ],
                ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
                width: 292,
                child: Html(
                  data: planDescription,
                  style: {
                    /* ... */
                  },
                )
                // child: Text(
                //   planDescription,
                //   style: TextStyle(color: Color(0xff707070)),
                // ),
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
              visible: getSubscription?.contains("payment_processed") ?? false,
              child: Text(
                  "Your payment is in progress. Please check after some time.")),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(isFreePlan
                      // ? Apputil.isPlanSelected(
                      //         planID: planId, getSubscription: getSubscription)
                      //     ? Colors.grey
                      //     : Color(0xff36BC8F)
                      ? Color(0xff36BC8F)
                      : Apputil.isPlanSelected(
                              planID: planId, getSubscription: getSubscription)
                          ? Colors.grey
                          : AppColor.appColor)),
              onPressed: isFreePlan
                  ? onPressed
                  : Apputil.isPlanSelected(
                          planID: planId, getSubscription: getSubscription)
                      ? null
                      : onPressed,
              // onPressed: onPressed,
              child: Text("Get ${isFreePlan ? "Free" : "Premium"}"),
            ),
          ),
          const SizedBox(
            height: 19,
          )
        ],
      ),
    );
  }
}
