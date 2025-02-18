import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_home.dart';
import 'package:sossul/pages/page_launch.dart';
import 'package:sossul/pages/page_list.dart';
import 'package:sossul/pages/page_profile.dart';
import 'package:get_it/get_it.dart';

import 'database.dart';

void main() {
  setupSingletons();
  runApp(MyApp());}

  GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton(() => DBManager());
  locator.registerLazySingleton(() => Authentication());
}

int _selectedPageIndex = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LaunchPage(),
    );
  }
}

class Main extends StatefulWidget {
  final currentUser;
  const Main({Key key, this.currentUser}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  List<Widget> _bodyWidgets;
  List<AppBar> _appBars;
  DateTime backButtonOnPressedTime;

  @override
  void initState() {
    super.initState();
    _bodyWidgets = <Widget>[
      HomeBody(
        changeMainState: setSelectedPage,
        currentUser: widget.currentUser,
      ),
      ListPage(
        currentUser: widget.currentUser,
      ),
      Container(),
      ProfilePage(currentUser: widget.currentUser,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _appBars = <AppBar>[
      AppBar(
        bottom: PreferredSize(
            child: Divider(
              color: kMainColor,
              height: 0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '[So. SSul]',
          style: TextStyle(color: kMainColor),
        ),
      ),
      null,
      AppBar(
        bottom: PreferredSize(
            child: Divider(
              color: kMainColor,
              height: 0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '[So. SSul]',
          style: TextStyle(color: kMainColor),
        ),
      ),
      AppBar(
        bottom: PreferredSize(
            child: Divider(
              color: kMainColor,
              height: 0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '[So. SSul]',
          style: TextStyle(color: kMainColor),
        ),
      ),
    ];
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _selectedPageIndex == 1
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: Icon(FontAwesomeIcons.penNib, color: kBottomNavigationItemColor,),
              )
            : null,
        appBar: _appBars[_selectedPageIndex],
        body: WillPopScope(
          onWillPop: () async {
            DateTime currentTime = DateTime.now();
            bool backButton = backButtonOnPressedTime == null || currentTime.difference(backButtonOnPressedTime) > Duration(seconds: 2);

            if (backButton) {
              backButtonOnPressedTime = currentTime;
              Fluttertoast.showToast(msg: '종료하려면 한 번 더 누르세요.', backgroundColor: kBottomNavigationItemColor, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
              return false;
            } return true;
          },
          child: IndexedStack(
            index: _selectedPageIndex,
            children: _bodyWidgets,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          selectedItemColor: kBottomNavigationItemColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 40,
                ),
                title: Text('홈')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bookOpen, size: 40),
                title: Text('전체 목록')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.trophy, size: 40),
                title: Text('리더 보드')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userCog, size: 40),
                title: Text('마이 페이지')),
          ],
          currentIndex: _selectedPageIndex,
          onTap: (int index) {
            setState(() {
              setSelectedPage(index);
            });
          },
        ),
      ),
    );
  }

  void setSelectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}
