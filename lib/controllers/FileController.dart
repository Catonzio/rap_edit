import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/models/SongFile.dart';

class FileController {

  static String filePath;

  static setDirectoryPath() async {
    filePath = (await getApplicationDocumentsDirectory()).path;
  }

  static String readFile(String title) {
    try {
      File file = new File(filePath + "/" + title);
      return file.readAsStringSync();
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static void writeFile(SongFile song) {
    song.setLastModified(DateTime.now());
    song.setPath(filePath + "/" + song.title + ".txt");
    File file = new File(song.path);
    file.writeAsStringSync(song.getText());
  }

  static String getOnlyFileName(String path) {
    if(path == null)
      return "";
    if(path.endsWith(".txt")) {
      return path.substring(path.lastIndexOf("/") + 1);
    }
    else if(path.endsWith(".mp3")) {
      return path.substring(path.lastIndexOf("/") + 1);
    }
    else {
      return "";
    }
  }

  static List<FileSystemEntity> getListOfFilesFromDirectory(String directory) {
    List<FileSystemEntity> file = new List();
    file = Directory("$directory").listSync();
    file.removeRange(0, 2);
    return file;
  }

  static List<SongFile> getListOfFiles() {
    List<FileSystemEntity> file = new List();
    file = Directory("$filePath").listSync();
    file.removeRange(0, 2);
    return getSongsFromFiles(file);
  }

  static deleteFile(SongFile song) {
    loadFileEntityFromSong(song).deleteSync();
  }

  static FileSystemEntity loadFileEntityFromSong(SongFile song) {
    return new File(song.path);
  }

  static List<SongFile> getSongsFromFiles(List<FileSystemEntity> file) {
    List<SongFile> songs = new List();
    for(FileSystemEntity song in file) {
      SongFile newSong = saveSongFromEntity(song);
      if(newSong != null)
        songs.add(newSong);
    }
    return songs;
  }

  static SongFile saveSongFromEntity(FileSystemEntity song) {
    String name = getOnlyFileName(song.path);
    SongFile newSong;
    //DA AGGIUSTARE IL FATTO CHE QUANDO VIENE CREATA UNA NUOVA CANZONE (OVVERO QUANDO SI CARICA LA LISTA DI FILE),
    // LA DATA SI MODIFICA
    if(name.contains(".txt"))
      newSong = new SongFile(name.substring(0, name.lastIndexOf(".txt")), readFile(name), song.path);
    return newSong;
  }

}