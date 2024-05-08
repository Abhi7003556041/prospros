import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:prospros/Store/HiveStore.dart';
import 'package:prospros/router/navrouter_constants.dart';

class FirebaseMessageHandler extends GetxController {
  FirebaseMessageHandler() {}

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');
  static const String portName = 'notification_send_port';
  late final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  bool isNotificationPermissionGranted = false;

  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  static const String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  init(Future<void> Function(RemoteMessage) backGroundhandler) async {
    await FirebaseMessaging.instance.requestPermission();
    if (Platform.isAndroid) {
      _isAndroidPermissionGranted();
    } else {
      _requestIosMacPermissions();
    }
    if (Platform.isIOS) {
      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    String initialRoute = "/";

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      printRed("Notification launched app !!!!!!!!!!!!");
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      initialRoute = home;
    }
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        printRed(
            "Notification Response received : ${notificationResponse.payload}");
        if (notificationResponse.payload == "albumDownload") {
          //then redirect user to downloads folder
          // await _openDownloadsFolder();
        }
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    var fcmToken = await FirebaseMessaging.instance.getToken();
    printRed("Firebase Message token : " + fcmToken.toString());
    //fcm token stored
    await HiveStore().put(Keys.fcmToken, fcmToken.toString());
    FirebaseMessaging.onBackgroundMessage(backGroundhandler);
    FirebaseMessaging.onMessage.listen((message) {
      printRed("Message arrived : ${message.data}");
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        AndroidNotification? androidNotification;
        AppleNotification? appleNotification;
        if (GetPlatform.isIOS) {
          appleNotification = notification.apple;
          if (appleNotification != null) {
            _showNotification(
                notificationBody: notification.body ?? "---",
                notificationId: 121,
                notificationTitle: notification.title ?? "---",
                notificationPayload: notification.bodyLocKey ?? "");
          }
        } else {
          androidNotification = notification.android;
          if (androidNotification != null) {
            _showNotification(
                notificationBody: notification.body ?? "---",
                notificationId: 121,
                notificationTitle: notification.title ?? "---",
                notificationPayload: notification.bodyLocKey ?? "");
          }
        }
      }
    });
  }

  void selectNotification(String? payload) {
    // if (payload != null && payload.isNotEmpty) {
    //   behaviorSubject.add(payload);
    // }
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      isNotificationPermissionGranted = granted;
    }
  }

  Future<void> _requestIosMacPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      isNotificationPermissionGranted = granted ?? false;
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      printDeepPurple("Notification received");
      // await showDialog(
      //   context: context,
      //   builder: (BuildContext context) => CupertinoAlertDialog(
      //     title: receivedNotification.title != null
      //         ? Text(receivedNotification.title!)
      //         : null,
      //     content: receivedNotification.body != null
      //         ? Text(receivedNotification.body!)
      //         : null,
      //     actions: <Widget>[
      //       CupertinoDialogAction(
      //         isDefaultAction: true,
      //         onPressed: () async {
      //           Navigator.of(context, rootNavigator: true).pop();
      //           await Navigator.of(context).push(
      //             MaterialPageRoute<void>(
      //               builder: (BuildContext context) =>
      //                   SecondPage(receivedNotification.payload),
      //             ),
      //           );
      //         },
      //         child: const Text('Ok'),
      //       )
      //     ],
      //   ),
      // );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      // await Navigator.of(context).push(MaterialPageRoute<void>(
      //   builder: (BuildContext context) => SecondPage(payload),
      // ));
    });
  }

  Future<void> _showNotification(
      {required int notificationId,
      required String notificationTitle,
      required String notificationBody,
      required String notificationPayload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            color: Colors.purple,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(notificationId,
        notificationTitle, notificationBody, notificationDetails,
        payload: notificationPayload);
  }

  Future<void> configureCallNotifications() async {
    // Create a channel for incoming calls.
    AndroidNotificationChannel incomingCallChannel =
        AndroidNotificationChannel('incoming_call_channel', 'Incoming Call',
            importance: Importance.max,
            playSound: true,
            // sound:,
            description: "This channel is used to receive call notifications",
            enableLights: true,
            enableVibration: true,
            ledColor: Colors.green,
            showBadge: true);
  }

  @override
  void onClose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.onClose();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
