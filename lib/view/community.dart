import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/controller/community_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/custom_scaffold.dart';
import 'package:prospros/widgets/profile_avatar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class Community extends StatelessWidget {
  Community({super.key});

  CommunityController communityController = Get.put(CommunityController());
  ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      communityController.updateNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_scrollListener);
    });
    return CustomScaffold(
      activeTab: ActiveName.community,
      appBar: CustomPrefferedSizeWidget(AppTitle.community),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          controller: scrollController,
          child: StickyHeader(
              header: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Container(
                      color: AppColor.communityTxtFormFieldColor,
                      child: TextFormField(
                        controller: communityController.search,
                        textAlignVertical: TextAlignVertical.center,
                        scrollPadding: EdgeInsets.all(20),
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          print(communityController.search.text);
                          if (communityController.linearProgressBar == false &&
                              value.isNotEmpty) {
                            communityController.isDebouncerActive.value = true;
                            communityController.debounce();
                          }
                        },
                        decoration: InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(AppTitle.searchHere,
                              textAlign: TextAlign.start),
                          hintText: AppTitle.searchHere,
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),

                    // Container(
                    //     color: AppColor.communityTxtFormFieldColor,
                    //     child: const CustomTextFormField(
                    //         isBordered: false,
                    //         labelTxt: AppTitle.searchHere,
                    //         hintTxt: AppTitle.searchHere,
                    //         prefixIcon: Icon(Icons.search))),
                    Obx(
                      () => Visibility(
                        visible: communityController.linearProgressBar.value,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.orangeAccent,
                          valueColor:
                              communityController.linearProgressBar.value
                                  ? AlwaysStoppedAnimation(Colors.blue)
                                  : null,
                          minHeight: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() => RichText(
                          text: TextSpan(
                              text: AppTitle.medicalScience,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(text: " "),
                                TextSpan(
                                    text:
                                        "${communityController.itemCount.value == 0 ? " " : communityController.itemCount.value.toString() + " " + AppTitle.members}",
                                    style: AppStyle.communityTxtStyle12),
                              ]),
                        )),
                    const SizedBox(height: 38),
                  ],
                ),
              ),
              content: Obx(
                () => communityController.communityData.length == 0
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: communityController.communityData.length,
                        // itemCount: communityController
                        //     .communityResponseModel!
                        //     .data!
                        //     .communityData
                        //     ?.length,
                        itemBuilder: (context, index) {
                          //var data;
                          // if (communityController.search.text.isEmpty) {
                          //   data = communityController.communityData;
                          // } else {
                          //   data = communityController
                          //       .communityResponseModel!.data!.communityData!;
                          //}

                          final data = communityController.communityData[index];

                          return Column(
                            children: [
                              CommunityProfile(
                                id: data.userDetails!.userId.toString(),
                                name: data.name ?? "",
                                title: (data.professionalDetails != null)
                                    ? data.professionalDetails
                                            ?.professionalDesignation ??
                                        ""
                                    : "",
                                img: data.userDetails?.profilePicture ?? "",
                                country: data.userDetails!.country!.name ?? "",
                                flagImg: data.userDetails!.country!.flag ?? "",
                              ),
                              const SizedBox(height: 27),
                              index ==
                                          (communityController
                                                  .communityData.length -
                                              1) &&
                                      (index <
                                          communityController.itemCount.value -
                                              1)
                                  ? CircularProgressIndicator()
                                  : Container(),
                              SizedBox(height: 5)
                            ],
                          );
                        }),
              )),
        ),
      ),
    );
  }
}

class CommunityProfile extends StatelessWidget {
  const CommunityProfile(
      {super.key,
      required this.id,
      required this.name,
      required this.title,
      required this.img,
      required this.country,
      required this.flagImg});
  final String id;
  final String img;
  final String name;
  final String title;
  final String country;
  final String flagImg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HiveStore().put(Keys.currentUserId, id);
        final profile = Get.put(ProfileController());
        profile.postListData.clear();
        profile.page.value = 1;
        profile.userPostResponseModel = null;
        profile.getProfile();
      },
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            ProfileAvatar(profileImg: img),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(title, style: AppStyle.communityTxtStyle12),
                      Text(title.isNotEmpty && country.isNotEmpty ? ' | ' : ""),
                      country.isNotEmpty
                          ? CountryFlag(flagImg: flagImg)
                          : Container(),
                      const Text(' '),
                      country.isNotEmpty
                          ? Text(country, style: AppStyle.communityTxtStyle12)
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
