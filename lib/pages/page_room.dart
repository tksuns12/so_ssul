import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  final roomID;
  const RoomPage({Key key,@required this.roomID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '글쓰기 방',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('심장이 하늘에서 땅끝까지 아찔한 진자운동을 계속하였다. \n첫사랑이었다.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        child: Text('호러'),
                      ),
                      Card(
                        child: Text('추리'),
                      ),
                      Card(
                        child: Text('스릴러'),
                      ),
                      Card(
                        child: Text('블랙코미디'),
                      ),
                    ],
                  ),
                  Text('전체보기'),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Text('릴레이 히스토리'),
                  Expanded(
                      child: Container(
                          child: relayItems.length == 0
                              ? Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  color: Colors.white70,
                                )
                              : ListView())),
                  TextField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<RelayItem> relayItems = [];

class RelayItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            foregroundColor: Colors.lightBlue,
          ),
          Column(
            children: <Widget>[
              Text('ID: 어쩌구 저쩌구'),
              Text('내용이 어쩌구 저쩌구'),
            ],
          ),
          Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Icon(Icons.more_vert),
              ),
              FlatButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
