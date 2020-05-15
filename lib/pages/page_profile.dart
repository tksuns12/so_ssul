import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/database.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseUser currentUser;

  const ProfilePage({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: ProfilePicture(currentUser: currentUser,));
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
  var profile;

  @override
  Widget build(BuildContext context) {
    _getPicture();

    return FlatButton(onPressed: () async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((picture) {
        _dbManager.setProfilePicture(picture, widget.currentUser);
        setState(() {
          _getPicture();
        });
      });
    },
        child: CircleAvatar(radius: 30, backgroundImage: profile, backgroundColor: kMainColor,)
    );
  }

  Future<void> _getPicture() async {
    await _dbManager.getProfilePicture(widget.currentUser).then((url) {
      if (url != null){
      profile = NetworkImage(url);}
      else {
        profile = NetworkImage('https://firebasestorage.googleapis.com/v0/b/so-ssul.appspot.com/o/pngfuel.com.png?alt=media&token=317e88bf-bc0f-4644-8da9-07660ae93735');
      }
    });
  }
}
