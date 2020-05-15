import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_home.dart';
import 'package:sossul/pages/page_launch.dart';
import 'package:sossul/pages/page_list.dart';

void main() => runApp(MyApp());

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
      Container(),
      Container(),
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
        body: IndexedStack(
          index: _selectedPageIndex,
          children: _bodyWidgets,
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
