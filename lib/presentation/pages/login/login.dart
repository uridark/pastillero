import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pastillero/presentation/pages/my_home/my_home.dart';
import 'package:pastillero/presentation/widgets/sign_up_widget.dart';

class Login extends StatelessWidget {
  static const String title = 'Inicio de sesión';

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: const MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String? title;

  // ignore: use_key_in_widget_constructors
  const MainPage({
    this.title,
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
              return const SignUpWidget();
            }
          }));
}
