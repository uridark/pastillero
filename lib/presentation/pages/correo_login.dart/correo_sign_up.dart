import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pastillero/presentation/provider/email_signin.dart';
import 'package:pastillero/presentation/widgets/background_painter.dart';
import 'package:provider/provider.dart';

class SignUpWidget2 extends StatefulWidget {
  const SignUpWidget2({Key? key}) : super(key: key);

  @override
  State<SignUpWidget2> createState() => _SignUpWidget2State();
}

class _SignUpWidget2State extends State<SignUpWidget2> {
  final _formerKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: BackgroundPainter2()),
            buildAuthForm(context),
          ],
        ),
      );
  Widget buildAuthForm(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formerKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildEmailField(context),
                  if (!provider.isLogin) buildUsernameField(context),
                  if (!provider.isLogin) buildDatePicker(context),
                  buildPasswordField(context),
                  const SizedBox(height: 12),
                  buildButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);
    final dateOfBirth = provider.dateOfBirth;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(
            'Date of Birth',
            style: TextStyle(color: Colors.grey[700]),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
                '${dateOfBirth.year} - ${dateOfBirth.month}- ${dateOfBirth.day}'),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 80),
                lastDate: DateTime(DateTime.now().year + 1),
                initialDate: dateOfBirth,
              );

              if (date != null) {
                provider.dateOfBirth = date;
              }
            },
          ),
          Divider(color: Colors.grey[700])
        ],
      ),
    );
  }

  Widget buildUsernameField(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: const ValueKey('username'),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      validator: (value) {
        if (value!.isEmpty || value.length < 4 || value.contains(' ')) {
          return 'Inserta al menos 4 caracteres sin espacio';
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(labelText: 'Username'),
      onSaved: (username) => provider.userName = username!,
    );
  }

  Widget buildButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    if (provider.isLoading) {
      return const CircularProgressIndicator();
    } else {
      return Column(
        children: [
          buildLoginButton(context),
          buildSignupButton(context),
        ],
      );
    }
  }

  Widget buildLoginButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return OutlineButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      highlightedBorderColor: Colors.black,
      borderSide: const BorderSide(color: Colors.black),
      textColor: Colors.black,
      child: Text(provider.isLogin ? 'Acceso' : 'Registrate'),
      onPressed: () => submit(context),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: Text(
        provider.isLogin ? 'Crea una nueva cuenta' : 'Ya tengo una cuenta',
      ),
      onPressed: () => provider.isLogin = !provider.isLogin,
    );
  }

  Widget buildEmailField(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: const ValueKey('email'),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      validator: (value) {
        const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
        final regExp = RegExp(pattern);

        if (!regExp.hasMatch(value!)) {
          return 'Ingresa un correo valido';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Correo electronico'),
      onSaved: (email) => provider.userEmail = email!,
    );
  }

  Widget buildPasswordField(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: const ValueKey('password'),
      validator: (value) {
        if (value!.isEmpty || value.length < 7) {
          return 'La contraseña debe ser al menos de 7 caracteres';
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      onSaved: (password) => provider.userPassword = password!,
    );
  }

  Future submit(BuildContext context) async {
    final provider = Provider.of<EmailSignInProvider>(context, listen: false);

    final isValid = _formerKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formerKey.currentState!.save();

      final isSuccess = await provider.login();

      if (isSuccess!) {
        Navigator.of(context).pop();
      } else {
        const message = 'Upps, hubo un error checa tus credenciales!';

        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            content: const Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }
}
