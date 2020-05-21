import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sossul/constants.dart';

class RoomInfo {
  final String title;
  final List<String> tags;
  final int partLimit;
  final int charLimit;
  final bool isEnjoy;
  final String initSentence;

  RoomInfo(
      {this.title,
      this.tags,
      this.partLimit,
      this.charLimit,
      this.isEnjoy,
      this.initSentence});

      factory RoomInfo.fromSnapshot(DocumentSnapshot snapshot) {
        return RoomInfo(charLimit: snapshot.data[DBKeys.kRoomCharacterLimitKey],
        title: snapshot.data[DBKeys.kRoomTitleKey],
        tags: snapshot.data[DBKeys.kRoomTagsKey],);

        //TODO: 여기 패러미터 더 추가해야 됨.
      }
}
