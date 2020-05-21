import 'package:cloud_firestore/cloud_firestore.dart';

class FetchProfileUrlAction {}

class UpdateProfileAction {
  final String url;

  UpdateProfileAction(this.url);
}

class FetchProfileUrlCompleteAction {
  final String url;

  FetchProfileUrlCompleteAction(this.url);
}

class FetchProfileUrlFailed {
  final Exception error;

  FetchProfileUrlFailed(this.error);
}

class SetProfileUrlAction {
  final String url;

  SetProfileUrlAction(this.url);
}

class FetchMyNovelAction {}

class FetchMyNovelFailed {
  final Exception error;

  FetchMyNovelFailed(this.error);
}

class FetchMyNovelComplete {
  final List<DocumentSnapshot> novelList;

  FetchMyNovelComplete(this.novelList);
}

class FetchMyLikedAction {}

class FetchMyLikedFailed {
  final Exception error;

  FetchMyLikedFailed(this.error);
}

class FetchMyLikedComplete {
  final List<DocumentSnapshot> novelList;

  FetchMyLikedComplete(this.novelList);
}
