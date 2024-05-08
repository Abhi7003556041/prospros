import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/model/chat/call_document.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CallController extends GetxController {
  var isCallComing = false.obs;
  var isCallInProgress = false.obs;
  static const _callDocumentTag = "calls";
  DatabaseReference? callDocumentRef;
  DatabaseReference? onGoingCallRef;
  StreamSubscription? callDocumentListeningSubscription;
  //It will contain currently running or comming uncle
  CallDocument? currentCallDocument;

  @override
  void onInit() {
    super.onInit();
  }

  initCallDocumentListening(String firebaseUserId) async {
    callDocumentRef =
        FirebaseDatabase.instance.ref("/$_callDocumentTag/$firebaseUserId").ref;
    keepListeningToCallDocument();
  }

  keepListeningToCallDocument() async {
    callDocumentListeningSubscription =
        callDocumentRef!.onValue.listen((event) async {
      if (event.snapshot.exists) {
        printRed(event.snapshot.children.first.value);
        if (event.snapshot.value is Map) {
          printRed("Call is comming");
          var data = event.snapshot.value as Map;
          currentCallDocument = CallDocument(
              agoraAppId: data['agoraAppId'],
              callToken: data['callToken'],
              callType: data['callType'],
              reciverId: data['receiverId'],
              callerFirebaseId: data['callerFirebaseId'],
              channelId: data['channelId'],
              receiverCallToken: data['receiverCallToken'],
              callerCallToken: data['callerCallToken'],
              timestamp: data['timestamp'],
              callerName: data['callerName'],
              callerProfileImage: data['callerProfileImage'],
              reciverFirebaseId: data['reciverFirebaseId']);

          printRed(
              "##-- keepListeningToCallDocument() ${currentCallDocument?.toJson()}");
          //for receiver this is the place to get incomingCallDocument's reference
          onGoingCallRef = event.snapshot.ref;
          isCallComing.value = true;
          //play a ringtone while call is arriving
          FlutterRingtonePlayer.play(
            android: AndroidSounds.ringtone,
            ios: IosSounds.glass,
            looping: true, // Android only - API >= 28
            volume: 5, // Android only - API >= 28
            asAlarm: false, // Android only - all APIs
          );
        } else {
          printRed("Call disconnected");
          isCallComing.value = false;
          isCallInProgress.value = false;
          await FlutterRingtonePlayer.stop();
          currentCallDocument = null;
        }
      } else {
        if (onGoingCallRef != null) {
          //there was a call in progress or arriving
          isCallComing.value = false;
          isCallInProgress.value = false;
          await FlutterRingtonePlayer.stop();
          currentCallDocument = null;
        }
      }
    });
  }

  ///This function will create a new call document if it doesn't already exist
  ///If a call document is already then it will compare receivier or sender id with current callerid. If it matches then it will delete already going call and will create new call document
  ///If already existing call document's receiver or callerid is not matching with current call's callerid then it will show - "Use is busy"
  createCall({required CallDocument callDocument}) async {
    if (callDocumentRef != null) {
      //create a new document inside calls/{userId}/{callDocume}
      //Take care that if there is already a document then show user is busy

      var receiverCallDocRef = FirebaseDatabase.instance
          .ref("/$_callDocumentTag/${callDocument.reciverFirebaseId}");
      await receiverCallDocRef.once().then((value) async {
        printGreen(value.snapshot.value);
        if (value.snapshot.value is Map) {
          var callDoc = value.snapshot.value as Map;
          if (callDoc['callerFirebaseId'] == callDocument.callerFirebaseId ||
              callDoc['reciverFirebaseId'] == callDocument.callerFirebaseId) {
            //then there is already a call document which is related with current user
            printGreen("UPDATING CALL DOCUMNET");
            //remove already existing call
            await receiverCallDocRef.remove();
            //wait for half second; so that both parties's ui will get normalize
            await Future.delayed(Duration(milliseconds: 500));
            //now create a new call
            await receiverCallDocRef.update(callDocument.toJson());
            onGoingCallRef = receiverCallDocRef;
            currentCallDocument = callDocument;
          } else {
            //then there is already a call document which is not related with current user
            Get.showSnackbar(GetSnackBar(
                message: "User is busy",
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
          }
        } else {
          //now create a call document inside receiver's object
          await receiverCallDocRef.update(callDocument.toJson());
          //for caller this is the place to get incomingCallDocument's reference
          onGoingCallRef = receiverCallDocRef;
          currentCallDocument = callDocument;
        }
      });
    } else {
      Get.showSnackbar(GetSnackBar(
          message: "Unable to call",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 20, left: 0, right: 0)));
    }
  }

  pickCall() async {
    isCallComing.value = false;
    isCallInProgress.value = true;
    await FlutterRingtonePlayer.stop();
  }

  endCall() async {
    isCallInProgress.value = false;
    //remove ongoing call reference (document) from firebase realtime database
    onGoingCallRef?.remove();
    await FlutterRingtonePlayer.stop();
    currentCallDocument = null;
  }

  dropCall() async {
    isCallComing.value = false;
    await onGoingCallRef!.remove();
    await FlutterRingtonePlayer.stop();
    currentCallDocument = null;
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    callDocumentListeningSubscription?.cancel();
    super.dispose();
  }
}
