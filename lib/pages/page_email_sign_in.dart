import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authorization.dart';
import 'package:sossul/pages/page_create_account.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  Authorization _authorization = Authorization();
  String email;
  String password;
  SharedPreferences prefs;

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
                  await _authorization.signInEmail(
                      context: context, email: email, password: password);
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
