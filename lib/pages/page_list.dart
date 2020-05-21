import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:sossul/actions/list_actions.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/page_room.dart';
import 'package:sossul/store/app_state.dart';

final scrollViewKey = GlobalKey<ScrollableState>();

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ScrollController _controller;
  RefreshController _refreshController;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        onInit: (store) {
          store.dispatch(FetchInitNovelListAction());
          _controller = ScrollController()
            ..addListener(() {
              if (!store.state.novelListState.isLoading &&
                  store.state.novelListState.novelList.length > 10) {
                if (_controller.position.pixels ==
                    _controller.position.maxScrollExtent) {
                  store.dispatch(FetchMoreNovelsAction());
                }
              }
            });
          _refreshController = RefreshController();
        },
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, viewModel) {
          return SmartRefresher(
            header: WaterDropMaterialHeader(
              backgroundColor: Colors.white,
              color: kPrimaryColor,
            ),
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: () {
              viewModel.refreshList();
            },
            child: CustomScrollView(
              controller: _controller,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  floating: true,
                  snap: true,
                  expandedHeight: 60,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 8),
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
                          focusColor: kLightPrimaryColor,
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
                SliverList(
                    delegate: SliverChildListDelegate(viewModel.novelList
                        .map((novel) => ListItem(document: novel))
                        .toList()))
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final Function refreshList;
  final List<DocumentSnapshot> novelList;
  final bool isLoading;
  final bool isLoadingFailed;

  _ViewModel(
      {this.refreshList, this.novelList, this.isLoading, this.isLoadingFailed});

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
        refreshList: (store) {
          store.dispatch(RefreshNovelListAction());
        },
        novelList: store.state.novelListState.novelList,
        isLoading: store.state.novelListState.isLoading,
        isLoadingFailed: store.state.novelListState.isLoadingFailed);
  }
}

class ListItem extends StatefulWidget {
  final DocumentSnapshot document;
  final CircularProfileAvatar image;

  const ListItem({Key key, @required this.document, this.image})
      : super(key: key);
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
                onPressed: () {},
                child: Column(
                  children: <Widget>[
                    widget.image,
                    Text(
                      '${widget.document.data[DBKeys.kRoomAuthorNicknameKey]}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 3,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RoomPage()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.document.data[DBKeys.kRoomTitleKey]}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        generateTags(widget.document.data[DBKeys.kRoomTagsKey]),
                        style: TextStyle(color: Color(0xFFCECECE)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.users),
                            ),
                            Text(
                                '${widget.document.data[DBKeys.kRoomParticipantsNumberKey]}/${widget.document.data[DBKeys.kRoomParticipantLimitKey]}')
                          ]),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Text(
                                  '${widget.document.data[DBKeys.kRoomLikesKey]}')
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(FontAwesomeIcons.eye),
                              ),
                              Text(
                                  '${widget.document.data[DBKeys.kRoomVisitKey]}')
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
