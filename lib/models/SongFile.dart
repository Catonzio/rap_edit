class SongFile {
  String title;
  String text;
  DateTime lastModified;
  String path;

  SongFile(this.title, this.text, this.path) {
    lastModified = DateTime.now();
  }

  String getTitle() { return this.title; }
  String getText() { return this.text; }
  String getPath() { return this.path; }
  DateTime getLastModified() { return this.lastModified; }
  void setTitle(String title) { this.title = title; }
  void setText(String text) { this.text = text; }
  void setLastModified(DateTime time) { lastModified = time; }
  void setPath(String path) { this.path = path; }

  String lastModifiedToString() {
    int day = lastModified.day;
    int month = lastModified.month;
    int year = lastModified.year;
    int hours = lastModified.hour;
    int minutes = lastModified.minute;
    int seconds = lastModified.second;

    return "$hours:$minutes:$seconds $day/$month/$year";
  }

  bool isEmpty() {
    return this.text.isEmpty;
  }

  @override
  String toString() {
    return "Title: " + title + "\nTesto: " + text;
  }
}