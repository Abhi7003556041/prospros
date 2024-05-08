import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/create_profile/category_list_response_model.dart';
import 'package:prospros/model/create_profile/professional_qual/prof_qual_model.dart';
import 'package:prospros/model/create_profile/professional_qual/prof_qual_response_model.dart';
import 'package:prospros/model/profile_model/profile_response_model.dart';

class EditProfileController extends GetxController {
  var hasProfileCreated = false.obs;
  var hasProfileSet = false.obs;

  ProfileResponseModel? profileResponseModel;

  TextEditingController professionalDesignation = TextEditingController();
  TextEditingController professionalField = TextEditingController();
  TextEditingController officeName = TextEditingController();
  TextEditingController highestQual = TextEditingController();
  TextEditingController areaOfSpecialization = TextEditingController();
  TextEditingController biography = TextEditingController();
  List<SubCategory> selectedSubCategoryList = <SubCategory>[];
  var twoFactorAuth = false.obs;

  ///when user is logged through social account then 2fa menu should not be shown
  var isSocialLogin = false.obs;

  var categoryName = "";
  var categoryId = 1;
  var categoryList = [];
  var subCategory = "";

  ///it meant for all subcategory who has been selected by user(while profile creation or profile update); It's not meant for current modification
  List<SubCategory> subCategoryList = <SubCategory>[];

  ///It meant for all subcategory list inside selected category
  var wholeSubCategoryList = <SubCategory>[].obs;
  List<int>? subCategoryIdList;

  @override
  onInit() {
    super.onInit();
    getProfile();
  }

  ///
  ///
  ///This menthod must be called after successful users's profile retrival; so that user's selected category can be know priorly
  getCategoryList() async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
          },
          endpoint: Url.categoryList);

      final categoryListResponseModel = CategoryList.fromJson(result);

      print("getCategoryList =======");
      print(result);
      if (categoryListResponseModel.success!) {
        // categoryList = categoryListResponseModel.data;
        // isCategoryListLoaded.value = false;

        ///check for null & empty categoryList
        if (categoryListResponseModel.data != null &&
            categoryListResponseModel.data!.isNotEmpty) {
          ///filter for that specific category which is selcted by user
          var categorySelectedByUser = categoryListResponseModel.data!
              .where((category) => (category.id ?? 0) == categoryId);

          ///check if selected category is there or not
          if (categorySelectedByUser.isNotEmpty) {
            categorySelectedByUser.first.subcatagoryList?.forEach((subCat) {
              ///add all subcategory
              wholeSubCategoryList.value.add(SubCategory(
                  id: subCat.id, categoryName: subCat.categoryName));
            });
            wholeSubCategoryList.refresh();
          }

          printRed("--++" + wholeSubCategoryList.length.toString());
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      // isCategoryListLoaded.value = false;
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  getProfile() async {
    try {
      hasProfileCreated.value = true;

      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
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
          if (profileResponseModel?.data?.userDetails?.socialType != null &&
              profileResponseModel!.data!.userDetails!.socialType!.isNotEmpty &&
              (profileResponseModel!.data!.userDetails!.socialType!
                      .contains("google") ||
                  profileResponseModel!.data!.userDetails!.socialType!
                      .contains("apple"))) {
            isSocialLogin.value = true;
          } else {
            isSocialLogin.value = false;
          }
          if (profileResponseModel?.data?.userDetails?.two_factor_auth !=
                  null &&
              profileResponseModel!
                  .data!.userDetails!.two_factor_auth!.isNotEmpty &&
              profileResponseModel!.data!.userDetails!.two_factor_auth!
                  .contains("yes")) {
            twoFactorAuth.value = true;
          } else {
            twoFactorAuth.value = false;
          }
          categoryName = profileResponseModel!
                  .data!.categoryDetails!.category!.categoryName ??
              "";
          subCategoryList = <SubCategory>[].obs;
          categoryList = [];
          // subCategoryIdList = [];
          selectedSubCategoryList = <SubCategory>[].obs;
          categoryList.add(categoryName);
          categoryId =
              profileResponseModel!.data!.categoryDetails!.category!.id ?? 1;
          final _subCategoryList = profileResponseModel!
              .data!.categoryDetails!.category!.subCategory;
          if (_subCategoryList != null && _subCategoryList.isNotEmpty) {
            for (int i = 0; i < _subCategoryList.length; i++) {
              subCategoryList.add(_subCategoryList[i]);
              // subCategoryIdList!.add(_subCategoryList[i].id!);
            }
          }

          selectedSubCategoryList.assignAll(subCategoryList);
          // profileResponseModel!.data!.categoryDetails!.category!.subCategory!
          //     .map((e) {
          //   subCategoryList.add(e.categoryName);
          //   print(e.categoryName);
          // });
          if (subCategoryList.isNotEmpty) {
            subCategory =
                subCategoryList.first.categoryName ?? ""; //******** */
          }
          print("subCategoryList ========");
          print(subCategoryList);
          print(subCategory);

          professionalDesignation.text = profileResponseModel!
                  .data!.professionalDetails!.professionalDesignation ??
              "";
          professionalField.text = profileResponseModel!
                  .data!.professionalDetails!.professionalField ??
              "";
          officeName.text =
              profileResponseModel!.data!.professionalDetails!.officeName ?? "";
          highestQual.text = profileResponseModel!
                  .data!.educationalDetails!.highestQualification ??
              "";
          areaOfSpecialization.text = profileResponseModel!
                  .data!.educationalDetails!.areaOfSpecialization ??
              "";
          biography.text =
              profileResponseModel!.data!.userDetails!.biography ?? "";

          await getCategoryList();
          hasProfileCreated.value = false;
        } else {
          hasProfileCreated.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: "Server Error",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      hasProfileCreated.value = false;
      Get.closeAllSnackbars();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  postProfileUpdate() async {
    try {
      var selctedSubCatIds = selectedSubCategoryList.map((e) => e.id!).toList();
      final model = ProfQualModel(
          categoryId: categoryId,
          subCategoryId: selctedSubCatIds, //list of ints
          highestQualification: highestQual.value.text,
          areaOfSpecialization: areaOfSpecialization.value.text,
          professionalDesignation: professionalDesignation.value.text,
          professionalField: professionalField.value.text,
          officeName: officeName.value.text,
          twoFactorAuth: twoFactorAuth.value ? "yes" : "no",
          biography: biography.value.text);

      print(model.toJson());
      hasProfileSet.value = true;
      var result = await CoreService().apiService(
          body: model.toJson(),
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
          },
          endpoint: Url.profileUpdate);
      final profQualResponseModel = ProfQualResponseModel.fromJson(result);

      print("ProfQualResponseModel =======");
      print(result);

      hasProfileSet.value = false;
      if (profQualResponseModel.success!) {
        Get.showSnackbar(GetSnackBar(
            message: profQualResponseModel.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.showSnackbar(GetSnackBar(
            message: profQualResponseModel.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      hasProfileSet.value = false;
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
