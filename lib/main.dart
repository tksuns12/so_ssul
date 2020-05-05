import 'package:flutter/material.dart';
import 'package:sossul/pages/page_home.dart';
import 'package:sossul/pages/page_list.dart';
import 'pages/splash_animation.dart';

void main() => runApp(MyApp());

int _selectedPageIndex = 0;

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
  List<Widget> _bodyWidget;

  @override
  void initState() {
    super.initState();
    _bodyWidget = <Widget>[
      HomeBody(changeMainState: setSelectedPage),
      ListPage(),
      Container(),
      Container(),
      Container(),
    ];

  }

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
          child: _bodyWidget[_selectedPageIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
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