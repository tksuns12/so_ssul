import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/local_data_keys.dart';
class Authorization {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  SharedPreferences prefs;


  Future signInGoogle({@required BuildContext context}) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(kSignInType, 'Google');
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  }

  Future createEmailAccount(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          createErrorDialog(context,
              title: '계정 생성 실패', message: '비밀번호가 너무 단순합니다.');
          break;
        case 'ERROR_INVALID_EMAIL':
          createErrorDialog(context,
              title: '계정 생성 실패', message: '이메일 형식이 안 맞습니다.');
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          createErrorDialog(context,
              title: '계정 생성 실패', message: '이미 사용 중인 이메일입니다.');
          break;
      }
    }
    signInEmail(context: context, email: email, password: password);
  }

  Future signInEmail(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await storage.write(value: email, key: kStoredEmail);
      await storage.write(key: kStoredEmailPassword, value: password);
      prefs.setString(kSignInType, 'Email');
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          await createErrorDialog(context,
              message: '이메일 형식이 안 맞습니다.', title: '로그인 실패');
          break;
        case 'ERROR_WRONG_PASSWORD':
          await createErrorDialog(context,
              message: '이메일이나 비밀번호가 틀렸습니다.', title: '로그인 실패');
          break;
        case 'ERROR_USER_NOT_FOUND':
          await createErrorDialog(context,
              message: '계정이 없습니다.', title: '로그인 실패');
          break;
      }
    }
  }

  Future createErrorDialog(BuildContext context,
      {@required String message, @required String title}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
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
