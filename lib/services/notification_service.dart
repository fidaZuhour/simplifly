import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class NotificationScreen {
  final databaseReference = Firestore.instance;
  List<Message> messagesList;
  List<String> tokens = List<String>();

  Future<String> configureFirebaseListeners() async {
    String token = await _getToken();
    bool isExist =await isTokenExist(token);
    if (!isExist) {
      addToken(token);
    }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );

  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
    Message msg = Message(title, body, mMessage);
    messagesList.add(msg);
  }

  Future<String> _getToken() async {
    String newToken;
    await _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
      newToken = token;
    });
    return newToken;
  }

  Future<bool> isTokenExist(String token) async {
    tokens.clear();
   await databaseReference
        .collection("DeviceIDTokens")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((snap) {
        tokens.add(snap.data['device_token']);
      });
    });
    for (int i = 0; i < tokens.length; i++) {
      if (token == tokens[i]) return true;
    }
    return false;
  }

  addToken(String token) {
    if(token != null){
    databaseReference.collection("DeviceIDTokens").add({
      'device_token': token,
    });
    }
  }
}

class Message {
  String title;
  String body;
  String message = " ";

  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
