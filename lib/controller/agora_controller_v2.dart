import 'dart:async';
import 'dart:ffi';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/constants/agora_configs.dart';
import 'package:prospros/controller/call_controller.dart';

class AgoraControllerV2 extends GetxController {
  AgoraControllerV2(
      {required this.channelName,
      required this.token,
      required this.userId,
      required this.isAudioCall,
      required this.agoraAppId});
  String channelName;
  String token;
  String agoraAppId;
  bool isAudioCall;
  // uid of the local user
  int userId;
  final CallController callController = Get.find();
  StreamSubscription? ongoingCallStateListeningSubscription;

  RxInt? remoteUid; // uid of the remote user
  var isMuted = false.obs;
  var isVideoTurned = false.obs;
  var isVideoMuted = false.obs;
  var iscallDiconnecting = false.obs;
  var isRemoteUserJoined = false.obs;
  var isAgoraInitialized = false.obs;
  var isJoined =
      false.obs; // Indicates if the local user has joined the channel

  reInitValues(
      {required String agoraAppId,
      required String token,
      required String channel,
      required bool isAudioCall,
      required int userID}) {
    ///controller isn't getting disposed properly that's why this is used to update call value each time
    this.agoraAppId = agoraAppId;
    this.channelName = channel;
    this.userId = userID;
    this.token = token;
    this.isAudioCall = isAudioCall;

    iscallDiconnecting.value = false;
    isJoined.value = false;
    isRemoteUserJoined.value = false;
    isMuted.value = false;
    isVideoTurned.value = false;
    isVideoMuted.value = false;
    isJoined.value = false;
    isAgoraInitialized.value = false;
  }

  RtcEngine? agoraEngine; // Agora engine instance

  showMessage(String message) {}

  @override
  void onInit() {
    super.onInit();
    isJoined.listen((p0) {
      printRed("---+${p0}");
    });

    isRemoteUserJoined.listen((p0) {
      printRed("---+${p0}");
    });
    // setupVideoSDKEngine();
  }

  listenCallProgress({required bool createByPushingRoute}) async {
    if (callController.onGoingCallRef != null) {
      ongoingCallStateListeningSubscription =
          callController.onGoingCallRef!.onValue.listen((event) async {
        printRed("####### Previous route : ${Get.previousRoute}");
        if (event.snapshot.exists) {
          //that means call is in progress
          printRed("####### Call still in Progress");
        } else {
          //call disconnected
          printRed("####### Call disconnected");
          if (!iscallDiconnecting.value) {
            callController.isCallComing.value = false;
            callController.isCallInProgress.value = false;
            callController.onGoingCallRef = null;
            await leave();
            if (createByPushingRoute) {
              if (Get.previousRoute == "/chatScreen") {
                Get.back();
              }
            }
          }
        }
      });
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();
    printRed(" ##-- ${agoraAppId},$token,$userId,$channelName");

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine!.initialize(RtcEngineContext(appId: agoraAppId));
    if (isAudioCall) {
      await agoraEngine!.disableVideo();
      await agoraEngine!.enableAudio();
    } else {
      await agoraEngine!.enableVideo();
    }

    isAgoraInitialized.value = true;
    // Register the event handler
    agoraEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          printRed("Local user uid:${connection.localUid} joined the channel");
          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          printRed("Remote user uid:$rUid joined the channel");
          printRed("--++Remote user uid:$rUid joined the channel");
          remoteUid = RxInt(rUid);
          isRemoteUserJoined.value = true;
        },
        onUserMuteAudio: (rtcConnection, remoteUid, ismuted) {
          printRed("--++ AUDIO Muted : Uid${remoteUid}:${isMuted} ");
        },
        onUserMuteVideo: (rtcConnection, remoteUid, ismuted) {
          printRed("--++ VIDEO Muted : Uid${remoteUid}:${isMuted} ");
        },
        onUserEnableVideo: (rtcConnection, remoteUid, ismuted) {
          printRed("--++ VIDEO Enabled : Uid${remoteUid}:${isMuted} ");
        },
        onUserEnableLocalVideo: (connection, remoteUid, enabled) {
          printRed("--++ Local VIDEO Enabled : Uid${remoteUid}:${enabled} ");
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          showMessage("Remote user uid:$rUid left the channel");

          // remoteUid = null;
          // isRemoteUserJoined.value = false;
          // //since this is peer to peer video calling; that's why if one party is disconnected then complete call should be diconnected
          // Get.back();
        },
      ),
    );
  }

  Future<void> join() async {
    printRed("--++" + callController.currentCallDocument!.toJson().toString());
    if (agoraEngine != null) {
      await agoraEngine!.startPreview();
      printRed("--++Joining Channel");
      // Set channel options including the client role and channel profile
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      await agoraEngine!
          .joinChannel(
        token: token,
        channelId: channelName,
        // channelId: "jul_mon",
        // token:
        //     "006f69ec88beb3d4e06956159e1c1ca83feIABfnAWesKrie4ViA5guBjlHDyA67sUgIn7gWEF9D83nqlu2iS4pA1oIIgAXCAEA49yjZAQAAQBzmaJkAwBzmaJkAgBzmaJkBABzmaJk",
        options: options,
        uid: userId,
        // uid: 130,
      )
          .then((value) {
        isJoined.value = true;
      });
    }
  }

  Future<bool> leave() async {
    remoteUid = null;
    resetAllValues();
    callController.endCall();
    try {
      if (agoraEngine != null) {
        await agoraEngine!.stopPreview();
        await agoraEngine!.leaveChannel();
        await agoraEngine!.release();
        agoraEngine = null;
      }
      isAgoraInitialized.value = false;
      return true;
    } catch (err) {
      printRed(
          "###########################AgoraEngine Wasn't initialized#########################");
      return false;
    }

    return true;
  }

  Future<void> muteCall() async {
    if (agoraEngine != null) {
      if (isMuted.value) {
        //if already muted
        await agoraEngine!.muteLocalAudioStream(false);
      } else {
        await agoraEngine!.muteLocalAudioStream(true);
      }
      isMuted.value = !isMuted.value;
    }
  }

  Future<void> muteVideo() async {
    if (agoraEngine != null) {
      if (isVideoMuted.value) {
        //if already muted
        await agoraEngine!.enableLocalVideo(true);
      } else {
        await agoraEngine!.enableLocalVideo(false);
      }
      isVideoMuted.value = !isVideoMuted.value;
    }
  }

  Future<void> toogleCamera() async {
    if (agoraEngine != null) {
      await agoraEngine!.switchCamera();

      isVideoTurned.value = !isVideoTurned.value;
    }
  }

  resetAllValues() {
    iscallDiconnecting.value = true;
    isJoined.value = false;
    isRemoteUserJoined.value = false;
    isMuted.value = false;
    isVideoTurned.value = false;
    isVideoMuted.value = false;
    isJoined.value = false;
    isAgoraInitialized.value = false;
  }

  @override
  void onClose() {
    try {
      if (agoraEngine != null) {
        agoraEngine!.leaveChannel().then((value) => agoraEngine!.release());
        agoraEngine = null;
      }
    } catch (err) {
      printRed(
          "###########################AgoraEngine Wasn't initialized#########################");
    }
    printRed("##-- distroying ago_controller_v2");
    ongoingCallStateListeningSubscription?.cancel();
    super.onClose();
  }
}
