import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/model/country_list/country_list_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../controller/register_screen_controller.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({Key? key, required this.controller}) : super(key: key);

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: const EdgeInsets.only(left: 16, right: 16),
            // decoration: BoxDecoration(
            //     border: Border.all(
            //         color: registerController.registerValidate.value == true &&
            //                 registerController.hasCountry.value == false
            //             ? Colors.red
            //             : Colors.grey[300]!),
            //     borderRadius: BorderRadius.circular(3)),
            child:

                // DropdownButton<DataCountryListModel>(
                //   value: registerController.hasCountry == false
                //       ? null
                //       : registerController.country.value,
                //   borderRadius: BorderRadius.circular(3),
                //   icon: const Icon(
                //     Icons.arrow_drop_down_rounded,
                //     color: Colors.black,
                //   ),
                //   elevation: 16,
                //   style: const TextStyle(color: Colors.black),
                //   underline: Container(
                //     height: 2,
                //     color: Colors.transparent,
                //   ),
                //   isExpanded: true,
                //   onChanged: (value) {
                //     print("CountryList value ===========");
                //     print(value!);
                //     registerController.updateCountry(value);
                //   },
                //   hint: const Text("Please choose a Country"),
                //   items: registerController.countryList!
                //       .map<DropdownMenuItem<DataCountryListModel>>((value) {
                //     return DropdownMenuItem<DataCountryListModel>(
                //       value: value,
                //       child: Text(value.name!),
                //     );
                //   }).toList(),
                // )

                DropdownSearch<DataCountryListModel>(
              autoValidateMode: AutovalidateMode.disabled,
              popupProps: PopupProps.dialog(
                // showSelectedItems: true,

                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 5, bottom: 5, right: 10, left: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff2643E5)),
                        ))),
                disabledItemFn: (item) => item.name!.startsWith("1"),
                // itemBuilder: (context, model, status) {
                //   return ListTile(
                //     title: Text(model.name ?? ""),
                //     onTap: () {
                //       debugPrint("Tapped on ${model.name}");
                //       registerController.updateCountry(model);
                //     },
                //   );
                // }
              ),
              items: controller.countryList!,
              onChanged: (data) {
                print(data!.name!);
                controller.updateCountry(data);
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      hintText: "Select a country",
                      border: OutlineInputBorder(),
                      // errorText: registerController.hasCountry.value == false
                      //     ? ""
                      //     : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff2643E5)),
                      ),
                      errorStyle: TextStyle(fontSize: 0),
                      contentPadding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10))),
              filterFn: (item, filter) {
                return item.name?.toLowerCase().startsWith(filter) ?? false;
              },
              itemAsString: (data) => data.name!,
              selectedItem: controller.hasCountry.value == false
                  ? null
                  : controller.country.value,
              onSaved: (newValue) {
                controller.updateCountry(newValue);
              },
              validator: (DataCountryListModel? item) {
                // if (item == null)
                //   return "Required field";
                // else if (item.name! == "Brazil")
                //   return "Invalid item";
                // else
                return controller.hasCountry.value == false ? "" : null;
              },
            ),
          ),
          controller.registerValidate.value == true &&
                  controller.hasCountry.value == false
              ? Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "Please select a Country",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(color: const Color(0xffb00020), fontSize: 12),
                  ),
                )
              : Container(),
        ],
      ),
    );
    // return SizedBox(
    //   width: double.infinity,
    //   //height: 48,
    //   child: DropdownButtonFormField<String>(
    //     isExpanded: true,
    //     isDense: true,
    //     //itemHeight: 48,
    //     decoration: const InputDecoration(
    //       border: OutlineInputBorder(),
    //     ),
    //     //borderRadius: const BorderRadius.all(Radius.circular(5)),
    //     //focusColor: Colors.white,
    //     value: chosenValue, //'Android', //_chosenValue,
    //     //elevation: 5,
    //     //style: const TextStyle(color: Colors.white),
    //     iconEnabledColor: Colors.black,
    //     // items: <String>[
    //     //   'India',
    //     //   'Germany',
    //     //   'France',
    //     //   'Switzerland',
    //     //   'Russia',
    //     //   'China',
    //     //   'Japan',
    //     // ]
    //     items: items.map<DropdownMenuItem<String>>((String value) {
    //       return DropdownMenuItem<String>(
    //         value: value,
    //         child: Text(
    //           value,
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       );
    //     }).toList(),
    //     hint: const Text(
    //       "Please choose a Country",
    //       style: TextStyle(
    //           color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
    //     ),
    //     onChanged: (String? value) {
    //       // setState(() {
    //       //   _chosenValue = value;
    //       // });
    //     },
    //   ),
    // );
  }
}

// Container dropDownBtn() {
  //   return Container(
  //     margin: const EdgeInsets.only(left: 16, right: 16),
  //     padding: const EdgeInsets.only(left: 16, right: 16),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey[300]!),
  //         borderRadius: BorderRadius.circular(3)),
  //     child: DropdownButton<String>(
  //       value: dropdownValue,
  //       borderRadius: BorderRadius.circular(3),
  //       hint: const Text("Select Category"),
  //       icon: const Icon(
  //         Icons.arrow_drop_down_rounded,
  //         color: Colors.black,
  //       ),
  //       elevation: 16,
  //       style: const TextStyle(color: Colors.black),
  //       underline: Container(
  //         height: 2,
  //         color: Colors.transparent,
  //       ),
  //       isExpanded: true,
  //       onChanged: (String? value) {
  //         // This is called when the user selects an item.
  //         setState(() {
  //           dropdownValue = value!;
  //         });
  //       },
  //       items: ["Science", "Business", "Medical"]
  //           .map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }