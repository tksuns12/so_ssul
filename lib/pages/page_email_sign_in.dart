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
    final _formKey = GlobalKey<FormState>();
    return Container(
      child: Material(
        child: Stack(children: <Widget>[
          Form(
            key: _formKey,
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
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (text) {
                                email = text;
                              },
                              validator: (value) {
                                Pattern emailPattern = r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
                                RegExp emailRegex = RegExp(emailPattern);
                                if (!emailRegex.hasMatch(value)) {
                                  return "이메일 주소 형식이 안 맞습니다.";
                                } else {
                                  return null;
                                }
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
                          child: TextFormField(
                            maxLength: 12,
                            obscureText: true,
                            onChanged: (text) {
                              password = text;
                            },
                            validator: (value) {
                              Pattern passwordPattern = r'^(?=.*[a-z])(?=.*[0-9])(?=.{8,12})$';
                              RegExp passwordRegex = RegExp(passwordPattern);
                              if (!passwordRegex.hasMatch(value)) {
                                return '비밀번호는 영문, 숫자 8-12 자리입니다.';
                              } else {
                                return null;
                              }
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
          ),
          Visibility(child: Center(child: CircularProgressIndicator()), visible: isLoading,),
        ],),
      ),
    );
  }
}