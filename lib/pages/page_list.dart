import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_work.dart';

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
    _dbManager = DBManager();
    scrollController = ScrollController()
      ..addListener(() async {
        if (!_isLoading) {
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
    _getData(SortingOption.Date);
    return SmartRefresher(
      header: WaterDropMaterialHeader(backgroundColor: Colors.white, color: kMainColor,),
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () async {
        _lastVisible = null;
        _data.clear();
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
              background: Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(0xFFb2ebf2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: () {})
            ],
          ),
          childSliver,
        ],
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
              startAt: _lastVisible[SortingOptions[sortingOption.index]])
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
        _isEmpty = true;
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
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = isSelected ? false : true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: isSelected ? 15 : 10,
          color: isSelected ? Colors.purpleAccent : Colors.white,
          borderRadius: isSelected
              ? BorderRadius.circular(20)
              : BorderRadius.circular(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${widget.document.data['title']}',
                style: TextStyle(
                    fontSize: 30,
                    color: isSelected ? Colors.white : Colors.black),
              ),
              Text(
                '${widget.document.data['tags']}',
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${widget.document.data['participants']}/${widget.document.data['partlimit']}',
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WorkPage();
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.add),
                          Text(
                            '참여하기',
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black),
                          )
                        ],
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
