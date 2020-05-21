import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:sossul/actions/list_actions.dart';
import 'package:sossul/store/app_state.dart';

import '../database.dart';

void fetchNovelsListMiddleware(
    Store<AppState> store, action, NextDispatcher next) {
  final DBManager _dbManager = GetIt.I.get<DBManager>();
  if (store.state.userState.currentUser != null) {
    if (action is FetchInitNovelListAction) {
      _dbManager
          .loadNovelList(
              currentUser: store.state.userState.currentUser,
              sortingOption: store.state.novelListState.sortingOption)
          .then((List<DocumentSnapshot> novelSnapshots) {
        store.dispatch(SetFetchedNovelListAction(novelSnapshots));
      }).catchError((Exception error) {
        store.dispatch(FetchNovelsFailedAction(error));
      });
    } else if (action is FetchMoreNovelsAction) {
      _dbManager
          .loadNovelList(
              currentUser: store.state.userState.currentUser,
              sortingOption: store.state.novelListState.sortingOption,
              startAfter: store.state.novelListState.lastVisible)
          .then((List<DocumentSnapshot> novelSnapshots) {
        store.dispatch(AddMoreNovelsAction(novelSnapshots));
      }).catchError((Exception error) {
        store.dispatch(FetchNovelsFailedAction(error));
      });
    } else if (action is RefreshNovelListAction) {
      _dbManager
          .loadNovelList(
              currentUser: store.state.userState.currentUser,
              sortingOption: store.state.novelListState.sortingOption)
          .then((List<DocumentSnapshot> novelSnapshots) {
        store.dispatch(SetRefreshedNovelListAction(novelSnapshots));
      }).catchError((Exception error) {
        store.dispatch(FetchNovelsFailedAction(error));
      });
    }
  }

  next(action);
}
