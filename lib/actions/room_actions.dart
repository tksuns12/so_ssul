import 'package:sossul/models/room_model.dart';

class OpenRoomAction {}

class OpenRoomCompleteAction {
  final RoomInfo roomInfo;

  OpenRoomCompleteAction(this.roomInfo);
}

class OpenRoomFailedAction {
  final Exception error;

  OpenRoomFailedAction(this.error);
}

class RefreshRoomAction {}

class SetRoomInfo {}