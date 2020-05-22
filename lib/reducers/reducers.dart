import 'package:sossul/actions/actions.dart';
import 'package:sossul/reducers/signin_reducers.dart';
import 'package:sossul/store/app_state.dart';

AppState initAppReducer(AppState oldState, InitCheckAction action) {
  return oldState.copyWith(
    isInitialized: action.isInitialized,
    userState: oldState.userState.copyWith(currentUser: action.currentUser),
  );
}

AppState appReducer(AppState state, action) {
  return AppState(userState: signinReducers(state.userState, action));
}