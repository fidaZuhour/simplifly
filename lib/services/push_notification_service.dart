
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService{
  final FirebaseMessaging fbm = FirebaseMessaging();

  Future initialize(){

    fbm.configure(
      onMessage: (Map<String , dynamic> message) async{
        print('OnMessage : $message');
      },

      onResume: (Map<String , dynamic> message) async{
      print('OnMessage : $message');
    },
    onLaunch: (Map<String , dynamic> message) async{
      print('OnMessage : $message');
    }

    );

  }
}