import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/model/profile_model/profile_response_model.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/profile/user_post_widget.dart';
import 'package:prospros/widgets/custom_scaffold.dart';
import 'package:prospros/widgets/profile_avatar.dart';
import 'package:sizing/sizing.dart';

import '../controller/chat_controller.dart';
import '../controller/profile_controller.dart';
import '../widgets/common_widget.dart';
import '../widgets/cover_picture_widget.dart';

class Profile extends StatelessWidget {
  Profile({super.key, this.isDetail = false});
  final bool isDetail; //Detailed Profile

  ProfileController controller = Get.find<ProfileController>();
  ScrollController scrollController = ScrollController();

  changeTab() {
    controller.changeTab();
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      controller.updateNextPageUserPost();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_scrollListener);
    });

    return Obx(
      () => Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(20), child: Container()),
          body: Obx(
            () => ModalProgressHUD(
              inAsyncCall: controller.hasProfileCreated.value,
              child: controller.hasProfileCreated.value
                  ? Container()
                  : controller.profileResponseModel == null
                      ? Container()
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              Container(
                                height: 160,
                                // height: (isDetail ? true : controller.isAbout)
                                //     ? 52
                                //     : 150,
                                color: AppColor.transparentColor,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: controller
                                                .hasProfileCoverPictureUploaded
                                                .value
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 155,
                                                child: Center(
                                                    child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )))
                                            : (controller.profileResponseModel !=
                                                        null
                                                    ? controller
                                                            .profileResponseModel
                                                            ?.data
                                                            ?.userDetails
                                                            ?.coverPicture
                                                            ?.isNotEmpty ??
                                                        false
                                                    : false)
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 155,
                                                    child: CachedNetworkImage(
                                                        imageUrl: controller
                                                                .profileResponseModel
                                                                ?.data
                                                                ?.userDetails
                                                                ?.coverPicture ??
                                                            "",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Center(
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 155,
                                                                child: Image(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(),
                                                        //Center(child: CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            DefaultCoverPictuteWidget()),
                                                  )
                                                : DefaultCoverPictuteWidget()),
                                    Positioned(
                                      left: 10,
                                      top: 15.ss,
                                      child: controller.isOthersPost.value
                                          ? GestureDetector(
                                              onTap: () {
                                                if (controller
                                                    .isOthersPost.value) {
                                                  Get.back();
                                                } else {
                                                  changeTab();
                                                }
                                              },
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                2))),
                                                child: const Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 10),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 15,
                                      child: controller.isOthersPost.value
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () async {
                                                showBottomModal(context);
                                              },
                                              child: Container(
                                                width: 25,
                                                height: 20,
                                                child: Icon(
                                                  Icons.photo_camera,
                                                  color: Colors.grey,
                                                  size: 22.0,
                                                ),
                                              ),
                                            ),
                                    ),
                                    isDetail || controller.isOthersPost.value
                                        ? Container()
                                        : controller.isPost.value
                                            ? Positioned(
                                                right: 16,
                                                top: 13,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        drawerNavigation);
                                                  },
                                                  child: const Icon(
                                                    Icons.menu,
                                                    size: 24,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                    Positioned(
                                      bottom: -40,
                                      right:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              40,
                                      child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 40),
                                    ),
                                    Positioned(
                                      bottom: -35,
                                      right:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              35,
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await controller.selectImage();
                                              await controller
                                                  .profilePictureUpdate();
                                              controller.getProfile();
                                            },
                                            child: (controller.profileResponseModel != null
                                                    ? controller
                                                            .profileResponseModel
                                                            ?.data
                                                            ?.userDetails
                                                            ?.profilePicture
                                                            ?.isNotEmpty ??
                                                        false
                                                    : false)
                                                ? CachedNetworkImage(
                                                    imageUrl: controller
                                                            .profileResponseModel
                                                            ?.data
                                                            ?.userDetails
                                                            ?.profilePicture ??
                                                        "",
                                                    imageBuilder: (context, imageProvider) =>
                                                        CircleAvatar(
                                                            radius: 35,
                                                            backgroundImage:
                                                                imageProvider),
                                                    placeholder: (context, url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) =>
                                                        DefaultProfileAvatar())
                                                : const CircleAvatar(backgroundImage: AssetImage(AppImage.profileImg3), radius: 35),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isDetail
                                          ? false
                                          : (controller.isPost.value
                                              ? true
                                              : false),
                                      child: Positioned(
                                        bottom: 20,
                                        right:
                                            (MediaQuery.of(context).size.width /
                                                    2) +
                                                20,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Image.asset(
                                                  AppImage.profileCrown,
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 11 + 40),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(
                                    controller.profileResponseModel?.data
                                            ?.userDetails?.name ??
                                        "",
                                    //"Robert John",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              const SizedBox(height: 8),
                              TitleTag(
                                  flagImg: controller.profileResponseModel?.data
                                          ?.userDetails?.country?.flag ??
                                      "",
                                  category: controller
                                          .profileResponseModel
                                          ?.data
                                          ?.professionalDetails
                                          ?.professionalDesignation ??
                                      "",
                                  country: controller.profileResponseModel?.data
                                          ?.userDetails?.country?.name ??
                                      ""),
                              SizedBox(
                                  height: isDetail
                                      ? 26
                                      : (controller.isAbout ? 26 : 34)),
                              controller.isOthersPost.value && !isDetail
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: (isDetail
                                                      ? false
                                                      : controller.isPost.value)
                                                  ? Colors.white
                                                  : AppColor.appColor,
                                              side: const BorderSide(
                                                  color: AppColor.appColor),
                                              minimumSize:
                                                  const Size.fromHeight(42)),
                                          onPressed: () async {
                                            print(isDetail);
                                            print("========= ${isDetail}");
                                            if (isDetail) {
                                              final ChatService chatService =
                                                  Get.find();

                                              ///receiver user id
                                              final profileId = controller
                                                  .profileResponseModel
                                                  ?.data
                                                  ?.userDetails
                                                  ?.id;
                                              var currentUserProfile =
                                                  Apputil.getUserProfile();

                                              printRed("senderId" +
                                                  currentUserProfile!
                                                      .data!
                                                      .personalDetails!
                                                      .userDetails!
                                                      .id!
                                                      .toString());
                                              printRed("receiver ID" +
                                                  profileId.toString());
                                              chatService
                                                  .createOrUpdateChatRoom(
                                                      senderUserId:
                                                          currentUserProfile
                                                              .data!
                                                              .personalDetails!
                                                              .userDetails!
                                                              .id!
                                                              .toString(),
                                                      receiverUserId:
                                                          profileId.toString());

                                              //update current user details
                                              await chatService
                                                  .updateUserDetails(
                                                userId: currentUserProfile
                                                    .data!
                                                    .personalDetails!
                                                    .userDetails!
                                                    .id!
                                                    .toString(),
                                                userName: currentUserProfile
                                                        .data
                                                        ?.personalDetails
                                                        ?.userDetails
                                                        ?.name ??
                                                    "",
                                                profileImageUrl:
                                                    currentUserProfile
                                                            .data
                                                            ?.personalDetails
                                                            ?.userDetails
                                                            ?.profilePicture ??
                                                        "",
                                              );
                                              //update receiver user details
                                              await chatService
                                                  .updateUserDetails(
                                                userId: controller
                                                    .profileResponseModel!
                                                    .data!
                                                    .userDetails!
                                                    .id
                                                    .toString(),
                                                userName: controller
                                                        .profileResponseModel
                                                        ?.data
                                                        ?.userDetails
                                                        ?.name ??
                                                    "",
                                                profileImageUrl: controller
                                                        .profileResponseModel
                                                        ?.data
                                                        ?.userDetails
                                                        ?.profilePicture ??
                                                    "",
                                              );
                                              ChatController chatController =
                                                  Get.put(ChatController());

                                              await chatController
                                                  .initializeChatSession(
                                                      receiverId:
                                                          profileId.toString());

                                              Get.toNamed(chatScreen);

                                              // if (controller.isFriend ==
                                              //     AppTitle.sendChatRequest) {
                                              //   ChatController chatController =
                                              //       Get.put(ChatController());
                                              //   chatController.sendChatRequest(
                                              //       (profileId) ?? 0);
                                              // } else if (controller.isFriend ==
                                              //     AppTitle.message) {
                                              //   Get.toNamed(chatScreen);
                                              // }
                                            } else if (controller.isAbout) {
                                              if (controller
                                                  .isCurrentUsersProfile
                                                  .value) {
                                                Get.toNamed(message);
                                              } else {
                                                Get.toNamed(chatScreen);
                                              }
                                            } else if (controller
                                                .isPost.value) {
                                              Get.toNamed(editProfile);
                                            }
                                          },
                                          child: Text(
                                            (isDetail
                                                    ? false
                                                    : controller.isPost.value)
                                                ? AppTitle.editProfile
                                                //  : AppTitle.message,
                                                // : controller.isFriend!,
                                                // : controller.isFriendRx.value,
                                                : "Message",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: (isDetail
                                                        ? false
                                                        : controller
                                                            .isPost.value)
                                                    ? AppColor.appColor
                                                    : Colors.white),
                                          ))),
                              Visibility(
                                visible:
                                    isDetail ? false : controller.isPost.value,
                                child: Column(children: [
                                  const SizedBox(height: 34),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(children: [
                                      Text(AppTitle.category,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  AppColor.loginDividerColor)),
                                      SizedBox(width: 8),
                                      CategoryChip(
                                          label: controller
                                                  .profileResponseModel
                                                  ?.data
                                                  ?.categoryDetails
                                                  ?.category
                                                  ?.categoryName ??
                                              "")
                                    ]),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(children: [
                                      const Text(AppTitle.subCategories,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0XFF9EA2B7))),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: (controller
                                                      .profileResponseModel
                                                      ?.data
                                                      ?.categoryDetails
                                                      ?.category
                                                      ?.subCategory ==
                                                  null)
                                              ? Container()
                                              : Row(
                                                  children: controller
                                                      .profileResponseModel!
                                                      .data!
                                                      .categoryDetails!
                                                      .category!
                                                      .subCategory!
                                                      .map((e) => Row(
                                                            children: [
                                                              CategoryChip(
                                                                  label: e
                                                                      .categoryName!),
                                                              SizedBox(
                                                                  width: 8),
                                                            ],
                                                          ))
                                                      .toList()),
                                        ),
                                      )
                                    ]),
                                  ),
                                ]),
                              ),
                              SizedBox(
                                  height: controller.isPost.value ? 28 : 24),
                              Container(
                                  height: 4, color: AppColor.homeDividerColor),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0),
                                child: Row(children: [
                                  const SizedBox(width: 20),
                                  SwitchProfileButton(
                                      title: AppTitle.post,
                                      onTap: () => changeTab(),
                                      isActive: controller.isPost.value),
                                  const SizedBox(width: 40),
                                  SwitchProfileButton(
                                      title: AppTitle.about,
                                      onTap: () => changeTab(),
                                      isActive: controller.isAbout),
                                ]),
                              ),
                              Container(
                                  height: 4, color: AppColor.homeDividerColor),
                              Visibility(
                                visible: controller.isPost.value,
                                // child: controller.hasUserPostListCreated.value ||
                                //         (controller.userPostResponseModel
                                //                 ?.data ==
                                //             null)
                                //     ? Container()
                                //     :
                                child: UserPostWidget(isScrollable: true),

                                // : Column(
                                //     children: controller
                                //         .userPostResponseModel!
                                //         .data!
                                //         .postListData!
                                //         .map((e) => Column(
                                //               children: [
                                //                 PostCard(
                                //                     isProfile: true,
                                //                     flagImg: e.country!
                                //                             .flag ??
                                //                         "",
                                //                     UserId: e.postedBy!.id
                                //                         .toString(),
                                //                     postId:
                                //                         e.id.toString(),
                                //                     onTap: () async {
                                //                       print(
                                //                           "post id ========");
                                //                       print(e.id!
                                //                           .toString());
                                //                       await HiveStore().put(
                                //                           Keys
                                //                               .currentPostId,
                                //                           e.id!
                                //                               .toString());
                                //                       Get.toNamed(
                                //                           postDetails);
                                //                     },
                                //                     name: e.postedBy!
                                //                         .name!,
                                //                     numDays: e
                                //                         .postCreatedAt!,
                                //                     profileImg: e
                                //                         .postedByImage!,
                                //                     title: e.postTitle!,
                                //                     content: e
                                //                         .postDescription!,
                                //                     postImage:
                                //                         e.postImages!,
                                //                     numOfLikes: e
                                //                         .rxTotalLikes
                                //                         .value
                                //                         .toString(),
                                //                     isLiked:
                                //                         e.isLiked.value,
                                //                     onTapLike: () {
                                //                       controller.postId
                                //                               .value =
                                //                           e.id.toString();
                                //                       controller
                                //                           .updateLikesManually(e
                                //                               .isLiked
                                //                               .value);
                                //                       controller
                                //                           .likeDislike
                                //                           .value;
                                //                     },
                                //                     numOfComments: e
                                //                         .totalComments!
                                //                         .toString()),
                                //                 const Divider(
                                //                     height: 0.5,
                                //                     color: Colors.grey)
                                //               ],
                                //             ))
                                //         .toList()),
                              ),
                              Visibility(
                                visible: controller.isAbout,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0, right: 16.0, top: 24),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ProfileAbout(
                                          profileResponseModel: controller
                                              .profileResponseModel!)),
                                ),
                              ),
                              //Container(height: 4, color: AppColor.homeDividerColor),
                            ],
                          ),
                        ),
            ),
          )),
    );
  }

  void showBottomModal(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return Container(
            height: fullHeight(context) * 0.21,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Choice cover photo",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        goBack(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    hSpace(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context, 'Cancel');
                            await controller
                                .selectImageFromSource(ImageSource.camera);
                            await controller.profileCoverPictureUpdate();
                          },
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColor.appColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        vSpace(5),
                        textMedium(
                            color: Colors.grey, size: 15, text: "Camera"),
                      ],
                    ),
                    hSpace(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context, 'Cancel');
                            await controller
                                .selectImageFromSource(ImageSource.gallery);
                            await controller.profileCoverPictureUpdate();
                          },
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo,
                                color: AppColor.appColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        vSpace(5),
                        textMedium(
                            color: Colors.grey, size: 15, text: "Gallery"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  // showOptionDialog(context) async {
  //   showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       elevation: 15,
  //       actionsPadding: const EdgeInsets.all(15),
  //       actions: <Widget>[
  //         SizedBox(
  //           height: 5,
  //         ),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             alignment: Alignment.center,
  //             height: 40,
  //             color: Colors.grey,
  //             child: TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context, 'Cancel');
  //                 await controller.selectImageFromSource(ImageSource.camera);
  //                 await controller.profileCoverPictureUpdate();
  //               },
  //               child: const Padding(
  //                 padding: EdgeInsets.only(),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.camera_alt,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Text(
  //                       'Camera',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             alignment: Alignment.center,
  //             height: 40,
  //             color: Colors.grey,
  //             child: TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context, 'Cancel');
  //                 await controller.selectImageFromSource(ImageSource.gallery);
  //                 await controller.profileCoverPictureUpdate();
  //               },
  //               child: const Padding(
  //                 padding: EdgeInsets.only(),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.photo,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Text(
  //                       'Gallery',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             height: 40,
  //             color: Colors.red,
  //             alignment: Alignment.center,
  //             child: TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context, 'Cancel');
  //               },
  //               child: const Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.cancel_outlined,
  //                     color: Colors.white,
  //                   ),
  //                   SizedBox(
  //                     width: 15,
  //                   ),
  //                   Text(
  //                     'Cancel',
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class SwitchProfileButton extends StatelessWidget {
  const SwitchProfileButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.isActive = false});
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                color: isActive
                    ? AppColor.appColor
                    : AppColor.bottombarImgColor)));
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: AppColor.homeDividerColor,
      label: Text(label,
          style:
              const TextStyle(fontSize: 14, color: AppColor.loginDividerColor)),
      shape: const RoundedRectangleBorder(),
    );
  }
}

