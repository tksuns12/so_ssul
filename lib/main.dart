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
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: Colors.greenAccent),
      ),
      home: Scaffold(
        floatingActionButton: _selectedPageIndex==1?FloatingActionButton(onPressed: () {}, child: Icon(Icons.add),):null,
        appBar: _appBars[_selectedPageIndex],

        body: Center(
          child: _bodyWidgets[_selectedPageIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.greenAccent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('홈')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text('전체 목록')),
            BottomNavigationBarItem(
                icon: Icon(Icons.textsms), title: Text('내 글')),
            BottomNavigationBarItem(icon: Icon(Icons.store), title: Text('문장 마켓')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('프로필')),
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