import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers/print.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/user_controller.dart';
import 'package:prospros/model/delete_post/delete_post_res_model.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/model/profile_model/profile_response_model.dart';
import 'package:prospros/model/user_post_list_model/user_post_list_response_model.dart';
import 'package:prospros/model/user_post_list_model/user_post_model.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';

class ProfileController extends GetxController {
  var isPost = true.obs;
  var isOthersPost = false.obs;
  get isAbout => !isPost.value;

  var hasProfilePictureCreated = false.obs;
  var hasProfileCreated = false.obs;
  var hasUserPostListCreated = false.obs;

  var filePath = "".obs;

  //var likeDislike = "".obs;
  var postId = "".obs;

  ProfileResponseModel? profileResponseModel;
  UserPostResponseModel? userPostResponseModel;
  RxList<PostListData> postListData = <PostListData>[].obs;
  var isDataLoaded = false.obs;
  var hideBottomBar = false.obs;

  var page = 1.obs;
  var isNewPage = false.obs;

  var likeDisLikePostIndex = 0.obs;
  var commentPostIndex = (-1).obs;
  var isCurrentUsersProfile = false.obs;

  var isFriendRx = "".obs;

  ///the user id of current app user
  var appUserId = 0.obs;

  var hasProfileCoverPictureUploaded = false.obs;

  // @override
  // onInit() {
  //   super.onInit();
  //   getProfile();
  // }
//Need to check does this solves the loading error failing for profile controller
  @override
  void onReady() {
    // getProfile();
    setUserId();
    super.onReady();
  }

