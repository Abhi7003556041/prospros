import 'dart:convert';

import 'package:get/get.dart';

import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/model/country_list/country_list_model.dart';
import 'package:prospros/model/create_profile/category_list_response_model.dart';
import 'package:prospros/model/filter/subcat_list.dart';
import 'package:prospros/model/profile_model/profile_response_model.dart';
import 'package:prospros/util/app_util.dart';

class FilterScreenController extends GetxController {
  var filterParamList = [
    // SubCatList(title: "Subcategories", itemList: [
    //   SubCatItemList(title: "Medical"),
    //   SubCatItemList(title: "Anatomy"),
    //   SubCatItemList(title: "Space Science"),
    //   SubCatItemList(title: "Microbiology"),
    //   SubCatItemList(title: "Botany"),
    //   SubCatItemList(title: "Zology"),
    // ]),
    // SubCatList(title: "Location", itemList: [
    //   SubCatItemList(title: "Near by"),
    //   SubCatItemList(title: "Other than"),
    //   SubCatItemList(title: "Within 5 Km"),
    //   SubCatItemList(title: "Within 10 Km"),
    // ])
  ].obs;

  ///It stores subCat items which are stored inside HiveStore
  var storedSubCatFilterList = <SubCatItemList>[].obs;

  ///It stores country items which are stored inside HiveStore
  var storedCountryFilterList = <SubCatItemList>[].obs;

  RxBool isAllDataInitialized = false.obs;

  ProfileResponseModel? profileResponseModel;
  SubcategoryResponseDetails? subcategoryResponseDetails;

  //categoryList isn't used anywhere; if we need to show complete category then it's required
  CategoryList? categoryList;
  CountryListModel? countryListModel;

  clearAll() {
    filterParamList.value.forEach((element) {
      element.itemList.forEach((element) {
        element.isSelected = false;
      });
    });
    filterParamList.refresh();
    HiveStore().delete(Keys.filteredSubCat);
    HiveStore().delete(Keys.filteredCountry);
    HiveStore().delete(Keys.isFilteredEnabled);
    //restore the profile default subcategory values
    if (profileResponseModel?.data?.categoryDetails?.category?.subCategory !=
            null &&
        (profileResponseModel
                ?.data?.categoryDetails?.category?.subCategory?.isNotEmpty ??
            false)) {
      var subcatData =
          profileResponseModel!.data!.categoryDetails!.category!.subCategory;

      var subCatDataInFilterModel = subcatData!.map((e) => SubCatItemList(
          id: e.id.toString(), title: e.categoryName!, isSelected: true));

      var data = subCatDataInFilterModel.map((e) => e.toJson()).toList();
      HiveStore().put(Keys.filteredSubCat, data.toString());
    }
  }

  @override
  void onReady() {
    initFilterScreen();
    super.onReady();
  }

  var selectedSubCatIndex = RxInt(0);

  initFilterScreen() async {
    Apputil.showProgressDialouge();
    loadStoredFilters();
    try {
      await getProfile();
      if (profileResponseModel != null) {
        //get subCate
        await getSubCategories(
            catId: profileResponseModel!.data!.categoryDetails!.category!.id!
                .toString());
        await getCountryList();
      } else {
        //profilecouldn't be loaded
      }

      isAllDataInitialized.value = true;
      Apputil.closeProgressDialouge();
    } catch (err) {
      Apputil.closeProgressDialouge();
      isAllDataInitialized.value = false;
      Apputil.showError();
    }
  }

