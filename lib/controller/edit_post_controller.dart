import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/model/create_post/create_post_model.dart';
import 'package:prospros/model/create_post/create_post_response_model.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import '../Service/Url.dart';
import 'package:http/http.dart' as http;

class EditPostController extends GetxController {
  var hasPostCreated = false.obs;
  var title = TextEditingController();
  var isImageSelected = false.obs;

  var quillFocusNode = FocusNode();

  var filePath = "".obs;

  File? imageFile;

  Future<void> downloadImage(String? imageUrl) async {
    try {
      if (imageUrl != null) {
        final http.Response response = await http.get(Uri.parse(imageUrl));
        // Get temporary directory
        final dir = await getTemporaryDirectory();

        // Create an image name
        var filename = '${dir.path}/image.png';
        // Save to filesystem
        final file = File(filename);
        await file.writeAsBytes(response.bodyBytes);
        filePath.value = file.path;
        imageFile = file;
      }
    } catch (err) {
      printRed(err);
    }
  }

  @override
  dispose() {
    super.dispose();
    title.dispose();
  }

  resetVariables() {
    title.text = "";
    filePath = "".obs;
  }

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

  createPost(String postDescription, String postId) async {
    try {
      hasPostCreated.value = true;

      final model = CreatePostModel(
          postTitle: title.text, postDescription: postDescription);

      print("Post model");
      print(model.toJson());

      var postBodydata = model.toJson();
      postBodydata.addAll({"post_id": postId});
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: postBodydata,
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
          if (Get.previousRoute == home) {
            final HomeController homeController = Get.find();
            await homeController.showPost();
          } else if (Get.previousRoute == profile) {
            final ProfileController profileController = Get.find();
            profileController.postListData.clear();
            profileController.page.value = 1;
            await profileController.userPostList();
          }

          Get.back();
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
}
