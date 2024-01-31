import 'package:rap_edit/utils/constants.dart';

class Lyric {
  final String id;
  String title;
  String songUrl;
  String text;
  String beatId;

  String get songName => songUrl.split("/").last;

  Lyric({
    required this.id,
    required this.title,
    required this.songUrl,
    required this.text,
    required this.beatId,
  });

  factory Lyric.empty() {
    return Lyric(id: uuid.v4(), title: "", songUrl: "", text: "", beatId: "");
  }

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      id: json['id'] ?? uuid.v4(),
      title: json['title'] ?? "",
      songUrl: json['songUrl'] ?? "",
      text: json['text'] ?? "",
      beatId: json['beatId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'songUrl': songUrl,
      'text': text,
      'beatId': beatId,
    };
  }

  @override
  String toString() {
    return 'Lyric{id: $id, title: $title, songUrl: $songUrl, text: $text beatId: $beatId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lyric &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          songUrl == other.songUrl &&
          text == other.text &&
          beatId == other.beatId;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ songUrl.hashCode ^ text.hashCode ^ beatId.hashCode;
}
