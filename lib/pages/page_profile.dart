import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/database.dart';
import 'package:image_cropper/image_cropper.dart';

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
  String imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    _loadPictureFromServer();
    return StreamBuilder(
        stream: _dbManager.loadUserInfoStream(user: widget.currentUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            imageUrl = snapshot.data[DBKeys.kUserProfilePictureKey];
            if (imageUrl != null) {
              return CircularProfileAvatar(
                imageUrl,
                backgroundColor: kMainColor,
                initialsText: Text('.'),
                radius: 30,
                onTap: () async {
                  await _pickImage();
                  await _cropImage();
                  await _dbManager.setProfilePicture(
                      _imageFile, widget.currentUser);
                },
                cacheImage: true,
                elevation: 1.0,
                borderColor: kMainColor,
                borderWidth: 1,
              );
            } else {
              return FlatButton(
                              onPressed: () async { 
                  await _pickImage();
                  await _cropImage();
                  await _dbManager.setProfilePicture(
                      _imageFile, widget.currentUser); },
                              child: CircleAvatar(
                radius: 30,
                backgroundColor: kMainColor,
            ),
              );
            }
          } else {
            return FlatButton(
                              onPressed: () async { 
                  await _pickImage();
                  await _cropImage();
                  await _dbManager.setProfilePicture(
                      _imageFile, widget.currentUser); },
                              child: CircleAvatar(
                radius: 30,
                backgroundColor: kMainColor,
            ),
              );
          }
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
