import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sossul/authentication.dart';
import 'package:sossul/database.dart';
import 'package:sossul/store/app_state.dart';
import 'package:sossul/actions/actions.dart';

final DBManager dbManager = GetIt.I.get<DBManager>();
final Authentication authentication = GetIt.I.get<Authentication>();

ThunkAction<AppState> fetchNovelLists() {
  return (Store<AppState> store) async {
    if (store.state.novelListState.lastVisible == null) {
      List<DocumentSnapshot> novelList = await dbManager.loadNovelList(
        currentUser: store.state.userState.currentUser,
        sortingOption: store.state.novelListState.sortingOption,
      );
      store.dispatch(InitNovelListAction(novelList));
    } else {
      List<DocumentSnapshot> novelList = await dbManager.loadNovelList(
          currentUser: store.state.userState.currentUser,
          sortingOption: store.state.novelListState.sortingOption,
          startAfter: store.state.novelListState.lastVisible);
      store.dispatch(AddMoreNovelsAction(novelList));
    }
  };
}

ThunkAction<AppState> signInWithEmail(
    BuildContext context, String email, String password) {
  return (Store<AppState> store) async {
    await authentication.signInEmail(
        context: context, email: email, password: password);
    store.dispatch(SignInWithEmailAction());
  };
}

ThunkAction<AppState> singInWithGoogle(BuildContext context) {
  return (Store<AppState> store) async {
    await authentication.signInGoogle(context: context);
    store.dispatch(SignInWithGoogleAction());
  };
}

ThunkAction<AppState> fetchProfilePicture() {
  return (Store<AppState> store) async {
    String pictureUrl = await dbManager.getProfilePicture(store.state.userState.currentUser.uid);
    store.dispatch(SetProfilePictureAction(pictureUrl));
  };
}

ThunkAction<AppState> changeProfilePicture() {
  return (Store<AppState> store) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50);
        if (croppedFile != null) {
          String url = await dbManager.setProfilePicture(croppedFile, store.state.userState.currentUser);
          store.dispatch(SetProfilePictureAction(url));
        }
  };
}

ThunkAction<AppState> openRoom() {
}