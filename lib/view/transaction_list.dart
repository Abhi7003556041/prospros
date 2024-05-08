import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:prospros/main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/transaction_list_controller.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class TransactionList extends StatelessWidget {
  TransactionList({super.key});

  TransactionListController transactionListController =
      Get.put(TransactionListController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isProfile: true,
        activeTab: ActiveName.profile,
        appBar: CustomAppBar(Text(AppTitle.transaction)),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: transactionListController.hasTransactionList.value,
            child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    print('Scroll Started');
                  } else if (scrollNotification is ScrollUpdateNotification) {
                    print('Scroll Updated');
                  } else if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    print('Scroll Ended');
                    transactionListController.NextPageTransactionList();
                  }
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                      itemCount: transactionListController
                          .transactionData.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        final e =
                            transactionListController.transactionData[index];
                        final isLastIndex = (index ==
                            transactionListController.transactionData.length -
                                1);
                        final date = DateTime.parse(e.subscription?.createdAt ??
                            DateTime.now().toString());
                        final updatedAt = DateTime.parse(
                            e.subscription?.updatedAt ??
                                DateTime.now().toString());

                        printRed(date.toString());
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PlanDetails(
                                        title: "Plan name",
                                        content: e.subscription?.planName
                                                ?.capitalizeFirst ??
                                            ""),
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Plan description: "),
                                            Expanded(
                                              child: Html(
                                                  shrinkWrap: true,
                                                  data: (e.subscription
                                                          ?.planDerscription ??
                                                      ""),
                                                  style: {
                                                    "body": Style(
                                                      margin: Margins.all(0),
                                                      // padding:
                                                      //     EdgeInsets.all(0)
                                                    ),
                                                    "p": Style(
                                                        // padding:
                                                        //     EdgeInsets.zero,

                                                        margin: Margins.zero)
                                                  }),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5)
                                      ],
                                    ),
                                    PlanDetails(
                                        title: "Plan duration",
                                        content: e.subscription?.planDuration ??
                                            "25"),
                                    PlanDetails(
                                        title: "Amount",
                                        content: AppTitle.dollar +
                                            (e.subscription?.planAmount ??
                                                "0")),
                                    PlanDetails(
                                      title: "Created at",
                                      // content: DateFormat("dd-MM-yyyy | ")
                                      //     .add_jms()
                                      //     .format(date)
                                      content: timeZone
                                          .getLocalTimeFromUTC(date.toString()),
                                    ),
                                    PlanDetails(
                                      title: "Updated at",
                                      // content: DateFormat("dd-MM-yyyy | ")
                                      //     .add_jms()
                                      //     .format(updatedAt)
                                      content: timeZone.getLocalTimeFromUTC(
                                          updatedAt.toString()),
                                    ),
                                    PlanDetails(
                                        title: "Status",
                                        content:
                                            e.status?.capitalizeFirst ?? ""),
                                    // PlanDetails(
                                    //     title: "Plan Id",
                                    //     content: e.id.toString()!)
                                  ],
                                ),
                              ),
                            ),
                            isLastIndex &&
                                    (index !=
                                        transactionListController
                                                .totalCount.value -
                                            1)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 16),
                                      Center(
                                          child: CircularProgressIndicator()),
                                    ],
                                  )
                                : Container()
                          ],
                        );
                      }),
                )),
          ),
        ));
  }
}

class PlanDetails extends StatelessWidget {
  const PlanDetails({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 5),
        child: Text(title + " : " + content));
  }
}
