import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/controller/edit_profile_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:sizing/sizing.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? yourCatDropDownVal;

  EditProfileController controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    print("Login Response controller");
    // log(controller.loginResponse!.data!.userDetail!.contactNumber!.toString());
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.hasProfileCreated.value ||
            controller.hasProfileSet.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            Text("Edit Profile", style: const TextStyle(fontSize: 16)),
            action: Padding(
              padding: EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  controller.postProfileUpdate();
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Color(0xff2643E5)),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 33),
                      const Text("Your Category"),
                      const SizedBox(height: 16),
                      yourCatdropDownBtn(),
                      const SizedBox(height: 24),
                      // const Text("Select Subcategory"),
                      // const SizedBox(height: 16),
                      yourSubCatdropDownBtn(),
                      // const SizedBox(height: 24),
                    ],
                  ),
                ),
                const Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            "Professional Field",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 24),
                          Text("Professional Designation"),
                          SizedBox(height: 8),
                          CustomTextFormField(
                              controller: controller.professionalDesignation,
                              labelTxt: "Anatomy Student",
                              hintTxt: ""),
                          SizedBox(height: 16),
                          Text("Professional Field"),
                          SizedBox(height: 8),
                          CustomTextFormField(
                              controller: controller.professionalField,
                              labelTxt: "",
                              hintTxt: ""),
                          SizedBox(height: 16),
                          Text("Office/Business"),
                          SizedBox(height: 8),
                          CustomTextFormField(
                              controller: controller.officeName,
                              labelTxt: "",
                              hintTxt: ""),
                          SizedBox(height: 24),
                        ])),
                const Divider(height: 4, color: Colors.grey),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text("Education Details",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 24),
                          Text("Highest Education Degree"),
                          SizedBox(height: 8),
                          CustomTextFormField(
                              controller: controller.highestQual,
                              labelTxt: "",
                              hintTxt: ""),
                          SizedBox(height: 16),
                          Text("Specialized in"),
                          SizedBox(height: 8),
                          CustomTextFormField(
                              controller: controller.areaOfSpecialization,
                              labelTxt: "",
                              hintTxt: ""),
                          SizedBox(height: 24),
                        ])),
                const Divider(height: 4, color: Colors.grey),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            "Biography",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 24),
                          CustomTextFormField(
                            controller: controller.biography,
                            labelTxt: "",
                            hintTxt: "",
                            maxLines: 5,
                          ),
                          SizedBox(height: 24),
                        ])),
                const Divider(height: 4, color: Colors.grey),
                twoFactorSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget twoFactorSection() {
    return Obx(
      () => Visibility(
        visible: !controller.isSocialLogin.value,
        child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                    width: double.infinity,
                  ),
                  Text(
                    "Two-factor authentication",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable two factor authentication"),
                      Obx(
                        () => Transform.scale(
                          scale: 0.75,
                          child: CupertinoSwitch(
                              activeColor: Apputil.getActiveColor(),
                              value: controller.twoFactorAuth.value,
                              onChanged: (isEnabled) {
                                controller.twoFactorAuth.value = isEnabled;
                              }),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                ])),
      ),
    );
  }

  Container yourCatdropDownBtn() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(3)),
      child: DropdownButton<String>(
        value: controller.categoryList.isEmpty ? null : controller.categoryName,
        borderRadius: BorderRadius.circular(3),
        hint: const Text("Select Category"),
        icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(height: 2, color: Colors.transparent),
        isExpanded: true,
        onChanged: null,
        items: controller.categoryList.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget yourSubCatdropDownBtn() {
    return Obx(
      () => controller.wholeSubCategoryList.isEmpty
          ? Container()
          : Container(
              child: Column(
              children: [
                // MultiSelectChipField<SubCategory?>(
                //   initialValue: controller.wholeSubCategoryList,
                //   title: Text("Subcategory"),
                //   // items: controller.subCategoryList
                //   //     .map((subCategory) => MultiSelectItem<SubCategory?>(
                //   //         subCategory, subCategory.categoryName!))
                //   //     .toList(),
                //   items: controller.wholeSubCategoryList
                //       .map((subCategory) => MultiSelectItem<SubCategory?>(
                //           subCategory, subCategory.categoryName!))
                //       .toList(),
                //   icon: Icon(Icons.check),

                //   onTap: (values) {
                //     controller.selectedSubCategoryList.clear();
                //     for (int i = 0; i < values.length; i++) {
                //       if (values[i]?.id != null) {
                //         controller.selectedSubCategoryList.add(values[i]!);
                //       }
                //     }
                //   },
                // ),
                subCategoryField(),
                SizedBox(height: 12.ss),
              ],
            )),
    );
  }

  Container subCategoryField() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.blue,
              child: Text(
                "SubCategory",
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...controller.wholeSubCategoryList
                      .map((subcat) => MultiSelectChip(
                            itemId: subcat.id!,
                            onTap: (isSelected, itemId) {
                              var item = controller.wholeSubCategoryList
                                  .where((element) => element.id == itemId);

                              var selctedItemList = controller
                                  .selectedSubCategoryList
                                  .where((element) => element.id == itemId);
                              printRed(
                                  "Selcted item $isSelected $itemId ${selctedItemList?.map(
                                (e) => "${e.id} : ${e.categoryName}",
                              )}");
                              if (isSelected) {
                                //if chip is selected
                                if (selctedItemList.isNotEmpty) {
                                  //item is already selected don't do anything
                                } else {
                                  controller.selectedSubCategoryList
                                      .add(item.first);
                                }
                              } else {
                                //if chip is unselected

                                for (int i = 0;
                                    i <
                                        controller
                                            .selectedSubCategoryList.length;
                                    i++) {
                                  if (controller
                                          .selectedSubCategoryList[i].id ==
                                      itemId) {
                                    controller.selectedSubCategoryList.remove(
                                        controller.selectedSubCategoryList[i]);
                                  }
                                }
                              }

                              printRed(
                                  "Sected Child length: ${controller.selectedSubCategoryList.length} ${controller.selectedSubCategoryList.map((e) => "[${e.id} - ${e.categoryName}]").toList()}");
                            },
                            labelName: subcat.categoryName ?? "--",
                            isSelected: controller.selectedSubCategoryList
                                .where((element) => element.id == subcat.id)
                                .isNotEmpty,
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final String labelName;
  final int itemId;
  bool isSelected;
  void Function(bool isSelected, int itemId) onTap;
  MultiSelectChip(
      {super.key,
      required this.labelName,
      required this.itemId,
      required this.isSelected,
      required this.onTap});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  ValueNotifier isSelected = ValueNotifier<bool>(false);

  @override
  void initState() {
    isSelected.value = widget.isSelected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.ss),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.ss),
          splashColor: Colors.blue,
          onTap: () {
            isSelected.value = !isSelected.value;
            widget.onTap(isSelected.value, widget.itemId);
          },
          child: ValueListenableBuilder(
            valueListenable: isSelected,
            builder: (context, value, child) {
              return Container(
                constraints: BoxConstraints(maxHeight: 40),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: value ? Colors.blue : Colors.grey),
                    color: value
                        ? Colors.blue.withOpacity(.5)
                        : Colors.grey.withOpacity(.8),
                    borderRadius: BorderRadius.circular(20.ss)),
                child: Row(
                  children: [
                    value
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 5.ss,
                    ),
                    Text(widget.labelName),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
