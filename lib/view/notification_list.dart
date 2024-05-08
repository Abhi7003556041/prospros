import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/notificationList_controller.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/widgets/custom_app_bar.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/model/notificationlist_model/notificationlist_response_mode.dart';

class NotificationList extends StatelessWidget {
  NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationListController());
    return Scaffold(
      appBar: CustomAppBar(Text("Notifications")),
      body: Obx(
        () => !controller.isThereAnyNotifications.value
            ? controller.hasNotification.value
                ? const SizedBox()
                : Center(
                    child: Container(
                    child: Text("You don't have any notifications"),
                  ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: (controller
                              .notificationListResponseModel?.data?.isEmpty ??
                          true)
                      ? Container()
                      : Column(
                          children:
                              controller.notificationListResponseModel!.data!
                                  .map((e) => NotificationCard(
                                        notificationData: e,
                                      ))
                                  .toList()),
                ),
              ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  NotificationCard({
    super.key,
    required this.notificationData,
  });

  Data notificationData;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationListController());
    return GestureDetector(
      onTap: () async {
        if ((widget.notificationData.readAt == null)) {
          var isRead = await controller
              .readNotifications(widget.notificationData.id ?? 0);
          widget.notificationData.readAt = DateTime.now().toString();
          if (isRead) {
            if (mounted) setState(() {});
          }
        }
      },
      child: Card(
        child: Column(
          children: [
            NotificationMsgBtn(
                controller: controller,
                createdAt: widget.notificationData.datetime ?? "",
                msg: widget.notificationData.message!,
                notificationId: widget.notificationData.id ?? 0,
                senderId: widget.notificationData.senderId ?? 0,
                receiverId: widget.notificationData.receiverId ?? 0,
                isRead: widget.notificationData.readAt != null &&
                    widget.notificationData.readAt!.isNotEmpty,
                isChatRequest: widget.notificationData.type! == "chat_request"),
          ],
        ),
      ),
    );
  }
}

class NotificationMsgBtn extends StatelessWidget {
  const NotificationMsgBtn(
      {super.key,
      required this.msg,
      this.isChatRequest = false,
      required this.controller,
      required this.senderId,
      required this.receiverId,
      required this.isRead,
      required this.createdAt,
      required this.notificationId});
  final String msg;
  final bool isChatRequest;
  final int receiverId;
  final int senderId;
  final int notificationId;
  final NotificationListController controller;
  final bool isRead;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(3.ss)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GestureDetector(
          //     onTap: () {
          //       controller.readNotifications(notificationId);
          //     },
          //     child: Text(msg)),
          Row(
            children: [
              showIcon(msg),
              SizedBox(
                width: 10.ss,
              ),
              Expanded(child: Text(msg)),
            ],
          ),
          Divider(),
          Align(
              alignment: Alignment.centerRight,
              child: Text(Apputil.strToDateTime(createdAt))),

          isChatRequest
              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(width: 10),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        controller.acceptRejectChatRequest(
                            receiverId: receiverId,
                            senderId: senderId,
                            isAccept: AppTitle.reject);
                      },
                      child: Text("Reject")),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        controller.acceptRejectChatRequest(
                            receiverId: receiverId,
                            senderId: senderId,
                            isAccept: AppTitle.accept);
                      },
                      child: Text("Accept")),
                  SizedBox(width: 10),
                ])
              : Container()
        ],
      ),
    );
  }

  Widget showIcon(String msg) {
    if (msg.contains("liked")) {
      return Icon(
        Icons.thumb_up_sharp,
        color: Apputil.getActiveColor(),
      );
    }
    if (msg.contains("you have a message from")) {
      return Icon(
        Icons.message_outlined,
        color: Apputil.getActiveColor(),
      );
    } else {
      return SizedBox();
    }
  }
}
