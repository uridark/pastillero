import 'package:flutter/material.dart';
import 'package:pastillero/presentation/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pastillero/presentation/pages/my_home/my_home.dart';
import 'package:pastillero/presentation/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'api/notification_api.dart';
import 'presentation/provider/email_signin.dart';
import 'presentation/provider/facebook_signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationApi.init(initScheduled: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    listenNotifications();
    NotificationApi.init(initScheduled: true);
  }

  void listenNotifications() =>
      NotificationApi.onNotification.stream.listen((onClickedNotification));
  void onClickedNotification(String payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const MyHome()));

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
            ChangeNotifierProvider(create: (context) => EmailSignInProvider()),
            ChangeNotifierProvider(create: (context) => LogInWithFacebook()),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            home: Login(),
          ));
}
