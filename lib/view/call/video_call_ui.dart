import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/constants/agora_configs.dart';
import 'package:prospros/controller/agora_controller.dart';
import 'package:prospros/main.dart';

class VideoCallUI extends StatefulWidget {
  const VideoCallUI(
      {super.key,
      required this.channelName,
      required this.token,
      required this.userId,
      this.createByPushingRoute = false});
  final String channelName;
  final String token;
  final int userId;
  final bool createByPushingRoute;

  @override
  State<VideoCallUI> createState() => _VideoCallUIState(
      channelName: channelName,
      controller: Get.put(AgoraController(
          channelName: channelName, token: token, userId: userId)));
}

class _VideoCallUIState extends State<VideoCallUI> {
  final AgoraController controller;
  _VideoCallUIState({required this.channelName, required this.controller});
  final channelName;

  // Instantiate the client
  late AgoraClient client = AgoraClient(
    // agoraChannelData: AgoraChannelData(
    //     muteAllRemoteVideoStreams: true,
    //     channelProfileType: ChannelProfileType.channelProfileCommunication),
    // agoraRtmChannelEventHandler:
    //     AgoraRtmChannelEventHandler(onMemberJoined: (member) {
    //   printYellow("Member Joined : ");
    // }, onMemberLeft: (member) {
    //   printYellow("Member Disconnected : ");
    // }),
    agoraConnectionData: AgoraConnectionData(
        appId: AgoraVideoCallConfig.appId,
        username: "Ritesh Kumar Tiwari",
        channelName: widget.channelName,
        tempToken: widget.token),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await client.initialize();
    await client.engine.disableVideo();
    controller.listenCallProgress(
        createByPushingRoute: widget.createByPushingRoute, agoraClient: client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      // ),
      // body: oldSimpleWidget(),
      body: Stack(
        children: [
          AgoraVideoViewer(
            client: client,
            layoutType: Layout.oneToOne,
          ),
          AgoraVideoButtons(
            client: client,
            onDisconnect: () async {
              debugPrint("#### call disconnected");
              controller.leave();
              callController.endCall();

              if (widget.createByPushingRoute &&
                  Get.previousRoute == "/chatScreen") {
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  ListView oldSimpleWidget() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        // Container for the local video
        Container(
          height: 240,
          decoration: BoxDecoration(border: Border.all()),
          child: Center(child: _localPreview()),
        ),
        const SizedBox(height: 10),
        //Container for the Remote video
        Container(
          height: 240,
          decoration: BoxDecoration(border: Border.all()),
          child: Center(child: _remoteVideo()),
        ),
        // Button Row
        Row(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isJoined.value
                      ? null
                      : () => {controller.join()},
                  child: const Text("Join"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isJoined.value
                      ? () => {controller.leave()}
                      : null,
                  child: const Text("Leave"),
                ),
              ),
            ),
          ],
        ),
        // Button Row ends
      ],
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return Obx(
      () => controller.isRemoteUserJoined.value
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: controller.agoraEngine,
                canvas: VideoCanvas(uid: controller.remoteUid!.value),
                connection: RtcConnection(channelId: controller.channelName),
              ),
            )
          : controller.isJoined.value
              ? Text(
                  "Waiting for a remote user to join",
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
    );
  }

  // Display local video preview
  Widget _localPreview() {
    return Obx(() => controller.isJoined.value
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.agoraEngine,
              canvas: VideoCanvas(uid: 0),
            ),
          )
        : const Text(
            'Join a channel',
            textAlign: TextAlign.center,
          ));
  }

  @override
  void dispose() {
    controller.leave();
    controller.callController.endCall();
    super.dispose();
  }
}
