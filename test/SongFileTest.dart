import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rap_edit/models/SongFile.dart';

void main() {

  test("test if the json is created well", () {
    SongFile songFile = new SongFile(title: "prova", text: "questo è un testo\ndi prova", path: "dir/cstm/prova", lastModified: null, beatPath: "path/to/beat", beatIsAsset: true, beatIsLocal: false);
    SongFile songFile2 = new SongFile();
    songFile2.fromJsonFormat(songFile.toJsonFormat());
    expect(songFile.toJsonFormat(), songFile2.toJsonFormat());
  });

  test("test with empty title and text", () {
    SongFile songFile = new SongFile(title: "", text: "", path: "dir/cstm/prova", lastModified: null, beatPath: "path/to/beat", beatIsAsset: true, beatIsLocal: false);
    SongFile songFile2 = new SongFile();
    songFile2.fromJsonFormat(songFile.toJsonFormat());
    expect(songFile.toJsonFormat(), songFile2.toJsonFormat());
  });

  test("test with a bracket in the text", () {
    SongFile songFile = new SongFile(title: "prova", text: "questo è {un testo\ndi} prova", path: "dir/cstm/prova", lastModified: null, beatPath: "path/to/beat", beatIsAsset: true, beatIsLocal: false);
    SongFile songFile2 = new SongFile();
    songFile2.fromJsonFormat(songFile.toJsonFormat());
    expect(songFile.toJsonFormat(), songFile2.toJsonFormat());
  });

  test("test with a bracket in the title", () {
    SongFile songFile = new SongFile(title: "pr{ov\n}a", text: "questo è un testo\ndi prova", path: "dir/cstm/prova", lastModified: null, beatPath: "path/to/beat", beatIsAsset: true, beatIsLocal: false);
    SongFile songFile2 = new SongFile();
    songFile2.fromJsonFormat(songFile.toJsonFormat());
    expect(songFile.toJsonFormat(), songFile2.toJsonFormat());
  });

  test("test with empty path", () {
    SongFile songFile = new SongFile(title: "prova", text: "questo è un testo\ndi prova", path: "", lastModified: null, beatPath: "path/to/beat", beatIsAsset: true, beatIsLocal: false);
    SongFile songFile2 = new SongFile();
    songFile2.fromJsonFormat(songFile.toJsonFormat());
    expect(songFile.toJsonFormat(), songFile2.toJsonFormat());
  });

}