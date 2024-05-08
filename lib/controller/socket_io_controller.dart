// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:prospros/Service/CoreService.dart';
// import 'package:prospros/Store/HiveStore.dart';
// import 'package:socket_io_client_flutter/socket_io_client_flutter.dart' as IO;
// import 'package:socket_io_client_flutter/socket_io_client_flutter.dart';

// import '../../Models/DefaultModels/MessageModel/MessageModel.dart';
// import '../Service/Url.dart';

// class SocketIOController extends GetxController {
//   late IO.Socket socket;
//   TextEditingController? messageInputController;
//   Map<String, dynamic> users = <String, dynamic>{}.obs;
//   var messageList = <Message>[].obs;
//   ScrollController scrollController = ScrollController();

//   final url = Url.baseUrl;
//   final path = "/endsuicide/chat_server/socket.io";
//   final dynamic uri = Uri(
//       scheme: 'https',
//       host: Url.baseUrl,
//       path: '/endsuicide/chat_server/socket.io');

//   late bool isOPCuser;
//   late String incidentId;
//   late String helpSeekerId;
//   late String helpfulUserId;
//   bool isChatRequestSent = false;
//   late MessageReceiverDetails messageReceiverDetails;
//   var receiverName = "".obs;
//   var receiverProfileImageUrl = "".obs;
//   var receiverOnlineStatus = 0.obs;
//   String chatRoomId = ""; //initially it will be ""
//   String messageSenderName = "";
//   IsChatHistoryLoaded isChatHistoryLoaded = IsChatHistoryLoaded.init;

//   @override
//   void onInit() {
//     messageInputController = TextEditingController();
//     try {
//       isOPCuser = Get.arguments[0];
//     } catch (err) {
//       debugPrint(
//           "##################ISOPC ISN't PROVIDED######################");
//     }
//     try {
//       incidentId = Get.arguments[1] ?? "";
//     } catch (err) {
//       debugPrint(
//           "##################INCIDENT ISN't PROVIDED######################");
//     }
//     try {
//       helpSeekerId = Get.arguments[2] ?? "";
//     } catch (err) {
//       debugPrint(
//           "##################HELPSEEKER ISN't PROVIDED######################");
//     }
//     try {
//       messageReceiverDetails = Get.arguments[3];
//     } catch (err) {
//       debugPrint(
//           "##################MESSAGE RECEIVER DETAILS ISN't PROVIDED######################");
//     }

//     receiverName.value = messageReceiverDetails.user!.name!;
//     receiverProfileImageUrl.value =
//         messageReceiverDetails.user!.profileImagePath ?? "";
//     receiverOnlineStatus.value = messageReceiverDetails.user?.isLoggedIn ?? 0;
//     try {
//       chatRoomId = Get.arguments[4];
//     } catch (err) {
//       debugPrint(
//           "##################CHAT ROOM ID ISN't PROVIDED######################");
//     }

//     try {
//       helpfulUserId = Get.arguments[5];
//     } catch (err) {
//       debugPrint(
//           "##################HELPFUL user ID ISN't PROVIDED######################");
//     }
//     try {
//       messageSenderName = Get.arguments[6];
//     } catch (err) {
//       debugPrint(
//           "##################MESSAGE SENDER NAME ISN't PROVIDED######################");
//     }

//     super.onInit();

//     socket = IO.io(
//         'https://' + Url.baseUrl,
//         //'https://dev14.ivantechnology.in',
//         OptionBuilder()
//             .enableForceNewConnection()
//             .setPath("/endsuicide/chat_server/socket.io")
//             .setTransports(['polling', 'websocket']).build());

//     debugPrint(socket.io.uri);

//     Future.delayed(const Duration(milliseconds: 200), () {
//       loadChatHistoryData();
//     });
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     socket.emit("unsubscribe", chatRoomId);
//     socket.disconnect();
//     socket.dispose();
//     messageInputController?.dispose();
//     debugPrint('Socket disposed........');
//   }

