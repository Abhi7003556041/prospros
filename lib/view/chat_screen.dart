import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/controller/chat_controller.dart';
import 'package:prospros/model/chat/chat_message.dart';
import 'package:prospros/model/chat_history_model/chat_history_response_model.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/message/show_document_msg.dart';
import 'package:prospros/view/message/show_image_msg.dart';
import 'package:prospros/widgets/custom_textformfield.dart';
import 'package:sizing/sizing.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    chatController.loadChatMessages();
    chatController.chatMsgList.clear();
    chatController.msgTimeList.clear();
    chatController.msgTimeList.listen((p0) {
      printRed(p0);
    });
    chatController.scrollController.addListener(() {
      if (chatController.scrollController.offset == 0) {
        chatController.msgTimeList.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 79,
          elevation: 1,
          backgroundColor: const Color(0xFFFFFFFF),
          centerTitle: false,
          automaticallyImplyLeading: true,
          //leadingWidth: 25,
          title: Row(
            children: [
              StreamBuilder(
                stream: chatController.receiverDocumentRef().onValue,
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasData && snapshot.data != null) {
                      var data = snapshot.data!.snapshot.value as Map;
                      var reciverProfileImage = data['profileUrl'];
                      var receiverName = data['name'];
                      var receiverOnlineStatus = data['isOnline'] ?? false;

                      ///updating current status of the receiver
                      chatController.isReceiverOnline.value =
                          receiverOnlineStatus;

                      printRed(receiverOnlineStatus.toString());
                      return receiverCircleLoader(
                          userName: receiverName,
                          isOnline: receiverOnlineStatus,
                          pofileImageUrl: reciverProfileImage);
                    }
                    return SizedBox();
                  } catch (err) {
                    return Text(" ");
                  }
                },
              ),
              SizedBox(
                width: 15.ss,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       chatController.name.value,
              //       // "Robert John",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16.fss,
              //           fontFamily: "Outfit-medium"),
              //     ),
              //   ],
              // ),
            ],
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF1D232A),
          ),
          leading: Row(
            children: [
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  // final HomeController homeController =
                  //     Get.find<HomeController>();
                  // if (homeController.activeSelection.value ==
                  //     ActiveName.community) {
                  //   Get.toNamed(profileDetail);
                  // } else if (homeController.activeSelection.value ==
                  //     ActiveName.message) {
                  //   Get.toNamed(message);
                  // } else if (homeController.activeSelection.value ==
                  //     ActiveName.profile) {
                  //   Get.toNamed(profile);
                  // }
                  Get.back();
                },
                child: Container(
                  height: 24,
                  width: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColor.appBarBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Container(
                      height: 10,
                      width: 10,
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back_ios, size: 10)),
                ),
              ),
              // const SizedBox(width: 24),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                chatController.createCall(isAudio: true);
              },
              child: Container(
                  width: 12,
                  height: 12,
                  child:
                      const Icon(Icons.phone, color: AppColor.chatIconColor)),
            ),
            const SizedBox(width: 23),
            GestureDetector(
              onTap: () {
                // callController.generateDummyCall();
                chatController.createCall();
              },
              child: Container(
                  // width: 20,
                  // height: 12,
                  child: const Icon(Icons.videocam,
                      color: AppColor.chatIconColor)),
            ),
            const SizedBox(width: 12)
          ]),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10.ss),
            child: Column(
              children: [
                chatController.chatRoomReferences == null
                    ? Text("Something went wrong")
                    : Expanded(
                        child: FirebaseAnimatedList(
                            query: chatController.chatRoomReferences!
                                .orderByChild("sentAt"),
                            controller: chatController.scrollController,
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom +
                                    55.ss),
                            itemBuilder: (ctx, snapshot, animation, indx) {
                              var snapshotVal = snapshot.value as Map;

                              var chatData = ChatMsgData(
                                  msg: snapshotVal['msg'],
                                  isReadByreceiver:
                                      snapshotVal['isReadByreceiver'],
                                  msgType: snapshotVal['msg_type'],
                                  receiverId: snapshotVal['receiverId'],
                                  sentAt: snapshotVal['sentAt'],
                                  senderId: snapshotVal['senderId']);

                              chatController.chatMsgList.add(chatData);
                              if (chatData.receiverId ==
                                  chatController.getCurrentUserId()) {
                                //if receiver  is equal to current user, then message is sent by other user
                                return receivedMsgLayout(chatData, indx);
                              } else {
                                return sentMsgLayout(chatData, indx);
                              }
                            })),
              ],
            ),
          ),
          Obx(
            () => chatController.msgTimeList.isNotEmpty
                ? Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      spreadRadius: 1)
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(chatController.msgTimeList.last))),
                  )
                : SizedBox(),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: sendButton(),
          )
        ],
      ),
    );
  }

  Widget receiverCircleLoader(
      {required String userName,
      required bool isOnline,
      required String pofileImageUrl}) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 34.ss,
              width: 34.ss,
              decoration: BoxDecoration(
                color: AppColor.appBarBackgroundColor,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      pofileImageUrl,
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 12.ss,
                width: 12.ss,
                // ignore: prefer_const_constructors
                // decoration: BoxDecoration(
                //     color: isOnline ? const Color(0xFF31B768) : Colors.red,
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: const Color(0xFFFFFFFF),
                //       width: 2.0,
                //     )),
                child: isOnline
                    ? Image.asset(
                        AppImage.online,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        AppImage.offline,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10.ss,
        ),
        SizedBox(
          width: 125.ss,
          child: Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.ss,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget sendButton() {
    return Column(
      children: [
        Container(
            color: AppColor.appBarBackgroundColor,
            height: 48,
            child: Row(
              children: [
                SizedBox(width: 16),
                //  "\u263a"
                GestureDetector(
                    onTap: () {
                      chatController.isEmojiDialougueVisible.value =
                          !chatController.isEmojiDialougueVisible.value;
                      if (chatController.isEmojiDialougueVisible.value) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child:
                        Obx(() => chatController.isEmojiDialougueVisible.value
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Apputil.getActiveColor(),
                                    borderRadius: BorderRadius.circular(20.ss)),
                                child: Image.asset(AppImage.emojiIcon),
                              )
                            : Text("😀",
                                style: TextStyle(
                                  color: AppColor.appColor,
                                )))),
                SizedBox(width: 20),
                Flexible(
                    child: CustomTextFormField(
                        controller: chatController.messageController,
                        isBordered: false,
                        labelTxt: "Type",
                        onChanged: (text) {
                          printRed(text);
                          if (text.trim().isNotEmpty) {
                            chatController.isMsgTextThere.value = true;
                          } else {
                            chatController.isMsgTextThere.value = false;
                          }
                        },
                        hintTxt: "Type")),

                Obx(
                  () => chatController.isMsgTextThere.value
                      ? IconButton(
                          onPressed: () {
                            chatController.sendChatMessage(
                                chatController.messageController.text,
                                changeFocus: () =>
                                    FocusScope.of(context).unfocus());
                          },
                          icon: Icon(Icons.send))
                      : SizedBox(),
                ),
                GestureDetector(
                    onTap: () {
                      chatController.showAttachmentOptions(context);
                    },
                    child: Material(child: Icon(Icons.attach_file, size: 18))),
                SizedBox(width: 27)
              ],
            )),
        emojiWindow()
      ],
    );
  }

  Column msgWidget(ChatData e) {
    return Column(
      children: [
        DummyTextMessage(
          dummyTxt: e.message!,
          isReply: e.receiverId == chatController.memeberId.value,
        ),
        SizedBox(height: 11),
      ],
    );
  }

  Widget sentMsgLayout(ChatMsgData chat, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 15.ss, left: 35.ss),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          showDateTime(chat, index),
          chat.msgType == MsgType.normal_text_msg.name
              ? DummyTextMessage(
                  dummyTxt: chat.msg!,
                  isReply: true,
                )
              : SizedBox(),
          chat.msgType == MsgType.image.name
              ? ShowImageMsg(
                  imgUrl: chat.msg!,
                  isReply: true,
                )
              : SizedBox(),
          chat.msgType == MsgType.document.name
              ? ShowDocumentMsg(
                  docUrl: chat.msg!,
                  isReply: true,
                )
              : SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (chat.isReadByreceiver ?? false)
                  ? Icon(
                      Icons.check,
                      color: Apputil.getActiveColor(),
                      size: 15,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.grey,
                      size: 15,
                    ),
              Text(
                chatController.timeString(chat.sentAt ?? ""),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 11),
        ],
      ),
    );
  }

  Widget receivedMsgLayout(ChatMsgData chatData, int index) {
    if (chatData.isReadByreceiver == false) {
      //that means the message isn't marked as read
      chatController.markMessageAsRead(chatData);
    }
    return Padding(
      padding: EdgeInsets.only(left: 15.ss, right: 35.ss),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showDateTime(chatData, index),
          chatData.msgType == MsgType.normal_text_msg.name
              ? DummyTextMessage(
                  dummyTxt: chatData.msg!,
                  isReply: false,
                )
              : SizedBox(),
          chatData.msgType == MsgType.image.name
              ? ShowImageMsg(
                  imgUrl: chatData.msg!,
                  isReply: false,
                )
              : SizedBox(),
          chatData.msgType == MsgType.document.name
              ? ShowDocumentMsg(
                  docUrl: chatData.msg!,
                  isReply: false,
                )
              : SizedBox(),
          Text(
            chatController.timeString(chatData.sentAt ?? ""),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 11),
        ],
      ),
    );
  }

  Widget showDateTime(ChatMsgData chatData, int index) {
    var yearTimeString = chatController.yearDateString(chatData.sentAt ?? "");
    var previousYearTimeString = index == 0
        ? null
        : chatController
            .yearDateString(chatController.chatMsgList[index - 1].sentAt ?? "");
    bool isYearTimeDifferentThatEarlierOne = previousYearTimeString == null
        ? true
        : previousYearTimeString != yearTimeString;
    if (index == 0) {
      return VisibilityDetector(
        key: Key('${chatData.msg}-${chatData.sentAt ?? "-"}'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage == 0.0) {
            //add item inside msgTimeList
            chatController.msgTimeList.add(yearTimeString);
          } else {
            //remove item from msgTimeList
            if (chatController.msgTimeList.contains(yearTimeString)) {
              chatController.msgTimeList.remove(yearTimeString);
            }
          }
          printRed(
              'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
        },
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(yearTimeString),
            )),
      );
    } else {
      return isYearTimeDifferentThatEarlierOne
          ? VisibilityDetector(
              key: Key('${chatData.msg}-${chatData.sentAt ?? "-"}'),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                if (visiblePercentage == 0.0) {
                  //add item inside msgTimeList
                  if (chatController
                          .scrollController.position.userScrollDirection ==
                      ScrollDirection.forward) {
                    printRed("Scroller going upward");
                    //this condition is raerly called
                  } else {
                    printRed("Scroller going downward");
                    chatController.msgTimeList.add(yearTimeString);
                  }
                } else {
                  //remove item from msgTimeList
                  if (chatController.msgTimeList.contains(yearTimeString)) {
                    chatController.msgTimeList.remove(yearTimeString);
                  }
                }
                printRed(
                    'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
              },
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(yearTimeString),
                  )),
            )
          : SizedBox();
    }
  }

  Widget emojiWindow() {
    return Obx(() => chatController.isEmojiDialougueVisible.value
        ? SizedBox(
            height: 200.ss,
            child: EmojiPicker(
              onEmojiSelected: (Category? category, Emoji emoji) {
                // Do something when emoji is tapped (optional)
                chatController.isMsgTextThere.value = true;
              },
              onBackspacePressed: () {
                // Do something when the user taps the backspace button (optional)
                // Set it to null to hide the Backspace-Button
              },
              textEditingController: chatController
                  .messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
              config: Config(
                columns: 5,
                emojiSizeMax: 32 *
                    (foundation.defaultTargetPlatform == TargetPlatform.iOS
                        ? 1.30
                        : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Colors.white,
                indicatorColor: Colors.white,
                iconColor: Colors.grey,
                iconColorSelected: Colors.white,
                backspaceColor: Colors.white,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,

                recentsLimit: 28,
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ), // Needs to be const Widget
                loadingIndicator:
                    const SizedBox.shrink(), // Needs to be const Widget
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          )
        : const SizedBox());
  }
}

class DummyTextMessage extends StatelessWidget {
  const DummyTextMessage(
      {super.key, required this.dummyTxt, this.isReply = false});
  final String dummyTxt;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    print("$dummyTxt - $isReply");
    return Padding(
      padding: EdgeInsets.only(left: (isReply ? 16 : 0)),
      child: Container(
          decoration: BoxDecoration(
              color: isReply ? AppColor.chatMsgColor : AppColor.appColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(dummyTxt,
              style: TextStyle(
                  fontSize: 14,
                  color: isReply ? AppColor.chatMsgFontColor : Colors.white))),
    );
  }
}
