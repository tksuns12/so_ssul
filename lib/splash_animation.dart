import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SplashAnimation1 extends StatefulWidget {
  @override
  _SplashAnimation1State createState() => _SplashAnimation1State();
}

class _SplashAnimation1State extends State<SplashAnimation1>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool virginity = true;

  Future<void> getVirginity() async {
    final prefs = await SharedPreferences.getInstance();
    print("getVirginity executed");
    if (prefs.getBool("isVirgin") == null) {
      virginity = true;
    } else {
      virginity = prefs.getBool("isVirgin");
    }
  }

  Future<void> _changeVirginity() async {
    final prefs = await SharedPreferences.getInstance();
    print("changeVirginity executed");
    prefs.setBool("isVirgin", false);
  }

  @override
  void initState() {
    getVirginity().then((result){});
    _changeVirginity();
      super.initState();
      controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
      );
      animation = ColorTween(begin: Colors.black45, end: Colors.purpleAccent)
          .animate(controller);
      if (virginity)
      {controller.forward();}
      controller.addListener(() {
        setState(() {});
        if (controller.isCompleted && virginity) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SplashAnimation2()));
        }
      });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (virginity)
    {return Container(
      color: animation.value,
      child: Center(
        child: Hero(
          child: Icon(
            Icons.book,
            size: 100,
            color: Colors.white,
          ),
          tag: 'logo',
        ),
      ),
    );} else {
      return Home();
    }
  }
}

class SplashAnimation2 extends StatefulWidget {
  @override
  _SplashAnimation2State createState() => _SplashAnimation2State();
}

class _SplashAnimation2State extends State<SplashAnimation2> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.purpleAccent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                  tag: 'logo',
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.book,
                      size: 50,
                      color: Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TypewriterAnimatedTextKit(
                  text: ['So, SSul.'],
                  textStyle: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  speed: Duration(milliseconds: 300),
                  totalRepeatCount: 1,
                  onFinished: () {
                    Navigator.pushReplacement(context, CustomPageRoute(Home()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 800);
}
