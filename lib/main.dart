import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_home.dart';
import 'package:sossul/pages/page_launch.dart';
import 'package:sossul/pages/page_list.dart';
import 'package:get_it/get_it.dart';
import 'package:sossul/pages/page_room_making/page_room_making.dart';
import 'package:sossul/reducers/reducers.dart';
import 'package:sossul/store/app_state.dart';

import 'actions/actions.dart';
import 'database.dart';
import 'store/app_state.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  setupSingletons();
  runApp(StoreProvider(store: store, child: MyApp()));
}

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton(() => DBManager());
  locator.registerLazySingleton(() => Authentication());
}

int _selectedPageIndex = 0;

class MyApp extends StatelessWidget {
  final Authentication _authentication = GetIt.I.get<Authentication>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      onInit: (store) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        FirebaseUser currentUser = await _authentication.auth.currentUser();
        bool isInitialized = prefs.getBool(kIsVirgin) ?? true;
        store.dispatch(AppInitializeAction(
            currentUser: currentUser, isInitialized: isInitialized));
      },
      builder: (context, isInitialized) {
        return MaterialApp(
          home: isInitialized ? LaunchPage() : Main(),
        );
      },
      converter: (store) => store.state.isInitialized,
    );
  }
}

class Main extends StatefulWidget {
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
      ProfilePage(
        currentUser: widget.currentUser,
      ),
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
    return StoreConnector<AppState, _MainViewModel>(
      converter: (Store<AppState> store) {
        return _MainViewModel(
            appBody: store.state.appBody,
            store: store,
            onNavButtonClicked: (index) {
              store.dispatch(GoToAnotherBody(AppBody.values[index]));
            });
      },
      builder: (context, vm) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: vm.appBody.index == 1
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomMakingPage()));
                  },
                  child: Icon(
                    FontAwesomeIcons.penNib,
                    color: kBottomNavigationItemColor,
                  ),
                )
              : null,
          appBar: _appBars[vm.appBody.index],
          body: WillPopScope(
            onWillPop: () async {
              DateTime currentTime = DateTime.now();
              bool backButton = backButtonOnPressedTime == null ||
                  currentTime.difference(backButtonOnPressedTime) >
                      Duration(seconds: 2);

              if (backButton) {
                backButtonOnPressedTime = currentTime;
                Fluttertoast.showToast(
                    msg: '종료하려면 한 번 더 누르세요.',
                    backgroundColor: kBottomNavigationItemColor,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT);
                return false;
              }
              return true;
            },
            child: IndexedStack(
              index: vm.appBody.index,
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
            currentIndex: vm.appBody.index,
            onTap: (int index) {
              vm.onNavButtonClicked(index);
            },
          ),
        );
      },
    );
  }
}

class _MainViewModel {
  final AppBody appBody;
  final Function(int index) onNavButtonClicked;
  final Store<AppState> store;

  _MainViewModel({this.appBody, this.onNavButtonClicked, this.store});
}
