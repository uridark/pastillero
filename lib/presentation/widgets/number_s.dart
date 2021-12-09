import 'package:flutter/material.dart';
import 'package:pastillero/presentation/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class Numberswidget extends StatelessWidget {
  const Numberswidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          builddivider(),
          buildbutton(
              text: 'Cerrar sesión',
              icon: const Icon(
                Icons.logout_sharp,
              ),
              context: context),
        ],
      );
  Widget builddivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );
  Widget buildbutton({
    BuildContext? context,
    String? text,
    Icon? icon,
  }) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context!, listen: false);
          provider.logout();
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            icon!,
            const SizedBox(
              height: 2,
            ),
            Text(text!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
}
