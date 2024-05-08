import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgprovider;

import '../controller/home_controller.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key,
      this.isHome = false,
      this.isProfile = false,
      required this.appBar,
      required this.activeTab,
      this.isCreatePostPage = false,
      required this.body});
  final PreferredSize appBar;
  final Widget body;
  final bool isHome;
  final bool isCreatePostPage;
  final bool isProfile;
  final ActiveName activeTab;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        systemNavigationBarColor: Colors.black, // navigation bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar,
          //resizeToAvoidBottomInset: false,
          body: body,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton:
              (MediaQuery.of(context).viewInsets.bottom != 0.0 || isProfile)
                  ? null
                  : FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.red,
                      onPressed: () {
                        if (isCreatePostPage) {
                          Get.toNamed(home);
                        } else
                          Get.toNamed(createPost);
                      },
                      child: isCreatePostPage
                          ? const Icon(Icons.close)
                          : const Icon(Icons.add),
                    ),
          bottomNavigationBar: isProfile
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BottomAppBar(
                        child: BottomBar(
                      activetab: activeTab,
                    ))
                  ],
                )),
    );
  }
}

class ImgIcon extends StatelessWidget {
  const ImgIcon(this.imgName, {super.key, required this.isActive});
  final String imgName;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ImageIcon(svgprovider.Svg(imgName),
        color: isActive ? AppColor.appColor : AppColor.bottombarImgColor,
        size: 24);
  }
}

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
      {super.key,
      required this.imgName,
      required this.label,
      required this.onTap,
      this.isActive = false});
  final String imgName;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImgIcon(imgName, isActive: isActive),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                  color: AppColor.bottombarImgColor, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  BottomBar({super.key, required this.activetab});
  final ActiveName activetab;
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ChatService chatService = Get.find();
    return SizedBox(
      height: 67,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomBarItem(
              isActive: activetab == ActiveName.home,
              imgName: AppImage.home,
              label: AppTitle.home,
              onTap: () {
                //homeController.changePage(ActiveName.home);

                chatService.setUserOnlineStatus();
                homeController.activeSelection.value = ActiveName.home;
                homeController.showPost();
                // Get.toNamed(home);
                Get.until((route) => route.settings.name == home);
              }),
          BottomBarItem(
              isActive: activetab == ActiveName.community,
              imgName: AppImage.community,
              label: AppTitle.community,
              onTap: () {
                chatService.setUserOnlineStatus();
                homeController.activeSelection.value = ActiveName.community;
                homeController.changePage(ActiveName.community);
                // Get.toNamed(community);
                Get.offNamedUntil(
                    community, (route) => route.settings.name == home);
              }),
          const SizedBox(width: 50),
          BottomBarItem(
              isActive: activetab == ActiveName.message,
              // isActive: homeController.activeMessageButton.value,
              imgName: AppImage.message,
              label: AppTitle.message,
              onTap: () {
                chatService.setUserOnlineStatus();
                homeController.activeSelection.value = ActiveName.message;
                homeController.changePage(ActiveName.message);
                // Get.toNamed(message);
                Get.offNamedUntil(
                    message, (route) => route.settings.name == home);
              }),
          BottomBarItem(
              isActive: activetab == ActiveName.profile,
              imgName: AppImage.profile,
              label: AppTitle.profile,
              onTap: () async {
                chatService.setUserOnlineStatus();
                homeController.activeSelection.value = ActiveName.profile;
                Get.delete<ProfileController>();
                print("Deleted ProfileController...........");
                await HiveStore().put(Keys.currentUserId, "userId");
                homeController.changePage(ActiveName.profile);
                ProfileController profileController =
                    Get.put(ProfileController());
                profileController.getProfile();
                print(
                    "Sucessfully initialized profile contorller..............");
                //Get.toNamed(profile);
              }),
        ],
      ),
    );
  }
}

class CustomPrefferedSizeWidget extends PreferredSize {
  final String title;
  final Widget? action;
  CustomPrefferedSizeWidget(this.title, {super.key, this.action})
      : super(
            preferredSize:
                const Size.fromHeight(AppStyle.homeAppBarPrefferedSize),
            child: SafeArea(
              child: SizedBox(
                  height: 52,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 16)),
                              action ?? const SizedBox()
                            ],
                          )),
                      const SizedBox(height: 16),
                      Container(height: 1, color: AppColor.borderColor)
                    ],
                  )),
            ));
}
