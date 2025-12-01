
import 'dart:async';

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:permission_handler/permission_handler.dart';





class LocalNotificationServices {

  // ✅ Singleton setup

  static final LocalNotificationServices _instance = LocalNotificationServices._internal();

  factory LocalNotificationServices() => _instance;

  LocalNotificationServices._internal();



  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =

  FlutterLocalNotificationsPlugin();



  static String? _timeZone;



  static StreamController<NotificationResponse> streamController =StreamController();



  static Future<void> onTap(NotificationResponse notificationResponse) async {

    print("🔔 Notification tapped with payload: ${notificationResponse.payload}");

    if (notificationResponse.id != null) {

      // await  LocalNotificationServices.cancelNotification(id: notificationResponse.id!);

    }



    streamController.add(notificationResponse);

  }



  static Future<void> init() async {


    final settings = const InitializationSettings(

      android: AndroidInitializationSettings('@mipmap/ic_launcher'),

      iOS: DarwinInitializationSettings(),

    );



    await flutterLocalNotificationsPlugin.initialize(

      settings,

      onDidReceiveNotificationResponse: onTap,

      onDidReceiveBackgroundNotificationResponse: onTap,

    );



FirebaseMessaging.onMessage.listen((RemoteMessage message) {

  print('🔔 Foreground message: ${message.notification?.title} - ${message.notification?.body}');



  // ممكن تحوله لإشعار محلي

  LocalNotificationServices.showBasicNotification(

    title: message.notification?.title ?? '',

    body: message.notification?.body ?? '',

  );

});



FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

  print('🔔 User tapped notification: ${message.data}');

});



    if (Platform.isAndroid) {

      var status = await Permission.notification.status;

      if (status.isDenied || status.isPermanentlyDenied) {

        final result = await Permission.notification.request();

        if (result.isGranted) {

          print('✅ تم منح إذن الإشعارات');

        }

      }

    }

  }



  static Future<void> showBasicNotification({

    String title = "title",

    String body = "body",

    int id = 0,

    String? payload,

    String? soundPath,

  }) async {

    final notificationDetails = NotificationDetails(

      android: AndroidNotificationDetails(



        //soundPathشيل منه assets/

        sound: (soundPath!=null)?RawResourceAndroidNotificationSound(soundPath.split('.').first):null,







        'id_0',

        'basic notification',

        importance: Importance.max,

        priority: Priority.high,

        visibility: NotificationVisibility.public,

        autoCancel: false, // ما يختفيش لو الشاشة اتقفلت

      ),

      iOS: DarwinNotificationDetails(),

    );



    await flutterLocalNotificationsPlugin.show(

      id,

      title,

      body,

      notificationDetails,

      payload: payload,

    );

  }












  static Future<void> cancelNotification({required int id}) async {

    await flutterLocalNotificationsPlugin.cancel(id);

  }



  static Future<void> cancelAllNotification() async {

    await flutterLocalNotificationsPlugin.cancelAll();

  }


}

