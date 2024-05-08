import 'dart:convert';
import 'dart:isolate';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:hive/hive.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/controller/call_controller.dart';
import 'package:prospros/controller/chat_controller.dart';
import 'package:prospros/model/chat/chat_message.dart';
import 'package:prospros/model/chat/firebase_user.dart';

class ChatService extends GetxController {
  static const String _chatsCollectionName = "chat_lists";
  static const String _usersCollectionName = "users";
  DatabaseReference chatRef =
      FirebaseDatabase.instance.ref("/$_chatsCollectionName").ref;
  DatabaseReference _userRef =
      FirebaseDatabase.instance.ref("/$_usersCollectionName").ref;
  DatabaseReference rootRef = FirebaseDatabase.instance.ref().ref;
  String? _chatRomID;

  final CallController callController = Get.find();

  ///firebse-user-id(current user id or sender id)
  late String _userId;

  ///This prefix will be appended with user.(userId[which will be fetched from server] is like 1,243,432 etc. in this case the firebase database will take it as an array. So to avoid this we are appending some string with userID)
  String userPrefix = "pros_user";

  ///get userRef by sending user id. userID should be taken from userProfile or userResponse
  DatabaseReference userDocumentRef(String firebaseuserID) {
    return _userRef.child("/$firebaseuserID");
  }

  setUserId(String userId) {
    _userId = _formUserId(userId);
  }

  ///userId : server-user-id
  getFirebaseUserId(String userId) {
    return _formUserId(userId);
  }

  ///userId : server-user-id
  DatabaseReference getFirebasUserFriendListDataRef() {
    return userDocumentRef(_userId).child("friend_list").ref;
  }

  /// a dummy functions to forcefully update friend list collection; so that messages tab can be refresh systematically
  ///userId : server-user-id
  Future<void> addAndRemoveValueInsideUserFriendList() async {
    await userDocumentRef(_userId)
        .child("friend_list")
        .ref
        .update({"dummy": "dummy"});
    var values = <String, dynamic>{};
    values['${userDocumentRef(_userId).child("friend_list").ref.path}/dummy'] =
        null;
    await rootRef.update(values);
  }

  ///Provide server-user-id as a parameter
  //it will create a  firebase-user-id by appending string with server-user-id
  String _formUserId(String userId) {
    return userPrefix + userId;
  }

  String getServerUserFromFirebaseUserId(String firebaseUserId) {
    return firebaseUserId.replaceAll(userPrefix, '');
  }

  setUserOnlineStatus() async {
    await userDocumentRef(_userId)
        .update({
          // "name": userName,
          // "profileUrl": userProfileImage,
          // "userTag": userTag,
          "lastPresenceAt": ServerValue.timestamp,
          "isOnline": true,
          "status": "active"
        })
        .whenComplete(() => printGreen("user presence updated"))
        .catchError((err) {
          printRed("Error while user presence updation" + err);
        });

    //turn user offline while user closes app
    await userDocumentRef(_userId).onDisconnect().update({
      "lastPresenceAt": ServerValue.timestamp,
      "isOnline": false,
    });

    callController.initCallDocumentListening(_userId);
  }

  ///this method will be called when user is signing-out or deleting his/her account
  setUserOffile() async {
    await userDocumentRef(_userId)
        .update({
          // "name": userName,
          // "profileUrl": userProfileImage,
          // "userTag": userTag,
          "lastPresenceAt": ServerValue.timestamp,
          "isOnline": false,
          "status": "active"
        })
        .whenComplete(() => printGreen("user presence updated : Turned to offline"))
        .catchError((err) {
          printRed("Error while user presence updation" + err);
        });
  }

  ///This will create chat document (reffered as chat_room).And it will assign that document id to each user's - field chat_users
  /// senderUserId : the server-user-id
  /// receiverUserId: the server-user-id
  Future<void> createOrUpdateChatRoom(
      {required String senderUserId, required String receiverUserId}) async {
    String firbaseSenderId = _formUserId(senderUserId);
    String firebaseReceiverUserId = _formUserId(receiverUserId);
    String chatRoomIDName = "${firbaseSenderId}__${firebaseReceiverUserId}";
    // chatRef.child(chatRoomIDName).child("testMsg").update({
    //   "msg": "This is test message",
    //   "senderId": firbaseSenderId,
    //   "receiverId": firebaseReceiverUserId,
    //   "isReadByreceiver": false,
    //   "sentAt": ServerValue.timestamp,
    //   "msgType": "sys_test"
    // });

    //update current user friend list
    await updateFriendList(
        firebase_userId: firbaseSenderId,
        firebase_friendId: firebaseReceiverUserId,
        chatRoomId: chatRoomIDName);

    //update reveiver's friend llist
    await updateFriendList(
        firebase_userId: firebaseReceiverUserId,
        firebase_friendId: firbaseSenderId,
        chatRoomId: chatRoomIDName);
  }

