import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/page_home.dart';
import 'package:sossul/page_list.dart';
import 'splash_animation.dart';

void main() => runApp(MyApp());

int _selectedIndex = 0;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: SplashAnimation1(),
      );
    }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: Colors.purple),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Hero(
              tag: 'logo',
              child: Icon(
                Icons.book,
                color: Colors.white,
                size: 30,
              )),
          title: Text('S.S'),
        ),
        body: Center(
          child: _bodyWidget[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('홈')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text('내 프로젝트')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('프로필')),
            BottomNavigationBarItem(icon: Icon(Icons.store), title: Text('마켓')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('설정')),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

List<Widget> _bodyWidget = <Widget>[
  HomePage(),
  ListPage(),
  Container(),
  Container(),
  Container(),
];
