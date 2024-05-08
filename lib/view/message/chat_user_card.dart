import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/controller/chat_controller.dart';
import 'package:prospros/controller/message_controller.dart';
import 'package:prospros/model/chat/chat_user_card_details.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/view/message/message_profile.dart';

class ChatUserCard extends StatefulWidget {
  ChatUserCard(
      {super.key, required this.firebaseUserId, required this.chatRoomId});

  final String firebaseUserId;
  final String chatRoomId;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  final MesageController controller = Get.find();
  ValueNotifier<ChatUserListModel?> userChatCardData =
      ValueNotifier<ChatUserListModel?>(null);
  ChatService chatService = Get.find();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    var data = await controller.getUserDetails(
        userId: widget.firebaseUserId, chatRoomId: widget.chatRoomId);
    if (data != null && data.userName != null) {
      userChatCardData.value = data;
      printYellow("Get User data: ${data.userName}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ChatUserListModel?>(
      valueListenable: userChatCardData,
      builder: (context, value, child) {
        printRed("Builder value: ${value?.userName ?? 'N.A'} ");
        if (value == null) {
          return Apputil.showShimmer(
              height: 70.ss,
              shimmerBaseColor: Colors.grey[300]!,
              shimmerHiglightColor: Colors.grey[50]!);
        } else {
          return Container(
            padding: EdgeInsets.only(top: 15.ss),
            child: StreamBuilder(
              stream:
                  chatService.userDocumentRef(widget.firebaseUserId).onValue,
              builder: (context, snapshot) {
                try {
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!.snapshot.value as Map;

                    var userOnlineStatus = data['isOnline'] ?? false;

                    return messageProfile(ChatUserListModel(
                      isOnline: userOnlineStatus,
                      lastChatMessage: value.lastChatMessage ?? "",
                      lastChatMessageTime: value.lastChatMessageTime,
                      profileImageUrl: value.profileImageUrl,
                      unreadMsgCount: value.unreadMsgCount,
                      userName: value.userName,
                    ));
                  }
                  return messageProfile(value);
                } catch (err) {
                  //if there is any error then we returning
                  return messageProfile(value);
                }
              },
            ),
          );
        }
      },
    );
  }

  MessageProfile messageProfile(ChatUserListModel value) {
    return MessageProfile(
      unreadMsgCount: value.unreadMsgCount ?? 10,
      img: value.profileImageUrl ?? "",
      name: value.userName ?? "",
      msg: value.lastChatMessage ?? "",
      msgTime: value.lastChatMessageTime ?? "",
      onTap: () async {
        ChatController chatController = Get.put(ChatController());
        await chatController.initializeChatSession(
            receiverId: chatController.chatService
                .getServerUserFromFirebaseUserId(widget.firebaseUserId));
        await Get.toNamed(chatScreen);
        controller.chatService.addAndRemoveValueInsideUserFriendList();
      },
      status: (value.isOnline ?? false) ? Colors.green : Colors.red,
    );
  }
}
