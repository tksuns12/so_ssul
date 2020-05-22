import 'package:flutter/foundation.dart';

class MyPageState {
  final String photoUrl;
  final bool isPhotoLoading;
  final bool isPhotoLoadingFailed;
  final List myLikes;
  final List myComments;
  final List myProjects;

  MyPageState(
      {this.myLikes,
      this.myComments,
      this.myProjects,
      this.photoUrl,
      this.isPhotoLoading,
      this.isPhotoLoadingFailed});

  factory MyPageState.initial() {
    return MyPageState(
        myLikes: null,
        myComments: null,
        myProjects: null,
        photoUrl: null,
        isPhotoLoading: false,
        isPhotoLoadingFailed: false);
  }

  MyPageState copyWith(
      {myLikes,
      myComments,
      myProjects,
      photoUrl,
      isPhotoLoading,
      isPhotoLoadingFailed}) {
    return MyPageState(
        isPhotoLoading: isPhotoLoading ?? this.isPhotoLoading,
        isPhotoLoadingFailed: isPhotoLoadingFailed ?? this.isPhotoLoadingFailed,
        myComments: myComments ?? this.myComments,
        myLikes: myLikes ?? this.myLikes,
        myProjects: myProjects ?? this.myProjects,
        photoUrl: photoUrl ?? this.photoUrl);
  }

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        this.isPhotoLoading == other.isPhotoLoading &&
            this.isPhotoLoadingFailed == other.isPhotoLoadingFailed &&
            this.photoUrl == other.photoUrl &&
            listEquals(this.myComments, other.myComments) &&
            listEquals(this.myLikes, other.myLikes) &&
            listEquals(this.myProjects, other.myProjects)&&
            this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return this.isPhotoLoading.hashCode ^
        this.isPhotoLoadingFailed.hashCode ^
        this.myComments.hashCode ^
        this.myLikes.hashCode ^
        this.myProjects.hashCode ^
        this.photoUrl.hashCode;
  }
}
