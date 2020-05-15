import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_room.dart';

import '../database.dart';

class ListPage extends StatefulWidget {
  final FirebaseUser currentUser;
  const ListPage({Key key, this.currentUser}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DBManager _dbManager;
  ScrollController scrollController;
  bool _isLoading = true;
  bool _isEmpty = true;
  List<DocumentSnapshot> _data = List<DocumentSnapshot>();
  DocumentSnapshot _lastVisible;
  final scrollViewKey = GlobalKey<ScrollableState>();
  Widget childSliver;
  RefreshController refreshController;

  @override
  void initState() {
    _dbManager = GetIt.I.get<DBManager>();
    scrollController = ScrollController()
      ..addListener(() async {
        if (!_isLoading && _data.length > 10) {
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            setState(() {
              _isLoading = true;
            });
            await _getData(SortingOption.Date);
          }
        }
      });
    refreshController = RefreshController();
    _getData(SortingOption.Date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    childSliver = _isEmpty
        ? SliverToBoxAdapter(
            child: Container(
            alignment: Alignment.center,
            child: Text('올라온 글이 없습니다.'),
          ))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final DocumentSnapshot document = _data[index];
                return ListItem(
                  document: document,
                );
              },
              childCount: _data.length,
            ),
          );
    return Material(
      color: kBottomNavigationItemColor,
      child: SmartRefresher(
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.white,
          color: kMainColor,
        ),
        enablePullDown: true,
        controller: refreshController,
        onRefresh: () async {
          _lastVisible = null;
          _data = [];
          await _getData(SortingOption.Date);
          refreshController.refreshCompleted();
        },
        child: CustomScrollView(
          key: scrollViewKey,
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              expandedHeight: 60,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    cursorWidth: 3,
                    cursorColor: Color(0xFF797979),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xFF797979), width: 3),
                      ),
                      focusColor: kBottomNavigationItemColor,
                      prefixIcon: Icon(
                        FontAwesomeIcons.search,
                        color: Color(0xFF797979),
                      ),
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF797979)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xFF797979), width: 10),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ),
            childSliver,
          ],
        ),
      ),
    );
  }

  Future<void> _getData(SortingOption sortingOption) async {
    List<DocumentSnapshot> documentSnapshots;
    if (_lastVisible == null) {
      await _dbManager
          .loadNovelList(
              currentUser: widget.currentUser, sortingOption: sortingOption)
          .then((value) {
        documentSnapshots = value;
      });
    } else {
      await _dbManager
          .loadNovelList(
              currentUser: widget.currentUser,
              sortingOption: sortingOption,
              startAfter: _lastVisible)
          .then((value) {
        documentSnapshots = value;
      });
    }

    if (documentSnapshots != null && documentSnapshots.length > 0) {
      _lastVisible = documentSnapshots[documentSnapshots.length - 1];
      setState(() {
        _isLoading = false;
        _isEmpty = false;
        _data.addAll(documentSnapshots);
      });
    } else {
      setState(() {
        _isLoading = false;
        if (_data.length == 0){
        _isEmpty = true;}
      });
    }
  }
}

class ListItem extends StatefulWidget {
  final DocumentSnapshot document;

  const ListItem({Key key, @required this.document}) : super(key: key);
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(3),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {  },
                child: Column(children: <Widget>[
                  CircleAvatar(radius: 35,),
                  Text('${widget.document.data[DBKeys.kRoomAuthorNicknameKey]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                ],),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              flex: 3,
              child: FlatButton(
                onPressed: () {  },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text('${widget.document.data[DBKeys.kRoomTitleKey]}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(generateTags(widget.document.data[DBKeys.kRoomTagsKey]), style: TextStyle(color: Color(0xFFCECECE)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                      Row(children: <Widget>[Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.users),
                      ), Text('${widget.document.data[DBKeys.kRoomParticipantsNumberKey]}/${widget.document.data[DBKeys.kRoomParticipantLimitKey]}')]),
                      Row(children: <Widget>[Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(FontAwesomeIcons.solidHeart, color: Colors.redAccent,),
                      ), Text('${widget.document.data[DBKeys.kRoomLikesKey]}')],),
                      Row(children: <Widget>[Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(FontAwesomeIcons.eye),
                      ), Text('${widget.document.data[DBKeys.kRoomVisitKey]}')],),
                    ],),
                  )
                ],),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String generateTags(List<dynamic> tags) {
    String result = '';
    for (String tag in tags) {
      result += '#$tag ';
    }
    return result;
  }
}
