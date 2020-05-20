import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/database.dart';
import 'package:sossul/store/app_state.dart';
import 'package:sossul/actions/actions.dart';

class MiddleWares {
  final DBManager dbManager = GetIt.I.get<DBManager>();
  final Authentication authentication = GetIt.I.get<Authentication>();

  ThunkAction<AppState> getNovelLists() {
    return (Store<AppState> store) async {
      if (store.state.novelListState.lastVisible == null) {
        List<DocumentSnapshot> novelList = await dbManager.loadNovelList(
            currentUser: store.state.userState.currentUser,
            sortingOption: store.state.novelListState.sortingOption,);
            store.dispatch(InitNovelListAction(novelList));
      } else {
        List<DocumentSnapshot> novelList = await dbManager.loadNovelList(
            currentUser: store.state.userState.currentUser,
            sortingOption: store.state.novelListState.sortingOption,
            startAfter: store.state.novelListState.lastVisible);
            store.dispatch(AddMoreNovelsAction(novelList));
      }
    };
  }

  ThunkAction<AppState> signInWithEmail() {
    return (Store<AppState> store) async {
      store.dispatch(SignInWithEmailAction());
    };
  }

  ThunkAction<AppState> singInWithGoogle() {
    return (Store<AppState> store) async {
      store.dispatch(SignInWithGoogleAction());
    };
  }
}
