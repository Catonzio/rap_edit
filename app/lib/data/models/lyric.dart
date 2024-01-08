import 'package:rap_edit/utils/constants.dart';

class Lyric {
  final String id;
  String title;
  String songUrl;
  String text;

  Lyric({
    required this.id,
    required this.title,
    required this.songUrl,
    required this.text,
  });

  factory Lyric.empty() {
    return Lyric(id: uuid.v4(), title: "", songUrl: "", text: "");
  }

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      id: json['id'],
      title: json['title'],
      songUrl: json['songUrl'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'songUrl': songUrl,
      'text': text,
    };
  }

  @override
  String toString() {
    return 'Lyric{id: $id, title: $title, songUrl: $songUrl, text: $text}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lyric &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          songUrl == other.songUrl &&
          text == other.text;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ songUrl.hashCode ^ text.hashCode;
}
