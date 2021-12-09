import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pastillero/presentation/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  const GoogleSignupButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        child: OutlineButton.icon(
            label: const Text(
              'Inicia sesión con Google',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            highlightedBorderColor: Colors.black,
            borderSide: const BorderSide(color: Colors.black),
            textColor: Colors.black,
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            }),
      );
}
