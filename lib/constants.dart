import 'package:flutter/material.dart';

const kInitialPoint = 1000;
const kDarkPrimaryColor = Color(0xFF0096a7);
const kPrimaryColor = Color(0xFF00bcd4);
const kLightPrimaryColor = Color(0xFFb2ebf2);
const kTextIconsColor = Colors.white;
const kAccentColor = Color(0xFF009688);

enum AppBody{Home, List, LeaderBoard, Settings}

class DBKeys {
  static const kUserCollectionID = 'users';
  static const kRoomCollectionID = 'rooms';
  static const kUserLastVisitKey = 'last_visit';
  static const kUserNickNameKey = 'nickname';
  static const kUserGradeKey = 'grade';
  static const kUserEmailKey = 'email';
  static const kUserPointKey = 'point';
  static const kUserJoinDateKey = 'joindate';
  static const kUserAchievementKey = 'achievement';
  static const kUserProfilePictureKey = 'profile_picture';
  static const kRoomTitleKey = 'title';
  static const kRoomCharacterLimitKey = 'charlimit';
  static const kRoomInitialSentenceKey = 'initsentence';
  static const kRoomParticipantLimitKey = 'part_limit';
  static const kRoomLikesKey = 'likes';
  static const kRoomCreatedTimeKey = 'time';
  static const kRoomIsFinishedKey = 'finished';
  static const kRoomAuthorIDKey = 'authorID';
  static const kRoomAuthorNicknameKey = 'author';
  static const kRoomVisitKey = 'visit';
  static const kRoomIsFullKey = 'isfull';
  static const kRoomEnjoyKey = 'enjoy';
  static const kRoomTagsKey = 'tags';
  static const kRoomParticipantsIDKey = 'participantsID';
  static const kRoomParticipantsNicknameKey = 'participants_name';
  static const kRoomParticipantsNumberKey = 'participants_num';
  static const kRoomRecentWriterKey = 'recentwriter';
  static const kRelayCollectionID = 'relays';
  static const kRelayAuthorID = 'authorID';
  static const kRelayAuthorNickname = 'author';
  static const kRelayCreatedTime = 'time';
  static const kRelayContentKey = 'content';
  static const kRelayLikesKey = 'likes';
  static const kCommentsCollectionID = 'comments';
  static const kCommentsAuthorID = 'authorID';
  static const kCommentsAuthorNickname = 'author';
  static const kCommentsCreatedTime = 'time';
  static const kCommentsContentKey = 'content';
  static const kCommentsLikesKey = 'likes';
  static const kLikedbyCollectionID = 'likedby';
  static const kLikedbyLikerKey = 'liker';
  static const kReportsCollectionID = 'reports';
  static const kReportsCreatedTimeKey = 'time';
  static const kReportsReportedUserKey = 'reported_user';
  static const kReportsReasonKey = 'resaon';
  static const kReportsContentKey = 'content';
}