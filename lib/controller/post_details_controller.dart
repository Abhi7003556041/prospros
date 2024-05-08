import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/like_comment_model/comment_like_model.dart';
import 'package:prospros/model/like_comment_model/comment_like_response_model.dart';
import 'package:prospros/model/post_details/post_detail_model.dart';
import '../model/post_details/post_details_response_model.dart';

class PostDetailsController extends GetxController {
  var hasPostCreated = false.obs;
  var isCommentLiked = false.obs;

  var isLikedProgress = false.obs;

  ScrollController scrollController = ScrollController();

  var postId = "".obs;
  //var likeDislike = "".obs;

  PostDetailsResponseModel? postDetailsResponseModel;
  CommentLikeResponseModel? commentLikeResponseModel;

  var likeDisLikePostIndex = 0.obs;

  var isDetailedFromProfile = false.obs;

  @override
  onInit() {
    super.onInit();
    showPost();
  }

  updateLikesManually(bool isLiked) {
    final post = postDetailsResponseModel?.data;

    // if (post?.id == int.parse(postId.value)) {
    //   print("Post id from like =======================");
    //   print(post?.id);

    //   print("isLiked: ${isLiked}");
    //   if (isLiked) {
    //     post?.rxTotalLikes.value = (post.rxTotalLikes.value) - 1;
    //     post?.isLiked.value = false;
    //     likeDislike.value = "dislike";
    //   } else {
    //     post?.rxTotalLikes.value = (post.rxTotalLikes.value) + 1;
    //     post?.isLiked.value = true;
    //     likeDislike.value = "like";
    //   }
    // }

    if (isLiked) {
      post!.rxTotalLikes.value = ((post.rxTotalLikes.value)) - 1;
      post.isLiked.value = false;
    } else {
      post!.rxTotalLikes.value = (post.rxTotalLikes.value) + 1;
      post.isLiked.value = true;
    }
  }

  showPost() async {
    try {
      hasPostCreated.value = true;

      final userPostId = HiveStore().get(Keys.currentPostId);

      print("=======================");
      print(userPostId);

      final model = await PostDetailModel(postId: int.tryParse(userPostId));
      print("post model ========");
      print(model.toString());
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.postsDetails,
      );

      postDetailsResponseModel = PostDetailsResponseModel.fromJson(result);
      update();

      log(result.toString());

      if (postDetailsResponseModel!.success!) {
        hasPostCreated.value = false;
      } else {
        hasPostCreated.value = false;

        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
            message: postDetailsResponseModel!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      hasPostCreated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  commentLikePost(int commentId, String isLike, VoidCallback onTap) async {
    try {
      final model = CommentLikeModel(isLike: isLike, commentId: commentId);
      isCommentLiked.value = true;

      print("Comment Like post model===============");
      print(model.toJson());
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.POST,
        endpoint: Url.commentLike,
      );

      if (result != null) {
        commentLikeResponseModel = CommentLikeResponseModel.fromJson(result);

        log(result.toString());

        if (commentLikeResponseModel!.success!) {
          isCommentLiked.value = false;
          Get.showSnackbar(GetSnackBar(
              message: commentLikeResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          onTap();
        } else {
          isCommentLiked.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: commentLikeResponseModel!.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          onTap();
        }
      }
    } catch (e) {
      isCommentLiked.value = false;
      onTap();
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
