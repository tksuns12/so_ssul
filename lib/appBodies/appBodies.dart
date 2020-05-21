import 'package:flutter/material.dart';
import 'package:sossul/pages/page_home.dart';
import 'package:sossul/pages/page_list.dart';
import 'package:sossul/pages/page_settings.dart';

import '../constants.dart';

final List bodyWidgets = <Widget>[
  HomeBody(),
  ListPage(),
  Container(),
  SettingsPage(),
];

final List appBars = <AppBar>[
  AppBar(
    bottom: PreferredSize(
        child: Divider(
          color: kDarkPrimaryColor,
          height: 0,
        ),
        preferredSize: Size.fromHeight(4.0)),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text(
      '[So. SSul]',
      style: TextStyle(color: kDarkPrimaryColor),
    ),
  ),
  null,
  AppBar(
    bottom: PreferredSize(
        child: Divider(
          color: kDarkPrimaryColor,
          height: 0,
        ),
        preferredSize: Size.fromHeight(4.0)),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text(
      '[So. SSul]',
      style: TextStyle(color: kDarkPrimaryColor),
    ),
  ),
  AppBar(
    bottom: PreferredSize(
        child: Divider(
          color: kDarkPrimaryColor,
          height: 0,
        ),
        preferredSize: Size.fromHeight(4.0)),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text(
      '[So. SSul]',
      style: TextStyle(color: kDarkPrimaryColor),
    ),
  ),
];
