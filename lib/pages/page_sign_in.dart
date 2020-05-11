import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/database.dart';
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
  DBManager _dbManager = DBManager();
  Image buttonImage = Image.asset(
    'assets/images/google_sign_in_buttons/normal.png',
    scale: 1.5,
  );

  Authentication _authorization = Authentication();

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
        await _authorization.signInGoogle(context: context);
        FirebaseUser _currentUser = await _authorization.auth.currentUser();
        if (_currentUser.uid != null) {
          Map userInfo =
              await _dbManager.loadUserInfo(currentUser: _currentUser);
          print(userInfo);
          if (userInfo['nickname'] == null) {
            showNickNameDialog(
                context: context,
                currentUser: _currentUser,
                dbManager: _dbManager);
          } else {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Main()), (route) => false);
          }
        }
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

Future showNickNameDialog(
    {@required BuildContext context,
    @required FirebaseUser currentUser,
    @required DBManager dbManager}) {
  final _formKey = GlobalKey<FormState>();
  String _nickName;
  return showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Text('별명 짓기'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                decoration:
                    InputDecoration(labelText: "별명", hintText: "별명은 한글 2~6자"),
                maxLength: 6,
                onChanged: (text) {
                  _nickName = text;
                },
                validator: (value) {
                  Pattern nickNamePattern = r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$';
                  RegExp nickNameRegex = RegExp(nickNamePattern);
                  if (dbManager
                          .loadUserInfo(currentUser: currentUser)
                          .then((value) => value["nickname"]) ==
                      null) {
                    return "이미 있는 별명입니다.";
                  } else if (!nickNameRegex.hasMatch(value)) {
                    return "별명은 숫자 포함 한글 2~6자 사이입니다.";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  dbManager.setUserNickName(
                      currentUser: currentUser, nickName: _nickName);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Main()),
                      (route) => false);
                }
              },
              child: Text('확인'))
        ],
      ));
}
