import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/database.dart';
import 'package:sossul/pages/page_create_account.dart';

import '../main.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  Authentication _authorization = Authentication();
  String email;
  String password;
  DBManager _dbManager = DBManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Our Logo'),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.email),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            email = text;
                          },
                        ),
                      ),
                      Text(
                        '이메일 형식에 안 맞습니다.',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.vpn_key),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      child: TextField(
                        maxLength: 12,
                        obscureText: true,
                        onChanged: (text) {
                          password = text;
                        },
                      ),
                    ),
                    Text(
                      '비밀번호는 숫자, 영문, 특수기호 포함 6~12자',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FlatButton(
                child: Container(
                  child: Text('Sign In'),
                ),
                onPressed: () async {
                  await _authorization
                      .signInEmail(
                          context: context, email: email, password: password)
                      .then((value) => () async {
                            var _currentUser =
                                await _authorization.auth.currentUser();
                            var userInfo = await _dbManager.loadUserInfo(
                                currentUser: _currentUser);
                            if (userInfo["nickname"] == null) {
                              showNickNameDialog(
                                  context: context,
                                  currentUser: _currentUser,
                                  dbManager: _dbManager);
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Main()),
                                  (route) => false);
                            }
                          });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: FlatButton(
                child: Text('계정 생성'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccountPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
