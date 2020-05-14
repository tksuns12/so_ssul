import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeBody extends StatefulWidget {
  final Function changeMainState;
  final FirebaseUser currentUser;

  const HomeBody({Key key, this.changeMainState, this.currentUser})
      : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Swiper(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Text('Text1'),
                  color: Color(0xFF00bcd4),
                );
              },
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return FlatButton(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Text('$index'),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Color(0xFF2aa79b),
                              width: 5, style: BorderStyle.solid
                        ),borderRadius: BorderRadius.circular(10),),
                      ),
                      onPressed: () {
                        widget.changeMainState(1);
                        // TODO: 여기에 해당 선택한 장르로 필터링 해서 리스트뷰로 넘겨주는 동작 구현해주세요
                      },
                    );
                  }, childCount: 6),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
