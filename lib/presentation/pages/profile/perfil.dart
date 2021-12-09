import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:pastillero/presentation/widgets/number_s.dart';

class Perfil extends StatefulWidget {
  Perfil({Key? key}) : super(key: key);
  final plugin = FacebookLogin(debug: true);

  @override
  State<Perfil> createState() => PerfilBody();
}

class PerfilBody extends State<Perfil> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[buildtop(user!), buildContent(user)],
      ),
    );
  }

  Widget buildtop(User user) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: builderCoverImage(),
          ),
          Positioned(
            top: top,
            child: builderProfileImage(user),
          ),
        ]);
  }

  Widget buildContent(User user) => Column(
        children: [
          const SizedBox(height: 8),
          const Text('Usuario',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 8,
          ),
          Text('Nombre: ' + user.displayName!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Numberswidget(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          buildAbout(user),
          const SizedBox(height: 32),
        ],
      );
  Widget buildAbout(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text(
            'Detalles',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Al usar esta aplicación es bajo tu propia responsabilidad, todos los medicamentos son bajo tu propio riesgo y tenemos un limite de 5 medicamentos para tu propia salud',
            style: TextStyle(fontSize: 18, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget builderCoverImage() => Container(
      color: Colors.lightBlue[50],
      child: Image.asset(
        'assets/images/imagen2.jpg',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ));

  Widget builderProfileImage(User user) {
    var url = user.photoURL as String;
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: user.photoURL == null
          ? const AssetImage('assets/images/login-circle.png')
          : NetworkImage(url) as ImageProvider,
    );
  }
}
