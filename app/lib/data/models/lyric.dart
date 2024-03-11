import 'package:rap_edit/utils/constants.dart';

class Lyric {
  final String id;
  String title;
  String text;
  String beatUrl;
  String beatId;

  String get beatName => beatUrl.split("/").last;

  Lyric({
    required this.id,
    required this.title,
    required this.beatUrl,
    required this.text,
    required this.beatId,
  });

  factory Lyric.empty() {
    return Lyric(id: uuid.v4(), title: "", beatUrl: "", text: "", beatId: "");
  }

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      id: json['id'] ?? uuid.v4(),
      title: json['title'] ?? "",
      beatUrl: json['beatUrl'] ?? "",
      text: json['text'] ?? "",
      beatId: json['beatId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'beatUrl': beatUrl,
      'text': text,
      'beatId': beatId,
    };
  }

  @override
  String toString() {
    return 'Lyric{id: $id, title: $title, beatUrl: $beatUrl, text: $text beatId: $beatId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lyric &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          beatUrl == other.beatUrl &&
          text == other.text &&
          beatId == other.beatId;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      beatUrl.hashCode ^
      text.hashCode ^
      beatId.hashCode;
}
