import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Swiper(itemCount: 3,scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index){
              return Card(child: Text('Text1'), color: Colors.white,);
            },
              viewportFraction: 0.6,
              scale: 0.9,),
          ),
        ),
        Expanded(flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CircleAvatar(child: Text('$index'));
                    }, childCount: 6),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 4),),
              ],
            ),
          ),
        )
      ],
    );
  }
}

