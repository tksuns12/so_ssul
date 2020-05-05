import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sossul/pages/page_create_account.dart';

import '../abstract_basic_auth.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;

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
              child: Text('Sign In'),
            ),
            onPressed: () {
              try {
                _auth.signInWithEmailAndPassword(
                    email: email, password: password);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('로그인 실패'),
                      content: Text('계정이 없거나 아이디/비밀번호를 잘못 입력하셨습니다.'),
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
            },
          ),
          FlatButton(
            child: Text('계정 만들기'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccountPage()));
            },
          ),
        ],
      ),
    );
  }
}
