import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sossul/database.dart';

import '../authentication.dart';
import '../main.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String email;
  String password;
  Authentication _authorization = Authentication();
  DBManager dbManager = DBManager();
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
                await _authorization
                    .createEmailAccount(
                        context: context,
                        email: email.trim(),
                        password: password)
                    .then((value) async {
                  FirebaseUser _currentUser =
                      await _authorization.auth.currentUser();
                  setNickNameDialog(context, _currentUser);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future setNickNameDialog(BuildContext context, FirebaseUser _currentUser) {
    final _formKey = GlobalKey<FormState>();
    String _nickName;
    return showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: AlertDialog(
                      title: Text('별명 짓기'),
                      content: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "별명", hintText: "별명은 한글 2~6자"),
                              maxLength: 6,
                              onChanged: (text) {
                                _nickName = text;
                              },
                              validator: (value) {
                                Pattern nickNamePattern = r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$';
                                RegExp nickNameRegex = RegExp(nickNamePattern);
                                if (dbManager.nickNameAlreadyUsed(nickName: _nickName)) {
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
                                dbManager.setUserNickName(currentUser: _currentUser, nickName: _nickName);
                                _authorization.signInEmail(context: context, email: email, password: password);
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Main()), (route) => false);
                              }
                            },
                            child: Text('확인'))
                      ],
                    ));
  }
}
