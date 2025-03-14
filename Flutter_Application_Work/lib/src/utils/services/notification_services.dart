import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'package:rough_app/src/common_widgets/toast_widget/toast_widget.dart';
import 'package:rough_app/src/features/screens/chat_screen/receiver_chat_screen.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/receiver_group_chat_screen.dart';
import 'package:rough_app/src/utils/services/database.dart';

import '../../constants/text_strings.dart';
import '../../features/screens/group_chat_screen/group_chat_screen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted Notification permissions.");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted Notification provisional permissions.");
    } else {
      print("User denied Notification permissions.");
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: "Channel for Invite Notifications.",
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void localNotificationInit(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void firebaseMessagingInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      // print(message.notification!.title.toString());
      // print(message.notification!.body.toString());

      if (Platform.isAndroid) {
        if (message.data["type"] == "Alert") {
          ToastWidget().raiseToast(context, message.data["message"]);
        } else {
          localNotificationInit(context, message);
          showNotification(message);
        }
      } else {
        showNotification(message);
      }
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data["type"] == "chatRoomInvite") {
      Get.offAll(() => ReceiverChatScreen(
            chatRoomID: message.data["chatRoomID"],
            senderID: message.data["senderID"],
            senderEmail: message.data["senderEmail"],
            senderUserName: message.data["senderUserName"],
            senderDisplayName: message.data["senderDisplayName"],
            senderProfilePic: message.data["senderProfilePic"],
            senderToken: message.data["senderToken"],
          ));
    } else if (message.data["type"] == "groupInvite") {

      Get.offAll(() => ReceiverGroupChatScreen(
          groupID: message.data["groupID"],
          groupName: message.data["groupName"],
          groupCreatorUserName: message.data["groupCreatorUserName"],
          senderID: message.data["senderID"],
          senderEmail: message.data["senderEmail"],
          senderUserName: message.data["senderUserName"],
          senderDisplayName: message.data["senderDisplayName"],
          senderProfilePic: message.data["senderProfilePic"],
          senderToken: message.data["senderToken"]));
    }
  }

  Future<void> interactWithNotification(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app is backgrounded
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  void sendPushNotificationToUser(String token,
      Map<String, String> notificationDetails, Map dataInfoMap) async {
    var payload = {
      'to': token,
      'priority': 'high',
      'notification': {
        'title': '${notificationDetails["title"]}',
        'body': '${notificationDetails["body"]}'
      },
      'data': dataInfoMap
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAATNywlaU:APA91bH2pESkNVqvpw6DRJVX_RODsclo14rBLelQhHOmE-O7uqa6NMCUttLGztVJPHsTa5DlwW19eLAPayuFzsrrCOWEoATRllIcQcgCfqEQFBRatEAUuDQ70ofSsKliQMqStC_OLZwf'
        },
        body: jsonEncode(payload));
  }

  // void sendPushNotificationToUser(
  //     String token,
  //     Map<String, dynamic> roomDetails,
  //     Map<String, dynamic> senderDetails) async {
  //   var payload = {
  //     'to': token,
  //     'priority': 'high',
  //     'notification': {
  //       'title': '${roomDetails["roomType"]} Invite',
  //       'body':
  //           '${senderDetails["UserName"]} invites you to join his ${roomDetails["roomType"]}'
  //     },
  //     'data': {
  //       'type': '${roomDetails["roomType"]}Invite',
  //       '${roomDetails["roomType"]}ID': roomDetails["roomID"],
  //       'senderID': '${senderDetails["UserID"]}',
  //       'senderEmail': '${senderDetails["UserEmail"]}',
  //       'senderUserName': '${senderDetails["UserName"]}',
  //       'senderDisplayName': '${senderDetails["UserDisplayName"]}',
  //       'senderProfilePic': '${senderDetails["UserProfilePic"]}',
  //       'senderToken': '${senderDetails["UserToken"]}',
  //     }
  //   };
  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization':
  //             'key=AAAATNywlaU:APA91bH2pESkNVqvpw6DRJVX_RODsclo14rBLelQhHOmE-O7uqa6NMCUttLGztVJPHsTa5DlwW19eLAPayuFzsrrCOWEoATRllIcQcgCfqEQFBRatEAUuDQ70ofSsKliQMqStC_OLZwf'
  //       },
  //       body: jsonEncode(payload));
  // }
  //
  // void sendAlertToUser(
  //   String token,
  //   Map<String, dynamic> alertDetails,
  // ) async {
  //   var payload = {
  //     'to': token,
  //     'priority': 'high',
  //     'notification': {
  //       'title': '${alertDetails["type"]} Alert',
  //       'body': '${alertDetails["message"]}'
  //     },
  //     'data': {
  //       'type': 'Alert',
  //       'message': '${alertDetails["message"]}',
  //     }
  //   };
  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization':
  //             'key=AAAATNywlaU:APA91bH2pESkNVqvpw6DRJVX_RODsclo14rBLelQhHOmE-O7uqa6NMCUttLGztVJPHsTa5DlwW19eLAPayuFzsrrCOWEoATRllIcQcgCfqEQFBRatEAUuDQ70ofSsKliQMqStC_OLZwf'
  //       },
  //       body: jsonEncode(payload));
  // }

  //Token Management

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      gAccountUserFCMToken = token;
    }
    DatabaseMethods().addTokenDataToUserInfo(token!, gAccountID);
    return token;
  }

  void hasTokenRefreshed() async {
    messaging.onTokenRefresh.listen((token) {
      print("FCM token has been refreshed for this device.");
      DatabaseMethods().addTokenDataToUserInfo(token, gAccountID);
    });
  }
}
