
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sossul/constants.dart';

class InitCheckAction {
  final bool isInitialized;
  final FirebaseUser currentUser;

  InitCheckAction({this.isInitialized, this.currentUser});
}

class SignInWithEmailAction {}

class SignInWithEmailCompleteAction{
  final FirebaseUser currentUser;

  SignInWithEmailCompleteAction(this.currentUser);
}

class SignInWithEmailFailedAction {
  final Exception error;

  SignInWithEmailFailedAction(this.error);
}

class SignInWithGoogleAction {}

class SignInWithGoogleCompleteAction{
  final FirebaseUser currentUser;

  SignInWithGoogleCompleteAction(this.currentUser);
}

class SignInWithGoogleFailedAction {
  final Exception error;

  SignInWithGoogleFailedAction(this.error);
}

class GoToAnotherBodyAction {
  final AppBody appBody;

  GoToAnotherBodyAction(this.appBody);
}
