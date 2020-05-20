class AddTagAction {
  final String tag;

  AddTagAction(this.tag);

}

class DeleteTagAction {
  final String tag;

  DeleteTagAction(this.tag);
  
}

class ChangeEnjoyCheckAction {
  final bool value;

  ChangeEnjoyCheckAction(this.value);

}

class UpdateTitleAction {
  final String title;

  UpdateTitleAction(this.title);

}

class UpdateFirstSentenceAction {
  final String initsentence;

  UpdateFirstSentenceAction(this.initsentence);
}