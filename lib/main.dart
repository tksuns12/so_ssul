import 'package:flutter/material.dart';
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
      HomeBody(changeMainState: setSelectedPage, currentUser: widget.currentUser,),
      ListPage(currentUser: widget.currentUser,),
      Container(),
      Container(),
      Container(),
    ];

    _appBars = <AppBar>[
      AppBar(
          title: Text('[So.SSul]]'),),
      null,
      AppBar(
        title: Text('[So.SSul]]'),),
      AppBar(
        title: Text('[So.SSul]]'),),
      AppBar(
        title: Text('[So.SSul]]'),),

    ];

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(color: Colors.white),
      ),
      home: Scaffold(
        floatingActionButton: _selectedPageIndex==1?FloatingActionButton(onPressed: () {}, child: Icon(Icons.add),):null,
        appBar: _appBars[_selectedPageIndex],

        body: Center(
          child: _bodyWidgets[_selectedPageIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color(0xFFb2ebf2),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 45,), title: Text('홈')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people, size: 45), title: Text('전체 목록')),
            BottomNavigationBarItem(
                icon: Icon(Icons.textsms, size: 45), title: Text('내 글')),
            BottomNavigationBarItem(icon: Icon(Icons.store, size: 45), title: Text('문장 마켓')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 45), title: Text('프로필')),
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