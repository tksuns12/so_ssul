import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/local_data_keys.dart';
import 'package:sossul/pages/page_sign_in.dart';
import 'package:sossul/pages/splash_animation.dart';

import '../main.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Authentication _authentication = Authentication();

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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Main()), (route) => false);
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
    return Container(color: Colors.lightBlueAccent);
  }
}
