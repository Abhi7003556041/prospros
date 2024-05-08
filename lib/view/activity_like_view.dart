import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/activity_like_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/custom_appbar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class ActivityLike extends StatelessWidget {
  ActivityLike({super.key});

  getProfile(String userId) async {
    await HiveStore().put(Keys.currentUserId, userId);

    final profile = Get.put(ProfileController());
    profile.isOthersPost.value = true;
    profile.getProfile();
    // Get.toNamed(profileDetail);
  }

  @override
  Widget build(BuildContext context) {
    final likeController = Get.put(ActivityLikeController());
    return CustomScaffold(
      activeTab: ActiveName.profile,
      isProfile: true,
      appBar: CustomAppBarV2(
          enableBackgroundColor: false,
          title: AppTitle.activityLike,
          onTap: () {
            Get.toNamed(activity);
          }),
      body: Obx(() => (likeController.likeData.length == 0)
          ? Center(child: Container(child: Text("Loading...")))
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  print('Scroll Started');
                } else if (scrollNotification is ScrollUpdateNotification) {
                  print('Scroll Updated');
                } else if (scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
                  print('Scroll Ended');
                  likeController.NextPageActivityLike();
                }
                return true;
              },
              child: ListView.builder(
                  itemCount: likeController.likeData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final e = likeController.likeData[index];
                    final isLastIndex =
                        (index == likeController.likeData.length - 1);
                    return Column(
                      children: [
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  SvgPicture.asset(AppImage.like,
                                      width: 20, height: 20),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                          text: "You liked the post by ",
                                          style: TextStyle(
                                              //fontSize: 16,
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: e.postDetails?.postedBy
                                                        ?.name ??
                                                    "",
                                                style: TextStyle(
                                                    //fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.appColor),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        getProfile(e.postDetails
                                                                ?.postedBy?.id
                                                                .toString() ??
                                                            "");
                                                      }),
                                            TextSpan(
                                              text: " titled ",
                                              style: TextStyle(
                                                  //fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                                text:
                                                    e.postDetails?.postTitle ??
                                                        "",
                                                style: TextStyle(
                                                    //fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.appColor),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        await HiveStore().put(
                                                            Keys.currentPostId,
                                                            e.postDetails?.id
                                                                    ?.toString() ??
                                                                "");
                                                        Get.toNamed(
                                                            postDetails);
                                                      }),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                                thickness: 2, color: AppColor.homeDividerColor),
                            ...e.postDetails!.comments!
                                .map((commentData) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: commentData.isUserLike!
                                          ? [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        AppImage.like,
                                                        width: 20,
                                                        height: 20),
                                                    SizedBox(width: 8),
                                                    Flexible(
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "You liked the comment ",
                                                            style: TextStyle(
                                                                //fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                            children: [
                                                              TextSpan(
                                                                  text: commentData
                                                                      .commentText!,
                                                                  style:
                                                                      TextStyle(
                                                                          //fontSize: 16,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: AppColor
                                                                              .appColor),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () async {
                                                                          await HiveStore().put(
                                                                              Keys.currentPostId,
                                                                              e.postDetails?.id?.toString() ?? "");
                                                                          Get.toNamed(
                                                                              postDetails);
                                                                        }),
                                                              TextSpan(
                                                                text:
                                                                    " created by ",
                                                                style: TextStyle(
                                                                    //fontSize: 16,
                                                                    color: Colors.black),
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      commentData
                                                                          .user!,
                                                                  style:
                                                                      TextStyle(
                                                                          //fontSize: 16,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: AppColor
                                                                              .appColor),
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () async {
                                                                          getProfile(commentData.userId?.toString() ??
                                                                              "");
                                                                        }),
                                                            ]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                  thickness: 2,
                                                  color: AppColor
                                                      .homeDividerColor),
                                            ]
                                          : [],
                                    ))
                                .toList()
                          ],
                        )),
                        //It's disable for the time being
                        isLastIndex &&
                                (index != likeController.totalCount.value - 1)
                            //&& likeController.isLikesLoading.value
                            ? Column(
                                children: [
                                  SizedBox(height: 16),
                                  CircularProgressIndicator(),
                                ],
                              )
                            : Container()
                      ],
                    );
                  }),
            )),
    );
  }
}
