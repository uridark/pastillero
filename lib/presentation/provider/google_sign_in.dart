import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> facebookLogout() async {
    final loggedIn = await _facebookLogin.isLoggedIn;
    if (loggedIn) await _facebookLogin.logOut();
    notifyListeners();
  }

  Future logout() async {
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    } else {
      FirebaseAuth.instance.signOut();
    }
    notifyListeners();
  }
}
