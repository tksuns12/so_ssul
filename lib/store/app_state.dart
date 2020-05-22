import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sossul/database.dart';
import 'package:sossul/store/my_contents_state.dart';
import 'package:sossul/store/novel_list_state.dart';
import 'package:sossul/store/user_state.dart';

import '../constants.dart';

@immutable
class AppState {
  final bool isInitialized;
  final AppBody appBody;
  final UserState userState;
  final NovelListState novelListState;
  final MyPageState myPageState;

  AppState({
    this.myPageState,
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
        novelListState: NovelListState.initial(),
        myPageState: MyPageState.initial());
  }

  AppState copyWith(
      {isInitialized,
      userState,
      novelListState,
      authState,
      appBody,
      myPageState}) {
    return AppState(
        isInitialized: isInitialized ?? this.isInitialized,
        userState: userState ?? this.userState,
        novelListState: novelListState ?? this.novelListState,
        appBody: appBody ?? this.appBody,
        myPageState: myPageState ?? this.myPageState);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        this.appBody == other.appBody &&
            this.isInitialized == other.isInitialized &&
            this.myPageState == other.myPageState &&
            this.novelListState == other.novelListState &&
            this.userState == other.userState &&
            this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return this.appBody.hashCode ^
        this.isInitialized.hashCode ^
        this.myPageState.hashCode ^
        this.novelListState.hashCode ^
        this.userState.hashCode;
  }
}
