import 'package:flutter/material.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';

class AppStyle {
  //Login Page
  static const spacerHeight = 30.0;

  static const loginTxtStyle =
      TextStyle(fontSize: 24, fontFamily: AppTitle.fontMedium);

  //Home
  static const homeAppBarPrefferedSize = 58.0;

  //Community
  static const communityTxtStyle14 =
      TextStyle(fontSize: 14, color: AppColor.emailFontColor2);
  static const communityTxtStyle12 = TextStyle(
    fontSize: 12,
    color: AppColor.bottombarImgColor,
  );

  // Profile
  static const profileAbout16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const profileAbout14 =
      TextStyle(fontSize: 14, color: AppColor.bottombarImgColor);
  static const profileAbout14Black = TextStyle(fontSize: 14);

  //Notification
  static const notificationHeading = profileAbout16;
  static const notificationContent = profileAbout14;
  static const notificationSubTitle = profileAbout14Black;
}
