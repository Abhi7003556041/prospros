import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/edit_post_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/post_controller.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:prospros/widgets/custom_textformfield.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen(
      {super.key,
      required this.postTitle,
      required this.postId,
      required this.postBody,
      this.postImage = null});
  final String postTitle;
  final String postId;
  final String postBody;
  String? postImage;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final postController = Get.put(EditPostController());

  quill.QuillController _controller = quill.QuillController.basic();

  @override
  void initState() {
    postController.downloadImage(widget.postImage);
    postController.title.text = widget.postTitle;
    _controller = quill.QuillController(
        selection: TextSelection.collapsed(offset: 0),
        document:
            quil.Document.fromJson(postController.getContent(widget.postBody)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: postController.hasPostCreated.value,
        child: Scaffold(
            appBar: CustomAppBar(
              Text(
                "Edit Post",
                style: TextStyle(fontSize: 16),
              ),
              action: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: GestureDetector(
                  onTap: () {
                    // FocusManager.instance.primaryFocus?.unfocus();
                    // FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).unfocus();
                    var postDescription =
                        jsonEncode(_controller.document.toDelta().toJson());

                    if (postDescription.isNotEmpty &&
                        postController.title.text.isNotEmpty) {
                      final HomeController homeController = Get.find();
                      homeController.activeSelection.value = ActiveName.home;

                      postController.createPost(postDescription, widget.postId);
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

                                  // Container(
                                  //   height: 291,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: const BorderRadius.all(
                                  //           Radius.circular(8)),
                                  //       border: Border.all(color: Colors.grey)),
                                  //   // child: normalTextFiels(),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         left: 2,
                                  //         right: 2,
                                  //         top: 2,
                                  //         bottom: 36.0),
                                  //     child: Theme(
                                  //       data: ThemeData(
                                  //           textSelectionTheme:
                                  //               const TextSelectionThemeData(
                                  //             cursorColor:
                                  //                 Colors.black, //<-- SEE HERE
                                  //           ),
                                  //           colorScheme: ColorScheme.fromSeed(
                                  //               seedColor: Colors.black)),
                                  //       child: quill.QuillEditor(
                                  //         autoFocus: false,
                                  //         scrollController: ScrollController(),
                                  //         expands: true,
                                  //         focusNode:
                                  //             postController.quillFocusNode,

                                  //         readOnly: false,
                                  //         scrollable: true,
                                  //         //Bottom Padding added to give some space below the End of the text
                                  //         padding: EdgeInsets.zero,
                                  //         customStyles: quill.DefaultStyles(
                                  //           h1: quill.DefaultTextBlockStyle(
                                  //               TextStyle(
                                  //                   color: Colors.black,
                                  //                   fontSize: 18,
                                  //                   fontFamily:
                                  //                       AppTitle.fontNormal),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               null),
                                  //           h2: quill.DefaultTextBlockStyle(
                                  //               TextStyle(
                                  //                   color: Colors.black,
                                  //                   fontSize: 17,
                                  //                   fontFamily:
                                  //                       AppTitle.fontNormal),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               null),
                                  //           h3: quill.DefaultTextBlockStyle(
                                  //               TextStyle(
                                  //                   color: Colors.black,
                                  //                   fontSize: 16,
                                  //                   fontFamily:
                                  //                       AppTitle.fontNormal),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               quill.VerticalSpacing(0, 0),
                                  //               null),
                                  //           paragraph:
                                  //               quill.DefaultTextBlockStyle(
                                  //                   TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize: 14,
                                  //                       fontFamily: AppTitle
                                  //                           .fontNormal),
                                  //                   quill.VerticalSpacing(0, 0),
                                  //                   quill.VerticalSpacing(0, 0),
                                  //                   null),
                                  //           // strikeThrough: GoogleFonts.montserrat(
                                  //           //     color: darkText,
                                  //           //     decoration:
                                  //           //         TextDecoration.lineThrough),
                                  //           // sizeSmall: GoogleFonts.montserrat(
                                  //           //     color: darkText),
                                  //           // italic: GoogleFonts.montserrat(
                                  //           //     color: darkText,
                                  //           //     fontStyle: FontStyle.italic),
                                  //           // bold: GoogleFonts.montserrat(
                                  //           //     color: darkText,
                                  //           //     fontWeight: FontWeight.bold),
                                  //           // underline: GoogleFonts.montserrat(
                                  //           //     color: darkText,
                                  //           //     decoration:
                                  //           //         TextDecoration.underline),
                                  //           // color: darkText
                                  //         ),
                                  //         controller: _controller,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Positioned(
                                  //   bottom: 0,
                                  //   right: 0,
                                  //   child: Container(
                                  //     // width: MediaQuery.of(context).size.width,
                                  //     decoration: BoxDecoration(
                                  //         // color: Colors.white,
                                  //         // borderRadius: const BorderRadius.only(
                                  //         //     bottomRight: Radius.circular(8),
                                  //         //     bottomLeft: Radius.circular(8)),
                                  //         // border:
                                  //         //     Border.all(color: Colors.red)
                                  //         ),
                                  //     padding: const EdgeInsets.all(12.0),
                                  //     child: Align(
                                  //       alignment: Alignment.centerRight,
                                  //       child: quill.QuillToolbar.basic(
                                  //         iconTheme: const quill.QuillIconTheme(
                                  //             iconSelectedFillColor:
                                  //                 Color(0xff2646E5)),
                                  //         controller: _controller,
                                  //         showAlignmentButtons: false,
                                  //         showBackgroundColorButton: false,
                                  //         showUndo: false,
                                  //         showRedo: false,
                                  //         showFontFamily: false,
                                  //         showCenterAlignment: false,
                                  //         showClearFormat: false,
                                  //         showFontSize: false,
                                  //         showUnderLineButton: false,
                                  //         showStrikeThrough: false,
                                  //         showCodeBlock: false,
                                  //         showColorButton: false,
                                  //         showDirection: false,
                                  //         showDividers: false,
                                  //         showHeaderStyle: false,
                                  //         showListNumbers: false,
                                  //         showIndent: false,
                                  //         showInlineCode: true,
                                  //         showListBullets: false,
                                  //         showJustifyAlignment: false,
                                  //         showLink: false,
                                  //         showSearchButton: false,
                                  //         showListCheck: false,
                                  //         showBoldButton: true,
                                  //         showItalicButton: true,
                                  //         showQuote: true,
                                  //         customButtons: [
                                  //           // quill.QuillCustomButton(
                                  //           //     icon: Icons.format_bold_rounded,
                                  //           //     onTap: () {
                                  //           //       debugPrint('snowflake');
                                  //           //     }),
                                  //           // quill.QuillCustomButton(
                                  //           //     icon: Icons.format_italic,
                                  //           //     onTap: () {
                                  //           //       debugPrint('snowflake');
                                  //           //     }),
                                  //           // quill.QuillCustomButton(
                                  //           //     icon: Icons.format_quote_rounded,
                                  //           //     onTap: () {
                                  //           //       debugPrint('snowflake');
                                  //           //     }),
                                  //           // quill.QuillCustomButton(
                                  //           //     icon: Icons.code,
                                  //           //     onTap: () {
                                  //           //       debugPrint('snowflake');
                                  //           //     }),
                                  //           quill.QuillCustomButton(
                                  //               icon: Icons
                                  //                   .format_list_numbered_rounded,
                                  //               onTap: () {
                                  //                 debugPrint('snowflake');
                                  //               }),
                                  //           quill.QuillCustomButton(
                                  //               icon: Icons
                                  //                   .format_list_bulleted_rounded,
                                  //               onTap: () {
                                  //                 debugPrint('snowflake');
                                  //               }),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
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
