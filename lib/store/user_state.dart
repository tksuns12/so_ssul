import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
