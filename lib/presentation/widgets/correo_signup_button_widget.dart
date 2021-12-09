import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pastillero/presentation/pages/correo_login.dart/login_con_correo.dart';

class CorreoSignupButtonWidget extends StatelessWidget {
  const CorreoSignupButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        child: OutlineButton.icon(
          label: const Text(
            'Inicia sesión con correo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.black,
          borderSide: const BorderSide(color: Colors.black),
          textColor: Colors.black,
          icon: const FaIcon(FontAwesomeIcons.envelope, color: Colors.grey),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginCorreo()));
          },
        ),
      );
}
