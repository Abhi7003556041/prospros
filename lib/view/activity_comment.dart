import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/activity_comment_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/main.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/custom_appbar.dart';
import 'package:prospros/widgets/custom_scaffold.dart';

class ActivityComment extends StatelessWidget {
  ActivityComment({super.key});

  @override
  Widget build(BuildContext context) {
    final activityCommentController = Get.put(ActivityCommentController());
    return CustomScaffold(
        activeTab: ActiveName.profile,
        isProfile: true,
        appBar: CustomAppBarV2(
            enableBackgroundColor: false,
            title: AppTitle.activityComment,
            onTap: () {
              Get.toNamed(activity);
            }),
        body: Obx(() => (activityCommentController.commentData.length == 0)
            ? activityCommentController.iscommentLoading.value
                ? Center(child: SizedBox(child: Text("Loading...")))
                : Center(
                    child: Container(
                      child: Text("You haven't commented on any post."),
                    ),
                  )
            : NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    print('Scroll Started');
                  } else if (scrollNotification is ScrollUpdateNotification) {
                    print('Scroll Updated');
                  } else if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    print('Scroll Ended');
                    activityCommentController.NextPageActivityComment();
                  }
                  return true;
                },
                child: activityCommentController.commentData.length == 0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                            itemCount:
                                activityCommentController.commentData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final e =
                                  activityCommentController.commentData[index];
                              final isLastIndex = (index ==
                                  activityCommentController.commentData.length -
                                      1);
                              return Column(
                                children: [
                                  Card(
                                    child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(e.commentText ?? ""),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              // child: Text(DateFormat(
                                              //         'dd-MM-yyyy - kk:mm a')
                                              //     .format(DateTime.parse(
                                              //         e.createdAt ??
                                              //             DateTime.now()
                                              //                 .toString()))),
                                              child: Text(
                                                  timeZone.getLocalTimeFromUTC(
                                                      e.createdAt ?? "")),
                                            ),
                                          ],
                                        )),
                                  ),
                                  isLastIndex &&
                                          (index !=
                                              activityCommentController
                                                      .totalCount.value -
                                                  1)
                                      ? Column(
                                          children: [
                                            SizedBox(height: 16),
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : Container()
                                ],
                              );
                            }),
                      ),
              )));
  }
}
