import 'package:flutter/material.dart';
import 'package:sossul/pages/page_email_sign_in.dart';

class SingInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('So.SSul'),
            FlatButton(
              child: Text('이메일로 로그인'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailSignIn(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void signInWithEmail() {}
}
