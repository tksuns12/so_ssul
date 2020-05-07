import 'package:flutter/material.dart';
import 'package:sossul/authorization.dart';
import 'package:sossul/pages/page_email_sign_in.dart';

import '../main.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('So.SSul'),
            FlatButton(
              child: Text('이메일로 로그인'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailSignIn(),
                  ),
                );
              },
            ),
            GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  Image buttonImage = Image.asset(
    'assets/images/google_sign_in_buttons/normal.png',
    scale: 1.5,
  );

  Authorization _authorization = Authorization();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: buttonImage,
      onTapDown: (detail) {
        setState(() {
          buttonImage = Image.asset(
            'assets/images/google_sign_in_buttons/pressed.png',
            scale: 1.5,
          );
        });
      },
      onTapUp: (detail) async {
        setState(() {
          buttonImage = Image.asset(
            'assets/images/google_sign_in_buttons/normal.png',
            scale: 1.5,
          );
        });
        await _authorization.signInGoogle(context: context).whenComplete(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Main()), (route) => false);
        });
      },
      onTapCancel: () {
        setState(() {
          buttonImage = Image.asset(
            'assets/images/google_sign_in_buttons/normal.png',
            scale: 1.5,
          );
        });
      },
    );
  }
}