//   _connectSocket() {
//     socket.onConnect((data) {
//       debugPrint('Connection established ${socket.io.engine?.path.toString()}');
//       _joinWithRoomId(chatRoomId);
//     });
//     socket.onConnectError(
//         (data) => debugPrint('Connect Error: ${data.toString()}'));
//     socket.onDisconnect((data) => debugPrint('Socket.IO server disconnected'));

//     socket.on("new_message", (data) {
//       print("📢 new_message event >> ${data.toString()}");
//       final username = socket.id.toString();

//       messageList.value.add(Message(
//           message: data["message"],
//           senderUsername: messageSenderName,
//           sentAt: DateTime.now(),
//           isReceivedMsg: data['name'] == messageSenderName ? false : true));
//       messageList.refresh();
//       update();

//       scrollController.jumpTo(scrollController.position.maxScrollExtent +
//           MediaQuery.of(Get.context!).viewPadding.bottom);
//     });
//     _joinWithRoomId(chatRoomId);

//     // socket.on('new_message', (data) {
//     //   debugPrint('User List ${data.toString()}');
//     //   debugPrint(data.runtimeType.toString());
//     //   users = data;
//     //   debugPrint(data.toString());
//     //   debugPrint('USER: ${users.toString()}');
//     // });
//   }

//   _joinWithRoomId(String? roomId) {
//     socket.emit("subscribe", roomId);
//   }

//   sendMessage() async {
//     if (!isChatRequestSent && isOPCuser) {
//       var chatRequestRes = await sendChatRequestApiCall();
//       if (chatRequestRes != null && chatRequestRes.status == "success") {
//         isChatRequestSent = true;
//         if (chatRequestRes.data?.helpRoomId == null) {
//           debugPrint(
//               "######################ROOM ID NOT PROVIDED INSIDE CHAT REQUEST API CALL################################");
//         } else {
//           chatRoomId = chatRequestRes.data!.helpRoomId!;
//           helpfulUserId = chatRequestRes.data!.helpfulUserId!;
//           helpSeekerId = chatRequestRes.data!.helpSeekerUserId!;
//           _joinWithRoomId(chatRequestRes.data!.helpRoomId);
//         }

//         if (chatRequestRes.message != "Chat request already sent") {
//           //call chat History api and add data one by one
//         }
//       } else {
//         isChatRequestSent = false;
//       }
//     }
//     if (messageInputController?.text != null &&
//         (messageInputController?.text.length)! > 0) {
//       final msg.Message message = msg.Message(
//         helpSeekerUserId: helpSeekerId,
//         helpfulUserId: helpfulUserId,
//         incidentId: incidentId,
//         name: messageSenderName,
//         roomid: chatRoomId,
//         senderId: isOPCuser ? helpfulUserId : helpSeekerId,
//         avatar:
//             "http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcSlnBjZZUlFjaTi4CZ049gOQq-zAkM18J3-MRkGf8NnCwPJyGncu4M68e7cT4iqCySkh--_YS9xGZ6xT-M",
//         message: messageInputController?.text ?? "",
//       );

//       var encodedMsg = json.encode(message.toJson());
//       debugPrint(encodedMsg);
//       _joinWithRoomId(chatRoomId);
//       socket.emit('send', message.toJson());
//       // socket.send([
//       //   jsonEncode({
//       //     "message": message,
//       //     "username": username, // Need to replace with the user name
//       //     "sentAt": dateTime.toString(),
//       //   })
//       // ]);

//       // final username = socket.id.toString(); //'Atanu';
//       // final dateTime = DateTime.now();
//       // messageList.add(Message(
//       //   message: messageInputController?.text ?? "",
//       //   senderUsername: username,
//       //   sentAt: dateTime,
//       // ));

//       messageInputController?.text = '';
//     }
//   }

