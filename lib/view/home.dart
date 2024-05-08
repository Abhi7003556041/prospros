import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/select_plan_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_scaffold.dart';
import 'package:prospros/widgets/post_card.dart';
import 'package:sizing/sizing.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall:
              controller.search.text.isNotEmpty && controller.page.value == 1
                  ? controller.hasPostCreated.value
                  : false,
          child: GestureDetector(
            onTap: () {
              controller.hideSearchTextField.value = true;
              print("=========== controller .homeData.isEmpty");
              print(controller.homeData.isEmpty);

              if (controller.homeData.isEmpty) {
                controller.resetToHome();
              }
            },
            child: CustomScaffold(
                activeTab: ActiveName.home,
                isProfile: controller.hideBottomBar.value,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60), // Set this height
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 17.0, right: 17),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(AppImage.logo,
                                      width: 40, height: 40),
                                  controller.hideSearchTextField.value
                                      ? const Spacer()
                                      : const SizedBox(width: 16),
                                  controller.hideSearchTextField.value
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.hideSearchTextField
                                                .value = false;
                                          },
                                          child: SvgPicture.asset(
                                              AppImage.search,
                                              width: 24,
                                              height: 24),
                                        )
                                      : searchField(),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(notificationList);
                                    },
                                    child: SvgPicture.asset(
                                        AppImage.notificationIcon,
                                        width: 24,
                                        height: 24),
                                  ),
                                  // const SizedBox(width: 16),
                                  // filterButton()
                                ])),
                        const SizedBox(height: 8),
                        Container(height: 1, color: AppColor.borderColor),
                        Visibility(
                          visible: controller.linearProgress.value,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.orangeAccent,
                            valueColor: controller.linearProgress.value
                                ? AlwaysStoppedAnimation(Colors.blue)
                                : null,
                            minHeight: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: (controller.search.text.isEmpty &&
                        controller.page.value == 1 &&
                        controller.hasPostCreated.value)
                    ? Center(child: Text("Loading...."))
                    : (controller.homeResponseModel) == null
                        ? Center(child: Container())
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 60,
                            child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  // Logic of scrollNotification
                                  if (scrollNotification
                                      is ScrollStartNotification) {
                                    print('Scroll Started');
                                  } else if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    print('Scroll Updated');
                                  } else if (scrollNotification
                                          .metrics.pixels ==
                                      scrollNotification
                                          .metrics.maxScrollExtent) {
                                    print('Scroll Ended');
                                    printRed(
                                        "Controller page: ${controller.page.value}");
                                    printRed(
                                        "Controller page: ${controller.homeResponseModel?.data?.meta?.lastPage}");
                                    if (controller.page.value <=
                                                (controller
                                                        .homeResponseModel
                                                        ?.data
                                                        ?.meta
                                                        ?.lastPage ??
                                                    0) &&
                                            controller.isNewPage.value == false
                                        // && controller.search.text.isEmpty
                                        ) {
                                      controller.isNewPage.value = true;

                                      controller.page += 1;
                                      controller.showPost(
                                          diableProgressDialouge: true);
                                    }
                                  }
                                  return true;
                                },
                                child: Obx(() => controller.homeData.length == 0
                                    ? RefreshIndicator(
                                        onRefresh: () async {
                                          controller.page.value = 1;
                                          await Apputil.refreshProfileDetails();
                                          await controller.showPost(
                                              diableProgressDialouge: true);
                                        },
                                        child: ListView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            children: [
                                              Container(
                                                  height: 1.2.sw,
                                                  child: Center(
                                                      child: Text(
                                                          "No posts to show.")))
                                            ]),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          controller.page.value = 1;

                                          await Apputil.refreshProfileDetails();
                                          await controller.showPost(
                                              diableProgressDialouge: true);
                                        },
                                        child: ListView.builder(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller:
                                                controller.scrollController,
                                            itemCount:
                                                controller.homeData.length,
                                            itemBuilder: (context, index) {
                                              final e =
                                                  controller.homeData[index];
                                              print("e.postedBy.toString()");
                                              print(e.postedBy!.id.toString());
                                              return Column(children: [
                                                index == 0
                                                    ? const SizedBox(height: 14)
                                                    : Container(),
                                                Obx(
                                                  () => PostCard(
                                                      // isCreatedByCurrentUser:
                                                      //     controller.userId.value ==
                                                      //         e.postedBy!.id,
                                                      isCreatedByCurrentUser:
                                                          false,
                                                      isReportPossible: e
                                                                  .postedBy!.id
                                                                  .toString() ==
                                                              controller.userId.value
                                                                  .toString()
                                                          ? false
                                                          : true,
                                                      index: index,
                                                      flagImg:
                                                          e.country?.flag ?? "",
                                                      category: e
                                                              .postCategoryDetails
                                                              ?.categoryName ??
                                                          "",
                                                      country: e.country!.name,
                                                      UserId: e.postedBy?.id
                                                              ?.toString() ??
                                                          "",
                                                      postId: e.id.toString(),
                                                      onTap: () async {
                                                        controller
                                                            .commentPostIndex
                                                            .value = index;
                                                        controller
                                                            .likeDisLikePostIndex
                                                            .value = index;
                                                        controller.id.value =
                                                            e.id?.toString() ??
                                                                "";
                                                        print(
                                                            "post id ========");
                                                        print(
                                                            e.id?.toString() ??
                                                                "");
                                                        await HiveStore().put(
                                                            Keys.currentPostId,
                                                            e.id?.toString() ??
                                                                "");

                                                        Get.toNamed(
                                                            postDetails);
                                                      },
                                                      name: e.postedBy?.name ??
                                                          "",
                                                      title: e.postTitle ?? "",
                                                      content: e.postDescription ??
                                                          "",
                                                      numOfComments: e
                                                          .rxTotalComments.value
                                                          .toString(),
                                                      numOfLikes:
                                                          e.rxTotalLikes.value <= 0
                                                              ? ""
                                                              : e.rxTotalLikes.value
                                                                  .toString(),
                                                      numDays:
                                                          e.postCreatedAtRAW ?? "",
                                                      profileImg: e.postedByImage ?? "",
                                                      postImage: e.postImages ?? "",
                                                      isLiked: e.isLiked.value),
                                                ),
                                                Container(
                                                    height: 4,
                                                    color: AppColor
                                                        .homeDividerColor),
                                                const SizedBox(height: 18),
                                                if (index !=
                                                        controller.totalLength
                                                                .value -
                                                            1 &&
                                                    index ==
                                                        controller.homeData
                                                                .length -
                                                            1)
                                                  CircularProgressIndicator()
                                              ]);
                                            }),
                                      ))),
                          )),
          ),
        ));
  }

  Flexible searchField() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 0.5,
            ),
          ],
        ),
        //color: Colors
        //    .white, // AppColor.communityTxtFormFieldColor,
        child: TextFormField(
          controller: controller.search,
          textAlignVertical: TextAlignVertical.center,
          scrollPadding: EdgeInsets.all(20),
          cursorColor: Colors.black,
          onChanged: (value) {
            if (controller.linearProgress == false && value.isNotEmpty) {
              controller.isDebouncerActive.value = true;
              controller.debounce();
            }

            ///This is used to scroll to top ; when user is moved to 2nd or 3rd page and he is trying to search, then we are moving user to first page so that we can look search results from start result
            if (controller.scrollController.hasClients) {
              controller.scrollController.animateTo(0,
                  curve: Curves.ease, duration: Duration(milliseconds: 200));
            }

            // if (value.isEmpty) {
            //   if (controller.debounceTimer!.isActive) {
            //     controller.debounceTimer?.cancel();
            //   }

            //   controller.isDebouncerActive.value =
            //       false;
            //   controller.showPost();
            // }
          },
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            label: Text(AppTitle.searchHere, textAlign: TextAlign.start),
            hintText: AppTitle.searchHere,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            suffixIcon: GestureDetector(
                onTap: () {
                  if (controller.search.text.isNotEmpty) {
                    controller.resetToHome();
                  }
                },
                child: Icon(Icons.clear)),
            //contentPadding: EdgeInsets.zero,
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  GestureDetector filterButton() {
    return GestureDetector(
      onTap: () async {
        //if user has subscribed, then only he can be able to filter the posts
        var user = Apputil.getUserProfile();
        if (user != null) {
          if (Apputil.isUserSubscribed(user)) {
            printRed("User is subscribed");
            Get.toNamed(filterPosts);
          } else {
            var isYes = await Apputil.showCustomDialougeDialouge(
                titleText: "You aren't subscribed to paid plan ! ",
                description:
                    "To access filter feature,you need to be subscribed to paid plan. Would you like to subscribe ?",
                onYesTap: () async {
                  Get.back();
                  await Get.delete<SelectPlanController>();
                  Get.toNamed(selectPlan);
                },
                onNoTap: () {
                  Get.back();
                });
            printRed("IsYes ${isYes}");
          }
        }
      },
      child: Obx(
        () => Badge(
          label: controller.filterCount.value > 0
              ? Apputil.isFilterSet()
                  ? Text(controller.filterCount.value.toString())
                  : null
              : null,
          backgroundColor: controller.filterCount.value > 0
              ? Apputil.isFilterSet()
                  ? Colors.red
                  : Colors.transparent
              : Colors.transparent,
          child: SvgPicture.asset(AppImage.hamburgerIcon,
              width: 24,
              height: 24,
              color: controller.filterCount.value > 0
                  ? Apputil.isFilterSet()
                      ? Apputil.getActiveColor()
                      : Colors.black
                  : Colors.black),
        ),
      ),
    );
  }
}
