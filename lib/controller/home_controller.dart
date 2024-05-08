import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/model/comment_model/comment_post_model.dart';
import 'package:prospros/model/comment_model/comment_post_response_model.dart';
import 'package:prospros/model/delete_post/delete_post_res_model.dart';
import 'package:prospros/model/home_model/home_response_model.dart';
import 'package:prospros/model/like_comment_model/comment_like_response_model.dart';
import 'package:prospros/model/like_post_model/like_post_model.dart';
import 'package:prospros/model/like_post_model/like_post_response_model.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/util/app_util.dart';
import '../model/home_model/home_model.dart';

enum ActiveName { home, community, message, profile }

class HomeController extends GetxController {
  final ChatService chatService = Get.put(ChatService(), permanent: true);
  var id = "".obs;

  var userId = 0.obs;
  var page = 1.obs;
  var isNewPage = false.obs;
  var totalLength = 0.obs;

  var activeSelection = ActiveName.home.obs;
  var activeMessageButton = false.obs;
  var hideBottomBar = false.obs;
  var linearProgress = false.obs;
  var isDebouncerActive = false.obs;
  var filterCount = 0.obs;
  var isUserStartedTypingComment = false.obs;
  var hideSearchTextField = true.obs;
  var setScrollTop = true.obs;

  TextEditingController search = TextEditingController(text: "");
  TextEditingController comment = TextEditingController(text: "");
  final ScrollController scrollController = ScrollController();

  Rx<int> likeModalIndex = (-1).obs;

  changePage(ActiveName currentSelection) {
    activeSelection.value = currentSelection;
    print("activeSelection.value : ${activeSelection.value}");
  }

  var hasPostCreated = false.obs;
  var hasPostLiked = false.obs;
  var likeDislike = "".obs;
  var likeDisLikePostIndex = 0.obs;
  var hasCommentAdded = false.obs;

  Timer? debounceTimer;

  HomeResponseModel? homeResponseModel;
  RxList<HomeData> homeData = <HomeData>[].obs;
  LikePostResponseModel? likePostResponseModel;
  CommentPostResponseModel? commentPostResponseModel;
  CommentLikeResponseModel? commentLikeResponseModel;

  var isDetailedFromProfile = true.obs;
  var commentPostIndex = 0.obs;

  @override
  onReady() {
    setUserId();
    loadInitialData();

    super.onReady();
  }

  loadInitialData() async {
    await Apputil.refreshProfileDetails();
    showPost();
  }

  // @override
  // onReady() {
  //   super.onReady();

  //   // showPost();
  // }

  debounce() {
    page.value = 1;
    linearProgress.value = true;
    Timer(Duration(milliseconds: 300), () {
      if (isDebouncerActive.value) {
        showPost();
      }
    });
  }

  setUserId() {
    try {
      final data = json.decode(HiveStore().get(Keys.userDetails));
      final loginResponseModel = LoginResponseModel.fromJson(data);

      //update it in live version
      Apputil.storProfileImage(loginResponseModel
          .data?.personalDetails?.userDetails?.profilePicture);
      userId.value =
          loginResponseModel.data?.personalDetails?.userDetails?.id ?? 0;
      chatService.setUserId(userId.value.toString());
      chatService.setUserOnlineStatus();

      // print("User Id =============");
      // print(userId);
    } catch (err) {
      printRed(err.toString());
    }
  }

  List<String>? getStoredSubCatFilterResult() {
    var filteredSubCat = Apputil.getFilteredSubCatList();
    if (filteredSubCat != null) {
      return filteredSubCat.map((e) => e.id).toList();
    } else {
      return null;
    }
  }

  List<String>? getCountryFilterResult() {
    var filteredSubCat = Apputil.getFilteredCountryList();
    if (filteredSubCat != null) {
      return filteredSubCat.map((e) => e.id).toList();
    } else {
      return null;
    }
  }

  resetToHome() {
    search.text = "";
    setScrollTop.value = true;
    linearProgress.value = true;
    page.value = 1;
    showPost();
  }

