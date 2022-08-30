import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Colors.dart';

class NotificationUtils {
  static void showLocalNotification(context, title, message,void onTab(dynamic index)) {
    var f = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      borderColor: Colors.grey[300],
      onTap: onTab,
      borderRadius: BorderRadius.circular(10),
      icon: Image.asset("assets/images/hacker-2.png"),
      margin: const EdgeInsets.all(8),
      titleText: Text(title, style: Theme.of(context).textTheme.caption?.copyWith(color: PrimaryAppColor,fontSize: 15)),
      messageText: Text(message,  style: Theme.of(context).textTheme.caption?.copyWith(color: PrimaryAppColor)),
      duration: const Duration(seconds: 5),
      animationDuration: Duration(milliseconds: 300),
      mainButton: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("OK"),
      ),
    );
    f.show(context);
  }

  static Future setNotification(String notificationType, String email)async{

  }

  static Future showNotificationWithDefaultSound(
      String? title, String? message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'General Notifications',
        'General Notifications',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static sendNotification(fcm, title, body, code,Map<String,dynamic> data) {
    if (fcm == null) {
      return;
    }
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAA5PCa-aA:APA91bGefgEMyltKQwmqfh5shKcPq7p_z37rkKBifIwU1NgISgVOsejy8MqGq5C2q7peM_1cE8rXVekWyGQDj61h746PoseNE9kgxxBk_tYIoQQD1GLOKBTJNUpbUUB-bunT0FI3wRjX'
    };
    BaseOptions options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    Dio(options).post('https://fcm.googleapis.com/fcm/send', data: data.isEmpty ?{
      "to": "$fcm",
      "notification": {"title": "$title", "body": "$body"},
      "priority": "high",
      "sound": "default",
      "icon":"@mipmap/ic_launcher",
      "image":"https://firebasestorage.googleapis.com/v0/b/karaz-ec830.appspot.com/o/ic_launcher.png?alt=media&token=f6d0a0f8-fc84-4292-bf11-2c00bbe9e0f5",
      "data": {"click_action": code, "code": "$code"}
    } : data).then((value) => print("successfully send message"));
  }
}