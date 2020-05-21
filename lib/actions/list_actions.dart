import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sossul/database.dart';

class FetchInitNovelListAction {}

class ChangeSortingOptionAction {
  final SortingOption sortingOption;

  ChangeSortingOptionAction(this.sortingOption);
}

class SetFetchedNovelListAction {
  final List<DocumentSnapshot> novelList;

  SetFetchedNovelListAction(this.novelList);
}

class FetchMoreNovelsAction {}

class FetchNovelsFailedAction {
  final Exception error;

  FetchNovelsFailedAction(this.error);
}

class AddMoreNovelsAction {
  final List<DocumentSnapshot> extraNovelList;

  AddMoreNovelsAction(this.extraNovelList);
}

class RefreshNovelListAction {}

class SetRefreshedNovelListAction {
  final List<DocumentSnapshot> newNovelList;

  SetRefreshedNovelListAction(this.newNovelList);
}