import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/post_details_controller.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/main.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/view/edit_post/edit.dart';
import 'package:prospros/widgets/comment_box.dart';
import 'package:prospros/widgets/image_viewer.dart';
import 'package:prospros/widgets/profile_avatar.dart';

import 'package:flutter_quill/flutter_quill.dart' as quil;

import '../controller/home_controller.dart';
import '../controller/post_controller.dart';

class PostCard extends StatefulWidget {
  //isDummy variable should be removed in the production

  PostCard(
      {super.key,
      required this.profileImg,
      required this.postImage,
      required this.name,
      required this.numDays,
      this.country,
      this.category,
      required this.title,
      required this.content,
      required this.isCreatedByCurrentUser,
      this.onTap,
      required this.numOfComments,
      required this.numOfLikes,
      this.isDetailed = false,
      this.isProfile = false,
      this.isDetailedFromProfile = false,
      required this.postId,
      required this.UserId,
      required this.flagImg,
      required this.isLiked,
      this.index = 0,
      this.onTapLike});
  final String profileImg;
  final String postImage;
  final String name;
  final String numDays;
  final String? country;
  final String? category;
  final String title;
  final String content;
  final String numOfComments;
  final String numOfLikes;
  final VoidCallback? onTap;
  final VoidCallback? onTapLike;
  final bool isDetailed;
  final bool isProfile;
  final String postId;
  final String UserId;
  final String flagImg;
  final bool isLiked;
  final int index;
  final bool isDetailedFromProfile;
  final bool isCreatedByCurrentUser;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final HomeController controller = Get.put(HomeController());

  final PostController postControllerInstance = Get.put(PostController());

  ///getContent Function need to be removed in productions
  getContent(String? dataContent) {
    quil.QuillController _controller = quil.QuillController.basic();

    if (dataContent! == null) {
      return "";
    } else if (dataContent.startsWith("[{")) {
      return jsonDecode(dataContent);
    } else {
      _controller.document.insert(0, dataContent);
      return jsonDecode(jsonEncode(_controller.document.toDelta().toJson()));
    }
  }

  ValueNotifier<int> commentCount = ValueNotifier(0);

