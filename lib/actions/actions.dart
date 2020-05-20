import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sossul/models/room_model.dart';

class AppInitializeAction {}

class CheckInitializedAction {
  final bool isInitialized;

  CheckInitializedAction(this.isInitialized);
}

class UpdateProfilePictureAction {
  final String pictureUrl;

  UpdateProfilePictureAction(this.pictureUrl);
}

class InitNovelListAction {
  final List<DocumentSnapshot> novelList;

  InitNovelListAction(this.novelList);
}

class AddMoreNovelsAction {
  final List<DocumentSnapshot> extraNovelList;

  AddMoreNovelsAction(this.extraNovelList);
}

class OpenRoomAction {
  final RoomInfo roomInfo;

  OpenRoomAction(this.roomInfo);
}

class RefreshNovelListAction {}

class RefreshRoomAction {}

class SignInWithEmailAction {}

class SignInWithGoogleAction {}

class SetProfilePictureAction{
  final String url;

  SetProfilePictureAction(this.url);
}