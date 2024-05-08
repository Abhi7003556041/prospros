import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart' as getCpy;
import 'package:helpers/helpers.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/apple_sign_in.dart';
import 'package:prospros/Service/fb_sign_in_api.dart';
import 'package:prospros/Service/google_sign_in_api.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/filter_controller.dart';
import 'package:prospros/model/email_verification_model/resend_otp_email_response.dart';
import 'package:prospros/model/login/login_model.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/model/login/login_response_model.dart' as loginModel;
import 'package:prospros/model/phone_verification_model/resend_otp_phone_response.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/validator.dart';
import 'package:prospros/view/2fa/two_factor_verification.dart';
import 'package:prospros/view/complete_profile/complete_user_profile.dart';
import 'package:prospros/view/create_profile_details/create_profile_details.dart';
import 'package:prospros/view/email_verification.dart';
import 'package:prospros/view/fb_sign_in/fb_signed_in_page.dart';
import 'package:prospros/view/google_sign/google_sign_in_page.dart';
import 'package:prospros/view/phone_verfication.dart';
import 'package:prospros/view/select_plan/select_plan.dart';
import 'package:prospros/widgets/bool_extension.dart';
import 'dart:developer' as dev;

class LoginController extends GetxController {
  var passwordVisibility = false.obs;
  var isCallingLoginApi = false.obs;
  var currentUserId = "".obs;
 
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  togglePasswordVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  @override
  onInit() {
    // checkOAuthLoginStatus();
    super.onInit();
  }

