import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:sossul/actions/my_page_actions.dart';
import 'package:sossul/database.dart';
import 'package:sossul/store/app_state.dart';

void fetchUserDataMiddleware(Store<AppState> store, action, NextDispatcher next) {
  final DBManager _dbManager = GetIt.I.get<DBManager>();

  if (action is FetchProfileUrlAction) {
    _dbManager.getProfilePicture(store.state.userState.currentUser.uid).then((url) {
      store.dispatch(FetchProfileUrlCompleteAction(url));
    }).catchError((Exception error) {
      store.dispatch(FetchProfileUrlFailed(error));
    });
  }

  next(action);
}

void fetchMyNovelMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is FetchMyNovelAction) {
    
  }
}