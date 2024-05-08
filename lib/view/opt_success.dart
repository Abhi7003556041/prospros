import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/router/navrouter_constants.dart';
import '../router/navrouter_constants.dart';

class OPTSuccess extends StatelessWidget {
  const OPTSuccess({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.offAllNamed(login);
    });
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Get.offAllNamed(login);
          },
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 62.0,
                height: 62.0,
                decoration: const BoxDecoration(
                  color: AppColor.otpSucess,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(AppImage.optSuccess),
              ),
              const SizedBox(height: 24),
              const Text(
                AppTitle.otpSuccess,
                style: TextStyle(color: AppColor.otpFontColor, fontSize: 14),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
