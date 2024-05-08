import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/filter_controller.dart';
import 'package:prospros/view/filter/sub_cat_btn.dart';
import 'package:prospros/view/filter/sub_cat_item_btn.dart';
import 'package:prospros/widgets/back_button.dart';
import 'package:sizing/sizing.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final controller = Get.put(FilterScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: double.maxFinite,
                  color: const Color(0xffF9F9F9),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: double.maxFinite,
                  color: Colors.white,
                ),
              )
            ]),
          ),
          Column(
            children: [
              pageHeader(),
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              Obx(
                () => !controller.isAllDataInitialized.value
                    ? const SizedBox()
                    : IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.maxFinite,
                                  height:
                                      MediaQuery.of(context).size.height * .85,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Obx(
                                          () => ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: controller
                                                    .filterParamList
                                                    .value
                                                    .length +
                                                1,
                                            itemBuilder: (context, index) {
                                              if (controller
                                                      .filterParamList.length ==
                                                  0) {
                                                //if there is no item ; then we explicitly added +1 to length at itemCount.
                                                //so to handle that we are showing empty box
                                                return SizedBox();
                                              }
                                              if (index ==
                                                  (controller.filterParamList
                                                      .length)) {
                                                return SizedBox(
                                                  height: 50.ss,
                                                );
                                              }
                                              var data = controller
                                                  .filterParamList[index];

                                              return Obx(
                                                () => SubCatButton(
                                                  btnText: data.title,
                                                  isSelected: controller
                                                          .selectedSubCatIndex
                                                          .value ==
                                                      index,
                                                  onTap: () {
                                                    controller
                                                        .selectedSubCatIndex
                                                        .value = index;
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.maxFinite,
                                  height:
                                      MediaQuery.of(context).size.height * .85,
                                  child: Column(children: [
                                    Expanded(
                                      flex: 1,
                                      child: Obx(
                                        () => ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: controller
                                                      .selectedSubCatIndex
                                                      .value <
                                                  0
                                              ? 0
                                              : controller
                                                      .filterParamList
                                                      .value[controller
                                                          .selectedSubCatIndex
                                                          .value]
                                                      .itemList
                                                      .length +
                                                  1,
                                          itemBuilder: (context, index) {
                                            if (controller
                                                    .filterParamList
                                                    .value[controller
                                                        .selectedSubCatIndex
                                                        .value]
                                                    .itemList
                                                    .length ==
                                                0) {
                                              //if there is no item ; then we explicitly added +1 to length at itemCount.
                                              //so to handle that we are showing empty box
                                              return SizedBox();
                                            }
                                            if (index ==
                                                (controller
                                                    .filterParamList
                                                    .value[controller
                                                        .selectedSubCatIndex
                                                        .value]
                                                    .itemList
                                                    .length)) {
                                              return SizedBox(
                                                height: 100.ss,
                                              );
                                            }

                                            var data = controller
                                                .filterParamList
                                                .value[controller
                                                    .selectedSubCatIndex.value]
                                                .itemList[index];
                                            return SubCatItemButton(
                                              btnText: data.title,
                                              isSelected: controller
                                                  .filterParamList
                                                  .value[controller
                                                      .selectedSubCatIndex
                                                      .value]
                                                  .itemList[index]
                                                  .isSelected,
                                              onTap: () {
                                                controller
                                                        .filterParamList
                                                        .value[controller
                                                            .selectedSubCatIndex
                                                            .value]
                                                        .itemList[index]
                                                        .isSelected =
                                                    !controller
                                                        .filterParamList
                                                        .value[controller
                                                            .selectedSubCatIndex
                                                            .value]
                                                        .itemList[index]
                                                        .isSelected;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ]),
                                ))
                          ],
                        ),
                      ),
              )
            ],
          ),
          Positioned(
              bottom: 10,
              right: 16,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 158,
                    height: 42,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Color(0xff2643E5))),

                        // backgroundColor:
                        //     MaterialStateProperty.all(Color(0xff2643E5))
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0xff2643E5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 158,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.onApply();
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              )),
        ],
      )),
    );
  }

  Container pageHeader() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppBackButton.stackBackButton(),
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Filter",
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          TextButton(
            child: const Text(
              "Clear All",
              style: TextStyle(color: Color(0xff2643E5)),
            ),
            onPressed: () {
              controller.clearAll();
            },
          )
        ],
      ),
    );
  }
}
