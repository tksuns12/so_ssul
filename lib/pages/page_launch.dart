import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
//  bool virginity = true;
//  bool isSignedIn = false;
  Authorization _authorization = Authorization();
  String email;
  String password;

  Future startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      if (signInType != null) {
          await _authorization.signInEmail(
              context: context, email: email, password: password);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Main(),
            ),
          );
      } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ),
          );
      }
    }
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 200), (){startTime();});
    super.initState();
//    getVirginity();
//    _changeVirginity();
//    SchedulerBinding.instance.addPostFrameCallback((_){
//      if (virginity) {
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => SplashAnimation1(),
//          ),
//        );
//      } else {
//        getSignedInState().then((value) {});
//        if (isSignedIn) {
//          _authorization.signInEmail(
//              context: context, email: email, password: password);
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => Main(),
//            ),
//          );
//        } else {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => SignInPage(),
//            ),
//          );
//        }
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.lightBlueAccent);
  }
//
//  Future<void> getVirginity() async {
//    final prefs = await SharedPreferences.getInstance();
//    if (prefs.getBool(kIsVirgin) == null) {
//      virginity = true;
//    } else {
//      virginity = prefs.getBool(kIsVirgin);
//    }
//  }
//
//  Future<void> getSignedInState() async {
//    final prefs = await SharedPreferences.getInstance();
//    if (prefs.getString(kSignInType) == null) {
//      isSignedIn = false;
//    } else {
//      isSignedIn = true;
//      email = prefs.getString(kStoredEmail);
//      password = prefs.getString(kStoredEmailPassword);
//    }
//  }
//
//  Future<void> _changeVirginity() async {
//    final prefs = await SharedPreferences.getInstance();
//    prefs.setBool(kIsVirgin, false);
//  }
}
