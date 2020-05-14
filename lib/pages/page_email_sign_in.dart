import 'package:flutter/material.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/pages/page_create_account.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  Authentication _authorization = Authentication();
  String email;
  String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: Stack(children: <Widget>[
          Column(
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
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FlatButton(
                  child: Container(
                    child: Text('로그인'),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _authorization
                        .signInEmail(
                        context: context, email: email, password: password).then((value) {
                          setState(() {
                            isLoading = false;
                          });
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
          Visibility(child: Center(child: CircularProgressIndicator()), visible: isLoading,),
        ],),
      ),
    );
  }
}