import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/model/create_post/create_post_model.dart';
import 'package:prospros/model/create_post/create_post_response_model.dart';
import 'package:prospros/router/navrouter_constants.dart';

import '../Service/Url.dart';
import '../model/report_post/report_post_model.dart';
import '../model/report_post/report_post_response_model.dart';

class PostController extends GetxController {
  var hasPostCreated = false.obs;
  var hasPostReported = false.obs;
  var title = TextEditingController();
  var isImageSelected = false.obs;

  var quillFocusNode = FocusNode();

  var filePath = "".obs;

  File? imageFile;

  @override
  dispose() {
    super.dispose();
    title.dispose();
  }

  resetVariables() {
    title.text = "";
    filePath = "".obs;
  }

  selectImage() async {
    try {
      isImageSelected.value = false;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        filePath.value = image.path;
        imageFile = File(image.path);
        isImageSelected.value = true;
      }
    } catch (err) {
      if (err.toString().contains("photo_access_denied")) {
        Get.showSnackbar(GetSnackBar(
            message:
                "You haven't granted access to photos. Please grant access from settings",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
  }

  createPost(String postDescription) async {
    try {
      hasPostCreated.value = true;

      final model = CreatePostModel(
          postTitle: title.text, postDescription: postDescription);

      print("Post model");
      print(model.toJson());
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: filePath.isEmpty ? METHOD.POST : METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.createPost,
        filePath: filePath.isEmpty ? null : imageFile!.path,
        fileKey: "post_images",
      );

      if (result != null) {
        final createPostResponseModel =
            CreatePostResponseModel.fromJson(result);

        print("post ===========");
        log(result.toString());

        if (createPostResponseModel.success!) {
          hasPostCreated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: createPostResponseModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          resetVariables();
          final HomeController homeController = Get.find();
          homeController.showPost();
          Get.toNamed(home);
        } else {
          //resetVariables();
          hasPostCreated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: createPostResponseModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      resetVariables();
      hasPostCreated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  reportPost(String postId) async {
    try {
      hasPostReported.value = true;

      final model = ReportPostModel(postId: postId);

      print("reportPost model");
      print(model.toJson());
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: filePath.isEmpty ? METHOD.POST : METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.userPostReport,
      );

      if (result != null) {
        final reportPostSuccessModel = ReportPostSuccessModel.fromJson(result);

        print("reportPost ===========");
        log(result.toString());

        if (reportPostSuccessModel.success!) {
          hasPostReported.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: reportPostSuccessModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          resetVariables();
          final HomeController homeController = Get.find();
          homeController.showPost();
          Get.toNamed(home);
        } else {
          //resetVariables();
          hasPostReported.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: reportPostSuccessModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      resetVariables();
      hasPostReported.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
