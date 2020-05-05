import 'package:firebase/firebase.dart';
import 'package:firebase/firebase_io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String email;
  String password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  _CreateAccountPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Text('Our Logo'),
          Row(
            children: <Widget>[
              Icon(Icons.email),
              Column(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      email = text;
                    },
                  ),
                  Text('이메일 형식에 안 맞습니다.'),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.vpn_key),
              Column(
                children: <Widget>[
                  TextField(
                    maxLength: 12,
                    obscureText: true,
                    onChanged: (text) {
                      password = text;
                    },
                  ),
                  Text('비밀번호는 숫자, 영문, 특수기호 포함 6~12자'),
                ],
              )
            ],
          ),
          FlatButton(
            child: Container(
              child: Text('계정 만들기'),
            ),
            onPressed: () {
              try {
                _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
              } catch (e) {
                switch (e.code) {
                  case 'ERROR_WEAK_PASSWORD':
                    accountCreateErrorDialog(context, message: '비밀번호가 너무 단순합니다.');
                    break;
                  case 'ERROR_INVALID_EMAIL':
                    accountCreateErrorDialog(context, message: '이메일 형식이 안 맞습니다.');
                    break;
                  case 'ERROR_EMAIL_ALREADY_IN_USE':
                    accountCreateErrorDialog(context, message: '이미 사용 중인 이메일입니다.');
                    break;
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future accountCreateErrorDialog(BuildContext context, {@required String message}) {

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 실패'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
