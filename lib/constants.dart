import 'package:flutter/material.dart';

const kInitialPoint = 1000;
const kMainColor = Color(0xFF00bcd4);
const kBottomNavigationItemColor = Color(0xFFb2ebf2);

class DBKeys {
  static const kUserCollectionID = 'users';
  static const kRoomCollectionID = 'rooms';
  static const kUserLastVisitKey = 'last_visit';
  static const kUserNickNameKey = 'nickname';
  static const kUserGradeKey = 'grade';
  static const kUserEmailKey = 'email';
  static const kUserPointKey = 'point';
  static const kUserJoinDateKey = 'joindate';
  static const kUserAchievementKey = 'achievment';
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
}