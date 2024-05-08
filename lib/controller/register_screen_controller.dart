import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/model/country_list/country_list_model.dart';
import 'package:prospros/model/registration/registration_model.dart';
import 'package:prospros/model/registration/registration_model_response.dart';
import 'package:prospros/view/email_verification.dart';

import '../widgets/internet_snackbar.dart';

class RegisterController extends GetxController {
  var contactNumber = "".obs;
  var countryId = "".obs;
  var passwordVisibility = false.obs;
  var confPasswordVisibility = false.obs;
  var isCountryListLoaded = true.obs;
  var registerValidate = false.obs;

  List<DataCountryListModel>? countryList = [];
  var country = Rx<DataCountryListModel>(DataCountryListModel());

  var hasCountry = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  togglePasswordVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
    print(passwordVisibility.value);
  }

  ///Getting called by Location field country drop down
  updateCountry(DataCountryListModel? data) {
    print("inside registration controllledddddd");
    country.value = data!;
    hasCountry.value = false;
    hasCountry.value = true;
    update();
  }

  updateContactNumber(String number) {
    contactNumber.value = number;
  }

  ///Should be called when user is selcting country through phone number country code dialouge
  updateCountryCode(String countryCode) {
    printRed("Country code ${countryCode}");

    var selectedCountry = countryList!
        .where((element) =>
            element.phonecode.toString() == countryCode.replaceAll("+", ''))
        .first;

    printRed(selectedCountry.phonecode);

    country.value = selectedCountry;
    hasCountry.value = true;
    update();
  }

  validatePassword() {
    return passwordController.text == cPasswordController.text;
  }

  @override
  void onInit() {
    getCountryList();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    super.dispose();
  }

  getCountryList() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl, method: METHOD.GET, endpoint: Url.countryList);

      final countryListResponseModel = CountryListModel.fromJson(result);

      print(countryListResponseModel);

      if (countryListResponseModel.success!) {
        countryList = countryListResponseModel.data;
        isCountryListLoaded.value = false;
      }
    } else {
      Get.back();
      noInternetConnection();
    }
  }

  register() async {
    isCountryListLoaded.value = true;

    final model = RegistrationModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        cPassword: cPasswordController.text,
        contactNumber: contactNumber.value,
        phoneCode: country.value.phonecode.toString(),
        countryId: country.value.id!.toString());

    print("========Model");
    print(model.toJson());

    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: model.toJson(),
          method: METHOD.POST,
          endpoint: Url.register);
      isCountryListLoaded.value = false;
      if (result != null) {
        final registrationResponseModel =
            RegistrationResponseModel.fromJson(result);

        if (registrationResponseModel.success!) {
          printRed("Registrations successfully registered");
          isCountryListLoaded.value = false;
          final data = registrationResponseModel.data!;
          //we are not getting token while user regiistration ; to obtain token we need to register
          // HiveStore().put(Keys.accessToken, data.token!);
          HiveStore()
              .put(Keys.userName, data.userDetail?.userDetails?.name ?? "");
          HiveStore().put(Keys.userNumber,
              data.userDetail?.userDetails?.contactNumber ?? "");
          HiveStore()
              .put(Keys.userEmail, data.userDetail?.userDetails?.email ?? "");

          ///this will be used to retrive userNumer inside email Controller
          HiveStore().put(Keys.userNumber, contactNumber.value);

          ///this will be used to retrive country code inside email Controller
          HiveStore().put(Keys.userCountryCode, country.value.phonecode!);

          Get.to(EmailVerification(email: emailController.text));
        } else {
          printRed("Registrations unsuccessful");
          isCountryListLoaded.value = false;
          Get.closeAllSnackbars();
          Get.showSnackbar(GetSnackBar(
              message: registrationResponseModel.message,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      }
    } catch (e) {
      printRed("Exception caught while Registrations ${e.toString()}");
      Get.closeAllSnackbars();
      isCountryListLoaded.value = false;
      Get.showSnackbar(GetSnackBar(
          message: e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }
}