  /// userId : server-user-id
  updateUserDetails(
      {required String userId,
      required String userName,
      required String profileImageUrl}) async {
    await userDocumentRef(_formUserId(userId))
        .update({
          "name": userName,
          "profileUrl": profileImageUrl,
        })
        .whenComplete(() => printGreen("userName & profileimage updated"))
        .catchError((err) {
          printRed("Error while userName & profileimage updation" + err);
        });
  }

  updateFriendList(
      {required String firebase_userId,
      required String firebase_friendId,
      required String chatRoomId}) async {
    await userDocumentRef(firebase_userId)
        .child("friend_list/${firebase_friendId}")
        .update({
      "user_id": firebase_friendId,
      "chat_room_id": chatRoomId,
      "status": "active"
    });
  }

  /// Get chat document ref to listen for incoming messages
  /// receiverId : server-user id
  Future<DatabaseReference?> chatDocumentRef(
      {required String receiverId}) async {
    var firebaseReceiverId = _formUserId(receiverId);
    var data = await userDocumentRef(_userId)
        .child("/friend_list/${firebaseReceiverId}")
        .get();

    String? chatRoomID;
    if (data.exists) {
      chatRoomID = data.child("chat_room_id").value.toString();
      // data.children.forEach((element) {
      //   printRed(element.toString());
      //   printRed(element.child("chat_room_id").value.toString());
      //   // var keyValue = element.children.
      // });
      print(chatRoomID);
      _chatRomID = chatRoomID;
    } else {
      printRed("chat room not exists");
    }
    if (chatRoomID != null) {
      return chatRef.child(chatRoomID);
    } else {
      return null;
    }
  }

  /// Get chat document ref using chat room id
  /// receiverId : firebase-user id
  DatabaseReference chatRoomRefByChatRoomID({required String chatRoomID}) {
    return chatRef.child(chatRoomID);
  }

  Future<FirebaseUser?> getFirebaseUserDetails(String firebaseUserID) async {
    var snapshotData = await userDocumentRef(firebaseUserID).once();

    try {
      if (snapshotData.snapshot.exists) {
        var data = snapshotData.snapshot.value as Map;
        // printRed(data);

        var usrData = FirebaseUser(
            isOnline: data['isOnline'],
            lastPresenceAt: data['lastPresenceAt'].toString(),
            name: data['name'],
            profileUrl: data['profileUrl'],
            status: data['status']);
        printRed(usrData.toJson());
        return usrData;
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  Future<void> sendMessage(
      {required String receiverId,
      required String msg,
      MsgType msgType = MsgType.normal_text_msg}) async {
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var firebaseReceiverId = _formUserId(receiverId);
    var msgObject = ChatMsgData(
        isReadByreceiver: false,
        msg: msg,
        msgType: msgType.name,
        receiverId: firebaseReceiverId,
        sentAt: timestamp,
        senderId: _userId);
    if (_chatRomID == null) {
      await chatDocumentRef(receiverId: receiverId);
    }

    var values = <String, dynamic>{};
    values['$_chatsCollectionName/${_chatRomID}/${timestamp}'] =
        msgObject.toJson();
    //update lasteChat of sender user
    values['$_usersCollectionName/${_userId}/friend_list/${firebaseReceiverId}/lastChat'] =
        timestamp;
    //update lasteChat of receiver user
    values['$_usersCollectionName/${firebaseReceiverId}/friend_list/${_userId}/lastChat'] =
        timestamp;

    await rootRef.update(values);

    String fcmVal = HiveStore().get(Keys.fcmToken);
    sendNotification({
      "fcmVal": fcmVal,
      "messageDocPath": '$_chatsCollectionName/${_chatRomID}/${timestamp}',
      // "rootIsolateToken": ServicesBinding.rootIsolateToken!
      "rootIsolateToken": RootIsolateToken.instance!,
      "room_id": _chatRomID,
      "receiver_id": receiverId,
      "message": msg,
      "auth_token": HiveStore().get(Keys.accessToken)
    });
    // Isolate.spawn(sendNotification, {
    //   "fcmVal": fcmVal,
    //   "messageDocPath": '$_chatsCollectionName/${_chatRomID}/${timestamp}',
    //   // "rootIsolateToken": ServicesBinding.rootIsolateToken!
    //   "rootIsolateToken": RootIsolateToken.instance!
    // });
  }

  updateMsgReadingStatus(
      {required chatData, required server_receiver_id}) async {
    var chatDocRef = await chatDocumentRef(receiverId: server_receiver_id);
    if (chatDocRef != null) {
      chatDocRef.child(chatData.sentAt!).once().then((value) {
        print("+++" + value.snapshot.value.toString());
      });

      ///sentAt is timestamp, and timestamp is used as message id
      var values = <String, dynamic>{};
      values["${chatDocRef.child(chatData.sentAt!).ref.path}/isReadByreceiver"] =
          true;
      await rootRef.update(values);
    }
  }
}

enum MsgType {
  test_text("test_text"),
  normal_text_msg("normal_txt_msg"),
  image("image"),
  document("document");

  const MsgType(this.name);
  final String name;
}
