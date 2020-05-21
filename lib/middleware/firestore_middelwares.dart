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

final Authentication authentication = GetIt.I.get<Authentication>();