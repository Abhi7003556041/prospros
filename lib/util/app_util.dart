import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/filter_controller.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/model/paypal/braintree/braintree_payment_processing.dart';
import 'package:prospros/model/profile_model/profile_response_model.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/model/login/login_response_model.dart' as loginModel;
import 'package:shimmer/shimmer.dart';

class Apputil {
  static showError() {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
        message: "Server Error",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
  }

  static storeUserDetails({
    String? accessToken,
    String? hasUserLogged,
    String? isUserCompletedAllRequiredSteps,
    LoginResponseModel? userDetails,
  }) {
    if (accessToken != null) {
      HiveStore().put(Keys.accessToken, accessToken);
    }
    if (hasUserLogged != null) {
      HiveStore()
          .put(Keys.hasUserLogged, hasUserLogged.toString().toLowerCase());
    }

    if (userDetails != null) {
      HiveStore().put(Keys.userDetails, jsonEncode(userDetails.toJson()));
      HiveStore().put(
          Keys.userCatgory,
          userDetails.data?.personalDetails?.categoryDetails?.category?.id ??
              0);
    }
    if (isUserCompletedAllRequiredSteps != null) {
      HiveStore().put(Keys.hasUserCompletedAllRequiredStepsWhileLogin,
          jsonEncode(isUserCompletedAllRequiredSteps.toString().toLowerCase()));
    }
  }

  static bool isUserLogged() {
    final accessToken = HiveStore().get(Keys.accessToken);
    final isAllStepsCompleted =
        HiveStore().get(Keys.hasUserCompletedAllRequiredStepsWhileLogin);
    return accessToken != null && isAllStepsCompleted != null
        ? accessToken != "" && isAllStepsCompleted != ""
            ? isAllStepsCompleted.toString().contains("true")
                ? true
                : false
            : false
        : false;
  }

