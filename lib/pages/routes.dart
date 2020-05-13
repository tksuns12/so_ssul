import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

MaterialPageRoute mainRoute(FirebaseUser currentUser) {
  return MaterialPageRoute(builder: (context) => Main(currentUser: currentUser,));
}