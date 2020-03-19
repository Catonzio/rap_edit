import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/models/SongFile.dart';

class FileController {

  static String filePath;

  ///Sets the directory path of files written on the phone in this application
  static setDirectoryPath() async {
    filePath = (await getApplicationDocumentsDirectory()).path;
  }

  /// Read the content of the text of the song named as title
  static String readFile(String title) {
    try {
      File file = new File(filePath + "/" + title);
      return file.readAsStringSync();
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Writes a file named as the song title (.txt) which content is the text of the song
  static void writeFile(SongFile song) {
    song.setLastModified(DateTime.now());
    song.setPath(filePath + "/" + song.title + ".txt");
    File file = new File(song.path);
    file.writeAsStringSync(song.getText());
  }

  /// Given the path, extracts the name of the file (with extension)
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

  /*static getListDownloads() async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    List<FileSystemEntity> file = dir.listSync();
    file.forEach((file) {
      if(file.path.contains("aaaa")) {
        debugPrint("ooooooooooooooooooo " + file.path);
      }
    });
  }*/

  /// Given the directory path, extracts the list of FileSystemEntity that are there
  static List<FileSystemEntity> getListOfFilesFromDirectory(String directory) {
    List<FileSystemEntity> file = new List();
    file = Directory("$directory").listSync();
    file.removeRange(0, 2);
    return file;
  }

  /// Extracts the list of SongFiles from the current FilePath
  static List<SongFile> getListOfFiles() {
    List<FileSystemEntity> file = new List();
    file = Directory("$filePath").listSync();
    file.removeRange(0, 2);
    return getSongsFromFiles(file);
  }

  /// Delete the file which correspond to the song
  static deleteFile(SongFile song) {
    loadFileEntityFromSong(song).deleteSync();
  }

  static deleteRegistration(String path) {
    File(path).deleteSync();
  }

  /// Return the FileSystemEntity that has as path the path of the song
  static FileSystemEntity loadFileEntityFromSong(SongFile song) {
    return new File(song.path);
  }

  /// Returns a list of SongFile built by the list of FileSystemEntity passed as argument
  static List<SongFile> getSongsFromFiles(List<FileSystemEntity> file) {
    List<SongFile> songs = new List();
    for(FileSystemEntity song in file) {
      SongFile newSong = saveSongFromEntity(song);
      if(newSong != null)
        songs.add(newSong);
    }
    return songs;
  }

  /// Create a song from the FileSystemEntity passed as argument
  static SongFile saveSongFromEntity(FileSystemEntity song) {
    String name = getOnlyFileName(song.path);
    SongFile newSong;
    //DA AGGIUSTARE IL FATTO CHE QUANDO VIENE CREATA UNA NUOVA CANZONE (OVVERO QUANDO SI CARICA LA LISTA DI FILE),
    // LA DATA SI MODIFICA
    if(name.contains(".txt"))
      newSong = new SongFile(name.substring(0, name.lastIndexOf(".txt")), readFile(name), song.path);
    return newSong;
  }

  static String manageName(String text) {
    String result;
    RegExp regExp = RegExp(r'(\({1}[0-9]+\){1})$');
    if(regExp.hasMatch(text)) {
      String str = regExp.stringMatch(text);
      int number = int.parse(str.substring(1, str.length - 1));
      number = number + 1;
      result = text.substring(0, text.indexOf(str)) +
      "(" + number.toString() + ")";
    } else {
      result = text + "(1)";
    }
    return result;
  }

  static bool existsRecord(String text) {
    bool itExists = false;
    Directory dir = Directory(filePath);
    dir.listSync().forEach((file) {
      String path = file.path.substring(0, file.path.lastIndexOf("."));
      if(path.endsWith((text)))
        itExists = true;
    });
    return itExists;
  }

}