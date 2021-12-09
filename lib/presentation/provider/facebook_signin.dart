import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class LogInWithFacebook extends ChangeNotifier {
  Map? userData;
  final _firebaseAuth = FirebaseAuth.instance;
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    if (response.status == FacebookLoginStatus.success) {
      final accessToken = response.accessToken;
      final userCredential = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(accessToken!.token),
      );
      return userCredential.user!;
    }

    if (response.status == FacebookLoginStatus.cancel) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
    if (response.status == FacebookLoginStatus.error) {
      throw FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_FAILED',
        message: response.error!.developerMessage,
      );
    }
  }
}
