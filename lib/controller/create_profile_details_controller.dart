import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/create_profile/category_list_response_model.dart';
import 'package:prospros/model/create_profile/professional_qual/prof_qual_model.dart';
import 'package:prospros/model/create_profile/professional_qual/prof_qual_response_model.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/router/navrouter_constants.dart';

class CreateProfileDetailsController extends GetxController {
  CreateProfileDetailsController();
  Function? callbackActionForLoginScreen;

  void setCallBack(Function? callbackAction) {
    callbackActionForLoginScreen = callbackAction;
  }

  PageController pageController = PageController();

  List<CategoryData>? categoryList = [];
  var isCategoryListLoaded = true.obs;

  TextEditingController highestQual = TextEditingController();
  TextEditingController areaOfSpecialization = TextEditingController();

  TextEditingController professionalDesignation = TextEditingController();
  TextEditingController professionalField = TextEditingController();
  TextEditingController officeName = TextEditingController();

  TextEditingController biography = TextEditingController();

  RxList<CategoryData> categoryDataReactive = <CategoryData>[].obs;

  RxMap<String, bool> subCategoryIsSeclected = <String, bool>{}.obs;

  get categoryData => categoryDataReactive[0];
  get categoryId => categoryDataReactive[0].id;

  var subcategoryList = [].obs;

  get isCategoryDataEmpty => (categoryDataReactive.length == 0);

  var isCreateProfile = false.obs;

  RxList<int> selectedListId = <int>[].obs;

  LoginResponseModel? loginResponse;

  TextEditingController biographyEditProfileController =
      TextEditingController();
  TextEditingController highestEduDegEditProfileCtrl = TextEditingController();

  TextEditingController EduSpecializationEditProfileCtrl =
      TextEditingController();

  updateCategoryData(CategoryData value) {
    categoryDataReactive.value = <CategoryData>[];
    categoryDataReactive.add(value);

    subCategoryIsSeclected = <String, bool>{}.obs;
    value.subcatagoryList?.forEach((element) {
      subCategoryIsSeclected[element.categoryName!] = false;
    });
  }

  @override
  onInit() {
    super.onInit();
    getCategoryList();
  }

  @override
  dispose() {
    highestQual.dispose();
    areaOfSpecialization.dispose();
    professionalDesignation.dispose();
    professionalField.dispose();
    officeName.dispose();
    biography.dispose();
    super.dispose();
  }

  getSubCategoryIdList() {
    selectedListId = <int>[].obs;
    categoryData.subcatagoryList?.forEach((element) {
      if (subCategoryIsSeclected[element.categoryName!] == true) {
        selectedListId.add(element.id);
      }
    });
  }

  postProfileUpdate() async {
    List<int> selectedListId = [];
    categoryData.subcatagoryList?.forEach((element) {
      if (subCategoryIsSeclected[element.categoryName!] == true) {
        selectedListId.add(element.id);
      }
    });

    getSubCategoryIdList();

    print("selectedList Id's====================");
    print(selectedListId);

    final model = ProfQualModel(
        categoryId: categoryId,
        subCategoryId: selectedListId, //list of ints
        highestQualification: highestQual.value.text,
        areaOfSpecialization: areaOfSpecialization.value.text,
        professionalDesignation: professionalDesignation.value.text,
        professionalField: professionalField.value.text,
        officeName: officeName.value.text,
        biography: biography.value.text);

    print(model.toJson());

    try {
      isCreateProfile.value = true;
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

      isCreateProfile.value = false;
      if (profQualResponseModel.success!) {
        if (callbackActionForLoginScreen != null) {
          callbackActionForLoginScreen!();
        } else {
          Get.toNamed(selectPlan);
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      isCreateProfile.value = false;

      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

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
        categoryList = categoryListResponseModel.data;
        isCategoryListLoaded.value = false;
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      isCategoryListLoaded.value = false;
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
