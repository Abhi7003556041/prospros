import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';

import 'package:prospros/controller/agora_controller_v2.dart';
import 'package:prospros/main.dart';
import 'package:sizing/sizing.dart';

class VideoCallUIV2 extends StatefulWidget {
  const VideoCallUIV2(
      {super.key,
      required this.channelName,
      required this.token,
      required this.agoraAppID,
      required this.userId,
      required this.userProfileImage,
      required this.userName,
      this.isAudioCall = false,
      this.createByPushingRoute = false});
  final String channelName;
  final String token;

  ///for caller it will be receiver image | for receiver it will be caller image
  final String userProfileImage;

  ///for caller it will be receiver name | for receiver it will be caller name
  final String userName;
  final String agoraAppID;
  final int userId;
  final bool createByPushingRoute;
  final isAudioCall;

  @override
  State<VideoCallUIV2> createState() => _VideoCallUIV2State(
      channelName: channelName,
      controller: Get.put(AgoraControllerV2(
          agoraAppId: agoraAppID,
          channelName: channelName,
          token: token,
          isAudioCall: isAudioCall,
          userId: userId)));
}

class _VideoCallUIV2State extends State<VideoCallUIV2> {
  final AgoraControllerV2 controller;
  _VideoCallUIV2State({required this.channelName, required this.controller});
  final channelName;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    printRed(
        "##-- initAgora:VideoCallUIV2 ${widget.token},${widget.userId} ${widget.channelName},");
    controller.reInitValues(
        agoraAppId: widget.agoraAppID,
        channel: widget.channelName,
        isAudioCall: widget.isAudioCall,
        token: widget.token,
        userID: widget.userId);
    await controller.setupVideoSDKEngine();
    await controller.join();
    controller.listenCallProgress(
      createByPushingRoute: widget.createByPushingRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      // ),
      // body: oldSimpleWidget(),
      body: newLayout(),
    );
  }

  Widget newLayout() {
    return Stack(
      children: [
        //Container for the Remote video
        Positioned(
          child: Container(
            height: 100.sh,
            width: 100.sw,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _remoteVideo()),
          ),
        ),
        // Container for the local video
        Obx(
          () => Positioned(
            right: controller.isRemoteUserJoined.value ? 20.ss : null,
            top: controller.isRemoteUserJoined.value ? 100.ss : null,
            child: Container(
              height: controller.isRemoteUserJoined.value ? 150.ss : 100.sh,
              width: controller.isRemoteUserJoined.value ? 100.ss : 100.sh,
              child: Center(child: _localPreview()),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Button Row
        Positioned(
          bottom: 20.ss,
          left: 10.ss,
          right: 10.ss,
          child: Row(
            children: <Widget>[
              Visibility(visible: !widget.isAudioCall, child: muteVideo()),
              const SizedBox(width: 10),
              Visibility(visible: !widget.isAudioCall, child: toogleCamera()),
              const SizedBox(width: 10),
              muteButton(),
              const SizedBox(width: 10),
              cancelButton()
            ],
          ),
        ),
        // Button Row ends
      ],
    );
  }

  Widget toogleCamera() {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: controller.isJoined.value
              ? () async {
                  await controller.toogleCamera();
                }
              : null,
          child: CircleAvatar(
            radius: 30,
            backgroundColor:
                controller.isVideoTurned.value ? Colors.grey : Colors.white,
            child: Icon(
              controller.isVideoTurned.value
                  ? Icons.cameraswitch_outlined
                  : Icons.cameraswitch_outlined,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget muteVideo() {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: controller.isJoined.value
              ? () async {
                  await controller.muteVideo();
                }
              : null,
          child: CircleAvatar(
            radius: 30,
            backgroundColor:
                controller.isVideoMuted.value ? Colors.grey : Colors.white,
            child: Icon(
              controller.isVideoMuted.value
                  ? Icons.videocam_off_outlined
                  : Icons.videocam_outlined,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget muteButton() {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: controller.isJoined.value
              ? () async {
                  await controller.muteCall();
                }
              : null,
          child: CircleAvatar(
            radius: 30,
            backgroundColor:
                controller.isMuted.value ? Colors.grey : Colors.white,
            child: Icon(
              controller.isMuted.value
                  ? Icons.mic_off_sharp
                  : Icons.mic_none_sharp,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget cancelButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (await controller.leave()) {
            await callController.endCall();
            if (widget.createByPushingRoute) {
              if (Get.previousRoute == "/chatScreen") {
                Get.back();
              }
            }
          }
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.call_end_sharp,
            color: Colors.white,
          ),
        ),
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
          ? controller.isAgoraInitialized.value
              ? widget.isAudioCall
                  ? Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.ss,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.userProfileImage),
                            ),
                            Text(widget.userName)
                          ]),
                    )
                  : Obx(
                      () => AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: controller.agoraEngine!,
                          canvas: VideoCanvas(
                              uid: controller.remoteUid?.value ?? 1, view: 1),
                          connection:
                              RtcConnection(channelId: controller.channelName),
                        ),
                      ),
                    )
              : Container(
                  color: Colors.grey,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue[900],
                  )),
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
        ? controller.isVideoMuted.value
            ? Container(
                color: Colors.grey,
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              )
            : controller.isAgoraInitialized.value
                ? widget.isAudioCall
                    ? SizedBox()
                    : AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: controller.agoraEngine!,
                          canvas: VideoCanvas(view: 0, uid: 0),
                        ),
                      )
                : Container(
                    color: Colors.grey,
                    child: Center(child: CircularProgressIndicator()),
                  )
        : controller.iscallDiconnecting.value
            ? const Text(
                'Wait, call is disconnecting',
                textAlign: TextAlign.center,
              )
            : const Text(
                'Initializing call',
                textAlign: TextAlign.center,
              ));
  }

  @override
  void dispose() {
    controller.resetAllValues();
    controller.leave();
    controller.callController.currentCallDocument = null;
    controller.callController.endCall();
    super.dispose();
  }
}
