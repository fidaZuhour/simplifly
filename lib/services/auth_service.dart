import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simplifly/screens/register.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Authentication{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
   FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> googleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    }
    else {
      final GoogleSignInAccount googleUser =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential =
      GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  void createUserRecord(FirebaseUser user) async {
    try {
       await databaseReference
          .collection("users")
          .add({'username': user.displayName, 'email': user.email});

    } catch (x) {
      print(x);
    }
  }

  Future<FirebaseUser> facebookSignIn() async{
    final FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    AuthCredential authCredential = FacebookAuthProvider.getCredential(accessToken: facebookAccessToken.token);
    FirebaseUser fbUser;
    fbUser = (await _auth.signInWithCredential(authCredential)).user;
    return fbUser;

  }


}