  Future<void> showPost({bool diableProgressDialouge = false}) async {
    try {
      //countryId: 101, subCategoryId: "3,4"
      //TODO: Country & subCategoryId need to be set
      // if (!diableProgressDialouge) {
      //   Apputil.closeProgressDialouge();
      //   Apputil.showProgressDialouge();
      // }

      filterCount.value = 0;
      var getFilteredSubCat = getStoredSubCatFilterResult();
      var getCategoryId = Apputil.getUserProfileCategory();
      printRed("Get Category id : ${getCategoryId}");
      if (getFilteredSubCat != null) {
        filterCount.value += getFilteredSubCat.length;
      }
      if (getFilteredSubCat == null) {
        ///if filter sub cat is null then pick default from user profile data
        getFilteredSubCat = Apputil.getUserProfileDefaultSubCat_Cat();
        filterCount.value = 0;
      }
      var getCountryFIlter = getCountryFilterResult();

      if (getCountryFIlter != null) {
        filterCount.value += getCountryFIlter.length;
      }
      var model = search.text.isNotEmpty
          ? HomeModel(
              page: page.value,
              keyword: search.text,
              subCategoryId: getFilteredSubCat,
              categoryId: getCategoryId,
            )
          //? {"keyword": search.text, "page": page.value}
          : HomeModel(
              page: page.value,
              subCategoryId: getFilteredSubCat,
              categoryId: getCategoryId,

              // subCategoryId: ["10"],
              countryId: getCountryFIlter);

      if (search.text.isNotEmpty) {
        linearProgress.value = true;
      } else {
        hasPostCreated.value = true;
      }

      print("Home model");
      print(model);
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.posts,
      );

      totalLength.value = 0;

      if (result != null) {
        homeResponseModel = HomeResponseModel.fromJson(result);
        totalLength.value = homeResponseModel?.data?.meta?.total ?? 0;
        if (search.text.isNotEmpty && page.value == 1) {
          homeData.clear();
          setScrollTop.value = true;
        } else if (search.text.isEmpty && page.value == 1) {
          homeData.clear();
          setScrollTop.value = true;
        }

        if (homeResponseModel?.data != null &&
            homeResponseModel?.data !=
                []) if (homeResponseModel?.data?.homeData != null &&
            (homeResponseModel?.data?.homeData)!.isNotEmpty) {
          homeData.addAll((HomeResponseModel.fromJson(result).data?.homeData)!);
        }

        log(result.toString());

        if (homeResponseModel?.success ?? false) {
          hasPostCreated.value = false;
          linearProgress.value = false;
          isNewPage.value = false;
          isDebouncerActive.value = false;
          if (model.keyword != search.text) {
            linearProgress.value = true;
            setScrollTop.value = true;
            showPost();
          }
        } else {
          hasPostCreated.value = false;
          linearProgress.value = false;
          isNewPage.value = false;
          isDebouncerActive.value = false;

          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: homeResponseModel?.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
      // if (!diableProgressDialouge) {
      //   Apputil.closeProgressDialouge();
      // }
    } catch (e) {
      search.text = "";
      // if (!diableProgressDialouge) {
      //   Apputil.closeProgressDialouge();
      // }
      hasPostCreated.value = false;
      linearProgress.value = false;
      isNewPage.value = false;
      isDebouncerActive.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }

    update();
  }

  likePost(bool isLike, Function(bool isLike) runUpdateManually,
      {bool isNotProfile = true}) async {
    // isLike is value set manually in the HomeResponseModel for checking is the user liked the post
    try {
      final model = LikePostModel(
          isLike: isLike ? "dislike" : "like", postId: int.parse(id.value));
      hasPostLiked.value = true;

      print("Like post model===============");
      print(model);
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.postLike,
      );

      if (result != null) {
        likePostResponseModel = LikePostResponseModel.fromJson(result);

        log(result.toString());

        print("===============hasPostLiked");
        print(hasPostLiked);
        print("===========likePostResponseModel!.success!");
        print(likePostResponseModel?.success ?? "Server Error");

        if (likePostResponseModel?.success ?? false) {
          hasPostLiked.value = false;

          print("===========likePostResponseModel!.success!");
          print("inside likePostResponseModel!.success ==============");

          if (isNotProfile) {
            final post = homeData[likeDisLikePostIndex.value];
            // Value of isLiked is set in the HomeResponseModel which needs to be reset
            // HomeResponseModel will not get reloaded as we manully update these Values
            //If isLiked value doesn't reset the value moves only in one direction
            if (isLike) {
              post.rxTotalLikes.value = (post.rxTotalLikes.value) - 1;
              post.isLiked.value = false;
            } else {
              post.rxTotalLikes.value = (post.rxTotalLikes.value) + 1;
              post.isLiked.value = true;
            }
          }

          runUpdateManually(isLike);
        } else {
          hasPostLiked.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: likePostResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasPostLiked.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  Future<void> deletePost(String postId) async {
    var postData =
        homeData.firstWhere((element) => element.id.toString() == postId);
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
          homeData.remove(postData);
          homeData.refresh();
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

  Future<bool> commentPost() async {
    try {
      hasCommentAdded.value = true;
      final model = CommentPostModel(
          postId: int.parse(id.value), commentText: comment.text);
      // hasPostCreated.value = true;

      print("Comment post model===============");
      print(model);
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.comment,
      );

      comment.text = "";

      if (result != null) {
        commentPostResponseModel = CommentPostResponseModel.fromJson(result);

        log(result.toString());

        if (commentPostResponseModel!.success!) {
          hasPostCreated.value = false;

          ///PostDetail comment is updated by reloading in the CommentBox
          if (activeSelection == ActiveName.home) {
            if (commentPostIndex.value != -1) {
              final post = homeData[commentPostIndex.value];
              post.rxTotalComments.value += 1;
            }
          } else if (activeSelection == ActiveName.profile) {
            if (commentPostIndex.value != -1) {
              final ProfileController profileController = Get.find();
              final post = profileController
                  .postListData[profileController.commentPostIndex.value];
              post.rxTotalComments.value += 1;
            }
          }
          hasCommentAdded.value = false;
          Get.showSnackbar(GetSnackBar(
              message: "Commented successfully",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          return true;
        } else {
          hasCommentAdded.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: commentPostResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      comment.text = "";
      hasCommentAdded.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return false;
    }
  }
}
