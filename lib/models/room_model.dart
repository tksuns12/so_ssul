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
}
