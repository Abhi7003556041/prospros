import 'dart:async';
import 'dart:ffi';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prospros/constants/agora_configs.dart';
import 'package:prospros/controller/call_controller.dart';

class AgoraController extends GetxController {
  AgoraController(
      {required this.channelName, required this.token, required this.userId});
  final String channelName;
  final String token;
  // uid of the local user
  final int userId;
  final CallController callController = Get.find();
  StreamSubscription? ongoingCallStateListeningSubscription;

  RxInt? remoteUid; // uid of the remote user
  var isRemoteUserJoined = false.obs;
  var isJoined =
      false.obs; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  showMessage(String message) {}

  @override
  void onInit() {
    super.onInit();
    // setupVideoSDKEngine();
  }

  listenCallProgress(
      {required bool createByPushingRoute, AgoraClient? agoraClient}) async {
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
          callController.isCallComing.value = false;
          callController.isCallInProgress.value = false;
          callController.onGoingCallRef = null;
          if (createByPushingRoute) {
            try {
              // await leave();
              callController.endCall();
              // await agoraEngine.release();
              await agoraClient!.engine.stopPreview();
              await agoraClient!.engine.leaveChannel();
              await agoraClient.engine.release();
              if (Get.previousRoute == "/chatScreen") {
                Get.back();
              }
            } catch (err) {
              printRed("######Exception thrown ${err.toString()}");
              if (Get.previousRoute == "/chatScreen") {
                // Get.back();
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

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine
        .initialize(RtcEngineContext(appId: AgoraVideoCallConfig.appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");

          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          showMessage("Remote user uid:$rUid joined the channel");

          remoteUid = RxInt(rUid);
          isRemoteUserJoined.value = true;
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

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: userId,
    );
  }

  Future<void> leave() async {
    isJoined.value = false;
    remoteUid = null;
    // await agoraEngine.stopPreview();
    // await agoraEngine.leaveChannel();
  }

  @override
  void onClose() {
    // agoraEngine.leaveChannel().then((value) => agoraEngine.release());
    ongoingCallStateListeningSubscription?.cancel();
    super.onClose();
  }
}
