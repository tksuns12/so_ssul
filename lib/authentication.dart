import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sossul/database.dart';
import 'pages/routes.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  DBManager _dbManager = DBManager();
  FirebaseUser currentUser;

  Future signInGoogle({@required BuildContext context}) async {
        try {
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          await auth.signInWithCredential(credential);
          currentUser = await auth.currentUser();
          if (currentUser != null) {
            var userInfo = await _dbManager.loadUserInfoSnapshot(user: currentUser);
            if (userInfo == null) {
              _dbManager.createNewUserInfo(currentUser: currentUser, context: context);
            } else {
              Navigator.of(context).pushAndRemoveUntil(mainRoute(currentUser), (route) => false);
            }
          }

    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_CREDENTIAL':
          createErrorDialog(context,
              message: '잘못된 로그인 정보입니다.', title: '로그인 실패');
          break;
        case 'ERROR_ACCOUNT_EXIST_WITH_DIFFERENT_CREDENTIAL':
          createErrorDialog(context, message: '같은 이메일로 만들어진 계정이 있습니다.', title: '로그인 실패');

      }
    }
  }

  Future createEmailAccount(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
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
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      currentUser = await auth.currentUser();
      if (currentUser != null) {
        var userInfo = await _dbManager.loadUserInfoSnapshot(user: currentUser);
        if (userInfo == null) {
          _dbManager.createNewUserInfo(currentUser: currentUser, context: context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(mainRoute(currentUser), (route) => false);
        }
      }

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

  Future<void> deleteAccount() async {
    currentUser = await auth.currentUser();
    await currentUser.delete();
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