class TitleTag extends StatelessWidget {
  const TitleTag(
      {super.key, this.country, required this.category, required this.flagImg});
  final String? country;
  final String category;
  final String flagImg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(category, style: AppStyle.communityTxtStyle12),
        Text(country != null ? "  |  " : " ",
            style: AppStyle.communityTxtStyle12),
        country != null
            // ? SvgPicture.asset(AppImage.communityCountry)
            ? CountryFlag(flagImg: flagImg)
            : Container(),
        country != null
            ? Text(" $country", style: AppStyle.communityTxtStyle12)
            : Container(),
      ],
    );
  }
}

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({super.key, required this.profileResponseModel});
  final ProfileResponseModel profileResponseModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 23, left: 24, bottom: 32),
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.borderColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Education Details", style: AppStyle.profileAbout16),
              SizedBox(height: 16),
              ProfileDegreeWidget(
                  educationTitle: "Highest Education Degree",
                  degree: //"Doctor of Medicine"
                      profileResponseModel
                              .data!.educationalDetails!.highestQualification ??
                          ""),
              SizedBox(height: 16),
              ProfileDegreeWidget(
                  educationTitle: "Specialized in",
                  degree: profileResponseModel
                          .data!.educationalDetails!.areaOfSpecialization ??
                      "" //"Doctor of Medicine"

                  )
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 19, left: 24, bottom: 32),
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.borderColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Professional Details", style: AppStyle.profileAbout16),
              SizedBox(height: 16),
              ProfileDegreeWidget(
                  educationTitle: "Professional Designation",
                  degree: profileResponseModel
                          .data!.professionalDetails!.professionalDesignation ??
                      ""),
              SizedBox(height: 16),
              ProfileDegreeWidget(
                  educationTitle: "Professional Field",
                  degree: profileResponseModel
                          .data!.professionalDetails!.professionalField ??
                      ""),
              SizedBox(height: 16),
              ProfileDegreeWidget(
                  educationTitle: "Office/Business",
                  degree: profileResponseModel
                          .data!.professionalDetails!.officeName ??
                      "")
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ProfileDegreeWidget extends StatelessWidget {
  const ProfileDegreeWidget(
      {super.key, required this.educationTitle, required this.degree});
  final String educationTitle;
  final String degree;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(educationTitle, style: AppStyle.profileAbout14),
      const SizedBox(height: 4),
      Text(degree, style: AppStyle.profileAbout14Black),
    ]);
  }
}
