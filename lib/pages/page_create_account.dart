import 'package:flutter/material.dart';

import '../authorization.dart';
import '../main.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String email;
  String password;
  Authorization _authorization = Authorization();
  _CreateAccountPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Our Logo'),
          Row(
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
                child: Text('계정 만들기'),
              ),
              onPressed: () async {
                var message1 = await _authorization.createEmailAccount(
                    context: context, email: email.trim(), password: password);
                if (message1 == 'AccountCreateSucceed') {
                  var message2 = await _authorization.signInEmail(
                      context: context,
                      email: email.trim(),
                      password: password);
                  if (message2 == 'SignInSucceed') {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Main()));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
