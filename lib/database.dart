import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sossul/pages/routes.dart';

enum HeartType { Novel, Sentence, Comment }
enum SortingOption { Date, Participatable, Likes }
const SortingOptions = ['time', 'isfull', 'likes'];

class DBManager {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> onExecuteApp({@required FirebaseUser currentUser}) async {
    await _firestore
        .collection('users')
        .document('${currentUser.uid}')
        .updateData({'lastvisit': FieldValue.serverTimestamp()});
  }

  Future<void> setUserNickName(
      {@required currentUser, @required nickName}) async {
    await _firestore
        .collection('users')
        .document('${currentUser.uid}')
        .setData({'nickname': nickName});
  }

  Future<void> createUserInfo(
      {@required FirebaseUser currentUser,
      @required BuildContext context}) async {
    await _firestore
        .collection('users')
        .document('${currentUser.uid}')
        .setData({
      'email': currentUser.email,
      'grade': 1,
      'point': 0,
      'joindate': FieldValue.serverTimestamp(),
      'lastvisit': FieldValue.serverTimestamp(),
    });

    showNickNameDialog(context: context, currentUser: currentUser);
  }

  Future<Map> loadUserInfo({@required FirebaseUser user}) async {
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
        .collection("users")
        .where("nickname", isEqualTo: nickName)
        .snapshots()
        .first;
    print(data.documents.length);
    bool isAlreadyUsed = data.documents.length != 0;
    return isAlreadyUsed;
  }

