import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplifly/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:simplifly/services/auth_service.dart';

bool showSpinner = false;
final databaseReference = Firestore.instance;

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  Authentication authentication = Authentication();

  void _showDialog(title, txt) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(txt),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void createRecord() async {
    try {
      DocumentReference ref = await databaseReference
          .collection("users")
          .add({'username': txtname, 'email': txtemail});
      print(ref.documentID);
    } catch (x) {
      print(x);
    }
  }

  String txtemail = '';
  String txtpassword = '';
  String txtname = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        title: 'Create your account',
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Center(child: Text('Create your account')),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  bottom: TabBar(tabs: <Widget>[
                    Tab(
                      text: 'Sign up',
                    ),
                    Tab(
                      text: 'Login',
                    ),
                  ]),
                ),
                body: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            ButtonTheme(
                              minWidth: 300,
                              height: 40,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)),
                                onPressed: () async {
                                  FirebaseUser user =
                                      await authentication.googleSignIn();
                                  authentication.createUserRecord(user);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen()));
                                },
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text("Login using gmail".toUpperCase(),
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ButtonTheme(
                              minWidth: 300,
                              height: 40,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)),
                                onPressed: () async {
                                  FirebaseUser user =
                                      await authentication.facebookSignIn();
                                  authentication.createUserRecord(user);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen()));
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text(
                                    "Login using facebook".toUpperCase(),
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: Text('Or login using email address',
                                    style: TextStyle(fontSize: 16))),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                txtname = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Your Name",
                                icon: Icon(Icons.person),
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                txtemail = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Email",

                                //add icon outside input field
                                icon: Icon(Icons.email),
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                txtpassword = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                //add icon outside input field
                                icon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ButtonTheme(
                              minWidth: double.infinity,
                              child: RaisedButton(
                                color: Color.fromRGBO(59, 65, 74, 100),
                                onPressed: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    if (txtname.length == 0) {
                                      _showDialog(
                                          'Error', 'You Must enter your name');
                                      return;
                                    }
                                    if (txtemail.length == 0) {
                                      _showDialog(
                                          'Error', 'You must enter your email');
                                      return;
                                    }
                                    if (txtpassword.length == 0) {
                                      _showDialog(
                                          'Error', 'you must enter a password');
                                      return;
                                    }
                                    if (txtpassword.length < 0) {
                                      _showDialog('Error',
                                          'Password should be at least 6 characters');
                                      return;
                                    }

                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(txtemail);
                                    if (emailValid == false) {
                                      _showDialog(
                                          'Error', 'Invalid E-mail Address!');
                                    } else {
                                      print(txtemail);
                                      final newuser = await _auth
                                          .createUserWithEmailAndPassword(
                                              email: txtemail,
                                              password: txtpassword);
                                      if (newuser != null) {
                                        createRecord();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen()));
                                      }
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Text(
                                  'CREATE YOUR PROFILE',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        //Secnd Tab
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onChanged: (value) {
                              txtname = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Your Name",
                              icon: Icon(Icons.person),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              txtemail = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              icon: Icon(Icons.email),
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            onChanged: (value) {
                              txtpassword = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.lock),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton(
                              color: Color.fromRGBO(59, 65, 74, 100),
                              onPressed: () async {
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  if (txtname.length == 0) {
                                    _showDialog(
                                        'Error', 'You Must enter your name');
                                    return;
                                  }
                                  if (txtemail.length == 0) {
                                    _showDialog(
                                        'Error', 'You must enter your email');
                                    return;
                                  }
                                  if (txtpassword.length == 0) {
                                    _showDialog(
                                        'Error', 'you must enter a password');
                                    return;
                                  }
                                  if (txtpassword.length < 0) {
                                    _showDialog('Error',
                                        'Password should be at least 6 characters');
                                    return;
                                  }

                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(txtemail);
                                  if (emailValid == false) {
                                    _showDialog(
                                        'Error', 'Invalid E-mail Address!');
                                  } else {
                                    print(txtemail);
                                    final newuser =
                                        await _auth.signInWithEmailAndPassword(
                                            email: txtemail,
                                            password: txtpassword);
                                    if (newuser != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen()));
                                    }
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text(
                                'CREATE YOUR PROFILE',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}
