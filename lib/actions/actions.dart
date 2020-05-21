import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sossul/models/room_model.dart';
import 'package:sossul/constants.dart';

class AppInitializeAction {
  final bool isInitialized;
  final FirebaseUser currentUser;

  AppInitializeAction({this.isInitialized, this.currentUser});
}

class SignInWithEmailAction {}

class SignInWithEmailFailedAction {
  final Exception error;

  SignInWithEmailFailedAction(this.error);
}

class SignInWithGoogleAction {}

class SignInWithGoogleFailedAciton {
  final Exception error;

  SignInWithGoogleFailedAciton(this.error);
}

class GoToAnotherBodyAction {
  final AppBody appBody;

  GoToAnotherBodyAction(this.appBody);
}
