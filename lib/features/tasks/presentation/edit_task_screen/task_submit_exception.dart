class TaskSubmitException {
  String get title => 'Title already used';
  String get description => 'Please choose a different task title';

  @override
  String toString() {
    return '$title. $description.';
  }
}