  Future<String> getNickname({@required currentUser}) async {
    String nickName;
    await _firestore
        .collection('users')
        .document('${currentUser.uid}')
        .get()
        .then((value) {
      nickName = value.data['nickname'];
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
      @required bool visibility,
      @required bool enjoy}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore.collection('rooms').add({
      'title': title,
      'charlimit': charLimit,
      'initsentence': initSentence,
      'partlimit': partLimit,
      'tags': tags,
      'visibility': visibility,
      'likes': 0,
      'time': FieldValue.serverTimestamp(),
      'finished': false,
      'authorID': currentUser.uid,
      'author': _nickName,
      'visit': 0,
      'participants': 1,
      'isfull': false,
      'enjoy': enjoy,
    });
  }

  Future<void> enterRoom({@required currentUser, @required roomID}) async {
    await _firestore
        .collection('rooms')
        .document(roomID)
        .updateData({'participants': FieldValue.arrayUnion(currentUser.uid)});
  }

  Future<void> addSentence(
      {@required FirebaseUser currentUser,
      @required String content,
      @required roomID}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore
        .collection('rooms')
        .document(roomID)
        .collection('relays')
        .add({
      'authorID': currentUser.uid,
      'author': _nickName,
      'time': FieldValue.serverTimestamp(),
      'content': content,
      'likes': 0
    });
  }

  Future<void> addComment(
      {@required FirebaseUser currentUser,
      @required String content,
      @required roomID}) async {
    String _nickName = await getNickname(currentUser: currentUser);
    await _firestore
        .collection('rooms')
        .document(roomID)
        .collection('comments')
        .add({
      'authorID': currentUser.uid,
      'author': _nickName,
      'time': FieldValue.serverTimestamp(),
      'content': content,
      'likes': 0,
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
            .collection('rooms')
            .document(roomID)
            .collection('comments')
            .document(documentID)
            .updateData({'likes': FieldValue.increment(1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('comments')
            .document(documentID)
            .collection('likedBy')
            .add({'liker': currentUser.uid});
        break;
      case HeartType.Novel:
        await _firestore
            .collection('rooms')
            .document(roomID)
            .updateData({'likes': FieldValue.increment(1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('likedBy')
            .add({'liker': currentUser.uid});
        break;
      case HeartType.Sentence:
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('relays')
            .document(documentID)
            .updateData({'likes': FieldValue.increment(1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('relays')
            .document(documentID)
            .collection('likedBy')
            .add({'liker': currentUser.uid});
        break;
    }
  }

  Future<void> closeRoom(
      {@required FirebaseUser currentUser, @required roomID}) async {
    await _firestore.collection('rooms').document(roomID).delete();
    await _firestore
        .collection('rooms')
        .document(roomID)
        .collection('relays')
        .getDocuments()
        .then((value) async {
      for (DocumentSnapshot ds in value.documents) {
        await ds.reference
            .collection('likedBy')
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
        .collection('rooms')
        .document(roomID)
        .collection('comments')
        .getDocuments()
        .then((value) async {
      for (DocumentSnapshot ds in value.documents) {
        await ds.reference
            .collection('likedBy')
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
        .collection('rooms')
        .document(roomID)
        .collection('likedBy')
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
            .collection('rooms')
            .document(roomID)
            .collection('comments')
            .document(documentID)
            .updateData({'likes': FieldValue.increment(-1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('comments')
            .document(documentID)
            .collection('likedBy')
            .where('liker', isEqualTo: currentUser.uid)
            .getDocuments()
            .then((value) {
          value.documents[0].reference.delete();
        });
        break;
      case HeartType.Novel:
        await _firestore
            .collection('rooms')
            .document(roomID)
            .updateData({'likes': FieldValue.increment(-1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('likedBy')
            .where('liker', isEqualTo: currentUser.uid)
            .getDocuments()
            .then((value) {
          value.documents[0].reference.delete();
        });
        break;
      case HeartType.Sentence:
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('relays')
            .document(documentID)
            .updateData({'likes': FieldValue.increment(-1)});
        await _firestore
            .collection('rooms')
            .document(roomID)
            .collection('relays')
            .document(documentID)
            .collection('likedBy')
            .where('liker', isEqualTo: currentUser.uid)
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
        .collection('rooms')
        .document(roomID)
        .collection('relays')
        .getDocuments()
        .then((value) async {
      for (var ds in value.documents) {
        await ds.reference
            .collection('likedBy')
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
        .collection('rooms')
        .document(roomID)
        .collection('relays')
        .document(sentenceID)
        .delete();
  }

  Future<void> deleteComment(
      {@required FirebaseUser currentUser,
      @required roomID,
      @required commentID}) async {
    await _firestore
        .collection('rooms')
        .document(roomID)
        .collection('comments')
        .getDocuments()
        .then((value) async {
      for (var ds in value.documents) {
        await ds.reference
            .collection('likedBy')
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
        .collection('rooms')
        .document(roomID)
        .collection('comments')
        .document(commentID)
        .delete();
  }

  Future<Map> loadMyPage({@required FirebaseUser currentUser}) async {
    DocumentReference docRef =
        _firestore.collection('users').document('${currentUser.uid}');
    DocumentSnapshot doc = await docRef.get();
    return doc.data;
  }

  Future<List<DocumentSnapshot>> loadNovelList(
      {@required FirebaseUser currentUser,
      List<String> tags,
      dynamic startAt,
      @required SortingOption sortingOption}) async {
    QuerySnapshot snapshot;
    Query defaultQuery;
    if (tags != null) {
      defaultQuery = _firestore
          .collection('rooms')
          .where('tags', arrayContainsAny: tags)
          .limit(20);
    } else {
      defaultQuery = _firestore.collection('rooms').limit(20);
    }
    if (startAt == null) {
      switch (sortingOption) {
        case SortingOption.Date:
          defaultQuery =
              defaultQuery.orderBy(SortingOptions[sortingOption.index]);
          break;
        case SortingOption.Participatable:
          defaultQuery =
              defaultQuery.orderBy(SortingOptions[sortingOption.index]);
          break;
        case SortingOption.Likes:
          defaultQuery =
              defaultQuery.orderBy(SortingOptions[sortingOption.index]);
          break;
      }
    } else {
      switch (sortingOption) {
        case SortingOption.Date:
          defaultQuery = defaultQuery.orderBy('time').startAt(startAt);
          break;
        case SortingOption.Participatable:
          defaultQuery = defaultQuery.orderBy('isfull').startAt(startAt);
          break;
        case SortingOption.Likes:
          defaultQuery = defaultQuery.orderBy('likes').startAt(startAt);
          break;
      }
    }
    snapshot = await defaultQuery.getDocuments();
    return snapshot.documents;
  }

  Future<String> setProfilePicture(File image) async {
    StorageReference storageReference =
        _storage.ref().child('profile_pictures');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    String url;
    storageReference.getDownloadURL().then((fileURL) {
      url = fileURL;
    });
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
