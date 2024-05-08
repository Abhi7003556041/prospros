import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/post_controller.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_textformfield.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final postController = Get.put(PostController());

  quill.QuillController _controller = quill.QuillController.basic();

  TextFormField normalTextFiels() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "Describe your queries/questions",
          labelStyle: TextStyle(fontSize: 14, color: Color(0xff999BA5)),
          contentPadding: EdgeInsets.all(14),
          border: InputBorder.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: postController.hasPostCreated.value,
        child: Scaffold(
            appBar: CustomAppBar(
              Text(
                "Create Post",
                style: TextStyle(fontSize: 16),
              ),
              action: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).unfocus();
                    var postDescription =
                        jsonEncode(_controller.document.toDelta().toJson());

                    if (postDescription.isNotEmpty &&
                        postController.title.text.isNotEmpty) {
                      final HomeController homeController = Get.find();
                      homeController.activeSelection.value = ActiveName.home;

                      postController.createPost(postDescription);
                    } else {
                      Get.closeAllSnackbars();
                      Get.showSnackbar(GetSnackBar(
                          message: "All field as required",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                          margin:
                              EdgeInsets.only(bottom: 20, left: 0, right: 0)));
                    }

                    // Get.toNamed(home);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "Publish",
                      style: TextStyle(color: Color(0xff2643E5)),
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Material(
                          child: SizedBox(
                            height: 33,
                            width: double.infinity,
                          ),
                        ),
                        const Text(
                          "Title",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Material(
                          child: SizedBox(
                            height: 4,
                            width: double.infinity,
                          ),
                        ),
                        const Text(
                          "Summarize your problem",
                          style: TextStyle(color: Color(0xff707070)),
                        ),
                        const Material(
                          child: SizedBox(
                            height: 16,
                            width: double.infinity,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                style: TextStyle(
                                    fontFamily: AppTitle.fontMedium,
                                    fontSize: 18),
                                controller: postController.title,
                                labelTxt: "",
                                hintTxt: "",
                                obscureText: false,
                              ),
                            ),
                          ],
                        ),
                        const Material(
                          child: SizedBox(
                            height: 24,
                            width: double.infinity,
                          ),
                        ),
                        postController.filePath.value.isEmpty
                            ? selectImage()
                            : Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                spreadRadius: 3,
                                                blurRadius: 30)
                                          ]),
                                      padding: EdgeInsets.all(5),
                                      child: GestureDetector(
                                        onTap: () {
                                          postController.selectImage();
                                        },
                                        child: Image.file(
                                          File(postController.filePath.value),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 10,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            postController.filePath.value = "";
                                            postController.imageFile = null;
                                          },
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                        Material(
                          child: SizedBox(
                            height: 24,
                            width: double.infinity,
                          ),
                        ),
                        const Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Material(
                          child: SizedBox(
                            height: 12,
                            width: double.infinity,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 291,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(color: Colors.grey)),
                                    // child: normalTextFiels(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2,
                                          right: 2,
                                          top: 2,
                                          bottom: 2.0),
                                      child: quill.QuillProvider(
                                        configurations:
                                            quill.QuillConfigurations(
                                          controller: _controller,
                                          sharedConfigurations: const quill
                                              .QuillSharedConfigurations(
                                              locale: Locale('de'),
                                              animationConfigurations: quill
                                                  .QuillAnimationConfigurations(
                                                      checkBoxPointItem: true)),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 250,
                                              child: quill.QuillEditor.basic(
                                                configurations: const quill
                                                    .QuillEditorConfigurations(
                                                  readOnly: false,
                                                  // autoFocus: true,
                                                  showCursor: true,
                                                  scrollable: true,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                  height: 35,
                                                  child: quill.QuillToolbar(
                                                    configurations: quill
                                                        .QuillToolbarConfigurations(
                                                      showAlignmentButtons:
                                                          false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showUndo: false,
                                                      showRedo: false,
                                                      showFontFamily: false,
                                                      showCenterAlignment:
                                                          false,
                                                      showClearFormat: false,
                                                      showFontSize: false,
                                                      showUnderLineButton:
                                                          false,
                                                      showStrikeThrough: false,
                                                      showCodeBlock: false,
                                                      showColorButton: false,
                                                      showDirection: false,
                                                      showDividers: false,
                                                      showHeaderStyle: false,
                                                      showListNumbers: true,
                                                      showIndent: false,
                                                      showJustifyAlignment:
                                                          false,
                                                      showLink: false,
                                                      showSearchButton: false,
                                                      showListCheck: false,
                                                      showBoldButton: true,
                                                      showSubscript: true,
                                                      showSuperscript: true,
                                                      showItalicButton: true,
                                                      showQuote: true,
                                                      showInlineCode: true,
                                                      showListBullets: true,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // const SizedBox(
                        //   height: 30,
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Row selectImage() {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: 42,
          child: OutlinedButton(
              onPressed: () {
                postController.selectImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add),
                  SizedBox(
                    width: 10,
                  ),
                  Text(postController.filePath.value.isEmpty
                      ? "Add Image"
                      : "Replace Image"),
                ],
              )),
        )),
      ],
    );
  }
}