  ///load user profile data
  getProfile() async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.getProfile);

      if (result != null) {
        profileResponseModel = ProfileResponseModel.fromJson(result);
        if (profileResponseModel!.success!) {
        } else {
          Apputil.showError();
        }
      }
    } catch (e) {
      Apputil.showError();
    }
  }

  ///load list of subcategories and add subcategories data inside filterParamList
  getSubCategories({required String catId}) async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.categoryList + "/${catId}}");

      if (result != null) {
        subcategoryResponseDetails =
            SubcategoryResponseDetails.fromJson(result);
        if (subcategoryResponseDetails?.success ?? false) {
          var data = SubCatList(
              title: profileResponseModel
                      ?.data?.categoryDetails?.category?.categoryName ??
                  "N.A.",
              itemList: subcategoryResponseDetails?.data
                      ?.map((e) => SubCatItemList(
                          isSelected: storedSubCatFilterList
                              .where(
                                  (p0) => p0.id.toString() == e.id.toString())
                              .isNotEmpty,
                          title: e.categoryName!,
                          id: e.id.toString()))
                      .toList() ??
                  []);

          filterParamList.add(data);
        } else {
          Apputil.showError();
        }

        // categoryList = CategoryList.fromJson(result);
        // if (categoryList?.success ?? false) {

        // } else {
        //   Apputil.showError();
        // }
      }
    } catch (e) {
      Apputil.showError();
    }
  }

  ///load list of country and  country data inside filterParamList also mark isselcted country as
  getCountryList() async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.GET,
          endpoint: Url.countryList);

      if (result != null) {
        countryListModel = CountryListModel.fromJson(result);
        if (countryListModel?.success ?? false) {
          var data = SubCatList(
              title: "Country",
              itemList: countryListModel?.data
                      ?.map((e) => SubCatItemList(
                          title: e.name!,
                          id: e.id.toString(),
                          //check if id exist inside storeCountryList
                          isSelected: storedCountryFilterList
                              .where((p0) => p0.id == e.id.toString())
                              .isNotEmpty
                          //     ||
                          // (e.id.toString() ==
                          //     (profileResponseModel
                          //             ?.data?.userDetails?.country?.id
                          //             .toString() ??
                          //         "0")
                          //         )
                          ))
                      .toList() ??
                  []);

          filterParamList.add(data);
        } else {
          Apputil.showError();
        }
      }
    } catch (e) {
      Apputil.showError();
    }
  }

  ///find filtered parameters and store them locally using HiveStorage
  onApply() async {
    if (filterParamList.isNotEmpty) {
      var selectedSubCatItem = [];
      var selectedCountries = [];

      //filter and add selected subcategories
      filterParamList[0].itemList.forEach((e) {
        if (e.isSelected) {
          selectedSubCatItem.add(e);
        }
      });

      //filter and add selected countries
      filterParamList[1].itemList.forEach((e) {
        if (e.isSelected) {
          selectedCountries.add(e);
        }
      });

      if (selectedSubCatItem.isNotEmpty) {
        var data = selectedSubCatItem.map((e) => e.toJson()).toList();

        HiveStore().put(Keys.filteredSubCat, data.toString());
        HiveStore().put(Keys.isFilteredEnabled, true);
      } else {
        HiveStore().delete(Keys.filteredSubCat);
        HiveStore().delete(Keys.isFilteredEnabled);
      }
      if (selectedCountries.isNotEmpty) {
        var data = selectedCountries.map((e) => e.toJson()).toList();
        HiveStore().put(Keys.filteredCountry, data.toString());
      } else {
        HiveStore().delete(Keys.filteredCountry);
      }

      final HomeController controller = Get.find();
      controller.homeData.clear();
      Apputil.showProgressDialouge();
      await controller.showPost();
      controller.homeData.refresh();
      Apputil.closeProgressDialouge();
      Get.back();
    }
  }

  ///initializes filter screen state,and retrives store filter data from HiveStore
  loadStoredFilters() async {
    var subCatData = Apputil.getFilteredSubCatList();

    var countryData = Apputil.getFilteredCountryList();

    if (subCatData != null) {
      storedSubCatFilterList.addAll(subCatData);
    }
    if (countryData != null) {
      storedCountryFilterList.addAll(countryData);
    }
  }
}

class SubCatList {
  final String title;
  final List<SubCatItemList> itemList;

  SubCatList({required this.title, required this.itemList});
}

class SubCatItemList {
  final String title;
  final String id;
  bool isSelected;
  SubCatItemList(
      {required this.title, required this.id, this.isSelected = false});

  factory SubCatItemList.fromJson(Map<String, dynamic> json) {
    return SubCatItemList(
        title: json['title'], id: json['id'], isSelected: true);
  }

  String toJson() {
    var data = {};
    data["title"] = title;
    data["id"] = id;
    data["isSelected"] = isSelected;
    return json.encode(data);
  }
}
