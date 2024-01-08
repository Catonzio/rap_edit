import 'package:rap_edit/utils/constants.dart';

class Beat {
  final String id;
  String title;
  String songUrl;

  Beat({
    required this.id,
    required this.title,
    required this.songUrl,
  });

  factory Beat.empty() {
    return Beat(id: uuid.v4(), title: "", songUrl: "");
  }

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      id: json['id'],
      title: json['title'],
      songUrl: json['songUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'songUrl': songUrl,
    };
  }

  @override
  String toString() {
    return 'Beat{id: $id, title: $title, songUrl: $songUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beat &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          songUrl == other.songUrl;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ songUrl.hashCode;
}
