import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_email_sign_in.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: kDarkPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(tag: 'appname',
          child: Material(color: kDarkPrimaryColor,child: Text('So.SSul', style: TextStyle(fontSize: 60, color: Colors.white),))),
          SizedBox(height: 80,),
          FlatButton(
            child: Container(
              width: 245,
              height: 50,
              child: Center(child: Text('이메일로 로그인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailSignInPage(),
                ),
              );
            },
          ),
          SizedBox(height: 10,),
          GoogleSignInButton(),
        ],
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

  Authentication _authentication = GetIt.I.get<Authentication>();

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
        await _authentication.signInGoogle(context: context);
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
