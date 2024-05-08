import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/constants/constant.dart';
import 'package:prospros/constants/style.dart';
import 'package:prospros/util/app_util.dart';
import 'package:sizing/sizing.dart';

class MessageProfile extends StatelessWidget {
  const MessageProfile(
      {super.key,
      required this.name,
      required this.msg,
      required this.img,
      required this.msgTime,
      required this.unreadMsgCount,
      required this.status,
      required this.onTap});
  final String img;
  final String name;
  final String msg;
  final String msgTime;
  final Color status;
  final int unreadMsgCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: unreadMsgCount > 0
            ? Colors.grey.withOpacity(.9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.ss),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(img),
                      //child: Text("AD"),
                      radius: 20),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      // decoration:
                      //     BoxDecoration(shape: BoxShape.circle, color: status),
                      height: 17,
                      width: 17,
                      child: status == Colors.red
                          ? Image.asset(
                              AppImage.offline,
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              AppImage.online,
                              fit: BoxFit.fill,
                            ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(Apputil.timeStampToDateTime(msgTime),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.msgFontColor1))
                          ]),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxHeight: 50,
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6),
                            child: msg.isImageFileName
                                ? Icon(Icons.image)
                                : msg.isPDFFileName ||
                                        msg.isVideoFileName ||
                                        msg.isDocumentFileName ||
                                        msg.isHTMLFileName
                                    ? Icon(Icons.my_library_books)
                                    : Text(msg,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyle.communityTxtStyle12),
                          ),
                          Visibility(
                            visible: unreadMsgCount > 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              child: Text(
                                unreadMsgCount.toString(),
                                style: TextStyle(fontSize: 9.ss),
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
