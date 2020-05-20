import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/pages/routes.dart';

enum HeartType { Novel, Sentence, Comment }
enum SortingOption { Date, Participatable, Likes }
const SortingOptions = [
  DBKeys.kRoomCreatedTimeKey,
  DBKeys.kRoomIsFullKey,
  DBKeys.kRoomLikesKey
];

class DBManager {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> sendReport(
      {@required time,
      @required reportedUser,
      @required reason,
      @required content}) async {
    await _firestore.collection(DBKeys.kReportsCollectionID).add({
      DBKeys.kReportsCreatedTimeKey: FieldValue.serverTimestamp(),
      DBKeys.kReportsReportedUserKey: reportedUser,
      DBKeys.kReportsContentKey: content,
      DBKeys.kReportsReasonKey: reason
    });
  }

  Future<void> onExecuteApp({@required FirebaseUser currentUser}) async {
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${currentUser.uid}')
        .updateData({DBKeys.kUserLastVisitKey: FieldValue.serverTimestamp()});
  }

  Future<void> participateInRoom(
      {@required FirebaseUser currentUser, @required roomID}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .get()
        .then((value) async {
      if (!value.data[DBKeys.kRoomIsFullKey]) {
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .setData({
          DBKeys.kRoomParticipantsIDKey: FieldValue.arrayUnion([currentUser]),
          DBKeys.kRoomParticipantsNicknameKey:
              FieldValue.arrayUnion([_nickName]),
          DBKeys.kRoomParticipantsNumberKey: FieldValue.increment(1),
        });
      }
    });
  }

  Future<void> setUserNickName(
      {@required currentUser, @required nickName}) async {
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${currentUser.uid}')
        .setData({DBKeys.kUserNickNameKey: nickName});
  }

  Future<void> createNewUserInfo(
      {@required FirebaseUser currentUser,
      @required BuildContext context}) async {
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${currentUser.uid}')
        .setData({
      DBKeys.kUserEmailKey: currentUser.email,
      DBKeys.kUserGradeKey: 1,
      DBKeys.kUserPointKey: kInitialPoint,
      DBKeys.kUserJoinDateKey: FieldValue.serverTimestamp(),
      DBKeys.kUserLastVisitKey: FieldValue.serverTimestamp(),
    });

    showNickNameDialog(context: context, currentUser: currentUser);
  }

  Stream<DocumentSnapshot> loadUserInfoStream({@required FirebaseUser user}) {
    Stream<DocumentSnapshot> data = _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${user.uid}')
        .snapshots();
    return data;
  }

  Future<Map> loadUserInfoSnapshot({@required FirebaseUser user}) async {
    Map data;
    await _firestore
        .collection("users")
        .document('${user.uid}')
        .get()
        .then((DocumentSnapshot ds) {
      data = ds.data;
    });
    return data;
  }

  Future<bool> nickNameAlreadyUsed({@required String nickName}) async {
    var data = await _firestore
        .collection(DBKeys.kUserCollectionID)
        .where(DBKeys.kUserNickNameKey, isEqualTo: nickName)
        .snapshots()
        .first;
    print(data.documents.length);
    bool isAlreadyUsed = data.documents.length != 0;
    return isAlreadyUsed;
  }

  Future<String> getNickname({@required currentUser}) async {
    String nickName;
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${currentUser.uid}')
        .get()
        .then((value) {
      nickName = value.data[DBKeys.kUserNickNameKey];
    });
    return nickName;
  }

  Future<void> openRoom(
      {@required String title,
      @required FirebaseUser currentUser,
      @required int charLimit,
      @required String initSentence,
      @required int partLimit,
      @required List<String> tags,
      @required bool enjoy}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore.collection(DBKeys.kRoomCollectionID).add({
      DBKeys.kRoomTitleKey: title,
      DBKeys.kRoomCharacterLimitKey: charLimit,
      DBKeys.kRoomInitialSentenceKey: initSentence,
      DBKeys.kRoomParticipantLimitKey: partLimit,
      DBKeys.kRoomTagsKey: tags,
      DBKeys.kRoomLikesKey: 0,
      DBKeys.kRoomCreatedTimeKey: FieldValue.serverTimestamp(),
      DBKeys.kRoomIsFinishedKey: false,
      DBKeys.kRoomAuthorIDKey: currentUser.uid,
      DBKeys.kRoomAuthorNicknameKey: _nickName,
      DBKeys.kRoomVisitKey: 0,
      DBKeys.kRoomParticipantsIDKey: [currentUser.uid],
      DBKeys.kRoomIsFullKey: false,
      DBKeys.kRoomEnjoyKey: enjoy,
      DBKeys.kRoomParticipantsNicknameKey: [_nickName],
      DBKeys.kRoomParticipantsNumberKey: 1,
      DBKeys.kRoomRecentWriterKey: _nickName,
    });
  }

  Future<void> increaseVisit({@required currentUser, @required roomID}) async {
    // 조회수를 1 올림
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .updateData({DBKeys.kRoomVisitKey: FieldValue.increment(1)});
  }

