import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailSignInProvider extends ChangeNotifier {
  late bool _isLoading;
  late bool _isLogin;
  late String _userEmail;
  late String _userPassword;
  late String _userName;
  late DateTime _dateOfBirth;

  EmailSignInProvider() {
    _isLoading = false;
    _isLogin = true;
    _userEmail = '';
    _userPassword = '';
    _userName = '';
    _dateOfBirth = DateTime.now();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }

  String get userPassword => _userPassword;

  set userPassword(String value) {
    _userPassword = value;
    notifyListeners();
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  DateTime get dateOfBirth => _dateOfBirth;

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  Future<bool?> login() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      isLoading = true;

      print(userEmail);
      print(userPassword);

      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      } else {
        try {
          UserCredential result = await _auth.createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
          User? user = result.user;
          user?.updateProfile(displayName: _userName); //added this line
        } catch (e) {
          print(e.toString());
          return null;
        }
      }

      isLoading = false;
      return true;
    } catch (err) {
      print(err);
      isLoading = false;
      return false;
    }
  }
}
