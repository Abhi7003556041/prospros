import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/controller/create_profile_details_controller.dart';
import 'package:prospros/model/create_profile/category_list_response_model.dart';

class CreateProfilePage1 extends StatelessWidget {
  CreateProfilePage1({super.key});
  static const titleText = "Create Your Profile";

  final CreateProfileDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.isCategoryListLoaded.value,
        progressIndicator: CircularProgressIndicator(
          color: Color(0xff2643E5),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      titleText,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
                stepProgressBar(),
                stepText(),
                const SizedBox(
                  height: 32,
                ),
                title(),
                const SizedBox(
                  height: 16,
                ),
                subTitle(),
                const SizedBox(
                  height: 48,
                ),
                dropDownBtn()
              ],
            ),
            continueButton()
          ],
        ),
      ),
    );
  }

  Padding stepProgressBar() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 28),
      child: Row(
        children: [
          stepBlock(color: const Color(0xff2643E5)),
          stepBlock(),
          stepBlock(),
          stepBlock(),
          stepBlock()
        ],
      ),
    );
  }

  Row stepText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "01",
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

  Text title() {
    return const Text(
      "Choose Your Category",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  SizedBox subTitle() {
    return const SizedBox(
      width: 244,
      child: Text(
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam",
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xff9EA2B7)),
      ),
    );
  }

  Container dropDownBtn() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(3)),
      child: DropdownButton<CategoryData>(
        value: controller.isCategoryDataEmpty ? null : controller.categoryData,
        borderRadius: BorderRadius.circular(3),
        hint: const Text("Select Category"),
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: Colors.black,
        ),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        isExpanded: true,
        onChanged: (value) {
          controller.updateCategoryData(value!);
          print("selected Category......");
          print(value.id);
        },
        items: controller.categoryList!
            .map<DropdownMenuItem<CategoryData>>((value) {
          return DropdownMenuItem<CategoryData>(
            value: value,
            child: Text(value.categoryName!),
          );
        }).toList(),
      ),
    );
  }

  Positioned continueButton() {
    return Positioned(
        bottom: 10,
        left: 20,
        right: 20,
        child: SizedBox(
          width: 350,
          height: 42,
          child: ElevatedButton(
            onPressed: () {
              if (controller.isCategoryDataEmpty == false) {
                controller.pageController.animateToPage(1,
                    duration: const Duration(seconds: 1), curve: Curves.easeIn);
              } else {
                Get.showSnackbar(GetSnackBar(
                    message: "Please choose a Category ",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                    margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
              }
            },
            child: const Text("Continue"),
          ),
        ));
  }

  Expanded stepBlock({Color? color}) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 2.5,
        color: color ?? const Color(0xffE4E6EC),
        child: const Text(" "),
      ),
    );
  }
}
