import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest_all.dart' as tz;



class AlertNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> notificationSetup() async {
    tz.initializeTimeZones();
    await Firebase.initializeApp();
    const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, macOS: null);

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onSelectNotificationEmpLocation,
      onDidReceiveNotificationResponse: (details) {
          showGenericDialog(details.payload.toString());
      },
    );
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    var payloadData = payload;
    return Get.dialog(
        AlertDialog(
          content: Text(payloadData.toString()),
        )
    );
  }

  /// user tap on notification
  static onSelectNotificationEmpLocationOnApp(notificationResponse) async {
    var payloadData = notificationResponse.toString();
    showGenericDialogLocation("Hello", payloadData);
  }

  static onSelectNotificationEmpLocation(NotificationResponse notificationResponse) async {
    var payloadData = notificationResponse.payload.toString();
    showGenericDialog(payloadData);

  }

  static Future showGenericDialogLocation(String title,String body){
    return Get.defaultDialog(
        radius: 5,
        title: title,
        titlePadding: const EdgeInsets.only(top:15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        titleStyle:  GoogleFonts.nunitoSans(
          fontSize: Get.width*0.0455,
          fontWeight: FontWeight.w700,
        ),
        content: Text(body,
          style: GoogleFonts.nunitoSans(
            fontSize: Get.width*0.040,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,).paddingOnly(top:Get.width*0.015));
  }

  static Future showGenericDialog(String payloadData){
    return Get.dialog(
        AlertDialog(content: Text(payloadData.toString(), style: GoogleFonts.nunitoSans(
          fontSize: Get.width*0.045,
          fontWeight: FontWeight.w500,
        )),)
    );
  }



  @pragma('vm:entry-point')
  static void display(RemoteMessage message)async{
    print('hello597');
    print(message);
    print('hello597');
    try {
      print('hello599');
      // int id =  Random().nextInt(2147483647);
      const  NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(

            "home",
            "home channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );

      await flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload:  message.notification!.body,
      );

    } on Exception catch (_) {
      if (kDebugMode) {
        print('solve out the error local class error');
      }
    }
  }


  //suraj notification ui 14-10-24



}
/// all notification body end  *********************************************
