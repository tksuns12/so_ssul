import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  ScrollController controller;
  bool _isLoading = true;
  bool _isEmpty = true;
  List<DocumentSnapshot> _data = List<DocumentSnapshot>();
  DocumentSnapshot _lastVisible;
  final scrollViewKey = GlobalKey<ScrollableState>();
  Widget childSliver;

  @override
  void initState() {
    _dbManager = DBManager();
    controller = ScrollController()
      ..addListener(() {
        if (!_isLoading) {
          if (controller.position.pixels ==
              controller.position.maxScrollExtent) {
            setState(() {
              _isLoading = true;
            });
            _getData(SortingOption.Date);
          }
        }
      });
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
    return Stack(children: <Widget>[
      CustomScrollView(
        key: scrollViewKey,
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 30,
                            width: 300,
                            child: TextField(
                              keyboardType: TextInputType.text,
                            )),
                        IconButton(icon: Icon(Icons.search), onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: () {})
            ],
          ),
          childSliver,
        ],
      ),
      Visibility(
        child: Center(child: CircularProgressIndicator()),
        visible: _isLoading,
      ),
    ]);
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
