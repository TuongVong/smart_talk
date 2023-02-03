// Dart imports:
import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui';

// Flutter imports:
import 'package:awesome_notifications/android_foreground_service.dart';
// Package imports:
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

// Project imports:
import '../bloc/call_bloc.dart';
import '../firebase_options.dart';
import 'notification_ring.dart';

const firebaseChannelGroupKey = 'firebase_channel_group';
const firebaseChannelGroupName = 'Firebase group';
const firebaseChannelKey = 'firebase_channel';
const firebaseChannelName = 'Firebase notifications';
const firebasechannelDescription = 'Notification channel for firebase';
const backgroundIsolatePortName = 'notification_manager_isolate_port';

class NotificationManager {
  static var shared = NotificationManager();
  final int notiID = math.Random().nextInt(2147483647);

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(onFirebaseBackgroundMessage);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications. we don't need this
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    NotificationRing.shared.init();

    if (defaultTargetPlatform == TargetPlatform.android) {
      await AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          '',
          [
            NotificationChannel(
                channelGroupKey: firebaseChannelGroupKey,
                channelKey: firebaseChannelKey,
                channelName: firebaseChannelName,
                channelDescription: firebasechannelDescription,
                defaultColor: const Color(0xFF9D50DD),
                playSound: true,
                enableVibration: true,
                vibrationPattern: lowVibrationPattern,
                onlyAlertOnce: false,
                ledColor: Colors.white)
          ],
          // Channel groups are only visual and are not required
          channelGroups: [
            NotificationChannelGroup(
                channelGroupKey: firebaseChannelGroupKey,
                channelGroupName: firebaseChannelGroupName)
          ]);
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print('FCM token: $token');
  }

  void uninit() async {
    NotificationRing.shared.uninit();
  }

  Future<void> requestNotificationPermission() async {
    requestFirebaseMessagePermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      requestAwesomeNotificationsPermission();
      listenAwesomeNotification();
    }
  }

  void requestFirebaseMessagePermission() async {
    // 1. Instantiate Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    print("FCM Token $token");

    // 2. On iOS, this helps to take the user permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // For handling the received notifications
    FirebaseMessaging.onMessage.listen(onFirebaseForegroundMessage);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      FirebaseMessaging.onMessageOpenedApp.listen(onFirebaseOpenedAppMessage);
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          onFirebaseForegroundMessage(message);
        }
      });
    }

    // 3. Grant permission, for iOS only, Android ignore by default
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      assert(false);
      print('User declined or has not accepted permission');
    }
  }

  void requestAwesomeNotificationsPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      List<NotificationPermission> requestedPermissions = [
        NotificationPermission.Sound,
        NotificationPermission.FullScreenIntent,
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
        NotificationPermission.Light,
      ];
      await AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: firebaseChannelKey, permissions: requestedPermissions);
    }
  }

  void listenAwesomeNotification() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      //  BEFORE!! MaterialApp widget, starts to listen the notification actions
      print('Listening message on android');
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: (ReceivedAction receivedAction) {
        onActionReceivedMethod(receivedAction, notiID);
        throw 'onActionReceivedMethod is null';
      });
    }
    ;
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification, int notiID) async {
    // Your code goes here

    print('Receive message: ' + receivedNotification.toString());
    AndroidForegroundService.stopForeground(notiID);
    IsolateNameServer.lookupPortByName(backgroundIsolatePortName)
        ?.send("stop_ring");

    if (receivedNotification.channelKey != firebaseChannelKey) {
      print('unknown channel key');
      return;
    }
    if (receivedNotification is ReceivedAction) {
      var action = receivedNotification;
      switch (action.buttonKeyPressed) {
        case 'decline':
          CallBloc.shared.add(CallInviteDecline());
          return;
        case 'accept':
          CallBloc.shared.add(CallInviteAccept(
              receivedNotification.payload!['roomID']!,
              receivedNotification.payload!.containsKey("targetUserIDList")));
          return;
        default:
          break;
      }
    }
    CallBloc.shared.add(CallReceiveInvited(
        receivedNotification.payload!['callerUserID']!,
        receivedNotification.payload!['callerUserName']!,
        receivedNotification.payload!['callerIconUrl']!,
        receivedNotification.payload!['roomID']!,
        receivedNotification.payload!.containsKey("targetUserIDList")));
  }

  Future<void> onFirebaseOpenedAppMessage(RemoteMessage message) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      onFirebaseForegroundMessage(message);
    }
  }

  Future<void> onFirebaseForegroundMessage(RemoteMessage message) async {
    // for more reliable and faster notification in foreground,
    // use listener in firebase manager

    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    CallBloc.shared.add(CallReceiveInvited(
        message.data['callerUserID'],
        message.data['callerUserName'],
        message.data['callerIconUrl'],
        message.data['roomID'],
        message.data.containsKey("targetUserIDList")));
    // CallBloc.shared.add(CallReceiveInvited(
    //     'BJc0ufgjK6cbdP3PivmYNWGwtfZ2',
    //     '"Wall World',
    //     'https://img.icons8.com/color/48/000000/avatar.png',
    //     'BJc0ufgjK6cbdP3PivmYNWGwtfZ2',
    //     false));
  }

  Future<void> onFirebaseRemoteMessageReceive(RemoteMessage message) async {
    print('remote message receive: ${message.data}');
    NotificationRing.shared.startRing();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final ReceivePort backgroundPort = ReceivePort();
      IsolateNameServer.registerPortWithName(
          backgroundPort.sendPort, backgroundIsolatePortName);
      backgroundPort.listen((dynamic message) {
        NotificationRing.shared.stopRing();
        backgroundPort.close();
        IsolateNameServer.removePortNameMapping(backgroundIsolatePortName);
      });

      AndroidForegroundService.startAndroidForegroundService(
        // AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notiID,
          groupKey: firebaseChannelGroupName,
          channelKey: firebaseChannelKey,
          title: "You have a new call",
          ticker: "You have a new call",
          body: "${message.data["callerUserName"]} is calling you.",
          largeIcon: 'asset://assets/images/invite_voice.png',
          category: NotificationCategory.Call,
          backgroundColor: Colors.white,
          roundedLargeIcon: true,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          payload: message.data.containsKey("targetUserIDList")
              ? {
                  "callerUserID": message.data["callerUserID"],
                  "callerUserName": message.data["callerUserName"],
                  "callerIconUrl": message.data["callerIconUrl"],
                  "roomID": message.data["roomID"],
                  "targetUserIDList": message.data["targetUserIDList"]
                }
              : {
                  "callerUserID": message.data["callerUserID"],
                  "callerUserName": message.data["callerUserName"],
                  "callerIconUrl": message.data["callerIconUrl"],
                  "roomID": message.data["roomID"]
                },
          notificationLayout: NotificationLayout.Default,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'accept',
            icon: 'asset://assets/images/invite_voice.png',
            label: 'Accept Call',
            color: Colors.green,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'decline',
            icon: 'asset://assets/images/invite_reject.png',
            label: 'Reject Call',
            color: Colors.red,
            autoDismissible: true,
          ),
        ],
      );
    } else {
      onFirebaseForegroundMessage(message);
    }
  }
}

// Declared as global, outside of any class
Future<void> onFirebaseBackgroundMessage(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationRing.shared.init();
  NotificationManager.shared.onFirebaseRemoteMessageReceive(message);
}
