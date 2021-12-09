import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pastillero/presentation/provider/facebook_signin.dart';
import 'package:provider/provider.dart';

class FacebookSignupButtonWidget extends StatelessWidget {
  const FacebookSignupButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        child: OutlineButton.icon(
          label: const Text(
            'Inicia sesión Facebook',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          highlightedBorderColor: Colors.black,
          borderSide: const BorderSide(color: Colors.black),
          textColor: Colors.black,
          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          onPressed: () {
            final provider =
                Provider.of<LogInWithFacebook>(context, listen: false);
            provider.signInWithFacebook();
          },
        ),
      );
}
