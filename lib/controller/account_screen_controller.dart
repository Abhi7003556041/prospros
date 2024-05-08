import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/user_controller.dart';
import 'package:prospros/model/create_profile/professional_qual/prof_qual_response_model.dart';
import 'package:prospros/model/delete_account_response/delete_account_response.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';

class AccountScreenController extends GetxController {
  var isNameEditable = false.obs;
  var isEmailEditable = false.obs;
  var isPhoneEditable = false.obs;
  var isLocationEditable = false.obs;
  var isDeleting = false.obs;
  var phoneTextController = TextEditingController();

  var name = "".obs;
  var email = "".obs;
  var location = "".obs;
  var phone = "".obs;
  var isSocialLoginUser = false.obs;

  var isAdminCheckBox = true.obs;

  DeleteAccountResponse? deleteAccountResponse;

  late UserController userController;

  @override
  onInit() {
    super.onInit();
    print("====== is user registered.....");
    print(Get.isRegistered<UserController>());
    if (Get.isRegistered<UserController>()) {
      userController = Get.find<UserController>();
    } else {
      userController = Get.put(UserController());
    }
    getUserDetails();
  }

  getUserDetails() async {
    // log("${HiveStore().get(Keys.accessToken)}");
    // final data = HiveStore().get(Keys.userDetails);
    // final loginResponseModel = LoginResponseModel.fromJson(jsonDecode(data));
    // final user = loginResponseModel.data?.personalDetails?.userDetails;

    // print("user =======");
    // log(data.toString());

    // name.value = user?.name ?? "";
    // email.value = user?.email ?? "";
    // location.value = user?.country?.name ?? "";
    // phone.value = user?.contactNumber ?? "";
    // isSocialLoginUser.value = (user?.socialId?.isNotEmpty ?? false) &&
    //     (user?.socialType?.isNotEmpty ?? false);

    name.value = userController.name.value;
    email.value = userController.email.value;
    location.value = userController.location.value;
    phone.value = userController.phone.value;
    isSocialLoginUser.value = userController.isSocialLoginUser.value;
  }

  toggleCheckBox(bool? value) {
    isAdminCheckBox.value = !isAdminCheckBox.value;
  }

  updateAccountToUserDetails() {
    userController.updateUserDetails(
        name: name.value,
        email: email.value,
        location: location.value,
        phone: phone.value);
  }

  deleteAccount() async {
    try {
      isDeleting.value = true;

      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: {"switch_to_admin": isAdminCheckBox.value ? "yes" : "no"},
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.accountDeletion);

      print("Delete Account ==============");
      log(response.toString());
      deleteAccountResponse = DeleteAccountResponse.fromJson(response);

      if (deleteAccountResponse!.success!) {
        await HiveStore().put(Keys.accessToken, "");
        GoogleSignInApi.logout();
        FacebookSignInApi.logout();
        isDeleting.value = false;
        await Apputil.logoutStoredKey();
        Get.offAllNamed(login);
        Get.showSnackbar(GetSnackBar(
            message: response!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Get.closeAllSnackbars();
        isDeleting.value = false;

        Get.showSnackbar(GetSnackBar(
            message: deleteAccountResponse?.message ?? "Server Error",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isDeleting.value = false;
      Get.showSnackbar(GetSnackBar(
          message: deleteAccountResponse?.message ?? "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  UpdateAccount() async {
    try {
      Apputil.showProgressDialouge();

      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          body: {
            "name": name.value,
            "category_id": userController.categoryId.value
          },
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.profileUpdate);

      final profQualResponseModel = ProfQualResponseModel.fromJson(response);

      print("ProfQualResponseModel =======");
      print(response);

      isDeleting.value = false;
      if (profQualResponseModel.success!) {
        isNameEditable.value = false;
        userController.name.value = name.value;
        updateAccountToUserDetails();
        Apputil.closeProgressDialouge();
        Get.showSnackbar(GetSnackBar(
            message: profQualResponseModel.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      } else {
        Apputil.closeProgressDialouge();
        Get.showSnackbar(GetSnackBar(
            message: profQualResponseModel.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      Get.showSnackbar(GetSnackBar(
          message: "Server Error",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
