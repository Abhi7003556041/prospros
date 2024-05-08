import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/login/login_response_model.dart';

class UserController extends GetxController {
  LoginResponseModel? _loginResponseModel;

  var name = "".obs;
  var email = "".obs;
  var location = "".obs;
  var phone = "".obs;
  var isSocialLoginUser = false.obs;
  var categoryId = 1.obs;
  var accessToken = "".obs;

  LoginResponseModel get loginResponseModel {
    final data = HiveStore().get(Keys.userDetails);
    _loginResponseModel = LoginResponseModel.fromJson(jsonDecode(data));
    return _loginResponseModel!;
  }

  set loginResponseModel(LoginResponseModel model) {
    _loginResponseModel = model;
  }

  // get categoryId => _categoryId;

  // set CategoryId(int id) => _categoryId.value = id;

  @override
  onInit() {
    getUserDetails();
    super.onInit();
  }

  getUserDetails() {
    //final data = HiveStore().get(Keys.userDetails);
    //final loginResponseModel = LoginResponseModel.fromJson(jsonDecode(data));
    //final loginResponseModel = userDetails;
    final user = loginResponseModel.data?.personalDetails?.userDetails;

    print("========= user details .........");
    log(user.toString());

    name.value = user?.name ?? "";
    email.value = user?.email ?? "";
    location.value = user?.country?.name ?? "";
    phone.value = user?.contactNumber ?? "";
    isSocialLoginUser.value = (user?.socialId?.isNotEmpty ?? false) &&
        (user?.socialType?.isNotEmpty ?? false);
    categoryId.value = loginResponseModel
            .data?.personalDetails?.categoryDetails?.category?.id ??
        1;
  }

  updateUserDetails(
      {required String name,
      required String email,
      required String location,
      required String phone,
      int categoryId = 1,
      bool isProfile = false}) {
    this.name.value = name;
    this.email.value = email;
    this.location.value = location;
    this.phone.value = phone;

    if (isProfile) {
      this.categoryId.value = categoryId;
    }

    try {
      var respModel = loginResponseModel;
      var userDetails = respModel.data?.personalDetails?.userDetails;

      userDetails!.name = name;
      userDetails.email = email;
      userDetails.country!.name = location;
      if (isProfile) {
        respModel.data!.personalDetails!.categoryDetails!.category!.id =
            categoryId;
      }

      print("=============  log(respModel.toJson().toString())");
      log(respModel.toJson().toString());
      HiveStore().put(Keys.userDetails, jsonEncode(respModel.toJson()));
    } catch (e) {
      print("SetAccountDetails(): Failed login responsible model");
    }
  }
}
