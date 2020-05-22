import 'package:flutter/material.dart';
import 'package:sossul/pages/page_create_account.dart';
import 'package:sossul/pages/page_email_sign_in.dart';
import 'package:sossul/pages/page_list.dart';
import 'package:sossul/pages/page_room.dart';
import 'package:sossul/pages/page_room_making/page_room_making.dart';

import 'main.dart';

class Routes {
  static const String main = '/';
  static const String list = '/list';
  static const String openRoom = '/openroom';
  static const String room = '/room';
  static const String signInPage = '/signIn';
  static const String emailSignInPage = 'emailSignIn';
  static const String emailAccountCreate = 'emailAccountCreate';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.main: (context) => Main(),
      Routes.list: (context) => ListPage(),
      Routes.emailAccountCreate: (context) => EmailSignInPage(),
      Routes.emailSignInPage: (context) => CreateAccountPage(),
      Routes.openRoom: (context) => RoomMakingPage(),
      Routes.room: (context) => RoomPage(),
    };
  }
}