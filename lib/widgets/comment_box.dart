import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/post_details_controller.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:sizing/sizing.dart';

class CommentBox extends StatelessWidget {
  CommentBox({super.key, this.isDetailed = false});
  final bool isDetailed;

  HomeController controller = Get.put(HomeController());

  TextEditingController textEditingController = TextEditingController();

  bottomBarHide() {
    if (controller.activeSelection == ActiveName.home) {
      controller.hideBottomBar.value = false;
      printRed("It's on the homepage");
    } else if (controller.activeSelection == ActiveName.profile) {
      final ProfileController profileController = Get.find();
      profileController.hideBottomBar.value = false;
      printRed("It's on the profilePage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 190,
      color: Colors.white,
      padding:
          EdgeInsets.only(top: 10.fs, bottom: 5.fs, right: 5.fs, left: 5.fs),
      child: SingleChildScrollView(
        child: Column(children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                        HiveStore().get(Keys.profileImage)),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 5,
                    controller: textEditingController,
                    cursorColor: Colors.black,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        controller.isUserStartedTypingComment.value = true;
                      } else {
                        controller.isUserStartedTypingComment.value = false;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Write your comments",
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Apputil.getActiveColor())),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                Obx(
                  () => !controller.isUserStartedTypingComment.value
                      ? SizedBox()
                      : Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              if (textEditingController.text.isNotEmpty) {
                                controller.comment.text =
                                    textEditingController.text;

                                var isCommentedSuccessfully =
                                    controller.commentPost();
                                FocusScope.of(context).unfocus();
                                bottomBarHide();

                                if (isDetailed) {
                                  // Navigator.pop(context);
                                  Get.back(result: isCommentedSuccessfully);
                                  final PostDetailsController postDetailScreen =
                                      Get.find();
                                  final scrollController =
                                      postDetailScreen.scrollController;

                                  await postDetailScreen.showPost();

                                  await Duration(milliseconds: 300).delay();

                                  if (postDetailScreen.hasPostCreated ==
                                      false) {
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                  }
                                } else {
                                  // if (controller.activeSelection ==
                                  //     ActiveName.home) {
                                  //  // controller.showPost();
                                  // } else if (controller.activeSelection ==
                                  //     ActiveName.profile) {
                                  //   final ProfileController profileController =
                                  //       Get.find();
                                  //   profileController.userPostList();
                                  // }

                                  // Navigator.pop(context);
                                  Get.back(result: isCommentedSuccessfully);
                                }
                              }
                            },
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Icon(
                                    Icons.send,
                                    color: Apputil.getActiveColor(),
                                  ),
                                )),
                          )),
                )
              ],
            ),
          ),
          // SizedBox(height: 20),
          // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          //   SizedBox(width: 20),
          //   GestureDetector(
          //       onTap: () {
          //         Navigator.pop(context);
          //         bottomBarHide();
          //       },
          //       child: Text("Cancel")),
          //   SizedBox(width: 50),
          //   GestureDetector(
          //       onTap: () async {
          //         if (textEditingController.text.isNotEmpty) {
          //           controller.comment.text = textEditingController.text;
          //           controller.commentPost();
          //           bottomBarHide();
          //           if (isDetailed) {
          //             Navigator.pop(context);
          //             final PostDetailsController postDetailScreen = Get.find();
          //             final scrollController =
          //                 postDetailScreen.scrollController;

          //             await postDetailScreen.showPost();

          //             await Duration(milliseconds: 300).delay();

          //             if (postDetailScreen.hasPostCreated == false) {
          //               scrollController.animateTo(
          //                 scrollController.position.maxScrollExtent,
          //                 curve: Curves.easeOut,
          //                 duration: const Duration(milliseconds: 300),
          //               );
          //             }
          //           } else {
          //             if (controller.activeSelection == ActiveName.home) {
          //               controller.showPost();
          //             } else if (controller.activeSelection ==
          //                 ActiveName.profile) {
          //               final ProfileController profileController = Get.find();
          //               profileController.userPostList();
          //             }

          //             Navigator.pop(context);
          //           }
          //         }
          //       },
          //       child: Text("Send"))
          // ])
        ]),
      ),
    );
  }
}
