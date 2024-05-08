import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/controller/select_plan_controller.dart';
import 'package:prospros/main.dart' as call;
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/about/about.dart';
import 'package:prospros/view/disclaimer_terms/disclaimer_terms.dart';
import 'package:prospros/widgets/custom_appbar.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarV2(
          enableBackgroundColor: false,
          title: " ",
          onTap: () {
            // final userDetails = jsonDecode(HiveStore().get(Keys.userDetails));
            // final userId = LoginResponseModel.fromJson(userDetails);

            // HiveStore().put(
            //     Keys.currentUserId,
            //     userId.data?.personalDetails?.userDetails?.id.toString() ??
            //         "0");

            ProfileController profileController = Get.find<ProfileController>();

            profileController.isOthersPost.value = false;
            profileController.getProfile();
            // Get.toNamed(profile);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 14, top: 33),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavTitleWidget(
                    title: AppTitle.accountNavigation,
                    onTap: () {
                      Get.toNamed(account);
                    }),
                NavTitleWidget(
                    title: AppTitle.activity,
                    onTap: () {
                      Get.toNamed(activity);
                    }),
                NavTitleWidget(
                    title: AppTitle.subscription,
                    onTap: () async {
                      await Get.delete<SelectPlanController>();
                      Get.toNamed(selectPlan);
                    }),
                NavTitleWidget(
                    title: AppTitle.transaction,
                    onTap: () {
                      Get.toNamed(transactionList);
                    }),
                NavTitleWidget(
                    title: AppTitle.notificationNav,
                    onTap: () {
                      Get.toNamed(notification);
                    }),
                NavTitleWidget1(
                    title: AppTitle.disclaimer,
                    onTap: () {
                      Get.to(() => DisclaimerTerms());
                    }),
                NavTitleWidget1(
                    title: AppTitle.about,
                    onTap: () {
                      Get.to(() => AboutPage());
                    }),
                NavTitleWidget1(
                    title: AppTitle.logout,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text('Are you sure want to Logout?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    ChatService chatService = Get.find();

                                    await Apputil.logoutStoredKey();
                                    GoogleSignInApi.logout();
                                    FacebookSignInApi.logout();
                                    await call.callController
                                        .callDocumentListeningSubscription
                                        ?.cancel();
                                    await chatService.setUserOffile();
                                    Get.offAllNamed(login);
                                    // Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    }),
              ],
            ),
          ),
        ));
  }
}

class NavTitleWidget extends StatelessWidget {
  const NavTitleWidget({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35)
      ],
    );
  }
}

class NavTitleWidget1 extends StatelessWidget {
  const NavTitleWidget1({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: onTap,
            child: Material(
              color: Colors.transparent,
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            )),
        const SizedBox(height: 35)
      ],
    );
  }
}
