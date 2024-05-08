import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/create_profile_details_controller.dart';
import 'package:prospros/model/create_profile/category_list_response_model.dart';
import 'package:sizing/sizing.dart';

class CreateProfilePage2 extends StatefulWidget {
  const CreateProfilePage2({super.key});

  @override
  State<CreateProfilePage2> createState() => _CreateProfilePage2State();
}

class _CreateProfilePage2State extends State<CreateProfilePage2> {
  final CreateProfileDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(children: [
            backButton(),
            stepProgressBar(),
            stepText(),
            const SizedBox(
              height: 32,
            ),
            title(),
            const SizedBox(
              height: 16,
            ),
            subtitle(),
            const SizedBox(
              height: 48,
            ),
            ...controller.categoryData?.subcatagoryList != null
                ? controller.categoryData?.subcatagoryList
                    .map((e) => checkBtn(e))
                    .toList()
                : [Text("Sorry there is no subcategory items available")],
            SizedBox(
              height: 100.ss,
            )
          ]),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.pageController.animateToPage(2,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                            color: Color(
                          0xff2643E5,
                        )),
                      )),
                  SizedBox(
                    width: 132,
                    height: 42,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.getSubCategoryIdList();
                          // if (controller.selectedListId.isNotEmpty) {
                          //   controller.pageController.animateToPage(2,
                          //       duration: const Duration(seconds: 1),
                          //       curve: Curves.easeIn);
                          // } else {
                          //   Get.showSnackbar(GetSnackBar(
                          //       message:
                          //           "Please select minimum one subcategories",
                          //       snackPosition: SnackPosition.BOTTOM,
                          //       duration: Duration(seconds: 2),
                          //       margin: EdgeInsets.only(
                          //           bottom: 20, left: 0, right: 0)));
                          // }

                          controller.pageController.animateToPage(2,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          "Continue",
                        )),
                  )
                ],
              ),
            ))
      ],
    );
  }

  Row stepText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "02",
          style: TextStyle(
              color: Color(
                0xff2643E5,
              ),
              fontSize: 14),
        ),
        Text(
          "/5",
          style: TextStyle(color: Color(0xff9EA2B7), fontSize: 14),
        )
      ],
    );
  }

  Padding stepProgressBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 28),
      child: Row(
        children: [
          stepBlock(color: const Color(0xff2643E5)),
          Animate(effects: const [
            ShimmerEffect(
                delay: Duration(milliseconds: 900),
                colors: [Color(0xff2643E5), Color(0xffE4E6EC)])
          ], child: stepBlock(color: const Color(0xff2643E5))),
          stepBlock(),
          stepBlock(),
          stepBlock()
        ],
      ),
    );
  }

  Padding backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffF2F3F6),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              controller.pageController.animateTo(0,
                  duration: const Duration(seconds: 1), curve: Curves.easeIn);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text title() {
    return const Text(
      "Select Subcategories",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  SizedBox subtitle() {
    return const SizedBox(
      width: 244,
      child: Text(
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam",
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xff9EA2B7)),
      ),
    );
  }

  checkBtn(SubcatagoryList data) {
    return Obx(
      () => Container(
        height: 40,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: const EdgeInsets.only(
          left: 16,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.categoryName!),
            Checkbox(
                side: BorderSide(width: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                activeColor: const Color(
                  0xff2643E5,
                ),
                value: controller.subCategoryIsSeclected[data.categoryName!],
                onChanged: (val) {
                  print(controller.subCategoryIsSeclected[data.categoryName!]);
                  controller.subCategoryIsSeclected[data.categoryName!] =
                      val ?? false;
                  // controller.subcategoryList.value
                  //     .where((p0) => p0.id == data.id)
                  //     .first
                  //     .isSelected = val ?? false;
                  // setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  Expanded stepBlock({Color? color}) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 2.5,
        color: color ?? const Color(0xffE4E6EC),
      ),
    );
  }
}