  @override
  void initState() {
    commentCount.value = int.tryParse(widget.numOfComments) ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, right: 35),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.category == null
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      color: AppColor.categoryTagColor,
                      child: Text(widget.category!,
                          style: const TextStyle(fontSize: 12))),
              const SizedBox(height: 12),
              widget.isDetailed
                  ? Text(widget.numDays,
                      style: TextStyle(
                          fontFamily: AppTitle.fontMedium,
                          color: Color(0xff979797),
                          fontSize: 12))
                  : GestureDetector(
                      onTap: () async {
                        controller.changePage(ActiveName.profile);
                        //  await HiveStore().put(
                        //                       Keys.currentPostId, e.id!.toString());

                        print("Post user id=============");
                        print(widget.UserId);
                        await HiveStore()
                            .put(Keys.currentUserId, widget.UserId);
                        ProfileController profileController =
                            Get.put(ProfileController());
                        profileController.postListData.clear();
                        profileController.page.value = 1;
                        profileController.userPostResponseModel = null;
                        await profileController.getProfile();
                        // Get.toNamed(profile);
                      },
                      child: Row(children: [
                        ProfileAvatar(profileImg: widget.profileImg),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                          timeZone.getLocalTimeFromUTC(
                                              widget.numDays),
                                          style: AppStyle.communityTxtStyle12),
                                      widget.country != null
                                          ? const Text(" | ",
                                              style:
                                                  AppStyle.communityTxtStyle12)
                                          : Container(),
                                      widget.country != null
                                          ? CountryFlag(flagImg: widget.flagImg)
                                          : Container(),
                                      Expanded(
                                        flex: 1,
                                        child: widget.country != null
                                            ? Text("  ${widget.country ?? ""}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppStyle
                                                    .communityTxtStyle12)
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        )
                      ]),
                    ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: widget.onTap,
                child: Material(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: AppTitle.fontMedium,
                            //fontWeight: FontWeight.bold
                          )),
                      const SizedBox(height: 8),
                      QuillProvider(
                        configurations: QuillConfigurations(
                          controller: quil.QuillController(
                            document: quil.Document.fromJson(
                                getContent(widget.content)),
                            selection: TextSelection.collapsed(offset: 0),
                          ),
                          sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('de'),
                              animationConfigurations:
                                  QuillAnimationConfigurations(
                                      checkBoxPointItem: true)),
                        ),
                        child: Stack(
                          children: [
                            QuillEditor.basic(
                              configurations: const QuillEditorConfigurations(
                                readOnly: true,
                                showCursor: false,
                                scrollable: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      widget.postImage.isNotEmpty
                          ? GestureDetector(
                              onTap: () => Get.to(InterActiveImageViewer(
                                  fileUrl: widget.postImage)),
                              child: CachedNetworkImage(
                                  imageUrl: widget.postImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Center(
                                        child: Image(
                                          image: imageProvider,
                                        ),
                                      ),
                                  placeholder: (context, url) => Container(),
                                  //Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container()),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        var likeDislike = "";
                        controller.id.value = widget.postId;
                        //   controller.updateLikesManually(isLiked);

                        Function(bool isLike) runUpdateManually =
                            (bool isLike) {
                          print(isLike);
                        };

                        if (widget.isDetailed) {
                          print("Detailed Post =================");
                          print(widget.isLiked);
                          runUpdateManually = (bool islike) {
                            PostDetailsController postDetailsController =
                                Get.find();
                            postDetailsController.postId.value = widget.postId;
                            controller.likeModalIndex.value =
                                postDetailsController
                                    .likeDisLikePostIndex.value;
                            postDetailsController.updateLikesManually(islike);
                            final isDetailedProfile = postDetailsController
                                .isDetailedFromProfile.value;
                            if (isDetailedProfile) {
                              ProfileController profileController = Get.find();
                              profileController.postId.value = widget.postId;
                              controller.likeModalIndex.value =
                                  profileController.likeDisLikePostIndex.value;
                              //profileController.likeDisLikePostIndex.value = index;
                              profileController
                                  .updateLikesManually(widget.isLiked);
                            }
                          };

                          if (widget.isProfile) {
                            controller.likePost(
                                widget.isLiked, runUpdateManually,
                                isNotProfile: false);
                          } else {
                            controller.likeModalIndex.value = widget.index;
                            controller.likePost(
                                widget.isLiked, runUpdateManually);
                          }
                        } else if (widget.isProfile) {
                          ProfileController profileController = Get.find();
                          profileController.postId.value = widget.postId;
                          profileController.likeDisLikePostIndex.value =
                              widget.index;
                          controller.likeModalIndex.value = widget.index;
                          controller.likePost(widget.isLiked,
                              profileController.updateLikesManually,
                              isNotProfile: false);
                        } else {
                          likeDislike = controller.likeDislike.value;
                          controller.likeDisLikePostIndex.value = widget.index;
                          controller.likeModalIndex.value = widget.index;
                          controller.likePost(
                              widget.isLiked, runUpdateManually);
                        }
                      },
                      child: IgnorePointer(
                        ignoring: controller.hasPostLiked.value,
                        child: Row(children: [
                          SvgPicture.asset(AppImage.like,
                              width: 20, height: 20),
                          Container(
                            color: Colors.white,
                            height: 20,
                            width: 100,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Text(
                                          " ${(int.tryParse(widget.numOfLikes) ?? 0) <= 0 ? "" : NumberFormat.compact().format(int.parse(widget.numOfLikes))}",
                                          style: const TextStyle(
                                              fontFamily: AppTitle.fontMedium,
                                              fontSize: 12,
                                              color:
                                                  AppColor.bottombarImgColor)),
                                      (controller.hasPostLiked.value &&
                                              controller.likeModalIndex.value ==
                                                  widget.index)
                                          ? SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.white))
                                          : Container()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    // ignoring: controller.hasCommentAdded.value,
                    ignoring: false,
                    child: GestureDetector(
                      onTap: () async {
                        controller.id.value = widget.postId;

                        if (controller.activeSelection == ActiveName.home) {
                          controller.hideBottomBar.value = true;
                          if (widget.isDetailed == false) {
                            controller.commentPostIndex.value = widget.index;
                          }
                        } else if (controller.activeSelection ==
                            ActiveName.profile) {
                          final ProfileController profileController =
                              Get.find();
                          profileController.hideBottomBar.value = true;

                          if (widget.isDetailed == false) {
                            controller.commentPostIndex.value = widget.index;
                            profileController.commentPostIndex.value =
                                widget.index;
                          }
                        }
                        Get.bottomSheet(
                                CommentBox(isDetailed: widget.isDetailed))
                            .then((value) {
                          if (value is bool) {
                            if (value) {
                              //commented successfully
                              commentCount.value++;
                            }
                          }
                          HomeController controller = Get.put(HomeController());
                          printRed(
                              "This is getting called ${Get.currentRoute}");
                          if (controller.activeSelection == ActiveName.home ||
                              controller.activeSelection ==
                                  ActiveName.profile) {
                            controller.hideBottomBar.value = false;
                          }
                          if (Get.currentRoute == "/profile") {
                            ProfileController profileController = Get.find();
                            profileController.hideBottomBar.value = false;
                          }
                        });
                        // showBottomSheet(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return CommentBox(isDetailed: isDetailed);
                        //     });
                      },
                      child: Row(children: [
                        SvgPicture.asset(AppImage.homeMessage,
                            width: 20, height: 20),
                        ValueListenableBuilder(
                          valueListenable: commentCount,
                          builder: (context, commCtr, child) {
                            return Row(
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(
                                        " ${commCtr == 0 ? "" : NumberFormat.compact().format(commCtr)} ",
                                        style: const TextStyle(
                                            fontFamily: AppTitle.fontMedium,
                                            fontSize: 12,
                                            color: AppColor.bottombarImgColor)),
                                    controller.hasCommentAdded.value &&
                                            controller.commentPostIndex.value ==
                                                widget.index
                                        ? SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator())
                                        : Container(),
                                  ],
                                ),
                                Text(commCtr == 0 ? "" : "Comments",
                                    style: const TextStyle(
                                        fontFamily: AppTitle.fontMedium,
                                        fontSize: 12,
                                        color: AppColor.bottombarImgColor)),
                              ],
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18)
            ]),
            Positioned(
                right: -15,
                top: 0,
                child: widget.isCreatedByCurrentUser
                    ? PopupMenuButton<String>(
                        onSelected: (value) {
                          print(value);
                          print(Get.currentRoute);
                          if (value == "edit") {
                            if (Get.currentRoute == home) {
                            } else if (Get.currentRoute == profile) {
                              Get.to(EditPostScreen(
                                  postId: widget.postId,
                                  postImage: widget.postImage,
                                  postTitle: widget.title,
                                  postBody: widget.content));
                            }
                          } else if (value == "delete") {
                            if (Get.currentRoute == home) {
                              controller.deletePost(widget.postId);
                            } else if (Get.currentRoute == profile) {
                              ProfileController profileController = Get.find();
                              profileController.deletePost(widget.postId);
                            }
                          } else {}
                        },
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: "edit",
                                child: Text('Edit Post'),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text('Delete Post'),
                              ),
                            ])
                    : SizedBox()),
            Positioned(
                right: -15,
                top: 0,
                child: widget.isCreatedByCurrentUser
                    ? SizedBox()
                    : PopupMenuButton<String>(
                        onSelected: (value) {
                          print(value);
                          print(Get.currentRoute);
                          if (value == "reoprt") {
                            print("Report Alert");
                          } else {}
                        },
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                              // PopupMenuItem(
                              //   value: "reoprt",
                              //   child: Text('Report'),
                              // ),
                              PopupMenuItem(
                                child: const Text('Report'),
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Warning",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                        content: const Text(
                                            "Would you like to report this post?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: postControllerInstance
                                                    .hasPostReported.value
                                                ? SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Text('Yes'),
                                            onPressed: () async {
                                              await postControllerInstance
                                                  .reportPost(
                                                      widget.postId.toString());
                                              Navigator.of(context).pop();

                                              if (Get.currentRoute == home) {
                                                controller.showPost();
                                              } else if (Get.currentRoute ==
                                                  profile) {
                                              } else {}

                                              // if (postControllerInstance
                                              //         .hasPostReported ==
                                              //     true) {}
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ])),
          ],
        ),
      ),
    );
  }

  Widget reportAlertBox(BuildContext context) {
    return AlertDialog(
      title: const Text('Report alert'),
      content: const Text("do you want to report!"),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {},
        ),
      ],
    );
  }
}
