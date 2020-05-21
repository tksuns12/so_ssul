import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sossul/constants.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
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
          flex: 3,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text('릴레이 장르', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ), Text('장르를 클릭하여 소설을 이어가세요!', style: TextStyle(fontSize: 11, color: Colors.grey),)],
              ),
              CustomScrollView(
                shrinkWrap: true,
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
                                width: 3,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
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
            ],
          ),
        ),
        Divider(color: kDarkPrimaryColor, height: 0, thickness: 1,),
      ],
    );
  }
}