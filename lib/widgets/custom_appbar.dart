import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';

class CustomAppBarV2 extends PreferredSize {
  final String title;
  final VoidCallback onTap;
  final bool enableBackgroundColor;

  CustomAppBarV2(
      {super.key,
      required this.title,
      required this.onTap,
      this.enableBackgroundColor = true})
      : super(
            preferredSize: const Size.fromHeight(52), // Set this height
            child: AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarColor: enableBackgroundColor
                    ? AppColor.appBarBackgroundColor
                    : Colors.transparent, // transparent status bar
                systemNavigationBarColor: Colors.black, // navigation bar color
                statusBarIconBrightness:
                    Brightness.dark, // status bar icons' color
                systemNavigationBarIconBrightness:
                    Brightness.dark, //navigation bar icons' color
              ),
              child: SafeArea(
                child: Container(
                  height: 52,
                  color: enableBackgroundColor
                      ? AppColor.appBarBackgroundColor
                      : Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: enableBackgroundColor
                                      ? Colors.white
                                      : AppColor.appBarBackgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2))),
                              child: Container(
                                  height: 10,
                                  width: 10,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.arrow_back_ios,
                                      size: 10)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppTitle.fontMedium,
                                  color: Colors.black))
                        ],
                      ),
                      const Spacer(),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                              height: 1, color: AppColor.homeDividerColor)),
                    ],
                  ),
                ),
              ),
            ));
}
