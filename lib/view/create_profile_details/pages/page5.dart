import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/controller/create_profile_details_controller.dart';
import 'package:prospros/widgets/custom_textformfield.dart';

class CreateProfilePage5 extends StatefulWidget {
  const CreateProfilePage5({super.key});

  @override
  State<CreateProfilePage5> createState() => _CreateProfilePage5State();
}

class _CreateProfilePage5State extends State<CreateProfilePage5> {
  final CreateProfileDetailsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.isCreateProfile.value,
        progressIndicator: CircularProgressIndicator(
          color: Color(0xff2643E5),
        ),
        child: Scaffold(
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      controller: controller.biography,
                      labelTxt: "Biography",
                      hintTxt: "Biography",
                      maxLines: 5,
                      
                      autoFoucus: true,
                      labelTextStyle: TextStyle(fontSize: 14),
                      hintTextStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: submitButton(),
        ),
      ),
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: SizedBox(
        width: 350,
        height: 42,
        child: ElevatedButton(
          onPressed: () {
            if (controller.biography.text.isNotEmpty &&
                controller.biography.text.length > 10) {
              print(controller.biography.value.text);
              controller.postProfileUpdate();
            } else {
              Get.showSnackbar(GetSnackBar(
                  message: "Please enter minimum 10 characters",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
            }
          },
          child: const Text("Submit"),
        ),
      ),
    );
  }

  Text title() {
    return const Text(
      "Add Biography",
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
          "05",
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
          stepBlock(color: const Color(0xff2643E5)),
          stepBlock(color: const Color(0xff2643E5)),
          Animate(effects: const [
            ShimmerEffect(
                delay: Duration(milliseconds: 700),
                colors: [Color(0xff2643E5), Color(0xffE4E6EC)])
          ], child: stepBlock(color: const Color(0xff2643E5))),
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
              controller.pageController.animateToPage(3,
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
