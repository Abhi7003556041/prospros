import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prospros/widgets/back_button.dart';

class InterActiveImageViewer extends StatelessWidget {
  const InterActiveImageViewer({super.key, required this.fileUrl});

  final String fileUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: InteractiveViewer(
                  child: CachedNetworkImage(imageUrl: fileUrl))),
          Positioned(top: 30, left: 10, child: AppBackButton.stackBackButton())
        ],
      ),
    );
  }
}
