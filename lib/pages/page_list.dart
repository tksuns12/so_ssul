import 'package:flutter/material.dart';
import 'package:sossul/pages/page_work.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(children: <Widget>[
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                  SizedBox(height: 30, width: 300,child: TextField(
                    keyboardType: TextInputType.text,
                  )),
                  IconButton(icon: Icon(Icons.search), onPressed: (){}),
                ],),
              ),
            ],),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: (){})
          ],
        ),
    SliverList(delegate: SliverChildListDelegate(constructItemsList()))
      ],
    );
  }
}

List<ListItem> constructItemsList() {
  return [
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
    ListItem(),
  ];
}

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = isSelected? false:true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: isSelected?15:10,
          color: isSelected?Colors.purpleAccent:Colors.white,
          borderRadius: isSelected?BorderRadius.circular(20):BorderRadius.circular(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '글쓰기방 제목',
                style: TextStyle(fontSize: 30, color: isSelected?Colors.white:Colors.black),
              ),
              Text('Tag 들', style: TextStyle(color: isSelected?Colors.white:Colors.black),),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(child: Text('0/4', style: TextStyle(color: isSelected?Colors.white:Colors.black),),),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {return WorkPage();}));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Icon(Icons.add), Text('참여하기',style: TextStyle(color: isSelected?Colors.white:Colors.black),)],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
