import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/widgets/image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDocumentMsg extends StatelessWidget {
  const ShowDocumentMsg(
      {super.key, required this.isReply, required this.docUrl});

  final bool isReply;
  final String docUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isReply ? AppColor.chatMsgColor : AppColor.appColor,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
      child: GestureDetector(
          onTap: () {
            Uri url = Uri.parse(docUrl);
            // Uri url = Uri(
            //     scheme: "https",
            //     host: "dev17.ivantechnology.in",
            //     path:
            //         "/doubtanddiscussion/public/storage/chats/INVOICE_1109_1688384338.pdf");
            _launchUrl(url);
          },
          child: Icon(
            Icons.file_present,
            color: isReply ? Colors.black : Colors.white,
          )),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (err) {
        print(err.toString());
      }
    }
    // if (await launchUrl(url, mode: LaunchMode.inAppWebView)) {
    //   throw Exception('Could not launch $url');
    // }
  }
}
