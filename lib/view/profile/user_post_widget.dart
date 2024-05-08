import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/profile_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/widgets/post_card.dart';
import 'package:sizing/sizing.dart';

//Profile & Activity post will share the same Widget.
//isScrollable set to false to diable scroll in Profile view.
//scrollController event listener is added in the profile view for listening the
//maximum position of a scroll widget
//updateNextPageUserPost() will server both the profile & Activity post for next page.
class UserPostWidget extends StatelessWidget {
  UserPostWidget({super.key, this.isScrollable = false, this.onTap});
  final bool isScrollable;
  final VoidCallback? onTap;
  ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification) {
              print('Scroll Started');
            } else if (scrollNotification is ScrollUpdateNotification) {
              print('Scroll Updated');
            } else if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              print('Scroll Ended');
              controller.updateNextPageUserPost();
            }
            return true;
          },
          child: controller.postListData.length == 0
              ? controller.isDataLoaded.value
                  ? controller.postListData.length == 0
                      ? Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 200.ss,
                            child: Text("You haven't posted anything"),
                          ),
                        )
                      : SizedBox()
                  : SizedBox()
              : ListView.builder(
                  reverse: false,
                  shrinkWrap: true,
                  physics: isScrollable ? NeverScrollableScrollPhysics() : null,
                  itemCount: controller.postListData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final e = controller.postListData[index];
                    return Column(
                      children: [
                        Obx(
                          () => PostCard(
                              isCreatedByCurrentUser:
                                  controller.appUserId.value == e.postedBy!.id,
                              isReportPossible: e.postedBy!.id.toString() ==
                                      controller.appUserId.value.toString()
                                  ? false
                                  : true,
                              index: index,
                              isProfile: true,
                              flagImg: e.country?.flag ?? "",
                              UserId: e.postedBy?.id.toString() ?? "",
                              postId: e.id.toString() ?? "",
                              onTap: () async {
                                controller.commentPostIndex.value = index;
                                controller.likeDisLikePostIndex.value = index;
                                await HiveStore().put(
                                    Keys.currentPostId, e.id?.toString() ?? "");
                                Get.toNamed(postDetails, arguments: [true]);
                              },
                              name: e.postedBy?.name ?? "",
                              numDays: e.postCreatedAtRAW ?? "",
                              profileImg: e.postedByImage ?? "",
                              title: e.postTitle ?? "",
                              content: e.postDescription ?? "",
                              postImage: e.postImages ?? "",
                              numOfLikes: e.rxTotalLikes.value.toString(),
                              isLiked: e.isLiked.value,
                              onTapLike: () {
                                controller.postId.value = e.id.toString();
                                controller.updateLikesManually(e.isLiked.value);
                              },
                              numOfComments: e.rxTotalComments.value < 0
                                  ? "0"
                                  : e.rxTotalComments.value.toString()),
                        ),
                        const Divider(height: 0.5, color: Colors.grey),
                        if ((index !=
                                (controller.userPostResponseModel?.data?.meta
                                            ?.total ??
                                        0) -
                                    1) &&
                            index == controller.postListData.length - 1)
                          Column(
                            children: [
                              SizedBox(height: 15),
                              CircularProgressIndicator(),
                            ],
                          )
                      ],
                    );
                  })),
    );
  }
}
