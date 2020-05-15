import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_create_account.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  Authentication _authentication = GetIt.I.get<Authentication>();
  String email;
  String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Material(
      color: kMainColor,
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                    tag: 'appname',
                    child: Material(
                        color: kMainColor,
                        child: Text(
                          'So.SSul',
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ))),
                Padding(
                  padding: const EdgeInsets.only(top: 200, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          FontAwesomeIcons.envelope,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
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
                                Pattern emailPattern =
                                    r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
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
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(FontAwesomeIcons.key, color: Colors.white,),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onChanged: (text) {
                              password = text;
                            },
                            onFieldSubmitted: (text) async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await _authentication
                                    .signInEmail(
                                    context: context,
                                    email: email,
                                    password: password)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return '비밀번호를 입력하십시오.';
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
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await _authentication
                            .signInEmail(
                                context: context,
                                email: email,
                                password: password)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
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
          Visibility(
            child: Center(child: CircularProgressIndicator()),
            visible: isLoading,
          ),
        ],
      ),
    );
  }
}