  Future<void> addSentence(
      {@required FirebaseUser currentUser,
      @required String content,
      @required roomID}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kRelayCollectionID)
        .add({
      DBKeys.kRelayAuthorID: currentUser.uid,
      DBKeys.kRelayAuthorNickname: _nickName,
      DBKeys.kRelayCreatedTime: FieldValue.serverTimestamp(),
      DBKeys.kRelayContentKey: content,
      DBKeys.kRelayLikesKey: 0,
    });
  }

  Future<void> addComment(
      {@required FirebaseUser currentUser,
      @required String content,
      @required roomID}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kCommentsCollectionID)
        .add({
      DBKeys.kCommentsAuthorID: currentUser.uid,
      DBKeys.kCommentsAuthorNickname: _nickName,
      DBKeys.kCommentsCreatedTime: FieldValue.serverTimestamp(),
      DBKeys.kCommentsContentKey: content,
      DBKeys.kCommentsLikesKey: 0,
    });
  }

  Future<void> addHeart(
      {@required FirebaseUser currentUser,
      @required HeartType heartType,
      @required roomID,
      @required documentID}) async {
    switch (heartType) {
      case HeartType.Comment:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kCommentsCollectionID)
            .document(documentID)
            .updateData({DBKeys.kCommentsLikesKey: FieldValue.increment(1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kCommentsCollectionID)
            .document(documentID)
            .collection(DBKeys.kLikedbyCollectionID)
            .add({DBKeys.kLikedbyLikerKey: currentUser.uid});
        break;
      case HeartType.Novel:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .updateData({DBKeys.kRoomLikesKey: FieldValue.increment(1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kLikedbyCollectionID)
            .add({DBKeys.kLikedbyLikerKey: currentUser.uid});
        break;
      case HeartType.Sentence:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kRelayCollectionID)
            .document(documentID)
            .updateData({DBKeys.kRelayLikesKey: FieldValue.increment(1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kRelayCollectionID)
            .document(documentID)
            .collection(DBKeys.kLikedbyCollectionID)
            .add({DBKeys.kLikedbyLikerKey: currentUser.uid});
        break;
    }
  }

  Future<void> closeRoom(
      {@required FirebaseUser currentUser, @required roomID}) async {
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .delete();
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kRelayCollectionID)
        .getDocuments()
        .then((value) async {
      for (DocumentSnapshot ds in value.documents) {
        await ds.reference
            .collection(DBKeys.kLikedbyCollectionID)
            .getDocuments()
            .then((subvalue) {
          for (DocumentSnapshot subds in subvalue.documents) {
            subds.reference.delete();
          }
        });
        ds.reference.delete();
      }
    });

    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kCommentsCollectionID)
        .getDocuments()
        .then((value) async {
      for (DocumentSnapshot ds in value.documents) {
        await ds.reference
            .collection(DBKeys.kLikedbyCollectionID)
            .getDocuments()
            .then((subvalue) {
          for (DocumentSnapshot subds in subvalue.documents) {
            subds.reference.delete();
          }
        });
        ds.reference.delete();
      }
    });

    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kLikedbyCollectionID)
        .getDocuments()
        .then((value) {
      for (DocumentSnapshot ds in value.documents) {
        ds.reference.delete();
      }
    });
  }

  Future<void> cancelHeart(
      {@required FirebaseUser currentUser,
      @required HeartType heartType,
      @required roomID,
      @required documentID}) async {
    switch (heartType) {
      case HeartType.Comment:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kCommentsCollectionID)
            .document(documentID)
            .updateData({DBKeys.kCommentsLikesKey: FieldValue.increment(-1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kCommentsCollectionID)
            .document(documentID)
            .collection(DBKeys.kLikedbyCollectionID)
            .where(DBKeys.kLikedbyLikerKey, isEqualTo: currentUser.uid)
            .getDocuments()
            .then((value) {
          value.documents[0].reference.delete();
        });
        break;
      case HeartType.Novel:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .updateData({DBKeys.kRoomLikesKey: FieldValue.increment(-1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kLikedbyCollectionID)
            .where(DBKeys.kLikedbyLikerKey, isEqualTo: currentUser.uid)
            .getDocuments()
            .then((value) {
          value.documents[0].reference.delete();
        });
        break;
      case HeartType.Sentence:
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kRelayCollectionID)
            .document(documentID)
            .updateData({DBKeys.kRelayLikesKey: FieldValue.increment(-1)});
        await _firestore
            .collection(DBKeys.kRoomCollectionID)
            .document(roomID)
            .collection(DBKeys.kRelayCollectionID)
            .document(documentID)
            .collection(DBKeys.kLikedbyCollectionID)
            .where(DBKeys.kLikedbyLikerKey, isEqualTo: currentUser.uid)
            .getDocuments()
            .then((value) {
          value.documents[0].reference.delete();
        });
        break;
    }
  }

  Future<void> deleteSentence(
      {@required FirebaseUser currentUser,
      @required roomID,
      @required sentenceID}) async {
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kRelayCollectionID)
        .getDocuments()
        .then((value) async {
      for (var ds in value.documents) {
        await ds.reference
            .collection(DBKeys.kLikedbyCollectionID)
            .getDocuments()
            .then((subvalue) async {
          for (var subds in subvalue.documents) {
            await subds.reference.delete();
          }
        });
        ds.reference.delete();
      }
    });
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kRelayCollectionID)
        .document(sentenceID)
        .delete();
  }

  Future<void> deleteComment(
      {@required FirebaseUser currentUser,
      @required roomID,
      @required commentID}) async {
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kCommentsCollectionID)
        .getDocuments()
        .then((value) async {
      for (var ds in value.documents) {
        await ds.reference
            .collection(DBKeys.kLikedbyCollectionID)
            .getDocuments()
            .then((subvalue) async {
          for (var subds in subvalue.documents) {
            await subds.reference.delete();
          }
        });
        ds.reference.delete();
      }
    });
    await _firestore
        .collection(DBKeys.kRoomCollectionID)
        .document(roomID)
        .collection(DBKeys.kCommentsCollectionID)
        .document(commentID)
        .delete();
  }

  Future<Map> loadMyPage({@required FirebaseUser currentUser}) async {
    DocumentReference docRef = _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('${currentUser.uid}');
    DocumentSnapshot doc = await docRef.get();
    return doc.data;
  }

  Future<List<DocumentSnapshot>> loadNovelList(
      {@required FirebaseUser currentUser,
      List<String> tags,
      DocumentSnapshot startAfter,
      @required SortingOption sortingOption}) async {
    QuerySnapshot snapshot;
    Query defaultQuery;
    if (tags != null) {
      defaultQuery = _firestore
          .collection(DBKeys.kRoomCollectionID)
          .where(DBKeys.kRoomTagsKey, arrayContainsAny: tags)
          .limit(20);
    } else {
      defaultQuery = _firestore.collection(DBKeys.kRoomCollectionID).limit(20);
    }
    if (startAfter == null) {
      switch (sortingOption) {
        case SortingOption.Date:
          defaultQuery = defaultQuery
              .orderBy(SortingOptions[sortingOption.index], descending: true);
          break;
        case SortingOption.Participatable:
          defaultQuery =
              defaultQuery.orderBy(SortingOptions[sortingOption.index]);
          break;
        case SortingOption.Likes:
          defaultQuery = defaultQuery
              .orderBy(SortingOptions[sortingOption.index], descending: true);
          break;
      }
    } else {
      switch (sortingOption) {
        case SortingOption.Date:
          defaultQuery = defaultQuery
              .orderBy(DBKeys.kRoomCreatedTimeKey, descending: true)
              .startAfterDocument(startAfter);
          break;
        case SortingOption.Participatable:
          defaultQuery = defaultQuery
              .orderBy(DBKeys.kRoomIsFullKey)
              .startAfterDocument(startAfter);
          break;
        case SortingOption.Likes:
          defaultQuery = defaultQuery
              .orderBy(DBKeys.kRoomLikesKey, descending: true)
              .startAfterDocument(startAfter);
          break;
      }
    }
    snapshot = await defaultQuery.getDocuments();
    return snapshot.documents;
  }

  Future<String> setProfilePicture(File image, FirebaseUser currentUser) async {
    StorageReference storageReference =
        _storage.ref().child('profile_pictures/${currentUser.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    String url;
    await storageReference.getDownloadURL().then((fileURL) {
      url = fileURL;
    });
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document(currentUser.uid)
        .updateData({DBKeys.kUserProfilePictureKey: url});
    return url;
  }

  Future<String> getProfilePicture(String userid) async {
    DocumentSnapshot userInfoSnapshot;
    await _firestore
        .collection(DBKeys.kUserCollectionID)
        .document('$userid')
        .get()
        .then((value) {
      userInfoSnapshot = value;
    });
    String url = userInfoSnapshot[DBKeys.kUserProfilePictureKey];
    return url;
  }

  Future showNickNameDialog(
      {@required BuildContext context, @required FirebaseUser currentUser}) {
    final _formKey = GlobalKey<FormState>();
    String _nickName;
    return showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text('별명 짓기'),
          content: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: "별명", hintText: "별명은 한글 2~6자"),
                  maxLength: 6,
                  onChanged: (text) {
                    _nickName = text;
                  },
                  validator: (value) {
                    Pattern nickNamePattern = r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$';
                    RegExp nickNameRegex = RegExp(nickNamePattern);
                    if (!nickNameRegex.hasMatch(value)) {
                      return "별명은 숫자 포함 한글 2~6자 사이입니다.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  bool isAlreadyUsed =
                      await nickNameAlreadyUsed(nickName: _nickName);
                  if (isAlreadyUsed) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("별명 중복"),
                        content: Text('이미 있는 별명입니다.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                  } else if (_formKey.currentState.validate()) {
                    setUserNickName(
                        currentUser: currentUser, nickName: _nickName);
                    Navigator.of(context).pushAndRemoveUntil(
                        mainRoute(currentUser), (route) => false);
                  }
                },
                child: Text('확인'))
          ],
        ));
  }
}
