import 'package:flutter/cupertino.dart';

class SongFile {
  String title;
  String text;
  String beatPath;
  bool beatIsAsset;
  bool beatIsLocal;
  DateTime lastModified;
  String path;

  SongFile({
    Key key,
    this.title, this.text, this.path, this.beatPath, this.beatIsLocal, this.beatIsAsset, this.lastModified
  }) {
    if(lastModified == null)
      lastModified = DateTime.now();
  }

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

  String toJsonFormat() {
    String result;
    result = "title: $title\n" +
             "text: {\n$text\n}\n" +
             "lastModified: ${lastModifiedToString()}\n" +
             "path: $path\n" +
             "beatPath: $beatPath\n" +
             "beatIsAsset: $beatIsAsset\n" +
             "beatIsLocal: $beatIsLocal";
    return result;
  }

  SongFile fromJsonFormat(String jsonFormat) {
    try {
      title = jsonFormat.substring(jsonFormat.indexOf("title: ") + 7, jsonFormat.indexOf("\ntext"));
      text = jsonFormat.substring(jsonFormat.indexOf("text: {") + 8, jsonFormat.indexOf("}\nlastModified")-1);
      lastModified = dateFromString(jsonFormat.substring(jsonFormat.indexOf("lastModified: ") + 14, jsonFormat.indexOf("\npath")));
      path = jsonFormat.substring(jsonFormat.indexOf("path: ") + 6, jsonFormat.indexOf("\nbeatPath"));
      beatPath = jsonFormat.substring(jsonFormat.indexOf("beatPath: ") + 10, jsonFormat.indexOf("\nbeatIsAsset"));
      beatIsAsset = jsonFormat.substring(jsonFormat.indexOf("beatIsAsset: ") + 13, jsonFormat.indexOf("\nbeatIsLocal")) == "true";
      beatIsLocal = jsonFormat.substring(jsonFormat.indexOf("beatIsLocal: ") + 13) == "true";
      return this;
    } catch(ex) {
      debugPrint("Malformed formatting of the song file!");
      return null;
    }
  }

  DateTime dateFromString(String dateString) {
    int year = int.parse(dateString.substring(dateString.lastIndexOf("/") + 1));
    int month = int.parse(dateString.substring(dateString.indexOf("/") + 1, dateString.lastIndexOf("/")));
    int day = int.parse(dateString.substring(dateString.indexOf(" ") + 1, dateString.indexOf("/")));
    int seconds = int.parse(dateString.substring(dateString.lastIndexOf(":") + 1, dateString.indexOf(" ")));
    int minutes = int.parse(dateString.substring(dateString.indexOf(":") + 1, dateString.lastIndexOf(":")));
    int hours = int.parse(dateString.substring(0, dateString.indexOf(":")));

    return DateTime(
      year,
      month,
      day,
      hours,
      minutes,
      seconds
    );
  }
}