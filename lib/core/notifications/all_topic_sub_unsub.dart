import 'package:firebase_messaging/firebase_messaging.dart';


class TopicSubscribe {
  
   FirebaseMessaging? _firebaseMessaging;
   
   TopicSubscribe(){
      _firebaseMessaging  = FirebaseMessaging.instance;
   }

  subsAllTopic() async {
    await  _firebaseMessaging?.subscribeToTopic('admin');
   }



  unSubAllTopic() async{
    await _firebaseMessaging?.unsubscribeFromTopic('admin');

 }

}