//   Future<ChatRequestApiResponse?> sendChatRequestApiCall() async {
//     Get.dialog(
//       Center(
//           child: Container(
//               height: ScreenConstant.sizeXXL,
//               width: ScreenConstant.sizeXXL,
//               decoration: BoxDecoration(
//                   color: Color(0xFF000000),
//                   border: Border.all(
//                     color: Color(0xFF000000),
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(40))),
//               child: const Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 1.5,
//                 ),
//               ))),
//       barrierDismissible: false,
//     );
//     HeaderModel headerModel = HeaderModel(
//       token: HiveStore().get(
//         Keys.accessToken,
//       ),
//     );
//     NotificationListSendModel model = NotificationListSendModel(pageno: 1);
//     if (incidentId != "" && helpSeekerId != "") {
//       var result = await CoreService().apiService(
//         baseURL: Url.baseUrl,
//         header: headerModel.toHeader(),
//         body: {
//           "incident_id": incidentId,
//           "help_seeker_user_id": helpSeekerId,
//           "message": messageInputController?.text ?? "How may i help you",
//         },
//         method: METHOD.POST,
//         endpoint: sendchatRequest,
//       );
//       Get.back();
//       return ChatRequestApiResponse.fromJson(result);
//     } else {
//       debugPrint(
//           "##################INCIDENT ID OR HELPSEEKER ID ISN'T PROVIDED###########################");
//       return null;
//     }
//   }

//   loadChatHistoryData() async {
//     Get.dialog(
//       Center(
//           child: Container(
//               height: ScreenConstant.sizeXXL,
//               width: ScreenConstant.sizeXXL,
//               decoration: BoxDecoration(
//                   color: Color(0xFF000000),
//                   border: Border.all(
//                     color: Color(0xFF000000),
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(40))),
//               child: const Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 1.5,
//                 ),
//               ))),
//       barrierDismissible: false,
//     );
//     try {
//       var chatHistoryData = await chatHistoryApiCall();
//       if (chatHistoryData != null && chatHistoryData.status == "success") {
//         debugPrint(
//             "################ ChatHistory data loaded ####################");
//         isChatHistoryLoaded = IsChatHistoryLoaded.yes;
//         chatHistoryData.data?.docs?.forEach((msg) {
//           debugPrint(
//               "################ MESSAGE LOADED BY HELPFUL_USER : ${msg.senderUserDet!.sId == helpfulUserId ? true : false} ####################");
//           messageList.value.add(Message(
//               message: msg.message ?? "",
//               senderUsername: msg.senderUserDet!.name!,
//               sentAt: DateTime.now(),
//               isReceivedMsg: isOPCuser
//                   ? msg.senderUserDet!.sId == helpfulUserId
//                       ? false
//                       : true
//                   : msg.senderUserDet!.sId == helpSeekerId
//                       ? false
//                       : true));
//           messageList.refresh();
//           update();
//         });

//         scrollController.jumpTo(scrollController.position.maxScrollExtent +
//             MediaQuery.of(Get.context!).viewPadding.bottom);
//       }
//       //after chat history; connect socket
//       _connectSocket();
//       Get.back();
//     } catch (err) {
//       Get.back();
//     }
//   }

//   Future<ChatHistoryApiResponse?> chatHistoryApiCall() async {
//     HeaderModel headerModel = HeaderModel(
//       token: HiveStore().get(
//         Keys.accessToken,
//       ),
//     );
//     if (incidentId != "") {
//       var result = await CoreService().apiService(
//         baseURL: baseUrl,
//         header: headerModel.toHeader(),
//         body: {
//           "incident_id": incidentId,
//           "pageno": 1,
//         },
//         method: METHOD.POST,
//         endpoint: previousChatHistoryListUrl,
//       );
//       return ChatHistoryApiResponse.fromJson(result);
//     } else {
//       debugPrint(
//           "##################INCIDENT ID ISN'T PROVIDED###########################");
//       return null;
//     }
//   }
// }

// enum IsChatHistoryLoaded {
//   yes,
//   no,

//   ///If there is no chat history
//   noNeedToLoad,

//   ///If we are initializing value
//   init
// }
