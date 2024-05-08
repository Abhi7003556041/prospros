import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/widgets/back_button.dart';
import 'package:prospros/widgets/profile_avatar.dart';

import '../../controller/home_controller.dart';
import '../../controller/post_details_controller.dart';
import '../../widgets/post_card.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  //late  final PostDetailsController controller = Get.put(PostDetailsController());
  late final PostDetailsController controller;

  final HomeController homeControllerInstance = Get.find();

  @override
  initState() {
    super.initState();
    controller = Get.put(PostDetailsController());
    if (Get.arguments != null) {
      controller.isDetailedFromProfile.value = true;
    }
  }

  @override
  void dispose() {
    controller.isDetailedFromProfile.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.hasPostCreated.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: controller.postDetailsResponseModel == null
              ? Container()
              : Stack(children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 35.0, top: 65, right: 35),
                              child: Obx(
                                () => PostCard(
                                  isCreatedByCurrentUser: false,
                                  isReportPossible: controller
                                              .postDetailsResponseModel
                                              ?.data
                                              ?.postedBy
                                              ?.id
                                              ?.toString() ==
                                          homeControllerInstance.userId.value
                                              .toString()
                                      ? false
                                      : true,
                                  flagImg: controller.postDetailsResponseModel
                                          ?.data?.country?.flag ??
                                      "",
                                  UserId: controller.postDetailsResponseModel
                                          ?.data?.postedBy?.id
                                          ?.toString() ??
                                      "",
                                  postId: controller
                                          .postDetailsResponseModel?.data?.id
                                          .toString() ??
                                      "",
                                  isDetailed: true,
                                  profileImg: controller
                                          .postDetailsResponseModel
                                          ?.data
                                          ?.postedByImage ??
                                      "",
                                  postImage: controller.postDetailsResponseModel
                                          ?.data?.postImages ??
                                      "",
                                  name: controller.postDetailsResponseModel
                                          ?.data?.postedBy?.name ??
                                      "",
                                  numDays: controller.postDetailsResponseModel
                                          ?.data?.postCreatedAt ??
                                      "",
                                  title: controller.postDetailsResponseModel
                                          ?.data?.postTitle ??
                                      "",
                                  content: controller.postDetailsResponseModel
                                          ?.data?.postDescription ??
                                      "",
                                  numOfComments: (controller
                                                  .postDetailsResponseModel
                                                  ?.data
                                                  ?.rxTotalComments
                                                  .value ??
                                              0) <=
                                          0
                                      ? "0"
                                      : (controller.postDetailsResponseModel
                                              ?.data?.rxTotalComments.value
                                              .toString() ??
                                          ""),
                                  isLiked: controller.postDetailsResponseModel
                                          ?.data?.isLiked.value ??
                                      false,
                                  numOfLikes: ((controller
                                                  .postDetailsResponseModel
                                                  ?.data
                                                  ?.rxTotalLikes
                                                  .value ??
                                              0) <=
                                          0)
                                      ? ""
                                      : controller.postDetailsResponseModel
                                              ?.data?.rxTotalLikes.value
                                              .toString() ??
                                          "0",
                                  //numOfLikes: controller.postDetailsResponseModel!.data!.totalLikes.toString()
                                ),
                              )),
                          const Divider(height: 0.5, color: Colors.grey),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 35.0, right: 35),
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                Comments(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 10,
                      child: AppBackButton.stackBackButton()),
                ]),
        ),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  Comments({super.key});
  final PostDetailsController controller = Get.find<PostDetailsController>();

  Text commentBtmBtn(String text, {bool isHidden = false}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: AppTitle.fontMedium,
          color: isHidden
              ? Colors.white
              : Color(
                  0xff979797,
                ),
          fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "controller.postDetailsResponseModel!.data!.comments!.length : ${controller.postDetailsResponseModel!.data!.comments!.length}");
    return Obx(
      () => Column(children: [
        ...controller.postDetailsResponseModel!.data!.comments!.map((e) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileAvatar(profileImg: e.userImage ?? ""),
                    // CircleAvatar(
                    //     backgroundColor: Colors.grey,
                    //     child: Image.asset(AppImage.personImg)),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.user ?? "",
                                    style: TextStyle(
                                        fontFamily: AppTitle.fontMedium,
                                        fontSize: 14)),
                                IgnorePointer(
                                  ignoring: e.isLiked?.value ?? false,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: ModalProgressHUD(
                                      inAsyncCall: e.isLiked?.value ?? false,
                                      child: GestureDetector(
                                          onTap: () {
                                            e.isLiked?.value = true;
                                            final commentId = e.id!;
                                            var isLike = "like";
                                            if (e.isUserLike!) {
                                              isLike = "dislike";
                                              e.totalLike!.value -= 1;
                                              e.isUserLike = false;
                                            } else {
                                              e.totalLike!.value += 1;
                                              e.isUserLike = true;
                                            }

                                            controller.commentLikePost(
                                                commentId, isLike, () {
                                              e.isLiked?.value = controller
                                                  .isCommentLiked.value;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                              AppImage.likeSvgIcon)),
                                    ),
                                  ),
                                )
                              ]),
                          const SizedBox(height: 8),
                          Text(e.commentText!,
                              style: TextStyle(
                                  fontFamily: AppTitle.fontMedium,
                                  fontSize: 12,
                                  color: Color(0xff979797))),
                          const SizedBox(height: 16),
                          Row(children: [
                            commentBtmBtn(e.commentCreatedAt!),
                            const SizedBox(width: 20),
                            commentBtmBtn(
                                e.totalLike?.value == null
                                    ? ""
                                    : e.totalLike!.value.toString() + "Likes",
                                isHidden: e.totalLike?.value == null
                                    ? true
                                    : e.totalLike!.value == 0),
                            const SizedBox(width: 20),
                            commentBtmBtn("Reply")
                          ]),
                          const SizedBox(height: 33),
                          if (e.subComments != null)
                            ...e.subComments!
                                .map((e) => CommentCard(
                                      commentCreatedAt: e.commentCreatedAt!,
                                      commentText: e.commentText!,
                                      profileImg: e.userImage!,
                                      totalLike: e.totalLike!,
                                      userName: e.user!,
                                    ))
                                .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }).toList(),
        controller.postDetailsResponseModel?.data?.comments?.length == 0
            ? Container()
            : const Divider(height: 0.5, color: Colors.grey)
      ]),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard(
      {super.key,
      required this.profileImg,
      required this.userName,
      required this.commentText,
      required this.commentCreatedAt,
      required this.totalLike});

  final String profileImg;
  final String userName;
  final String commentText;
  final String commentCreatedAt;
  final int totalLike;

  Text commentBtmBtn(String text, {bool isHidden = false}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: AppTitle.fontMedium,
          color: isHidden
              ? Colors.white
              : Color(
                  0xff979797,
                ),
          fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(profileImg: profileImg),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userName,
                              style: TextStyle(
                                  fontFamily: AppTitle.fontMedium,
                                  fontSize: 14)),
                          SvgPicture.asset(AppImage.likeSvgIcon)
                        ]),
                    const SizedBox(height: 8),
                    Text(commentText,
                        style: TextStyle(
                            fontFamily: AppTitle.fontMedium,
                            fontSize: 12,
                            color: Color(0xff979797))),
                    const SizedBox(height: 16),
                    Row(children: [
                      commentBtmBtn(commentCreatedAt),
                      const SizedBox(width: 20),
                      commentBtmBtn(totalLike.toString() + "Likes",
                          isHidden: totalLike == 0),
                      const SizedBox(width: 20),
                      commentBtmBtn("Reply")
                    ]),
                    const SizedBox(height: 33),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
