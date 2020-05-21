import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_sign_in.dart';
import 'package:sossul/pages/routes.dart';
import 'package:sossul/pages/splash_animation.dart';
import 'package:sossul/database.dart';

const kIsVirgin = "IsVirgin";

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Authentication _authentication = GetIt.I.get<Authentication>();
  DBManager _dbManager;

  Future startTime() async {
    FirebaseUser _currentUser = await _authentication.auth.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool virginity = (prefs.getBool(kIsVirgin) ?? true);
    if (virginity) {
      await prefs.setBool(kIsVirgin, false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SplashAnimation1(),
        ),
      );
    } else {
      if (_currentUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      } else {
        _dbManager = GetIt.I.get<DBManager>();
        await _dbManager.onExecuteApp(currentUser: _currentUser);
        Navigator.of(context)
            .pushAndRemoveUntil(mainRoute(_currentUser), (route) => false);
      }
    }
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkPrimaryColor,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
