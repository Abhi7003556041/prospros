import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:prospros/controller/disc_terms_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/main.dart';

class DisclaimerTerms extends StatelessWidget {
  const DisclaimerTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DisclaimerAndTermsController());
    return Scaffold(
      appBar: CustomAppBar(Text("")),
      body: Obx(
        () => controller.isResLoaded.value
            ? Padding(
                padding: EdgeInsets.all(8.0.ss),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.disclaimerTermsRes?.data?.pageTitle ?? ''}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.ss),
                    ),
                    Text(
                      "Updated on : ${timeZone.getLocalTimeFromUTC(controller.disclaimerTermsRes?.data?.updatedAt ?? '')}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.ss),
                    ),
                    Divider(),
                    Html(
                        data:
                            controller.disclaimerTermsRes?.data?.content ?? "")
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
