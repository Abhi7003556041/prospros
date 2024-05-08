import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/notification_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_appbar.dart';

class Notification extends StatelessWidget {
  Notification({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  smsNotification(bool value) {
    notificationController.isPushNotification.value = false;
    notificationController.smsNotification.value = value ? "yes" : "no";
    notificationController.updatePreference();
  }

  setNotificationType(String notificationType) {
    notificationController.notificationType.value = notificationType;
  }

  pushNotification(bool value) {
    printRed("#pushNotification Value : ${value.toString()}");
    notificationController.isPushNotification.value = true;
    notificationController.pushNotification.value = value ? "yes" : "no";
    notificationController.updatePreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarV2(
          enableBackgroundColor: false,
          title: AppTitle.notification,
          onTap: () {
            Get.delete<NotificationController>();
            Get.toNamed(drawerNavigation);
          },
        ),
        body: Stack(
          children: [
            Obx(
              () => ModalProgressHUD(
                inAsyncCall: notificationController.hasPreferenceLoaded.value,

                // || notificationController.hasPreferenceUpdated.value,

                child: SingleChildScrollView(
                  controller: notificationController.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 35),
                            const Text("Message from community users",
                                style: AppStyle.notificationHeading),
                            const SizedBox(height: 16),
                            const Text(
                                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt",
                                style: AppStyle.notificationContent),
                            const SizedBox(height: 16),
                            PushButton(
                                pushVal: notificationController.pushMessage,
                                onChanged: (bool val) {
                                  setNotificationType(
                                      AppTitle.messageCommunityUsers);
                                  pushNotification(val);
                                  notificationController.pushMessage.value =
                                      val;
                                }),
                            const SizedBox(height: 16),
                            SMSButton(
                                smsVal: notificationController.smsMessage,
                                onChanged: (bool val) {
                                  setNotificationType(
                                      AppTitle.messageCommunityUsers);
                                  smsNotification(val);
                                  notificationController.smsMessage.value = val;
                                }),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      Container(height: 4, color: AppColor.homeDividerColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              const Text("Payment for Subscription",
                                  style: AppStyle.notificationHeading),
                              const SizedBox(height: 16),
                              const Text(
                                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt",
                                  style: AppStyle.notificationContent),
                              const SizedBox(height: 16),
                              PushButton(
                                  pushVal: notificationController.pushPayment,
                                  onChanged: (bool val) {
                                    setNotificationType(
                                        AppTitle.paymentSubscription);
                                    pushNotification(val);
                                    notificationController.pushPayment.value =
                                        val;
                                  }),
                              const SizedBox(height: 16),
                              SMSButton(
                                  smsVal: notificationController.smsPayment,
                                  onChanged: (bool val) {
                                    setNotificationType(
                                        AppTitle.paymentSubscription);
                                    smsNotification(val);
                                    notificationController.smsPayment.value =
                                        val;
                                  }),
                              const SizedBox(height: 24),
                            ]),
                      ),
                      Container(height: 4, color: AppColor.homeDividerColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            const Text("Queries",
                                style: AppStyle.notificationHeading),
                            const SizedBox(height: 16),
                            const Text("Queries posted by community users",
                                style: AppStyle.notificationContent),
                            const SizedBox(height: 16),
                            PushButton(
                                pushVal: notificationController.pushQueries,
                                onChanged: (bool val) {
                                  setNotificationType(AppTitle.queries);
                                  pushNotification(val);
                                  notificationController.pushQueries.value =
                                      val;
                                }),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      Container(height: 4, color: AppColor.homeDividerColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            const Text("Like and Comments on photo of You",
                                style: AppStyle.notificationHeading),
                            const SizedBox(height: 16),
                            const Text("Queries posted by community users",
                                style: AppStyle.notificationContent),
                            const SizedBox(height: 16),
                            PushButton(
                                pushVal: notificationController.pushlike,
                                onChanged: (bool val) {
                                  setNotificationType(AppTitle.likeComment);
                                  pushNotification(val);
                                  notificationController.pushlike.value = val;
                                }),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      Container(height: 4, color: AppColor.homeDividerColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            const Text("Forget Password",
                                style: AppStyle.notificationHeading),
                            const SizedBox(height: 16),
                            const Text("Queries posted by community users",
                                style: AppStyle.notificationContent),
                            const SizedBox(height: 16),
                            PushButton(
                                pushVal: notificationController.pushForget,
                                onChanged: (bool val) {
                                  setNotificationType(AppTitle.forgotPassword);
                                  pushNotification(val);
                                  notificationController.pushForget.value = val;
                                }),
                            const SizedBox(height: 75),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => notificationController.hasPreferenceUpdated.value
                ? Positioned.fill(
                    child: Container(
                      color: Colors.grey.withOpacity(.2),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Apputil.getActiveColor(),
                        ),
                      ),
                    ),
                  )
                : SizedBox())
          ],
        ));
  }
}

class PushButton extends StatelessWidget {
  PushButton({super.key, required this.onChanged, required this.pushVal});
  final void Function(bool)? onChanged;
  final RxBool pushVal;
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Push", style: AppStyle.notificationSubTitle),
        SizedBox(
          width: 31,
          height: 20,
          child: Obx(
            () => Transform.scale(
              scale: 0.85,
              child: CupertinoSwitch(
                  activeColor: AppColor.appColor,
                  trackColor: AppColor.inActiveColor,
                  value: pushVal.value,
                  onChanged: onChanged),
            ),
          ),
        )
      ],
    );
  }
}

class SMSButton extends StatelessWidget {
  SMSButton({super.key, required this.onChanged, required this.smsVal});
  final void Function(bool)? onChanged;
  final RxBool smsVal;
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "SMS",
          style: AppStyle.notificationSubTitle,
        ),
        SizedBox(
          width: 31,
          height: 20,
          child: Obx(
            () => Transform.scale(
              scale: 0.85,
              child: CupertinoSwitch(
                  activeColor: AppColor.appColor,
                  trackColor: AppColor.inActiveColor,
                  value: smsVal.value,
                  onChanged: onChanged),
            ),
          ),
        )
      ],
    );
    ;
  }
}