  checkOAuthLoginStatus() async {
    if (await isUserUserLoggedInUsingOAuth()) {
      print("User is signed in");
      var whichOauth = await whichOauthUsed();
      if (whichOauth == OauthProviderType.google) {
        Get.to(GoogleSignedInPage());
      } else {
        Get.to(FbSignedInPage());
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<LoginResponseModel> loginWithPassword() async {
    print("Login button clicked..........");
    print(emailController.text.trim());
    print(passwordController.text.trim());

    final model = LoginModel(
        deviceId: HiveStore().get(Keys.fcmToken),
        emailId: emailController.text.trim(),
        password: passwordController.text.trim());

    print("========Model");
    print(model.toJson());

    var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: model.toJson(),
        method: METHOD.POST,
        endpoint: Url.login);

    print("Login details");
    log(result.toString());

    return LoginResponseModel.fromJson(result);
  }

  String validateLogin() {
    String message = '';
    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty) {
      message += "Enter your e-mail";
    } else if (validateEmail(email)) {
      message += "Enter a valid e-mail";
    }
    if (password.isEmpty) {
      message += (message.isEmpty ? "" : "\n") + "Enter your password";
    }
    // else if (passwordValidator(password)) {
    //   message += (message.isEmpty ? "" : "\n") + "Enter a valid password";
    // }

    return message;
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    isCallingLoginApi.value = true;

    String message = validateLogin();

    try {
      if (message.isEmpty) {
        var response = await loginWithPassword();
        if (response.success!) {
          //check whether token is given or not also 2fa enable or not
          //if 2fa enabled then redirect user to 2fa verfication screen
          //while returning from the screen; return 2fa verfication status

          LoginResponseModel loginResponse =
              LoginResponseModel.fromJson(response.toJson());
          if (loginResponse.success ?? false) {
            if ((loginResponse.data?.twoFactorAuth?.isNotEmpty ?? false) &&
                loginResponse.data!.twoFactorAuth!.contains("yes")) {
              //2fa is enabled
              isCallingLoginApi.value = false;
              bool is2faDone = false;
              await Get.to(() => TwoFactorVerificationScreen(
                    onVerify: (LoginResponseModel loginResult) {
                      is2faDone = true;
                      loginResponse = loginResult;
                      response = loginResult;
                    },
                    email: emailController.text,
                    password: passwordController.text,
                  ));
              isCallingLoginApi.value = true;
              if (!is2faDone) {
                //if 2fa isn't done then stop execution
                isCallingLoginApi.value = false;
                return;
              }
            } else {
              //2fa isn't there , just go foreward
            }
          } else {
            //user isn't logged in
            Get.closeAllSnackbars();
            isCallingLoginApi.value = false;
            Get.showSnackbar(GetSnackBar(
                message: loginResponse.message ?? "Something went wrong",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            return;
          }
          HiveStore().put(Keys.accessToken, response.data!.token!);
          HiveStore().put(Keys.hasUserLogged, "true");
          HiveStore().put(Keys.userDetails, jsonEncode(response.toJson()));
          HiveStore().put(
              Keys.activePlanId,
              (loginResponse.data?.personalDetails?.userDetails?.subscription
                          ?.id ??
                      0)
                  .toString());
          HiveStore().put(Keys.country,
              response.data?.personalDetails?.userDetails?.country?.name ?? "");

          // print(response.data!.userDetail!.userDetails!.categoryDetails!.id);
          // print(response
          //     .data!.userDetail!.userDetails!.categoryDetails!.categoryName);

          // response.data!.userDetail!.userDetails!.categoryDetails!.id == null
          //     ? Get.toNamed(createProfileDetails)
          //     : Get.toNamed(home);

          //phone and email verification seperated; below one is no more valid
          // var isPhoneVerified = await phoneVerification(response);
          // await Future.delayed(Duration(milliseconds: 500));
          // var isEmailVerified = await emailVerification(response);
          // await Future.delayed(Duration(milliseconds: 500));
          await Future.delayed(Duration(milliseconds: 500));
          var isCategorySelected = await selectUserCategoryDetails(response);
          await Future.delayed(Duration(milliseconds: 500));

          ///we also need to check subscription status
          if (isCategorySelected) {
            var isPlanSubscribed =
                await procesSubscriptionPlanSelction(response);
            if (isPlanSubscribed) {
              getx.Get.closeAllSnackbars();
              Apputil.closeProgressDialouge();

              await Future.delayed(Duration(milliseconds: 500));
              loginResponse = LoginResponseModel.fromJson(response.toJson());
              response = loginResponse;
              HiveStore().put(Keys.accessToken, response.data!.token!);
              HiveStore().put(Keys.userDetails, jsonEncode(response.toJson()));
              HiveStore().put(
                  Keys.userCatgory,
                  response.data?.personalDetails?.categoryDetails?.category
                          ?.id ??
                      0);
              if (response.data?.personalDetails?.categoryDetails?.category
                          ?.subCategory !=
                      null &&
                  (response.data?.personalDetails?.categoryDetails?.category
                          ?.subCategory?.isNotEmpty ??
                      false)) {
                var subcatData = response.data!.personalDetails!
                    .categoryDetails!.category!.subCategory;

                var subCatDataInFilterModel = subcatData!.map((e) =>
                    SubCatItemList(
                        id: e.id.toString(),
                        title: e.categoryName!,
                        isSelected: true));

                var data =
                    subCatDataInFilterModel.map((e) => e.toJson()).toList();
                HiveStore().put(Keys.filteredSubCat, data.toString());
              }
              HiveStore().put(
                  Keys.activePlanId,
                  (loginResponse.data?.personalDetails?.userDetails
                              ?.subscription?.id ??
                          0)
                      .toString());
              HiveStore().put(
                  Keys.country,
                  response.data?.personalDetails?.userDetails?.country?.name ??
                      "");
              isCallingLoginApi.value = false;

              ///Mark that user has completed login process by filling all required
              Apputil.storeUserDetails(
                isUserCompletedAllRequiredSteps: "true",
              );

              Get.offNamedUntil(home, (route) => route.settings.name == home);
            }
          } else {
            Get.showSnackbar(GetSnackBar(
                message: "You must select a category to continue",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }

          // Get.toNamed(createProfileDetails);
        } else {
          if (response.message is Map) {
            bool isEmailVerified = false;
            bool isPhoneVerified = false;
            if (response.message['email_verified_at'] == null) {
              ///email isn't verified
              var email = response.message['email'];

              isEmailVerified = await emailVerification(email);
            } else {
              isEmailVerified = true;
            }

            if (response.message['phone_verified_at'] == null) {
              ///phone isn't verified
              var phone = response.message['contact_number'];
              var phoneCode = response.message['phone_code'];
              isPhoneVerified =
                  await phoneVerification(phone, phoneCode ?? "91");
            } else {
              isPhoneVerified = true;
            }
            isCallingLoginApi.value = false;
            if (isPhoneVerified && isEmailVerified) {
              //phone and email verified ; now again call login- api for normal flow
              login();
            } else {
              Get.showSnackbar(GetSnackBar(
                  message: "You must verify email and phone number",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            }
          } else {
            if (response.message
                .toString()
                .toLowerCase()
                .contains("unauthorised")) {
              Get.showSnackbar(GetSnackBar(
                  message: "Please enter correct username and password",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            } else {
              Get.showSnackbar(GetSnackBar(
                  message: response.message ??
                      "Something went wrong with server response",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            }
          }
        }
        isCallingLoginApi.value = false;
      } else {
        Get.closeAllSnackbars();
        isCallingLoginApi.value = false;
        Get.showSnackbar(GetSnackBar(
            message: message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
      isCallingLoginApi.value = false;
    } catch (e) {
      Get.closeAllSnackbars();
      isCallingLoginApi.value = false;
      Get.showSnackbar(GetSnackBar(
          message: "Enter a valid E-mail & password ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  googleSignIn() async {
    try {
      isCallingLoginApi.value = true;
      var googleSignInAcc = await GoogleSignInApi.login();
      if (googleSignInAcc != null) {
        // Get.to(GoogleSignedInPage());
        var userData = await GoogleSignInApi.getUserData();
        if (userData != null) {
          var username = userData.displayName ?? "N.A.";
          var userEmail = userData.email;
          print("######### USER DATA  ##############");
          print(userData.photoUrl);
          print("######### END USER DATA  ##############");
          // var openIdConnectId = await userData.authentication.then((value) {
          //       printRed("USER ID" + userData.id);
          //       printRed("ID TOKEN : ${value.idToken}");
          //       printRed("Access TOKEN : ${value.accessToken}");

          //       return value.accessToken;
          //     }) ??
          //     "";

          // await userData.authHeaders.then((value) {
          //   printRed(value..toString());
          // });

          // await userData.authentication.then((value) {
          //   printRed(
          //       GoogleSignInApi.getObj().currentUser?.serverAuthCode.toString());
          // });
          //   isCallingLoginApi.value = false;
          // return;
          var openIdConnectId = userData.id;

          var loginData = await completeSocialLoginProcess(
              email: userEmail,
              name: username,
              socialId: openIdConnectId,
              social_type: OauthProviderType.google.name);
          if (loginData != null) {
            Apputil.storeUserDetails(
                accessToken: loginData.data!.token!,
                hasUserLogged: "true",
                userDetails: loginData);

            //now check is profile details completed or not
            var isProfileSubmitted = await fillProfileDetails(loginData);
            if (isProfileSubmitted) {
              //now check for category selection
              var isCategoryDetailsFilled =
                  await fillCategoryDetails(loginData);
              if (isCategoryDetailsFilled) {
                //now check for subscription plan status
                var isPlanSubscribed =
                    await procesSubscriptionPlanSelction(loginData);
                if (isPlanSubscribed) {
                  loginData = await completeSocialLoginProcess(
                      email: userEmail,
                      name: username,
                      socialId: openIdConnectId,
                      social_type: OauthProviderType.google.name);

                  ///Mark that user has completed login process by filling all required
                  Apputil.storeUserDetails(
                    accessToken: loginData!.data!.token!,
                    hasUserLogged: "true",
                    userDetails: loginData,
                    isUserCompletedAllRequiredSteps: "true",
                  );
                  HiveStore().put(
                      Keys.userCatgory,
                      loginData.data?.personalDetails?.categoryDetails?.category
                              ?.id ??
                          0);
                  if (loginData.data?.personalDetails?.categoryDetails?.category
                              ?.subCategory !=
                          null &&
                      (loginData.data?.personalDetails?.categoryDetails
                              ?.category?.subCategory?.isNotEmpty ??
                          false)) {
                    var subcatData = loginData.data!.personalDetails!
                        .categoryDetails!.category!.subCategory;

                    var subCatDataInFilterModel = subcatData!.map((e) =>
                        SubCatItemList(
                            id: e.id.toString(),
                            title: e.categoryName!,
                            isSelected: true));

                    var data =
                        subCatDataInFilterModel.map((e) => e.toJson()).toList();
                    HiveStore().put(Keys.filteredSubCat, data.toString());
                  }
                  isCallingLoginApi.value = false;
                  Get.offNamedUntil(
                      home, (route) => route.settings.name == home);
                } else {
                  isCallingLoginApi.value = false;
                }
              } else {
                isCallingLoginApi.value = false;
                return;
              }
            } else {
              isCallingLoginApi.value = false;
            }
          } else {
            isCallingLoginApi.value = false;
            printRed("Login Data is null");
            Get.showSnackbar(GetSnackBar(
                message: "Something went wrong. Please try again",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            GoogleSignInApi.logout();
            return;
          }
        } else {
          isCallingLoginApi.value = false;
          Get.showSnackbar(GetSnackBar(
              message: "You are not signed in properly. Please try again",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));

          GoogleSignInApi.logout();
        }
      }
      isCallingLoginApi.value = false;
    } catch (err) {
      isCallingLoginApi.value = false;
      Get.showSnackbar(GetSnackBar(
          message: "Something went wrong.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  fbSignIn() async {
    isCallingLoginApi.value = true;
    var isLogged = await FacebookSignInApi.login();
    if (isLogged) {
      var fbUser = await FacebookSignInApi.getProfileDetails();
      if (fbUser != null) {
        var userName = fbUser.name ?? "N.A.";
        var userId = fbUser.id;
        var email = fbUser.email;
        printRed("User ID ${userId}");
        if (userId != null) {
          isCallingLoginApi.value = false;

          var loginData = await completeSocialLoginProcess(
              email: email,
              name: userName,
              socialId: userId,
              social_type: OauthProviderType.fb.name);
          if (loginData != null) {
            Apputil.storeUserDetails(
                accessToken: loginData.data!.token!,
                hasUserLogged: "true",
                userDetails: loginData);
            //now check is profile details completed or not
            var isProfileSubmitted = await fillProfileDetails(loginData);
            if (isProfileSubmitted) {
              //now check for category selection
              var isCategoryDetailsFilled =
                  await fillCategoryDetails(loginData);
              if (isCategoryDetailsFilled) {
                //now check for subscription plan status
                var isPlanSubscribed =
                    await procesSubscriptionPlanSelction(loginData);
                if (isPlanSubscribed) {
                  isCallingLoginApi.value = false;

                  ///Mark that user has completed login process by filling all required
                  Apputil.storeUserDetails(
                    isUserCompletedAllRequiredSteps: "true",
                  );
                  Get.offNamedUntil(
                      home, (route) => route.settings.name == home);
                } else {
                  isCallingLoginApi.value = false;
                }
              } else {
                isCallingLoginApi.value = false;
                return;
              }
            } else {
              isCallingLoginApi.value = false;
            }
          } else {
            isCallingLoginApi.value = false;
            Get.showSnackbar(GetSnackBar(
                message: "Something went wrong. Please try again",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            GoogleSignInApi.logout();
            return;
          }
        } else {
          Get.showSnackbar(GetSnackBar(
              message: "You are not signed in properly. Please try again",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          FacebookSignInApi.logout();
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "You are not signed in properly. Please try again",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        FacebookSignInApi.logout();
      }
    }
    isCallingLoginApi.value = false;
  }

  appleSignIn() async {
    var appleLoginData = await AppleSignInApi.signIn();
    if (appleLoginData != null) {
      isCallingLoginApi.value = true;
      if (appleLoginData.identityToken != null) {
        Map<String, dynamic> decodedToken =
            JwtToken.payload(appleLoginData.identityToken!);
        dev.log(
            "Apple authorization code : " + appleLoginData.authorizationCode);
        dev.log("Identity code : " + (appleLoginData.identityToken ?? "N.A."));
        dev.log("UserIdentifier code : " +
            (appleLoginData.userIdentifier ?? "N.A."));
        dev.log(
            "${appleLoginData.familyName}, ${appleLoginData.givenName}, ${appleLoginData.email} ");

        dev.log(decodedToken.toString());
        dev.log(decodedToken['email'].toString());

        if (decodedToken.keys.toList().contains("email")) {
          dev.log("Email  existes");
          var userEmail = decodedToken['email'];
          var openIdConnectId = appleLoginData.userIdentifier!;
          var loginData = await completeSocialLoginProcess(
              email: userEmail,
              // socialId: openIdConnectId,
              socialId:
                  userEmail, //this condition is only applicable when user is signing through apple account
              social_type: OauthProviderType.apple.name);
          if (loginData != null) {
            Apputil.storeUserDetails(
                accessToken: loginData.data!.token!,
                hasUserLogged: "true",
                isUserCompletedAllRequiredSteps: "false",
                userDetails: loginData);

            //now check is profile details completed or not
            var isProfileSubmitted = await fillProfileDetails(loginData);
            if (isProfileSubmitted) {
              //now check for category selection
              var isCategoryDetailsFilled =
                  await fillCategoryDetails(loginData);
              if (isCategoryDetailsFilled) {
                //now check for subscription plan status
                var isPlanSubscribed =
                    await procesSubscriptionPlanSelction(loginData);
                if (isPlanSubscribed) {
                  var loginData = await completeSocialLoginProcess(
                      email: userEmail,
                      // socialId: openIdConnectId,
                      socialId:
                          userEmail, //this condition is only applicable when user is signing through apple account
                      social_type: OauthProviderType.apple.name);

                  ///Mark that user has completed login process by filling all required
                  Apputil.storeUserDetails(
                    accessToken: loginData!.data!.token!,
                    hasUserLogged: "true",
                    userDetails: loginData,
                    isUserCompletedAllRequiredSteps: "true",
                  );
                  HiveStore().put(
                      Keys.userCatgory,
                      loginData.data?.personalDetails?.categoryDetails?.category
                              ?.id ??
                          0);
                  if (loginData.data?.personalDetails?.categoryDetails?.category
                              ?.subCategory !=
                          null &&
                      (loginData.data?.personalDetails?.categoryDetails
                              ?.category?.subCategory?.isNotEmpty ??
                          false)) {
                    var subcatData = loginData.data!.personalDetails!
                        .categoryDetails!.category!.subCategory;

                    var subCatDataInFilterModel = subcatData!.map((e) =>
                        SubCatItemList(
                            id: e.id.toString(),
                            title: e.categoryName!,
                            isSelected: true));

                    var data =
                        subCatDataInFilterModel.map((e) => e.toJson()).toList();
                    HiveStore().put(Keys.filteredSubCat, data.toString());
                  }
                  isCallingLoginApi.value = false;

                  Get.offNamedUntil(
                      home, (route) => route.settings.name == home);
                } else {
                  isCallingLoginApi.value = false;
                }
              } else {
                isCallingLoginApi.value = false;
                return;
              }
            } else {
              isCallingLoginApi.value = false;
            }
          } else {
            Get.showSnackbar(GetSnackBar(
                message: "You are not signed in properly. Please try again",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
        } else {
          dev.log("Email is not there");
          Get.showSnackbar(GetSnackBar(
              message: "You are not signed in properly. Please try again",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      } else {
        ///something went wrong ; JWT token isn't there
        Get.showSnackbar(GetSnackBar(
            message: "You are not signed in properly. Please try again",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
    isCallingLoginApi.value = false;
  }

  isUserUserLoggedInUsingOAuth() async {
    try {
      isCallingLoginApi.value = true;
      var isGoogleSignedIn = await GoogleSignInApi.isUserSignedIn();
      if (isGoogleSignedIn) {
        isCallingLoginApi.value = false;
        return true;
      }
      //now check for fb sign in status
      if (await FacebookSignInApi.isSigned()) {
        isCallingLoginApi.value = false;
        return true;
      }

      isCallingLoginApi.value = false;
      return false;
    } catch (err) {
      isCallingLoginApi.value = false;
      return false;
    }
  }

  Future<OauthProviderType> whichOauthUsed() async {
    if (await GoogleSignInApi.isUserSignedIn()) {
      return OauthProviderType.google;
    } else {
      return OauthProviderType.fb;
    }
  }

  Future<bool> phoneVerification(String phone, String phone_code) async {
    try {
      debugPrint("Phone verifiation started ########");

      var isVerified = false;

      debugPrint("############ User Phone isn't verified");

      await sendPhoneVerificationCode(phone, phone_code);

      await Get.to(PhoneVerification(
        phone: phone,
        countryCode: phone_code,
        onVerificationCompleted: () {
          isVerified = true;
          Get.back();
        },
      ));
      debugPrint("Phone verifiation ended ########");
      //check if user is verfied or not using profile details
      return isVerified;
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
          message: err.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return false;
    }
  }

  Future<bool> emailVerification(String email) async {
    try {
      debugPrint("Email vewrifiation started ########");

      var isVerified = false;

      debugPrint("############ User Phone isn't verified");
      await sendEmailVerificationCode(email);
      await Get.to(EmailVerification(
        email: emailController.text,
        onVerificationCompleted: () {
          isVerified = true;
          Get.back();
        },
      ));
      debugPrint("Email vewrifiation completed ########");
      //check if user is verfied or not using profile details

      return isVerified;
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
          message: err.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return false;
    }
  }

  Future<bool> selectUserCategoryDetails(LoginResponseModel response) async {
    if (!isCategorySelected(response)) {
      var isSelected = false;

      await Get.to(CreateProfileDetailsScreen(
        callbackActionForLoginScreen: () {
          isSelected = true;
          Get.back();
        },
      ));

      //check if user is verfied or not using profile details
      return isSelected;
    }
    return true;
  }

  Future<bool> selectSubscriptionPlan(LoginResponseModel response) async {
    if (!isAnyPlanSubscribed(response)) {
      var isSelected = false;

      await Get.to(SelectPlanScreen(
        callbackActionForLoginScreen: () {
          isSelected = true;
          Get.back();
        },
      ));

      //check if user is verfied or not using profile details
      return isSelected;
    }
    return true;
  }

  bool isCategorySelected(LoginResponseModel loginResponse) {
    if (loginResponse.data != null &&
        (loginResponse.data?.personalDetails?.categoryDetails?.category?.id !=
            null)) {
      return true;
    }
    return false;
  }

  bool isAnyPlanSubscribed(LoginResponseModel loginResponse) {
    if (loginResponse.data != null &&
        (loginResponse.data?.personalDetails?.userDetails?.subscription?.id !=
            null)) {
      return true;
    }
    return false;
  }

  sendPhoneVerificationCode(String phone, String phoneCode) async {
    final Map<String, dynamic> data = {
      "type": "phone",
      "contact_number": phone,
      "phone_code": phoneCode
    };

    var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: data,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
        },
        method: METHOD.POST,
        endpoint: Url.resendEmailOtp);

    final resendPhoneOTPResponseModel =
        ResendPhoneOTPResponseModel.fromJson(result);

    if (resendPhoneOTPResponseModel.success!) {
      Get.showSnackbar(GetSnackBar(
          message: "OTP Sent",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    } else {
      Get.showSnackbar(GetSnackBar(
          message: "Server Error, try again!",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  sendEmailVerificationCode(String email) async {
    final Map<String, dynamic> data = {"type": "email", "email": email};
    var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        body: data,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}',
        },
        method: METHOD.POST,
        endpoint: Url.resendEmailOtp);

    final resendEmailOTPResponseModel =
        ResendEmailOTPResponseModel.fromJson(result);

    if (resendEmailOTPResponseModel.success!) {
      Get.showSnackbar(GetSnackBar(
          message: "OTP Sent",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    } else {
      Get.showSnackbar(GetSnackBar(
          message: "Server Error, try again!",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  Future<bool> fillProfileDetails(LoginResponseModel response) async {
    try {
      var isEmailAvailable =
          response.data?.personalDetails?.userDetails?.email != null
              ? true
              : false;
      var isCountryAvailable =
          response.data?.personalDetails?.userDetails?.country != null
              ? true
              : false;
      var isPhoneNumberAvailable =
          response.data?.personalDetails?.userDetails?.contactNumber != null &&
                  (response.data?.personalDetails?.userDetails?.contactNumber
                          ?.isNotEmpty ??
                      false)
              ? true
              : false;
      var isNameAvailable = response.data?.personalDetails?.userDetails?.name !=
                  null &&
              (response.data?.personalDetails?.userDetails?.name?.isNotEmpty ??
                  false)
          ? true
          : false;

      bool isValueSubmitted = false;
      String? phoneNume;
      String? phoneCod;
      String? countryId;
      String? email;
      String? name;
      if (isEmailAvailable &&
          isPhoneNumberAvailable &&
          isCountryAvailable &&
          isNameAvailable) {
        return true;
      }
      await Get.to(CompleteUserProfile(
          callBack: ({
            required String phoneNumber,
            required String phoneCode,
            required String mail,
            required String countryid,
            required String nameDet,
          }) {
            isValueSubmitted = true;
            email = mail;
            countryId = countryid;
            phoneNume = phoneNumber;
            phoneCod = phoneCode;
            name = nameDet;
            Get.back();
          },
          completeProfileAttributes: CompleteProfileAttributes(
              isEmailAvailable: isEmailAvailable,
              isCountryAvailable: isCountryAvailable,
              isPhoneNumberAvailable: isPhoneNumberAvailable,
              isNameAvailable: isNameAvailable)));

      if (isValueSubmitted) {
        var loginData = await completeSocialLoginProcess(
            name: isNameAvailable ? null : name,
            social_type:
                response.data!.personalDetails!.userDetails!.socialType!,
            socialId: response.data!.personalDetails!.userDetails!.socialId!,
            email: isEmailAvailable ? null : email,
            phoneCode: isPhoneNumberAvailable ? null : phoneCod,
            phoneNumber: isPhoneNumberAvailable ? null : phoneNume);
        if (loginData != null && (loginData.success ?? false)) {
          //update country info, category info and subscription info
          if (!isCountryAvailable) {
            await updateCountryInfo(countryId: countryId!);
          }
          return true;
        } else {
          Get.showSnackbar(GetSnackBar(
              message: loginData?.message is String
                  ? loginData?.message
                  : "Something went wrong",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          signOutSocialAuth(response);
          return false;
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "You need to fill profile details",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));

        signOutSocialAuth(response);
        return false;
      }
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
          message: "Something went wrong. Please try again. ${err.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      signOutSocialAuth(response);
      return false;
    }
  }

  Future<bool> fillCategoryDetails(LoginResponseModel response) async {
    if (isCategorySelected(response)) {
      return true;
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      var isCategorySelected = await selectUserCategoryDetails(response);
      await Future.delayed(Duration(milliseconds: 500));
      if (isCategorySelected) {
        return true;
      } else {
        isCallingLoginApi.value = false;
        Get.showSnackbar(GetSnackBar(
            message: "You need to fill category details",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        await signOutSocialAuth(response);
        return false;
      }
    }
  }

  Future<bool> procesSubscriptionPlanSelction(
      LoginResponseModel response) async {
    if (isAnyPlanSubscribed(response)) {
      return true;
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      var isPlanSelected = await selectSubscriptionPlan(response);
      await Future.delayed(Duration(milliseconds: 500));
      if (isPlanSelected) {
        return true;
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "You need to select atleast any one plan",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        await signOutSocialAuth(response);
        return false;
      }
    }
  }

  signOutSocialAuth(LoginResponseModel response) async {
    switch (response.data!.personalDetails!.userDetails!.socialType!) {
      case "google":
        await GoogleSignInApi.logout();
        break;
      case "facebook":
        await FacebookSignInApi.logout();
        break;
      default:
    }

    HiveStore().delete(Keys.accessToken);
    HiveStore().delete(Keys.hasUserLogged);
    HiveStore().delete(Keys.userDetails);
  }

  Future<LoginResponseModel?> completeSocialLoginProcess(
      {String? email,
      String? name,
      String? phoneNumber,
      String? phoneCode,
      bool? isMergeAccount,
      required String social_type,
      required String socialId}) async {
    final Map<String, dynamic> data = {
      "social_type": social_type,
      "social_id": socialId,
      "merged": isMergeAccount == null ? false : isMergeAccount.toYesNo(),
      "device_id": HiveStore().get(Keys.fcmToken)
    };
    try {
      data.addIf(email != null, "email", email);
      data.addIf(name != null, "name", name);
      data.addIf(phoneNumber != null, "contact_number", phoneNumber);
      data.addIf(phoneCode != null, "phone_code", phoneCode);

      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: data,
          method: METHOD.POST,
          endpoint: Url.socialLogin);
      if (result != null) {
        var data = LoginResponseModel.fromJson(result);
        if (data != null) {
          if (data.success ?? false) {
            return data;
          } else {
            //now there may be conflict with account merge
            if (data.message
                .toString()
                .toLowerCase()
                .contains('email already exist')) {
              //request user to merge account
              printRed("Merge account");
              var isMergeAccepted = false;
              await getCpy.Get.dialog(AlertDialog(
                title: const Text(
                    'The email is already associated with other account'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text(
                          'The email is already associated with other account . Do you want to merge the account ?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      isMergeAccepted = false;
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Color(0xff2643E5)),
                    ),
                    onPressed: () async {
                      isMergeAccepted = true;
                      Get.back();
                    },
                  ),
                ],
              ));

              return completeSocialLoginProcess(
                  social_type: social_type,
                  socialId: socialId,
                  email: email,
                  name: name,
                  phoneCode: phoneCode,
                  phoneNumber: phoneNumber,
                  isMergeAccount: isMergeAccepted);
            } else {
              //there may be some other error; needs inspection
              printRed(data.message.toString());
              Get.showSnackbar(GetSnackBar(
                  message: data.message.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            }
          }
        } else {
          isCallingLoginApi.value = false;
          Get.showSnackbar(GetSnackBar(
              message: "Something went wrong ",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          FacebookSignInApi.logout();
          GoogleSignInApi.logout();
        }
      } else {
        isCallingLoginApi.value = false;

        Get.showSnackbar(GetSnackBar(
            message: "Something went wrong ",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        return null;
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
          message: "Something went wrong : ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return null;
    }
  }

  Future<void> updateCountryInfo({
    required String countryId,
  }) async {
    final Map<String, dynamic> data = {
      "country_id": countryId,
    };

    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          body: data,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.updateCountry);
      if (result != null) {
        // var loginData = LoginResponseModel.fromJson(result);

        // return loginData;
      } else {
        return null;
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
          message: "Something went wrong : ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return null;
    }
  }
}

enum OauthProviderType {
  google("google"),
  apple("apple"),
  fb("facebook");

  final String name;
  const OauthProviderType(this.name);
}

///this class is being used to determine which parameters should be mannually asked from user to complete registration while social login
class CompleteProfileAttributes {
  ///Is email retrived from social login
  final bool isEmailAvailable;

  ///is phone number retrived from social login
  final bool isPhoneNumberAvailable;

  ///is country retrived from social login
  final bool isCountryAvailable;

  ///is name retrived from social login
  final bool isNameAvailable;
  CompleteProfileAttributes(
      {required this.isEmailAvailable,
      required this.isPhoneNumberAvailable,
      required this.isCountryAvailable,
      required this.isNameAvailable});
}
