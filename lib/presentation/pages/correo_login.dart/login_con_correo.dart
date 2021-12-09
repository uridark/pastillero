import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pastillero/presentation/pages/correo_login.dart/correo_sign_up.dart';
import 'package:pastillero/presentation/pages/my_home/my_home.dart';

class LoginCorreo extends StatelessWidget {
  static const String title = 'Inicio de sesión';

  const LoginCorreo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: const MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const MyHome();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("ERROR"),
              );
            } else {
              return const SignUpWidget2();
            }
          }));
}
