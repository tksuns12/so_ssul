import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../abstract_basic_auth.dart';

class EmailSignIn extends StatefulWidget {
  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
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
                  TextField(),
                  Text('이메일 형식에 안 맞습니다.'),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.email),
              Column(
                children: <Widget>[
                  TextField(
                    maxLength: 12,
                    obscureText: true,
                  ),
                  Text('비밀번호는 숫자, 영문, 특수기호 포함 6~12자'),
                ],
              )
            ],
          ),
          FlatButton(child: Container(child: Text('Sign In'),), onPressed: () {signInWithEmail();},),
          FlatButton(
            child: Text('계정 만들기'),
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }

  void signInWithEmail() {

  }
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  Future<FirebaseUser> getCurrentUser() async {
    _user = await _firebaseAuth.currentUser();
    return _user;
  }

  @override
  bool isEmailVerified() {
    return _user.isEmailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    _user.sendEmailVerification();
  }

  @override
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    _user = result.user;
    return _user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) {
    // TODO: implement signUp
    return null;
  }

}