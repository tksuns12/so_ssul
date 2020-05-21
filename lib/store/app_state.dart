import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sossul/database.dart';
import 'package:sossul/store/novel_list_state.dart';
import 'package:sossul/store/user_state.dart';

import '../constants.dart';

@immutable
class AppState {
  final bool isInitialized;
  final AppBody appBody;
  final UserState userState;
  final NovelListState novelListState;

  AppState({
    this.appBody,
    this.isInitialized,
    this.userState,
    this.novelListState,
  });

  factory AppState.initial() {
    return AppState(
        appBody: AppBody.Home,
        isInitialized: false,
        userState: UserState.initial(),
        novelListState: NovelListState.initial());
  }

  AppState copyWith(
      {isInitialized, userState, novelListState, authState, appBody}) {
    return AppState(
      isInitialized: isInitialized ?? this.isInitialized,
      userState: userState ?? this.userState,
      novelListState: novelListState ?? this.novelListState,
      appBody: appBody ?? this.appBody,
    );
  }
}