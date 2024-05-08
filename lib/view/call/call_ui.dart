import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:prospros/controller/call_controller.dart';
import 'package:get/get.dart';
import 'package:prospros/main.dart';
import 'package:prospros/view/call/video_call_ui.dart';
import 'package:prospros/view/call/video_call_ui_v2.dart';

class CallUI extends StatefulWidget {
  final CallController controller;
  const CallUI({super.key, required this.controller});

  @override
  State<CallUI> createState() => _CallUIState();
}

class _CallUIState extends State<CallUI> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        switchOutCurve: Curves.easeOut,
        duration: Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: widget.controller.isCallInProgress.value
            // ? VideoCallUI(
            //     userId: callController.currentCallDocument!.reciverId!,
            //     token: callController.currentCallDocument!.callToken!,
            //     channelName: callController.currentCallDocument!.channelId!)
            ? VideoCallUIV2(
                key: Key(
                    "${callController.currentCallDocument!.receiverCallToken!}"),
                isAudioCall:
                    (callController.currentCallDocument?.callType ?? "") ==
                            "audio"
                        ? true
                        : false,
                userName: callController.currentCallDocument?.callerName ?? "",
                userProfileImage:
                    callController.currentCallDocument?.callerProfileImage ??
                        "",
                agoraAppID: callController.currentCallDocument!.agoraAppId!,
                userId: callController.currentCallDocument!.reciverId!,
                // token: callController.currentCallDocument!.callToken!,
                token: callController.currentCallDocument!.receiverCallToken!,
                channelName: callController.currentCallDocument!.channelId!)
            : widget.controller.isCallComing.value
                ? callIncomingDialouge()
                : SizedBox(),
      ),
    );
  }

  Widget callIncomingDialouge() {
    return Animate(
      effects: [ScaleEffect(duration: Duration(milliseconds: 700))],
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            height: 350,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 12, 72),
                borderRadius: BorderRadius.circular(7)),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(
                              callController.currentCallDocument
                                      ?.callerProfileImage ??
                                  ""),
                        ),
                      ),
                      Text(
                        callController.currentCallDocument?.callerName ??
                            "Unknown User",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.controller.pickCall();
                        },
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.call_outlined)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await widget.controller.dropCall();
                        },
                        child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red[800],
                            child: Icon(Icons.call_end_rounded)),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  stopRingtonePlaying() async {
    await FlutterRingtonePlayer.stop();
  }

  @override
  void dispose() {
    stopRingtonePlaying();
    super.dispose();
  }
}
