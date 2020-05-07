import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authorization.dart';
import 'package:sossul/local_data_keys.dart';
import 'package:sossul/pages/page_sign_in.dart';
import 'package:sossul/pages/splash_animation.dart';

import '../main.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Authorization _authorization = Authorization();

  Future startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FlutterSecureStorage storage = FlutterSecureStorage();
    bool virginity = (prefs.getBool(kIsVirgin) ?? true);
    String signInType = prefs.getString(kSignInType);
    if (virginity) {
      await prefs.setBool(kIsVirgin, false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SplashAnimation1(),
        ),
      );
    } else {
      if (signInType == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      } else if (signInType == 'Email') {
        String email;
        String password;
        email = await storage.read(key: kStoredEmail);
        password = await storage.read(key: kStoredEmailPassword);
        await _authorization
            .signInEmail(context: context, email: email, password: password)
            .whenComplete(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Main()),
              (route) => false);
        });
      } else if (signInType == 'Google') {
        await _authorization.signInGoogle(context: context).whenComplete(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Main()),
              (route) => false);
        });
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
