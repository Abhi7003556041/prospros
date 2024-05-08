import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/create_profile_details_controller.dart';
import 'package:prospros/widgets/custom_textformfield.dart';

class CreateProfilePage3 extends StatefulWidget {
  const CreateProfilePage3({super.key});

  @override
  State<CreateProfilePage3> createState() => _CreateProfilePage3State();
}

class _CreateProfilePage3State extends State<CreateProfilePage3> {
  final CreateProfileDetailsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Highest Education Degree",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextFormField(
                  controller: controller.highestQual,
                  labelTxt: "",
                  hintTxt: "",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 5, top: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Specialized in",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextFormField(
                  controller: controller.areaOfSpecialization,
                  labelTxt: "",
                  hintTxt: "",
                ),
              )
            ]),
          ),
        ],
      ),
      bottomNavigationBar: continueButton(),
    );
  }

  Widget continueButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: SizedBox(
        width: 350,
        height: 42,
        child: ElevatedButton(
          onPressed: () {
            if (controller.highestQual.value.text.isNotEmpty &&
                controller.areaOfSpecialization.value.text.isNotEmpty) {
              controller.pageController.animateToPage(3,
                  duration: const Duration(seconds: 1), curve: Curves.easeIn);

              print(controller.highestQual.value.text);
              print(controller.areaOfSpecialization.value.text);
            } else {
              Get.showSnackbar(GetSnackBar(
                  message: "Please enter all the fields ",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            }
          },
          child: const Text("Continue"),
        ),
      ),
    );
  }

  Text title() {
    return const Text(
      "Education Details",
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

  Row stepText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "03",
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
          stepBlock(color: const Color(0xff2643E5)),
          Animate(effects: const [
            ShimmerEffect(
                delay: Duration(milliseconds: 900),
                colors: [Color(0xff2643E5), Color(0xffE4E6EC)])
          ], child: stepBlock(color: const Color(0xff2643E5))),
          stepBlock(),
          stepBlock()
        ],
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
              controller.pageController.animateToPage(1,
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
}
