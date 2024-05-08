import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:prospros/Service/firebaseMessaging.dart';
import 'package:prospros/controller/call_controller.dart';
import 'package:prospros/controller/timeZone_controller.dart';
import 'package:prospros/router/navrouter.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/constants/color.dart';
import 'package:prospros/util/app_util.dart';
import 'package:prospros/view/call/call_ui.dart';
import 'package:sizing/sizing.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:firebase_core/firebase_core.dart';

/// To verify that your messages are being received, you ought to see a notification appearon your device/emulator via the flutter_local_notifications plugin.
/// Define a top-level named handler which background/terminated messages will
/// call. Be sure to annotate the handler with `@pragma('vm:entry-point')` above the function declaration.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

var callController = Get.put(CallController(), permanent: true);
var timeZone = Get.put(TimeZoneController(), permanent: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundIsolateBinaryMessenger.ensureInitialized(
      RootIsolateToken.instance!);
  await timeZone.initializeTimeZone();
  await HiveStore().initBox();
  await Firebase.initializeApp();
  var firebaseMessagingController = Get.put(FirebaseMessageHandler());
  firebaseMessagingController.init(_firebaseMessagingBackgroundHandler);

  Stripe.publishableKey =
      "pk_test_51NGKKQButuZhxgshgLJnqHGwzRX0lxRkbGmsXutjQFIBZNo4tzzxNUTofTMRR6tjH7bwFiZYhFC0tF9mQM3Rm2im00plUEuXAz";
  Stripe.merchantIdentifier = "merchant.com.gopros";

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
    systemNavigationBarIconBrightness:
        Brightness.dark, //navigation bar icons' color
  ));
  runApp(const ProsApp());
}

class ProsApp extends StatelessWidget {
  const ProsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizingBuilder(
      systemFontScale: true,
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Apputil.isUserLogged() ? home : login,
        // initialRoute: login,
        //emailVerification, //login, // createProfileDetails, // register //selectPlan
        getPages: NavRouter.generateRoute,
        title: "Projunctura",
        builder: (context, child) {
          return Stack(
            children: [
              child ??
                  Container(
                    width: 100.sw,
                    height: 100.sh,
                    color: AppColor.appBarBackgroundColor,
                  ),
              CallUI(controller: callController)
            ],
          );
        },
        theme: ThemeData(
          fontFamily: "Outfit",
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 14),
            backgroundColor: AppColor.elevatedBtnColor,
          )),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: AppColor.appColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
