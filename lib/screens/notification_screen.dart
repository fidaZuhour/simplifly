import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class NotificationScreen {
  final databaseReference = Firestore.instance;
  List<Message> messagesList;
  List<String> tokens = List<String>();

  void configureFirebaseListeners() {
    String token = _getToken();
    if (!isTokenExist(token)) {
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

  String _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
      return token;
    });
  }

  bool isTokenExist(String token) {
    databaseReference
        .collection("DeviceIDTokens")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((snap) {
        String tok = snap.data['device_token'].toString();
        print("device_token $tok");
        tokens.add(tok);
      });
    });
    for (int i = 0; i < tokens.length; i++) {
      if (token == tokens[i]) return true;
    }

    return false;
  }

  addToken(String token) {
    databaseReference.collection("DeviceIDTokens").add({
      'device_token': token,
    });
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
