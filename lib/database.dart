import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum HeartType { Novel, Sentence, Comment }

class DBManager {
  Firestore _firestore = Firestore.instance;

  void setUserNickName({@required currentUser, @required nickName}) {
    _firestore.collection('users').document('${currentUser.uid}').setData({'nickname': '$nickName'}).catchError((e) => e);
  }

  Future<Map> loadUserInfo(
      {@required FirebaseUser currentUser}) async {
    Map data;
    await _firestore
        .collection("users")
        .document('${currentUser.uid}')
        .get()
        .then((DocumentSnapshot ds) {
          data = ds.data;
    });
    return data;
  }

  bool nickNameAlreadyUsed({@required String nickName}) {
    var data;
     _firestore
            .collection("users")
            .where("nickname", isEqualTo: nickName)
            .snapshots()
            .listen((event) {
              data = event.documents;
        });
        return data != null;
  }

  void openRoom(
      {@required FirebaseUser currentUser,
      @required String title,
      @required int charLimit,
      @required String initSentence,
      @required int partLimit,
      @required List<String> tags}) {}

  void addComment(
      {@required FirebaseUser currentUser, @required String content}) {}

  void addHeart(
      {@required FirebaseUser currentUser, @required HeartType heartType}) {}

  void addSentence(
      {@required FirebaseUser currentUser, @required String content}) {}

  void closeRoom({@required FirebaseUser currentUser}) {}

  void cancelHeart(
      {@required FirebaseUser currentUser, @required HeartType heartType}) {}

  void deleteSentence({@required FirebaseUser currentUser}) {}

  void deleteComment({@required FirebaseUser currentUser}) {}

  void loadMyPage({@required FirebaseUser currentUser}) {}

  void loadNovels({@required FirebaseUser currentUser, List<String> tags}) {}
}
