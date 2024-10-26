import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'display_all_notification.dart';

class PushNotificationServices {

  late FirebaseMessaging messaging;

  Future<void> setupInteractedMessage() async {
    AlertNotification alertNotification = AlertNotification();
    await Firebase.initializeApp();
   var notificationMessage ;
    FirebaseMessaging.instance.getInitialMessage().then((message)async{
      if(message!=null) {
        notificationMessage = message;

        debugPrint("this is my initial msg : ${message}");
        debugPrint("this is my initial msg : ${message.data}");
        debugPrint("this is my initial msg : ${message.toString()}");
        final outmsg = message.notification!.body;
        final locationRequestParameter = message.data['LocationRequest'];
        if(locationRequestParameter!=null){
          AlertNotification.onSelectNotificationEmpLocationOnApp(locationRequestParameter);
        }
        else{
          AlertNotification.onSelectNotificationEmpLocationOnApp(message.notification?.body);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      notificationMessage = message;
      debugPrint("this is my foreground msg : ${message}");
      debugPrint("this is my foreground msg : ${message.data}");
      debugPrint("this is my foreground msg : ${message.toString()}");
      AlertNotification.display(message); // this code help us to show message when the app is on foreground
    });

    // app is minimize and user tap on it notifi step 2
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      notificationMessage = message;

      debugPrint("this is my minimizeontap msg : ${message}");
      debugPrint("this is my minimizeontap msg : ${message.data}");
      debugPrint("this is my minimizeontap msg : ${message.toString()}");
      final locationRequestParameter = message.data['LocationRequest'];
      if(locationRequestParameter!=null){
        AlertNotification.onSelectNotificationEmpLocationOnApp(locationRequestParameter);
      }
      else{
        AlertNotification.onSelectNotificationEmpLocationOnApp(message.notification?.body);
      }
    });
  }
}