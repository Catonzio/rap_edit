import 'dart:io';

import 'package:rap_edit/utils/constants.dart';
import 'package:rap_edit/utils/enums.dart';
import 'package:rap_edit/utils/utility_functions.dart';

class Beat {
  final String id;
  String title;
  String songUrl;
  SourceType sourceType;

  Beat({
    required this.id,
    required this.title,
    required this.songUrl,
    required this.sourceType,
  });

  factory Beat.empty() {
    return Beat(
        id: uuid.v4(), title: "", songUrl: "", sourceType: SourceType.asset);
  }

  factory Beat.fromAsset(String assetUrl) {
    return Beat(
        id: uuid.v4(),
        title: extractNameFromPath(assetUrl),
        songUrl: assetUrl,
        sourceType: SourceType.asset);
  }

  factory Beat.fromSongUrl(String songUrl) {
    return Beat(
        id: uuid.v4(),
        title: extractNameFromPath(songUrl),
        songUrl: songUrl,
        sourceType: SourceType.url);
  }

  factory Beat.fromPath(String path) {
    return Beat(
        id: uuid.v4(),
        title: extractNameFromPath(path),
        songUrl: path,
        sourceType: SourceType.file);
  }

  factory Beat.fromFile(File file) {
    return Beat.fromPath(file.path);
  }

  factory Beat.fromJson(Map<String, dynamic> json) {
    return Beat(
      id: json['id'],
      title: json['title'],
      songUrl: json['songUrl'],
      sourceType: SourceType.values
          .firstWhere((type) => type.name == json['sourceType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'songUrl': songUrl,
      'sourceType': sourceType.name,
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
