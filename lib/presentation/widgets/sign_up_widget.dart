import 'package:flutter/material.dart';
import 'package:pastillero/presentation/widgets/background_painter.dart';
import 'package:pastillero/presentation/widgets/correo_signup_button_widget.dart';
import 'package:pastillero/presentation/widgets/facebook_signup_button_widget.dart';
import 'package:pastillero/presentation/widgets/google_signup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomPaint(painter: BackgroundPainter()),
          buildSignUp(),
          SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 500,
                ),
                GoogleSignupButtonWidget(),
                FacebookSignupButtonWidget(),
                CorreoSignupButtonWidget(),
                SizedBox(height: 12),
                Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildSignUp() => Column(
        children: <Widget>[
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: 175,
              child: const Text(
                'Bienvenido, Inicia sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Spacer(),
        ],
      );
}
