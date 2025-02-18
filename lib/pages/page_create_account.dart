import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sossul/database.dart';

import '../authentication.dart';
import '../constants.dart';
import '../main.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String email;
  String password;
  Authentication _authorization = GetIt.I.get<Authentication>();
  DBManager dbManager = GetIt.I.get<DBManager>();
  bool isLoading = false;
  _CreateAccountPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kMainColor,
        child: Stack(
      children: <Widget>[
        Column(
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
                        textInputAction: TextInputAction.done,
                        maxLength: 12,
                        obscureText: true,
                        onChanged: (text) {
                          password = text;
                        },
                        onSubmitted: (text) async {

                          setState(() {
                            isLoading = true;
                          });
                          await _authorization
                              .createEmailAccount(
                              context: context,
                              email: email.trim(),
                              password: password)
                              .then((value) async {
                            FirebaseUser _currentUser =
                            await _authorization.auth.currentUser();
                            setState(() {
                              isLoading = false;
                            });
                            setNickNameDialog(context, _currentUser);
                          });
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
                  child: Text('계정 만들기'),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await _authorization
                      .createEmailAccount(
                          context: context,
                          email: email.trim(),
                          password: password)
                      .then((value) async {
                    FirebaseUser _currentUser =
                        await _authorization.auth.currentUser();
                    setState(() {
                      isLoading = false;
                    });
                    setNickNameDialog(context, _currentUser);
                  });
                },
              ),
            ),
          ],
        ),
        Visibility(
          child: Center(child: CircularProgressIndicator()),
          visible: isLoading,
        ),
      ],
    ));
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
                  decoration:
                      InputDecoration(labelText: "별명", hintText: "별명은 한글 2~6자"),
                  maxLength: 6,
                  onChanged: (text) {
                    _nickName = text;
                  },
                  validator: (value) {
                    Pattern nickNamePattern = r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$';
                    RegExp nickNameRegex = RegExp(nickNamePattern);
                    if (!nickNameRegex.hasMatch(value)) {
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
                onPressed: () async {
                  bool isAlreadyUsed =
                      await dbManager.nickNameAlreadyUsed(nickName: _nickName);
                  if (isAlreadyUsed) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("별명 중복"),
                        content: Text('이미 있는 별명입니다.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                  } else if (_formKey.currentState.validate()) {
                    dbManager.setUserNickName(
                        currentUser: _currentUser, nickName: _nickName);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Main()),
                        (route) => false);
                  }
                },
                child: Text('확인'))
          ],
        ));
  }
}
