import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:prospros/model/login/fb_user.dart';

class FacebookSignInApi {
  static final fbInstance = FacebookAuth.instance;
  static Future<bool> login() async {
    final LoginResult result = await fbInstance
        .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      print("##############" + (accessToken.toJson()).toString());
      return true;
    } else {
      print("##############" + (result.status).toString());
      print("##############" + (result.message).toString());
    }
    return false;
  }

  static Future<FbUser?> getProfileDetails() async {
    final userData = await fbInstance.getUserData();
    print("#################### ${json.encode(userData)}");

    return FbUser.fromJson(userData);
  }

  static Future<bool> isSigned() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
    if (accessToken != null) {
      // user is logged
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    await fbInstance.logOut();
  }
}