  Future<void> deletePost(String postId) async {
    var postData =
        postListData.firstWhere((element) => element.id.toString() == postId);
    try {
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: {"post_id": postId},
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.deletePost,
      );
      if (result != null) {
        var data = DeletePostRes.fromJson(result);
        if (data.success ?? false) {
          postListData.remove(postData);
          postListData.refresh();
          Get.showSnackbar(GetSnackBar(
              message: "Post deleted successfully.",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        } else {
          Get.showSnackbar(GetSnackBar(
              message: "Something went wrong",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Something went wrong",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
          message: "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  setUserId() {
    try {
      final data = json.decode(HiveStore().get(Keys.userDetails));
      final loginResponseModel = LoginResponseModel.fromJson(data);
      appUserId.value =
          loginResponseModel.data?.personalDetails?.userDetails?.id ?? 0;
    } catch (err) {
      printRed(err.toString());
    }
  }

  String get isFriend {
    var friendRequest = profileResponseModel?.data?.userDetails?.isFriend;
    print("friendRequest ====== $friendRequest");

    final userDetails = LoginResponseModel.fromJson(
        jsonDecode(HiveStore().get(Keys.userDetails)));
    print("UserDetails");
    log(userDetails.toString());
    final userId = userDetails.data?.personalDetails?.userDetails?.id ?? 0;

    final profileId = profileResponseModel?.data?.userDetails?.id;
    print("userId ====== ${userId}");
    print("profileId ===== $profileId");

    isCurrentUsersProfile.value = (userId == profileId);

    if (isCurrentUsersProfile.value || friendRequest == "accepted") {
      return AppTitle.message;
    } else if (friendRequest == "rejected") {
      return AppTitle.requestDenied;
    } else if (friendRequest == "requested") {
      return AppTitle.requestPending;
    }
    return AppTitle.sendChatRequest;
  }

  changeTab() {
    isPost.value = !isPost.value;
  }

  updateNextPageUserPost() {
    final data = userPostResponseModel?.data;
    if (data?.meta?.total != postListData.length &&
        page.value <= (data?.meta?.lastPage ?? 0) &&
        isNewPage.value == false) {
      isNewPage.value = true;
      page += 1;
      userPostList();
    } else {
      isNewPage.value = false;
    }
  }

  updateLikesManually(bool isLiked) {
    // final length = userPostResponseModel?.data?.postListData?.length ?? 0;

    // for (int index = 0; index < length; index++) {
    //   final post = userPostResponseModel?.data?.postListData?[index];

    //   if (post?.id == int.parse(postId.value.isEmpty ? "30" : postId.value)) {
    //     print("Post id from like =======================");
    //     print(post?.id);

    //     print("isLiked: ${isLiked}");
    //     if (isLiked) {
    //       post?.rxTotalLikes.value = (post.rxTotalLikes.value) - 1;
    //       post?.isLiked.value = false;
    //       likeDislike.value = "dislike";
    //     } else {
    //       post?.rxTotalLikes.value = (post.rxTotalLikes.value) + 1;
    //       post?.isLiked.value = true;
    //       likeDislike.value = "like";
    //     }

    //     break;
    //   }
    // }
    final post = postListData[likeDisLikePostIndex.value];
    print(
        "==========likeDisLikePostIndex.value : ${likeDisLikePostIndex.value}");
    print("============= postListData.length : ${postListData.length}");

    if (isLiked) {
      post.rxTotalLikes.value = post.rxTotalLikes.value - 1;
      post.isLiked.value = false;
    } else {
      post.rxTotalLikes.value = post.rxTotalLikes.value + 1;
      post.isLiked.value = true;
    }
  }

  selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 1024,
        maxWidth: 512);
    print(image!.path);
    filePath.value = image!.path;
  }

  selectImageFromSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 1024, maxWidth: 512);
    print(image!.path);
    filePath.value = image!.path;
  }

  userPostList() async {
    final model = UserPostModel(
        userId: profileResponseModel!.data!.userDetails!.id, page: page.value);

    //try {
    isDataLoaded.value = false;
    hasUserPostListCreated.value = true;
    var result = await CoreService().apiService(
      baseURL: Url.baseUrl,
      body: model.toJson(),
      header: {'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'},
      method: METHOD.POST,
      endpoint: Url.userPostList,
    );

    if (result != null) {
      userPostResponseModel = UserPostResponseModel.fromJson(result);
      print("userPostResponseModel=================");
      log(result.toString());

      if (userPostResponseModel!.success!) {
        hasUserPostListCreated.value = false;
        if (userPostResponseModel?.data?.postListData != null ||
            userPostResponseModel!.data!.postListData!.isNotEmpty) {
          postListData.addAll(userPostResponseModel!.data!.postListData!);
          //update();
        }
      } else {
        hasUserPostListCreated.value = false;
        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
            message: userPostResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
    isDataLoaded.value = true;
    // } catch (e) {
    //   hasUserPostListCreated.value = false;
    //   isDataLoaded.value = true;
    //   Get.closeAllSnackbars();
    //   Get.showSnackbar(GetSnackBar(
    //       message: "Server Error",
    //       snackPosition: SnackPosition.BOTTOM,
    //       duration: Duration(seconds: 2),
    //       margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    // }
  }

  profilePictureUpdate() async {
    try {
      hasProfilePictureCreated.value = true;
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.profilePictureUpdate,
        filePath: filePath,
        fileKey: "profile_picture",
      );

      if (result != null) {
        final profileResponseModel = ProfileResponseModel.fromJson(result);
        print("profilePictureUpdate=================");
        log(result.toString());

        if (profileResponseModel.success!) {
          hasProfilePictureCreated.value = false;

          //update it in live version
          Apputil.storProfileImage(
              profileResponseModel.data?.userDetails?.profilePicture);
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Your Profile picture has been successfully updated",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        } else {
          hasProfilePictureCreated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasProfilePictureCreated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  profileCoverPictureUpdate() async {
    try {
      hasProfileCoverPictureUploaded.value = true;
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.coverPictureUpdate,
        filePath: filePath,
        fileKey: "cover_picture",
      );

      if (result != null) {
        profileResponseModel = ProfileResponseModel.fromJson(result);
        print("profilecoverPictureUpdate=================");
        log(result.toString());

        if (profileResponseModel!.success!) {
          hasProfileCoverPictureUploaded.value = false;

          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Your Cover picture has been successfully updated",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        } else {
          hasProfileCoverPictureUploaded.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasProfileCoverPictureUploaded.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  getProfile() async {
    try {
      Apputil.showProgressDialouge();
      hasProfileCreated.value = true;

      final model = {"user_id": "${HiveStore().get(Keys.currentUserId)}"};

      isOthersPost.value =
          HiveStore().get(Keys.currentUserId) == "userId" ? false : true;

      // log('Authorization: Bearer  ${HiveStore().get(Keys.accessToken)}');

      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: isOthersPost.value ? model : {},
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.getProfile);

      if (result != null) {
        profileResponseModel = ProfileResponseModel.fromJson(result);
        print("getProfile=================");
        log(result.toString());

        if (profileResponseModel!.success!) {
          hasProfileCreated.value = false;
          HiveStore().put(
              Keys.activePlanId,
              (profileResponseModel?.data?.userDetails?.subscription?.id ?? 1)
                  .toString());

          final currentUser =
              HiveStore().get(Keys.currentUserId) == "userId" ? true : false;

          if (currentUser) {
            late UserController userController;
            if (Get.isRegistered<UserController>()) {
              userController = Get.find<UserController>();
            } else {
              userController = Get.put(UserController());
            }
            final userDetails = profileResponseModel?.data?.userDetails;
            printRed("======= calling profile .......");
            userController.updateUserDetails(
                name: userDetails?.name ?? "",
                email: userDetails?.email ?? "",
                location: userDetails?.country?.name ?? "",
                phone: userDetails?.contactNumber ?? "",
                categoryId:
                    profileResponseModel?.data?.categoryDetails?.category?.id ??
                        1,
                isProfile: true);
          }

          isFriendRx.value = isFriend;

          Apputil.closeProgressDialouge();

          if (currentUser) {
            isOthersPost.value = false;
            Get.toNamed(profile);
          } else {
            isOthersPost.value = true;
            Get.toNamed(profileDetail);
          }

          await userPostList();
        } else {
          Apputil.closeProgressDialouge();
          hasProfileCreated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          Get.back();
        }
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      hasProfileCreated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      Get.back();
    }
  }
}