  static bool isFilterSet() {
    try {
      var isEnabled = HiveStore().get(Keys.isFilteredEnabled);
      if (isEnabled != null && isEnabled == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static showProgressDialouge() {
    Get.dialog(Center(
      child: Container(
          width: 100.sw,
          height: 100.sh,
          child: Center(
            child: SizedBox(
              width: 35.ss,
              height: 35.ss,
              child: CircularProgressIndicator(
                color: Color(0xff2643E5),
              ),
            ),
          )),
    ));
  }

  static closeProgressDialouge() async {
    while ((Get.isDialogOpen ?? false)
        //  ||
        //     Get.previousRoute.toLowerCase().contains('/dialouge')
        ) {
      printRed(Get.previousRoute);
      Get.back();
    }
  }

  static List<SubCatItemList>? getFilteredSubCatList() {
    var rawData = HiveStore().get(Keys.filteredSubCat);
    if (rawData == null) {
      return null;
    } else {
      var dd = json.decode(rawData) as List;
      var subcData = dd.map((e) => SubCatItemList.fromJson(e)).toList();
      return subcData;
    }
  }

  static int? getUserProfileCategory() {
    var storedCat = HiveStore().get(Keys.userCatgory);
    if (storedCat != null && storedCat is int) {
      return storedCat;
    }

    var usrData = Apputil.getUserProfile();
    if (usrData?.data != null &&
        usrData?.data?.personalDetails != null &&
        usrData?.data?.personalDetails != null &&
        usrData?.data?.personalDetails?.categoryDetails != null) {
      return usrData?.data?.personalDetails?.categoryDetails?.category?.id;
    }
    return null;
  }

  ///It will return list of category and sub category from user profile
  static List<String>? getUserProfileDefaultSubCat_Cat() {
    var usrData = Apputil.getUserProfile();
    if (usrData?.data != null &&
        usrData?.data?.personalDetails != null &&
        usrData?.data?.personalDetails != null &&
        usrData?.data?.personalDetails?.categoryDetails != null) {
      var subCategoryId = [];

      if (usrData
              ?.data?.personalDetails?.categoryDetails?.category?.subCategory !=
          null) {
        subCategoryId.addAll(usrData!
            .data!.personalDetails!.categoryDetails!.category!.subCategory!
            .map((e) => e.id));
      }

      if (subCategoryId.isNotEmpty) {
        return subCategoryId.map((e) => e.toString()).toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static List<SubCatItemList>? getFilteredCountryList() {
    var rawData = HiveStore().get(Keys.filteredCountry);
    if (rawData == null) {
      return null;
    } else {
      var dd = json.decode(rawData) as List;
      var subcData = dd.map((e) => SubCatItemList.fromJson(e)).toList();
      return subcData;
    }
  }

  static getActiveColor() {
    return Color(0xff2643E5);
  }

  ///Stores app user profile image using HiveStorage using key -     Keys.profileImage.
  ///It needs to be updated while pushing live build
  static storProfileImage(String? imgUrl) {
    //update it in live version
    HiveStore().put(
        Keys.profileImage,
        imgUrl ??
            "https://dev17.ivantechnology.in/doubtanddiscussion/public/storage/no-image.png");
  }

  static LoginResponseModel? getUserProfile() {
    try {
      var data = HiveStore().get(Keys.userDetails);
      dev.log(data);
      return LoginResponseModel.fromJson(json.decode(data));
    } catch (err) {
      printRed(err.toString());
      return null;
    }
  }

  static bool isUserSubscribed(LoginResponseModel user) {
    if ((user.data?.personalDetails?.userDetails?.subscription?.planName
            ?.toLowerCase()
            .contains("free")) ??
        true) {
      return false;
    } else {
      return true;
    }
  }

  ///this is only meant to indicate whether user has selected given plan or not. Subscription status should be checked with isUserSubscribed()
  static bool isPlanSelected({required int planID, String? getSubscription}) {
    var storedPlanId =
        int.tryParse((HiveStore().get(Keys.activePlanId) ?? "-1")) ?? -1;
    var isUserEarlierSelectedThisPlan = getSubscription == null
        ? false
        : getSubscription
            .containsEither(["payment_processed", "payment_completed"]);

    if (isUserEarlierSelectedThisPlan) {
      return true;
    }
    if (getSubscription != null &&
        getSubscription.containsEither(["no_subscription_initiated"])) {
      storedPlanId = -1;
    }
    if (planID == storedPlanId) {
      printRed("Is plan Selected :true ");
      return true;
    } else {
      printRed("Is plan Selected :false ");
      return false;
    }
  }

  ///removes necessary key which needs to be deleted while logout
  static logoutStoredKey() async {
    await HiveStore().delete(Keys.accessToken);
    await HiveStore().delete(Keys.activePlanId);
    await HiveStore().delete(Keys.hasUserCompletedAllRequiredStepsWhileLogin);
    await HiveStore().delete(Keys.filteredCountry);
    await HiveStore().delete(Keys.filteredSubCat);
    await HiveStore().delete(Keys.filteredCountry);
    await HiveStore().delete(Keys.userDetails);
    await HiveStore().delete(Keys.activePlanId);
    await HiveStore().delete(Keys.userNumber);
    await HiveStore().delete(Keys.userName);
    await HiveStore().delete(Keys.userId);
    await HiveStore().delete(Keys.userEmail);
    await HiveStore().delete(Keys.userCountryCode);
    await HiveStore().delete(Keys.hasUserLogged);
    await HiveStore().delete(Keys.profileImage);
    await HiveStore().delete(Keys.currentUserId);
    await HiveStore().delete(Keys.currentPostId);
    await HiveStore().delete(Keys.userCatgory);
    await HiveStore().delete(Keys.isFilteredEnabled);
  }

  static Future<bool> showCustomDialougeDialouge(
      {required String titleText,
      required String description,
      required Function onYesTap,
      String positiveButtonLabelText = "Yes",
      String negativeButtonLabelText = "No",
      required Function onNoTap}) async {
    var returnVal = false;
    await Get.dialog(Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (ctx, constraints) => Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * .8),
              margin: EdgeInsets.only(top: 10.ss),
              padding: EdgeInsets.only(left: 10.ss, top: 3.ss, bottom: 3.ss),
              color: Apputil.getActiveColor(),
              child: Text(
                titleText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.ss,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 7.ss,
                ),
                Text(description),
                SizedBox(
                  height: 14.ss,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        // onPressed: () {
                        //   returnVal = true;
                        //   onYesTap();
                        //   Get.back();
                        // },
                        onPressed: () => onYesTap(),
                        child: Text(positiveButtonLabelText)),
                    SizedBox(
                      width: 5.ss,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        // onPressed: () {
                        //   returnVal = false;
                        //   onNoTap();
                        //   Get.back();
                        // },
                        onPressed: () => onNoTap(),
                        child: Text(negativeButtonLabelText))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));

    return returnVal;
  }

  static Future<void> refreshProfileDetails() async {
    await getProfile();
  }

  ///load user profile data
  static Future<ProfileResponseModel?> getProfile() async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.getProfile);

      if (result != null) {
        var profileResponseModel = ProfileResponseModel.fromJson(result);

        if (profileResponseModel.success ?? false) {
          var profDet = profileResponseModel.data?.professionalDetails;
          var usrDet = profileResponseModel.data?.userDetails;
          var usrcat = profileResponseModel.data?.categoryDetails?.category;
          var eduDet = profileResponseModel.data?.educationalDetails;
          Apputil.storeUserDetails(
              userDetails: LoginResponseModel(
                  success: true,
                  data: loginModel.Data(
                      personalDetails: loginModel.PersonalDetails(
                          categoryDetails: loginModel.CategoryDetails(
                              category: loginModel.Category(
                                  categoryName: usrcat?.categoryName,
                                  id: usrcat?.id,
                                  subCategory: usrcat?.subCategory
                                      ?.map((e) => loginModel.SubCategory(
                                          categoryName: e.categoryName,
                                          id: e.id))
                                      .toList())),
                          educationalDetails: loginModel.EducationalDetails(
                              areaOfSpecialization:
                                  eduDet?.areaOfSpecialization,
                              highestQualification:
                                  eduDet?.highestQualification,
                              id: eduDet?.id,
                              userId: eduDet?.userId),
                          userDetails: loginModel.UserDetails(
                              biography: usrDet?.biography,
                              contactNumber: usrDet?.contactNumber,
                              country:
                                  loginModel.Country(id: usrDet?.country?.id, flag: usrDet?.country?.flag, name: usrDet?.country?.name, phonecode: usrDet?.country?.phonecode, shortname: usrDet?.country?.shortname),
                              createdAt: usrDet?.createdAt,
                              email: usrDet?.email,
                              emailVerifiedAt: usrDet?.emailVerifiedAt,
                              emailVerify: usrDet?.emailVerify,
                              id: usrDet?.id,
                              isPaid: usrDet?.isPaid,
                              name: usrDet?.name,
                              phoneCode: usrDet?.phoneCode,
                              phoneVerifiedAt: usrDet?.phoneVerifiedAt,
                              phoneVerify: usrDet?.phoneVerify,
                              profilePicture: usrDet?.profilePicture,
                              socialId: usrDet?.socialId,
                              socialType: usrDet?.socialType,
                              status: usrDet?.status,
                              subscription: loginModel.Subscription(id: usrDet?.subscription?.id, planAmount: usrDet?.subscription?.planAmount, planDerscription: usrDet?.subscription?.planDerscription, planDuration: usrDet?.subscription?.planDuration, planName: usrDet?.subscription?.planName, status: usrDet?.subscription?.status),
                              type: usrDet?.type,
                              updatedAt: usrDet?.updatedAt),
                          professionalDetails: loginModel.ProfessionalDetails(id: profDet?.id, officeName: profDet?.officeName, professionalDesignation: profDet?.professionalDesignation, professionalField: profDet?.professionalField, userId: profDet?.userId)),
                      token: HiveStore().get(Keys.accessToken))));
        }
        return profileResponseModel;
      }
      return null;
    } catch (e) {
      printRed(e.toString());
      return null;
    }
  }

  static String showOnlyInDebugMode(String message) {
    if (!kReleaseMode) {
      return message;
    }
    return "";
  }

  static Widget showShimmer(
      {double width = 100,
      double height = 25,
      EdgeInsets? padding,
      Color shimmerBaseColor = Colors.black,
      Color shimmerHiglightColor = Colors.grey,
      Color borderColor = Colors.white,
      double borderRadius = 20,
      double borderWidth = 1}) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHiglightColor,
      child: SizedBox(
        width: width + 2,
        height: height + 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: width,
                height: height,
                margin: EdgeInsets.all(.5.ss),
                padding: padding ?? EdgeInsets.all(7.ss),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border:
                        Border.all(color: borderColor, width: borderWidth.ss),
                    borderRadius: BorderRadius.circular(borderRadius.ss)),
              ),
            )
          ],
        ),
      ),
    );
  }

  static String timeStampToDateTime(String timeStamp) {
    try {
      var date =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(timeStamp) * 1000);
      var now = DateTime.now();

      if (DateUtils.isSameDay(date, now)) {
        DateFormat dateFormat = DateFormat().add_jm();
        String returnDT = dateFormat.format(date);
        return returnDT;
      } else {
        DateFormat dateFormat = DateFormat("yMMMd").add_jm();
        String returnDT = dateFormat.format(date);
        return returnDT;
      }
    } catch (err) {
      return "";
    }
  }

  static String strToDateTime(String timeStr) {
    try {
      var date = DateTime.tryParse(timeStr);

      if (date != null) {
        DateFormat dateFormat = DateFormat("dd-MM-yy | ").add_jm();
        String returnDT = dateFormat.format(date);
        return returnDT;
      }
      return "";
    } catch (err) {
      return "";
    }
  }

  static String strToDateTimeV2(String timeStr) {
    try {
      var date = DateTime.tryParse(timeStr);

      if (date != null) {
        DateFormat dateFormat = DateFormat("dd-MM-yy ").add_jm();
        String returnDT = dateFormat.format(date);
        return returnDT;
      }
      return "";
    } catch (err) {
      return "";
    }
  }

  static String timeStampToYearDate(String timeStamp) {
    try {
      var date =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(timeStamp) * 1000);
      var now = DateTime.now();

      DateFormat dateFormat = DateFormat("yMMMd");
      String returnDT = dateFormat.format(date);
      return returnDT;
    } catch (err) {
      return "";
    }
  }

  static String timeStampTotime(String timeStamp) {
    try {
      var date =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(timeStamp) * 1000);

      DateFormat dateFormat = DateFormat().add_jm();
      String returnDT = dateFormat.format(date);
      return returnDT;
    } catch (err) {
      return "";
    }
  }

  static MsgType? getMsgTypeFromString(String str) {
    if (str == "test_text") {
      return MsgType.test_text;
    }
    if (str == "image") {
      return MsgType.image;
    }
    if (str == "normal_txt_msg") {
      return MsgType.normal_text_msg;
    }
    return null;
  }
}
