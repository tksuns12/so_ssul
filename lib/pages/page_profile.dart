import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/database.dart';
import 'package:image_cropper/image_cropper.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class ProfilePage extends StatelessWidget {
  final FirebaseUser currentUser;

  const ProfilePage({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ProfilePicture(
      currentUser: currentUser,
    ));
  }
}

class ProfilePicture extends StatefulWidget {
  final FirebaseUser currentUser;
  const ProfilePicture({Key key, @required this.currentUser}) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  DBManager _dbManager = GetIt.I.get<DBManager>();
  Map userInfo;
  var _profilePicture;
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _loadPictureFromServer();
    return StreamBuilder(
        stream: _dbManager.loadUserInfo(user: widget.currentUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String url =
                snapshot.data[DBKeys.kUserProfilePictureKey];
            _profilePicture = NetworkImage(url);
          }
          return FlatButton(
              onPressed: () async {
                await _pickImage();
                await _cropImage();
                await _dbManager.setProfilePicture(
                    _imageFile, widget.currentUser);
                setState(() {
                });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: _profilePicture != null
                    ? _profilePicture
                    : AssetImage('assets/images/default_profile.png'),
                backgroundColor: Colors.transparent,
              ));
        });
  }
  
  _pickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50);

    if (croppedFile != null) {
        _imageFile = croppedFile;
    }
  }
}
