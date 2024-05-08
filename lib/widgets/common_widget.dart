import 'dart:math';

import 'package:flutter/material.dart';

OutlineInputBorder customOutlineBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.shade400,
      width: 1.5,
    ),
  );
}

///text-Regular
Widget textRegular({
  String text = "",
  double size = 10,
  Color? color,
  int? maxLine,
  dynamic alignment,
}) {
  return Text(
    text,
    maxLines: maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    textAlign: alignment ?? TextAlign.left,
  );
}

///text-Bold Style
Widget textBold({
  String text = "",
  double size = 10,
  Color? color,
  int? maxLine,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLine,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Thin Style
Widget textThin({
  String text = "",
  double size = 10,
  Color? color,
}) {
  return Text(
    text,
    maxLines: 20,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w100,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Extra Light Style
Widget textExtraLight({
  String text = "",
  double size = 10,
  Color? color,
}) {
  return Text(
    text,
    maxLines: 1,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w200,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text- Light Style
Widget textLight({
  String text = "",
  double size = 10,
  Color? color,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Medium Style
Widget textMedium({
  String text = "",
  double size = 10,
  Color? color,
}) {
  return Text(
    text,
    // maxLines: 1,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500,
      fontFamily: "text",
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Black Style
Widget textBlack({
  String text = "",
  double size = 10,
  Color? color,
}) {
  return Text(
    text,
    maxLines: 1,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Semi Bold Style
Widget textSemiBold({
  String text = "",
  double size = 10,
  Color? color,
  int? maxLine,
}) {
  return Text(
    text,
    maxLines: maxLine,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    ),
  );
}

///text-Semi Bold Style
Widget textSemiBoldDashboard({
  String text = "",
  double size = 10,
  Color? color,
  int? maxLine,
}) {
  return Text(
    text,
    maxLines: maxLine,
    textAlign: TextAlign.left,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    ),
  );
}

///Navigate Push
goto(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen,
    ),
  );
}

///Navigate Without Back
gotoWithoutBack(
  BuildContext context,
  Widget nextScreen,
) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen,
    ),
  );
}

///Navigate Untill Remove
gotoUtillBack(
  BuildContext context,
  Widget nextScreen,
) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
      (route) => false);
}

///Pop Navigate
goBack(BuildContext context) {
  Navigator.of(context).pop();
}

///Vertical Space
Widget vSpace(
  double h,
) {
  return SizedBox(
    height: h,
  );
}

///Horizontal Space
Widget hSpace(
  double w,
) {
  return SizedBox(
    width: w,
  );
}

///Custom Indicator
Widget progressIndicator(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.red,
      ),
    ),
  );
}

///Custom Indicator
Widget progressIndicatorforCheck(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.red,
      ),
    ),
  );
}

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Color getRandomColor() {
  Random random = Random();
  int red =
      random.nextInt(256); // Generates a random value between 0 and 255 for red
  int green = random
      .nextInt(256); // Generates a random value between 0 and 255 for green
  int blue = random
      .nextInt(256); // Generates a random value between 0 and 255 for blue

  return Color.fromARGB(
      255, red, green, blue); // 255 is the alpha value (fully opaque)
}
