import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers/print.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/controller/message_controller.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/message/chat_user_card.dart';
import 'package:prospros/widgets/custom_scaffold.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:sizing/sizing.dart';

class Message extends StatefulWidget {
  Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final messageController = Get.put(MesageController());

  @override
  void initState() {
    // messageController.listenToUsersFriendList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      activeTab: ActiveName.message,
      appBar: CustomPrefferedSizeWidget(AppTitle.message),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 17),
          Container(
              color: AppColor.communityTxtFormFieldColor,
              child: Focus(
                onFocusChange: (isFocusChanged) {
                  //if focus is changed and searchText is empty then toogle isSearching to false
                  if (isFocusChanged) {
                    messageController.isSearching.value = true;
                  } else {
                    if (messageController.searchText.value.isEmpty) {
                      messageController.isSearching.value = false;
                    }
                  }
                },
                
                child: CustomTextFormField(
                    isBordered: false,
                    controller: messageController.userSearchController,
                    labelTxt: AppTitle.searchHere,
                    hintTxt: AppTitle.searchHere,
                    onChanged: (val) {
                      messageController.searchText.value = val;
                      messageController.searchUser();
                    },
                    prefixIcon: Icon(Icons.search)),
              )),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,

            //  child: usingFirebaseAnimatedList())
            child: Obx(
              () => messageController.isSearching.value
                  ? messageController.searchedChatUserData.value.isEmpty
                      ? messageController.searchText.value.isNotEmpty
                          ? Center(
                              child: Text(
                              "No users to show",
                              style: TextStyle(color: Colors.black),
                            ))
                          : Center(
                              child: Text(
                              "Search users",
                              style: TextStyle(color: Colors.black),
                            ))
                      : ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          itemCount: messageController
                              .searchedChatUserData.value.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              key: Key(messageController.searchedChatUserData
                                  .value[index].firebaseUserId),
                              firebaseUserId: messageController
                                  .searchedChatUserData
                                  .value[index]
                                  .firebaseUserId,
                              chatRoomId: messageController
                                  .searchedChatUserData.value[index].chatRoomId,
                            );
                          },
                        )
                  : StreamBuilder(
                      stream: messageController.chatService
                          .getFirebasUserFriendListDataRef()
                          .orderByChild("lastChat")
                          .onValue,
                      builder: (context, snapshot) {
                        // printRed("StramBuilder working");
                        // printRed(snapshot.data?.snapshot.value.toString());
                        messageController.chatUserDataInSortedOrder.clear();
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          for (var user in snapshot.data!.snapshot.children) {
                            if (user.value is Map) {
                              var mapData = user.value as Map;
                              var chatUserDetails = ChatUsersDetails(
                                  chatRoomId: mapData['chat_room_id'],
                                  firebaseUserId: mapData['user_id']);
                              messageController.chatUserDataInSortedOrder
                                  .add(chatUserDetails);
                            }
                          }

                          messageController.chatUserDataInSortedOrder.value =
                              messageController
                                  .chatUserDataInSortedOrder.value.reversed
                                  .toList();
                        }
                        if (messageController
                            .chatUserDataInSortedOrder.isEmpty) {
                          return Center(
                            child: Text("No conversations to show"),
                          );
                        }
                        return ListView.builder(
                          itemCount: messageController
                              .chatUserDataInSortedOrder.value.length,
                          itemBuilder: (context, index) {
                            var data = messageController
                                .chatUserDataInSortedOrder.value[index];
                            return ChatUserCard(
                              key: Key(data.firebaseUserId +
                                  (DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString())),
                              firebaseUserId: data.firebaseUserId,
                              chatRoomId: data.chatRoomId,
                            );
                          },
                        );
                      },
                    ),
            ),
          )
        ]),
      ),
    );
  }

  FirebaseAnimatedList usingFirebaseAnimatedList() {
    return FirebaseAnimatedList(
      query: messageController.chatService
          .getFirebasUserFriendListDataRef()
          .orderByChild("lastChat"),
      defaultChild: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      itemBuilder: (context, snapshot, animation, index) {
        printRed(snapshot.value.toString());

        if (snapshot.exists) {
          var data = snapshot.value as Map;
          var receiverFirebaseUserId = data['user_id'];
          var chatRoomId = data['chat_room_id'];

          return ChatUserCard(
            firebaseUserId: receiverFirebaseUserId,
            chatRoomId: chatRoomId,
            //   firebaseUserId: messageController
            //     .chatUserDataInSortedOrder[index].firebaseUserId,
            // chatRoomId: messageController
            //     .chatUserDataInSortedOrder[index].chatRoomId,
          );
        }
        return Apputil.showShimmer(
            height: 70.ss, shimmerBaseColor: Colors.grey[300]!);
      },
    );
  }

  @override
  void dispose() {
    messageController.streamSubscription?.cancel();
    messageController.isSearching.value = false;
    messageController.searchedChatUserData.clear();
    messageController.userSearchController.text = "";
    messageController.userSearchController.dispose();
    super.dispose();
  }
}
