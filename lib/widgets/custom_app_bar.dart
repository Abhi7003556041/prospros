import 'package:flutter/material.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/widgets/back_button.dart';

class CustomAppBar extends PreferredSize {
  final Text title;
  final Widget? action;
  final Widget? leading;

  CustomAppBar(this.title, {super.key, this.action, this.leading})
      : super(
            preferredSize:
                const Size.fromHeight(AppStyle.homeAppBarPrefferedSize),
            child: SafeArea(
              child: SizedBox(
                  height: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  leading ??
                                      AppBackButton.prefferedSizeBackButton(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  title
                                ],
                              ),
                              action ?? const SizedBox()
                            ],
                          )),
                      // const SizedBox(height: 16),
                      Container(height: 1, color: AppColor.borderColor)
                    ],
                  )),
            ));
}
