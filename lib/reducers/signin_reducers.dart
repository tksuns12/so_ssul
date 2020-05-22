import 'package:redux/redux.dart';
import 'package:sossul/actions/actions.dart';
import 'package:sossul/store/user_state.dart';

UserState emailSignIn(UserState oldState, SignInWithEmailAction action) {
  return oldState.copyWith(isSigningIn: true);
}

UserState emailSignInComplete(
    UserState oldState, SignInWithEmailCompleteAction action) {
  return oldState.copyWith(
      currentUser: action.currentUser,
      isSignedIn: true,
      isSignedInFailed: false,
      isSigningIn: false);
}

UserState emailSignInFailed(
    UserState oldState, SignInWithEmailFailedAction aciton) {
  return oldState.copyWith(
      currentUser: null,
      isSignedIn: false,
      isSignedInFailed: true,
      isSigningIn: false);
}

UserState googleSignIn(UserState oldState, SignInWithGoogleAction action) {
  return oldState.copyWith(isSigningIn: true);
}

UserState googleSignInComplete(
    UserState oldState, SignInWithGoogleCompleteAction action) {
  return oldState.copyWith(
      currentUser: action.currentUser,
      isSignedIn: true,
      isSignedInFailed: false,
      isSigningIn: false);
}

UserState googleSignInFailed(
    UserState oldState, SignInWithGoogleFailedAction action) {
  return oldState.copyWith(
      currentUser: null,
      isSignedIn: false,
      isSignedInFailed: true,
      isSigningIn: false);
}

final signinReducers = combineReducers<UserState>([
  TypedReducer<UserState, SignInWithEmailAction>(emailSignIn),
  TypedReducer<UserState, SignInWithEmailCompleteAction>(emailSignInComplete),
  TypedReducer<UserState, SignInWithEmailFailedAction>(emailSignInFailed),
  TypedReducer<UserState, SignInWithGoogleAction>(googleSignIn),
  TypedReducer<UserState, SignInWithGoogleCompleteAction>(googleSignInComplete),
  TypedReducer<UserState, SignInWithGoogleFailedAction>(googleSignInFailed),
]);
