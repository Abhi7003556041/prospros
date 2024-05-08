import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:prospros/model/disc_terms/about_us_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutUsController());
    return Scaffold(
      appBar: CustomAppBar(Text("About")),
      body: Obx(
        () => controller.isResLoaded.value
            ? Padding(
                padding: EdgeInsets.all(10.ss),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.aboutUs?.data?.pageTitle ?? ''}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.ss),
                      ),
                      Text(
                        "Updated on : ${timeZone.getLocalTimeFromUTC(controller.aboutUs?.data?.updatedAt ?? '')}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10.ss),
                      ),
                      Divider(),
                      Html(data: controller.aboutUs?.data?.content ?? "")
                    ]),
              )
            : SizedBox(),
      ),
    );
  }
}
