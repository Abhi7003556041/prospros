import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/model/country_list/country_list_model.dart';
import 'package:prospros/widgets/internet_snackbar.dart';

class CompleteUserProfileController extends GetxController {
  var contactNumber = "".obs;
  var countryId = "".obs;
  var progressLoader = true.obs;
  List<DataCountryListModel>? countryList = [];
  var country = Rx<DataCountryListModel>(DataCountryListModel());
  var hasCountry = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var registerValidate = false.obs;

  @override
  void onInit() {
    getCountryList();
    super.onInit();
  }

  ///Getting called by Location field country drop down
  updateCountry(DataCountryListModel? data) {
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

  getCountryList() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl, method: METHOD.GET, endpoint: Url.countryList);

      final countryListResponseModel = CountryListModel.fromJson(result);

      print(countryListResponseModel);

      if (countryListResponseModel.success!) {
        countryList = countryListResponseModel.data;
      }

      progressLoader.value = false;
    } else {
      progressLoader.value = false;
      Get.back();
      noInternetConnection();
    }
  }
}
