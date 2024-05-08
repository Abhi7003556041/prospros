import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prospros/Service/CoreService.dart';
import 'package:prospros/Service/Url.dart';
import 'package:prospros/Service/chatService.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/call_controller.dart';
import 'package:prospros/controller/home_controller.dart';
import 'package:prospros/model/ChatCommMemListResponse/ChatCommMemListResponse.dart';
import 'package:prospros/model/chat/agora_token_res.dart';
import 'package:prospros/model/chat/call_document.dart';
import 'package:prospros/model/chat/chat_message.dart';
import 'package:prospros/model/chat/file_upload_res_model.dart';
import 'package:prospros/model/chat_history_model/chat_history_response_model.dart';
import 'package:prospros/constants/agora_configs.dart';
import 'package:prospros/model/login/login_response_model.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/call/video_call_ui_v2.dart';
import 'package:sizing/sizing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  // var isSendChatRequest = false.obs;
  // var hasChatMessageSend = false.obs;
  var isChatHistoryLoaded = false.obs;
  var isMemebersLoaded = false.obs;
  final HomeController homeController = Get.find();
  var isEmojiDialougueVisible = false.obs;
  var chatList = <ChatMsgData>[].obs;

  ///followings are used to show receiver profile details on chat_screen appBar
  var name = "".obs;
  var profileImg = "".obs;
  var memeberId = 0.obs;

  ///used to toogle sendMsg icon on chat_screen.dart
  var isMsgTextThere = false.obs;

  /// whenever a year-time string widget is invisible that particular item will be pushed inside this list;And when visible it will be popped from list
  /// this is used to display year-time screen using overlay
  var msgTimeList = [].obs;

  ///this is update from chat_screen.dart's Streambuilder [ declared inside appBar()  ]
  var isReceiverOnline = false.obs;

  // SendChatRequestResponseModel? sendChatRequestResponseModel;
  // SendChatMessageResponseModel? sendChatMessageResponseModel;
  ChatHistoryResponseModel? chatHistoryResponseModel;

  String? _messageContent, _chatId;
  final List<String> _logText = [];
  ChatCommMemListResponse? chatCommMemListResponse;
  final ChatService chatService = Get.find();
  final CallController callController = Get.find();

  ///Receivers server-user-id
  late String _receiverId;

  ///this reference will be used to retrive messages from particlar chat room
  DatabaseReference? chatRoomReferences;

  ///sender or current user details
  LoginResponseModel? _senderDetails;
  var chatMsgList = <ChatMsgData>[].obs;

  var roomId = "".obs;
  var receiverId = (-1).obs;
  var filePath = "".obs;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  onInit() {
    super.onInit();
    chatCommunityMemeberList();
  }

  enableSendButton(String text) {
    printRed("Msg Text is being listednd");
    if (text.isEmpty) {
      isMsgTextThere.value = false;
    } else {
      isMsgTextThere.value = true;
    }
  }

  ///get firebase-user-id of current user or sender
  String getCurrentUserId() {
    return chatService.getFirebaseUserId(
        _senderDetails!.data!.personalDetails!.userDetails!.id!.toString());
  }

  DatabaseReference receiverDocumentRef() {
    return chatService
        .userDocumentRef(chatService.getFirebaseUserId(_receiverId));
  }

  Future<void> initializeChatSession({required String receiverId}) async {
    //remove all previous chat messages
    chatMsgList.clear();
    _receiverId = receiverId;
    _senderDetails = Apputil.getUserProfile();
    chatRoomReferences =
        await chatService.chatDocumentRef(receiverId: _receiverId);
    chatRoomReferences?.onValue.listen((event) async {
      if (scrollController.hasClients) {
        await scrollController.animateTo(
            scrollController.position.maxScrollExtent + 55,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    });
  }

  Future<void> loadChatMessages() async {
    if (chatRoomReferences != null) {
      ///This way isn't accessing correct value set
      ///
      ///
      // FirebaseDatabase.instance
      //     .ref("/chat_lists/pros_user130__pros_user3/")
      //     .orderByChild("sentAt")
      //     .once()
      //     .asStream()
      //     .listen((event) {
      //   var data = event.snapshot.value.toString();
      //   printRed(data);
      // });

      // chatRoomReferences!.orderByKey().once().then((value) {
      //   printAmber(value.snapshot.ref.path);
      //   printRed(value.snapshot.value.toString());
      //   var data = value.snapshot.value as Map;
      //   data.keys.forEach((key) {
      //     var chatData = ChatMsgData(
      //         id: key,
      //         msg: data[key]['msg'],
      //         isReadByreceiver: data[key]['isReadByreceiver'],
      //         msgType: data[key]['msgType'],
      //         receiverId: data[key]['receiverId'],
      //         sentAt: data[key]['sentAt'],
      //         senderId: data[key]['senderId']);
      //     chatMsgList.add(chatData);
      //   });
      // });
      // await chatRoomReferences!.get().then((value) {
      //   printRed(value!.ref.path.toString());
      //   printRed(value.value);

      //   var data = value.value as Map;
      //   data.keys.forEach((key) {
      //     // var chatData = ChatData.fromJson(data[key] as Map<String, dynamic>);
      //     var chatData = ChatMsgData(
      //         id: key,
      //         msg: data[key]['msg'],
      //         isReadByreceiver: data[key]['isReadByreceiver'],
      //         msgType: data[key]['msgType'],
      //         receiverId: data[key]['receiverId'],
      //         sentAt: data[key]['sentAt'].toString(),
      //         senderId: data[key]['senderId']);
      //     chatMsgList.add(chatData);
      //   });
      // });
      Future.delayed(Duration(seconds: 1), () async {
        if (scrollController.hasClients) {
          await scrollController.animateTo(
              scrollController.position.maxScrollExtent + 55,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      });
    }
  }

//YET TO IMPLEMENT & TEST
  sendChatRequest(int requestId) async {
    // isSendChatRequest.value = true;

    // try {
    //   final model = {"receive_request_id": requestId};
    //   var response = await CoreService().apiService(
    //       baseURL: Url.baseUrl,
    //       body: model,
    //       method: METHOD.POST,
    //       header: {
    //         'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
    //       },
    //       endpoint: Url.sendChatRequest);

    //   print("send Chat Request ==============");
    //   log(response.toString());

    //   sendChatRequestResponseModel =
    //       SendChatRequestResponseModel.fromJson(response);

    //   if (sendChatRequestResponseModel!.success!) {
    //     isSendChatRequest.value = false;
    //     Get.showSnackbar(GetSnackBar(
    //         message: sendChatRequestResponseModel?.message ?? "Server Error",
    //         snackPosition: SnackPosition.BOTTOM,
    //         duration: Duration(seconds: 2),
    //         margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    //   } else {
    //     Get.closeAllSnackbars();
    //     isSendChatRequest.value = false;
    //     Get.showSnackbar(GetSnackBar(
    //         message: sendChatRequestResponseModel?.message ?? "Server Error",
    //         snackPosition: SnackPosition.BOTTOM,
    //         duration: Duration(seconds: 2),
    //         margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    //   }
    // } catch (e) {
    //   Get.closeAllSnackbars();
    //   isSendChatRequest.value = false;
    //   Get.showSnackbar(GetSnackBar(
    //       message: "Server Error",
    //       snackPosition: SnackPosition.BOTTOM,
    //       duration: Duration(seconds: 2),
    //       margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    // }
  }

  sendChatMessage(String message, {required Function changeFocus}) async {
    await chatService.sendMessage(
      receiverId: _receiverId,
      msg: message,
    );

    isMsgTextThere.value = false;
    messageController.clear();
    changeFocus();
    isEmojiDialougueVisible.value = false;
  }

  String timeString(String timestamp) {
    return Apputil.timeStampTotime(timestamp);
  }

  String yearDateString(String timestamp) {
    return Apputil.timeStampToYearDate(timestamp);
  }

  // //YET TO IMPLEMENT & TEST
  // chatHistory(String roomId) async {
  //   isChatHistoryLoaded.value = true;

  //   try {
  //     var response = await CoreService().apiService(
  //         baseURL: Url.baseUrl,
  //         method: METHOD.POST,
  //         body: {
  //           "room_id": roomId,
  //         },
  //         header: {
  //           'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
  //         },
  //         endpoint: Url.chatHistory);

  //     print("sendChatMessage ==============");
  //     log(response.toString());

  //     chatHistoryResponseModel = ChatHistoryResponseModel.fromJson(response);

  //     if (chatHistoryResponseModel!.success!) {
  //       isChatHistoryLoaded.value = false;
  //     } else {
  //       Get.closeAllSnackbars();
  //       isChatHistoryLoaded.value = false;
  //       Get.showSnackbar(GetSnackBar(
  //           message: chatHistoryResponseModel!.message,
  //           snackPosition: SnackPosition.BOTTOM,
  //           duration: Duration(seconds: 2),
  //           margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
  //     }
  //   } catch (e) {
  //     Get.closeAllSnackbars();
  //     isChatHistoryLoaded.value = false;
  //     Get.showSnackbar(GetSnackBar(
  //         message: chatHistoryResponseModel!.message,
  //         snackPosition: SnackPosition.BOTTOM,
  //         duration: Duration(seconds: 2),
  //         margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
  //   }
  // }

  void _initSDK() async {
    ///It's redundant in current context , it was implemented for agora chat sdk
    // ChatOptions options = ChatOptions(
    //   appKey: AgoraChatConfig.appKey,
    //   autoLogin: false,
    // );
    // await ChatClient.getInstance.init(options);
    // // Notify the SDK that the UI is ready. After the following method is executed, callbacks within `ChatRoomEventHandler`, ` ChatContactEventHandler`, and `ChatGroupEventHandler` can be triggered.
    // await ChatClient.getInstance.startCallback();
  }

  // void _signIn() async {
  //   try {
  //     await ChatClient.getInstance.loginWithAgoraToken(
  //       AgoraChatConfig.userId,
  //       AgoraChatConfig.agoraToken,
  //     );
  //     _addLogToConsole("login succeed, userId: ${AgoraChatConfig.userId}");
  //   } on ChatError catch (e) {
  //     _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
  //   }
  // }

  // void _signOut() async {
  //   try {
  //     await ChatClient.getInstance.logout(true);
  //     _addLogToConsole("sign out succeed");
  //   } on ChatError catch (e) {
  //     _addLogToConsole(
  //         "sign out failed, code: ${e.code}, desc: ${e.description}");
  //   }
  // }

  // void _sendMessage() async {
  //   if (_chatId == null || _messageContent == null) {
  //     _addLogToConsole("single chat id or message content is null");
  //     return;
  //   }

  //   var msg = ChatMessage.createTxtSendMessage(
  //     targetId: _chatId!,
  //     content: _messageContent!,
  //   );

  //   ChatClient.getInstance.chatManager.sendMessage(msg);
  // }

  // void _addLogToConsole(String log) {
  //   _logText.add(_timeString + ": " + log);

  //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
  // }

  // void onMessagesReceived(List<ChatMessage> messages) {
  //   for (var msg in messages) {
  //     switch (msg.body.type) {
  //       case MessageType.TXT:
  //         {
  //           ChatTextMessageBody body = msg.body as ChatTextMessageBody;
  //           _addLogToConsole(
  //             "receive text message: ${body.content}, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.IMAGE:
  //         {
  //           _addLogToConsole(
  //             "receive image message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.VIDEO:
  //         {
  //           _addLogToConsole(
  //             "receive video message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.LOCATION:
  //         {
  //           _addLogToConsole(
  //             "receive location message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.VOICE:
  //         {
  //           _addLogToConsole(
  //             "receive voice message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.FILE:
  //         {
  //           _addLogToConsole(
  //             "receive image message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.CUSTOM:
  //         {
  //           _addLogToConsole(
  //             "receive custom message, from: ${msg.from}",
  //           );
  //         }
  //         break;
  //       case MessageType.CMD:
  //         {
  //           // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
  //         }
  //         break;
  //     }
  //   }
  // }

  // void _addChatListener() {
  //   ChatClient.getInstance.chatManager.addMessageEvent(
  //       "UNIQUE_HANDLER_ID",
  //       ChatMessageEvent(
  //         onSuccess: (msgId, msg) {
  //           _addLogToConsole("send message succeed");
  //         },
  //         onProgress: (msgId, progress) {
  //           _addLogToConsole("send message succeed");
  //         },
  //         onError: (msgId, msg, error) {
  //           _addLogToConsole(
  //             "send message failed, code: ${error.code}, desc: ${error.description}",
  //           );
  //         },
  //       ));

  //   ChatClient.getInstance.chatManager.addEventHandler(
  //     "UNIQUE_HANDLER_ID",
  //     ChatEventHandler(onMessagesReceived: onMessagesReceived),
  //   );
  // }

  markMessageAsRead(ChatMsgData chatData) async {
    await chatService.updateMsgReadingStatus(
        chatData: chatData, server_receiver_id: _receiverId);
  }

  chatCommunityMemeberList() async {
    isMemebersLoaded.value = true;

    try {
      var response = await CoreService().apiService(
          baseURL: Url.baseUrl,
          method: METHOD.POST,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          endpoint: Url.chatMemberList);

      print("chatCommunityMemeberList ==============");
      log(response.toString());

      chatCommMemListResponse = ChatCommMemListResponse.fromJson(response);
      if (chatCommMemListResponse!.success!) {
        isMemebersLoaded.value = false;
      } else {
        Get.closeAllSnackbars();
        isMemebersLoaded.value = false;
        Get.showSnackbar(GetSnackBar(
            message: chatCommMemListResponse!.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (e) {
      Get.closeAllSnackbars();
      isMemebersLoaded.value = false;
      Get.showSnackbar(GetSnackBar(
          message: chatCommMemListResponse!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  showAttachmentOptions(context) async {
    showGeneralDialog(
      barrierLabel: "Select an option",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Apputil.getActiveColor(),
                              child: Icon(Icons.image)),
                          Text(
                            "Image",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickDocument();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Apputil.getActiveColor(),
                              child: Icon(Icons.picture_as_pdf_outlined)),
                          Text(
                            "Document",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.ss),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(20, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
    return;
  }

  void pickImage() async {
    await selectImage();

    if (filePath.value.isNotEmpty) {
      //file has been picked
      Apputil.showProgressDialouge();
      String? imagePath = await uploadImage();
      if (imagePath == null) {
        Apputil.closeProgressDialouge();
      } else {
        await chatService.sendMessage(
            receiverId: _receiverId, msg: imagePath, msgType: MsgType.image);
        filePath.value = "";
      }
      Apputil.closeProgressDialouge();
    }
  }

  void pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      printRed("File Size : ${result.files.single.size}");
      var fileInMB = result.files.single.size * 0.000001;

      if (fileInMB > 0 && fileInMB < 20) {
        printRed("File In Mb : ${fileInMB}. UPLOAD FILE");
        File file = File(result.files.single.path!);

        String? fileUrl = await uploadDoc(file.path);
        if (fileUrl != null) {
          await chatService.sendMessage(
              receiverId: _receiverId, msg: fileUrl, msgType: MsgType.document);
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "File is too larze.",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } else {
      // User canceled the picker
    }
  }

  Future<String?> uploadImage() async {
    try {
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.fileUploadUrl,
        filePath: filePath,
        fileKey: "files[]",
      );

      if (result != null) {
        final profileResponseModel = FileUploadRes.fromJson(result);
        print("profilePictureUpdate=================");
        log(result.toString());

        if (profileResponseModel.success ?? false) {
          return profileResponseModel.data?.first ?? null;
        } else {
          return null;
        }
      }
    } catch (e) {
      Apputil.closeProgressDialouge();
      Get.showSnackbar(GetSnackBar(
          message: "Image couldn't uploaded.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return null;
    }
  }

  Future<String?> uploadDoc(String filePath) async {
    try {
      var result = await CoreService().apiService(
        baseURL: Url.baseUrl,
        header: {
          'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
        },
        method: METHOD.MULTIPART,
        multiPart: true,
        endpoint: Url.fileUploadUrl,
        filePath: filePath,
        fileKey: "files[]",
      );

      if (result != null) {
        final profileResponseModel = FileUploadRes.fromJson(result);
        print("profilePictureUpdate=================");
        log(result.toString());

        if (profileResponseModel.success ?? false) {
          return profileResponseModel.data?.first ?? null;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print(image.path);
        filePath.value = image.path;
      }
    } catch (err) {
      if (err.toString().contains("photo_access_denied")) {
        Get.showSnackbar(GetSnackBar(
            message:
                "You haven't granted access to photos. Please grant access from settings",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    }
  }

  createCall({bool isAudio = false}) async {
    if (!isReceiverOnline.value) {
      Get.showSnackbar(GetSnackBar(
          message: "Receiver isn't available to receive call.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      return;
    }
    try {
      var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      Apputil.showProgressDialouge();
      var agoraTokenRes = await getAgoraToken(
          channelName: timestamp,
          receiverId: _receiverId,
          callerId: _senderDetails!.data!.personalDetails!.userDetails!.id!
              .toString());
      Apputil.closeProgressDialouge();

      printRed("++${agoraTokenRes?.toJson()}");
      if (agoraTokenRes != null) {
        var receiverData = await chatService
            .getFirebaseUserDetails(chatService.getFirebaseUserId(_receiverId));
        printRed(receiverData?.toJson());
        if (receiverData != null) {
          var receiverToken = agoraTokenRes.data!
              .firstWhereOrNull((element) => element.userId! == _receiverId)!
              .token;

          var callerToken = agoraTokenRes.data!
              .firstWhereOrNull((element) =>
                  element.userId! ==
                  _senderDetails!.data!.personalDetails!.userDetails!.id!
                      .toString())!
              .token;

          var callDoc = CallDocument(
              // callToken: AgoraVideoCallConfig.tempToken,
              callType: isAudio ? "audio" : "video",
              channelId: timestamp,
              agoraAppId: AgoraVideoCallConfig.appId,
              callerCallToken: callerToken!,
              receiverCallToken: receiverToken!,
              timestamp: timestamp,
              reciverId: int.tryParse(_receiverId) ?? 0,
              callerName:
                  _senderDetails?.data?.personalDetails?.userDetails?.name,
              callerProfileImage: _senderDetails
                  ?.data?.personalDetails?.userDetails?.profilePicture,
              reciverFirebaseId: chatService.getFirebaseUserId(_receiverId),
              callerFirebaseId: chatService.getFirebaseUserId(_senderDetails!
                  .data!.personalDetails!.userDetails!.id!
                  .toString()));
          printGreen(callDoc.toJson());
          Apputil.showProgressDialouge();
          await callController.createCall(callDocument: callDoc);

          Apputil.closeProgressDialouge();

          Get.to(() => VideoCallUIV2(
                channelName: timestamp,
                agoraAppID: AgoraVideoCallConfig.appId,
                userId: _senderDetails!.data!.personalDetails!.userDetails!.id!,
                userName: receiverData.name ?? "--",
                userProfileImage: receiverData.profileUrl ?? "--",
                token: callerToken,
                createByPushingRoute: true,
                isAudioCall: isAudio,
              ));
        } else {
          Get.showSnackbar(GetSnackBar(
              message: "Call couldn't be completed.",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
        }
      } else {
        Get.showSnackbar(GetSnackBar(
            message: "Call token couldn't generated.",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
      }
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
          message: "Call couldn't be completed. ${err.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  ///GENERATES AGORA TOKEN FOR EACH USER BY COMBINIG USER-ID WITH CHANNEL-NAME
  ///
  ///receiverId : must be server-user-id; should be covertable to int
  ///
  ///callerId : must be server-user-id; should be covertable to int
  Future<AgoraTokenRes?> getAgoraToken({
    required String channelName,
    required String receiverId,
    required String callerId,
  }) async {
    try {
      var result = await CoreService().apiService(
          baseURL: Url.baseUrl,
          header: {
            'Authorization': 'Bearer  ${HiveStore().get(Keys.accessToken)}'
          },
          method: METHOD.POST,
          endpoint: Url.agoraToken,
          body: {
            "channelName": channelName,
            "uid": receiverId,
            "uidStr": callerId
          });

      if (result != null) {
        final agoraTokenRes = AgoraTokenRes.fromJson(result);
        print("profilePictureUpdate=================");
        log(result.toString());

        if (agoraTokenRes.success ?? false) {
          return agoraTokenRes;
        } else {
          return null;
        }
      }
    } catch (e) {
      printRed(e.toString());
      return null;
    }
  }

  notifiyReceiver() {}

  //METHOD TO UPLOAD IMAGE TO THE STORAGE
  // Future<void> sendNotification(String msgFilePath) async {
  //   await Future.delayed(Duration(seconds: 30));
  //   // var chatMsgRef = FirebaseDatabase.instance.ref(msgFilePath);
  // }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    isEmojiDialougueVisible.value = false;
    super.onClose();
  }
}

@pragma('vm:entry-point')
void sendNotification(Map vals) async {
  printRed("Isolate spawned");
  // BackgroundIsolateBinaryMessenger.ensureInitialized(vals['rootIsolateToken']);
  // await Future.delayed(Duration(seconds: 2));

  // await Firebase.initializeApp();
  // // FirebaseDatabase.instanceFor(app: Firebase.app("go-pros-app"))
  // FirebaseDatabase.instance
  //     .ref(vals['messageDocPath'])
  //     .get()
  //     .then((value) async {
  //   if (value.exists) {
  //     var data = value.value as Map;
  //     if (data['isReadByreceiver'] == false) {
  //       final String serverKey =
  //           'AAAAZq6DTkY:APA91bF8suTMeYI_7WhlQkpdjDNmVXeZt7PtnJ3oyPYr4bQYiX8DsEn9cfsQxSceHd_Eu58tm1kPtROPZ24oN5fTzvf1gj_t16pOpBJsXa6BoU4IZA9NEU-sLDTAzDa1IRkj_8Dh1z4z';
  //       final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
  //       final String deviceToken = vals['fcmVal'];

  //       final Map<String, dynamic> notification = {
  //         'title': 'Notification Title',
  //         'body': 'Notification Body',
  //       };

  //       final Map<String, dynamic> data = {
  //         'key1': 'value1',
  //         'key2': 'value2',
  //       };

  //       final Map<String, dynamic> message = {
  //         'notification': notification,
  //         'data': data,
  //         'token': deviceToken,
  //       };

  //       final headers = {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$serverKey',
  //       };

  //       final response = await http.post(
  //         Uri.parse(fcmEndpoint),
  //         headers: headers,
  //         body: jsonEncode({
  //           "to": "${deviceToken}",
  //           "notification": {
  //             "body": "Body of Your Notification",
  //             "title": "Title of Your Notification"
  //           }
  //         }),
  //       );

  //       if (response.statusCode == 200) {
  //         print('Notification sent successfully.');
  //       } else {
  //         print('Failed to send notification. Error: ${response.body}');
  //       }
  //     }
  //   }
  // });

  printRed(
      "https://www.dev17.ivantechnology.in/doubtanddiscussion/api/user/send-chat-message");

  printRed({
    "room_id": vals['room_id'],
    "receiver_id": vals['receiver_id'],
    "message": vals['message'],
  }.toString());

  final response = await http.post(
    Uri.parse(
        "https://www.dev17.ivantechnology.in/doubtanddiscussion/api/user/send-chat-message"),
    headers: {"Authorization": "Bearer ${vals['auth_token']}"},
    body: {
      "room_id": vals['room_id'],
      "receiver_id": vals['receiver_id'],
      "message": vals['message'],
    },
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully.');
  } else {
    print('Failed to send notification. Error: ${response.body}');
  }
}
