import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sossul/database.dart';

@immutable
class AppState {
  final bool isInitialized;

  final UserState userState;
  final NovelListState novelListState;

  AppState({
    this.isInitialized,
    this.userState,
    this.novelListState,
  });

  factory AppState.initial() {
    return AppState(
        isInitialized: false,
        userState: UserState.initial(),
        novelListState: NovelListState.initial());
  }

  AppState copyWith({isInitialized, userState, novelListState, authState}) {
    return AppState(
      isInitialized: isInitialized ?? this.isInitialized,
      userState: userState ?? this.userState,
      novelListState: novelListState ?? this.novelListState,
    );
  }
}

@immutable
class NovelListState {
  final bool isLoading;
  final bool isLoaded;
  final bool isLoadingFailed;
  final List<DocumentSnapshot> novelList;
  final DocumentSnapshot lastVisible;
  final SortingOption sortingOption;

  NovelListState(
      {this.sortingOption,
      this.lastVisible,
      this.isLoading,
      this.isLoaded,
      this.isLoadingFailed,
      this.novelList});

  factory NovelListState.initial() {
    return NovelListState(
        isLoaded: false,
        isLoading: false,
        isLoadingFailed: false,
        novelList: [],
        lastVisible: null,
        sortingOption: SortingOption.Date);
  }

  NovelListState copyWith(
      {isLoading,
      isLoaded,
      isLoadingFailed,
      novelList,
      lastVisible,
      sortingOption}) {
    return NovelListState(
        isLoaded: isLoaded ?? this.isLoaded,
        isLoading: isLoading ?? this.isLoading,
        isLoadingFailed: isLoadingFailed ?? this.isLoadingFailed,
        novelList: novelList ?? this.novelList,
        lastVisible: lastVisible ?? this.lastVisible,
        sortingOption: sortingOption ?? this.sortingOption);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is NovelListState &&
            this.isLoading == other.isLoading &&
            this.isLoaded == other.isLoaded &&
            this.isLoadingFailed == other.isLoadingFailed &&
            this.lastVisible == other.lastVisible &&
            this.runtimeType == other.runtimeType &&
            this.sortingOption == other.sortingOption &&
            listEquals(this.novelList, other.novelList);
  }

  @override
  int get hashCode {
    return this.isLoadingFailed.hashCode ^
        this.isLoading.hashCode ^
        this.isLoaded.hashCode ^
        this.novelList.hashCode ^
        this.lastVisible.hashCode ^
        this.sortingOption.hashCode;
  }
}

@immutable
class UserState {
  final FirebaseUser currentUser;
  final isSignedIn;
  final isSigningIn;
  final isSignedInFailed;

  UserState(
      {this.isSigningIn,
      this.currentUser,
      this.isSignedIn,
      this.isSignedInFailed});

  factory UserState.initial() {
    return UserState(
        currentUser: null,
        isSignedIn: false,
        isSignedInFailed: false,
        isSigningIn: false);
  }

  UserState copyWith({currentUser, isSignedIn, isSignedInFailed, isSigningIn}) {
    return UserState(
        currentUser: currentUser ?? this.currentUser,
        isSigningIn: isSignedIn ?? this.isSignedIn,
        isSignedInFailed: isSignedInFailed ?? this.isSignedInFailed,
        isSignedIn: isSignedIn ?? this.isSignedIn);
  }

  @override
  int get hashCode {
    return this.currentUser.hashCode ^
        this.isSignedIn.hashCode ^
        this.isSignedInFailed.hashCode ^
        this.isSigningIn.hashCode;
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is UserState &&
            this.runtimeType == other.runtimeType &&
            this.isSigningIn == other.isSigningIn &&
            this.isSignedInFailed == other.isSignedInFailed &&
            this.isSignedIn == other.isSignedIn &&
            this.currentUser == other.currentUser;
  }
}
