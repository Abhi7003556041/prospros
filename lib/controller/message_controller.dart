import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/model/chat/chat_user_card_details.dart';
import 'package:prospros/util/app_util.dart';

class MesageController extends GetxController {
  final ChatService chatService = Get.find();
  StreamSubscription? streamSubscription;
  TextEditingController userSearchController = TextEditingController();
  Timer? _debounce;

  var chatUserDataInSortedOrder = <ChatUsersDetails>[].obs;
  var searchedChatUserData = <ChatUsersDetails>[].obs;
  var isSearching = false.obs;
  var searchText = "".obs;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  listenToUsersFriendList() {
    chatUserDataInSortedOrder.clear();
    streamSubscription = chatService
        .getFirebasUserFriendListDataRef()
        .orderByKey()
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        printDeepOrange(event.snapshot.value.toString());
        var data = event.snapshot.value as Map;
        var tempData = <ChatUsersDetails>[];
        if (event.snapshot.exists) {
          event.snapshot.children.forEach((element) {});
        }
        // data.forEach((key, value) {
        //   tempData.add(ChatUsersDetails(
        //       firebaseUserId: key, chatRoomId: value['chat_room_id']));
        // });

        // chatUserDataInSortedOrder.insertAll(0, tempData);
      }
    });
  }

  ///used for chat-user-card
  ///userId : firebase-user-id
  Future<ChatUserListModel?> getUserDetails(
      {required String userId, required String chatRoomId}) async {
    String? userName;
    bool? isOnline;
    String? lastChatMessage;
    String? lastChatMessageTime;
    String? profileImageUrl;
    int unreadMsg = 0;
    var appUser = await Apputil.getProfile();
    await chatService.userDocumentRef(userId).once().then((value) {
      // printGreen(value.snapshot.value.toString());

      var data = value.snapshot.value as Map;
      userName = data['name'];
      isOnline = data["isOnline"];
      profileImageUrl = data['profileUrl'] ?? "";
      if (userName?.isNotEmpty ?? false) {
        chatUserDataInSortedOrder.forEach((user) {
          if (user.firebaseUserId == userId) {
            user.personName = userName;
          }
        });
      }
    });
    await chatService
        .chatRoomRefByChatRoomID(chatRoomID: chatRoomId)
        .orderByChild('sentAt')
        .limitToLast(1)
        .once()
        .then((databaseEvent) {
      // printGreen("MSG :" + databaseEvent.snapshot.value.toString());
      if (databaseEvent.snapshot.value != null &&
          databaseEvent.snapshot.value is Map) {
        var data = databaseEvent.snapshot.value as Map;
        lastChatMessage = data.values.first['msg'];
        lastChatMessageTime = data.values.first['sentAt'];
      }

      // printGreen("Last Message :  ${lastChatMessage}");
    });

    var unreadCollectionData = await chatService
        .chatRoomRefByChatRoomID(chatRoomID: chatRoomId)
        .orderByChild('isReadByreceiver')
        .equalTo(false)
        .once();

    if (unreadCollectionData.snapshot.exists) {
      printRed("Unread msg available");
      printRed("${unreadCollectionData.snapshot.value}");
      var onlyReceivedUnreadMsgCount =
          unreadCollectionData.snapshot.children.where((element) {
        printRed(
            "${(element.value as Map)['receiverId']} != ${chatService.getFirebaseUserId((appUser?.data?.userDetails?.id ?? 0).toString())}");
        return (element.value as Map)['receiverId'] ==
            chatService.getFirebaseUserId(
                (appUser?.data?.userDetails?.id ?? 0).toString());
      });
      unreadMsg = onlyReceivedUnreadMsgCount.length;
      // unreadMsg = unreadCollectionData.snapshot.children.length;

      printRed(
          "unread msg count :${unreadCollectionData.snapshot.children.length}");
    }
    printRed("unread msg count : ${unreadMsg}");
    return ChatUserListModel(
        isOnline: isOnline,
        lastChatMessage: lastChatMessage,
        lastChatMessageTime: lastChatMessageTime,
        profileImageUrl: profileImageUrl,
        unreadMsgCount: unreadMsg,
        userName: userName);
  }

  searchUser() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchedChatUserData.clear();
      if (searchText.value.isNotEmpty) {
        var searchedUser = chatUserDataInSortedOrder
            .where((user) =>
                user.personName
                    ?.toLowerCase()
                    .contains((searchText.value.toLowerCase())) ??
                false)
            .toList();

        searchedChatUserData.value.addAll(searchedUser);
        searchedChatUserData.forEach((element) {
          printGreen("Searched User : " + element.personName.toString());
        });

        searchedChatUserData.refresh();
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

class ChatUsersDetails {
  final String firebaseUserId;
  final String chatRoomId;
  String? personName;

  ChatUsersDetails(
      {required this.firebaseUserId,
      required this.chatRoomId,
      this.personName});
}
