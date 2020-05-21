
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sossul/database.dart';

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