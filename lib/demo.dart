  // void showOptionDialog(context) {
  //   showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       backgroundColor: white,
  //       elevation: 15,
  //       actionsPadding: const EdgeInsets.all(15),
  //       actions: <Widget>[
  //         vSpace(5),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             alignment: Alignment.center,
  //             height: 40,
  //             color: Colors.grey,
  //             child: TextButton(
  //               onPressed: () {
  //                 getImage(ImageSource.camera);
  //               },
  //               child: const Padding(
  //                 padding: EdgeInsets.only(),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.camera_alt,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Text(
  //                       'Camera',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         vSpace(5),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             alignment: Alignment.center,
  //             height: 40,
  //             color: Colors.grey,
  //             child: TextButton(
  //               onPressed: () {
  //                 getImage(ImageSource.gallery);
  //               },
  //               child: const Padding(
  //                 padding: EdgeInsets.only(),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.photo,
  //                       color: Colors.white,
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Text(
  //                       'Gallery',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         vSpace(5),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(50),
  //           child: Container(
  //             height: 40,
  //             color: Colors.red,
  //             alignment: Alignment.center,
  //             child: TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context, 'Cancel');
  //               },
  //               child: const Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.cancel_outlined,
  //                     color: Colors.white,
  //                   ),
  //                   SizedBox(
  //                     width: 15,
  //                   ),
  //                   Text(
  //                     'Cancel',
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future getImage(ImageSource source) async {
  //   Navigator.pop(context, 'Cancel');
  //   try {
  //     final image = await ImagePicker().pickImage(
  //         source: source, imageQuality: 25, maxHeight: 720, maxWidth: 512);

  //     if (image != null) {
  //       final imageTemporary = File(image.path);
  //       setState(() {
  //         _profileImage = imageTemporary;
  //       });
  //     } else {}
  //   } on PlatformException catch (e) {
  //     Get.snackbar(
  //       "Warning",
  //       'Failed to pick image:',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundGradient: LinearGradient(colors: [red, alertRed, white]),
  //     );
  //     print('Failed to pick image: $e');
  //   }
  // }