import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';

class FileController {

  static String filePath;
  static String textsFilePath;
  static String registrationsPath;
  static String mixedSongsPath;
  static String temporaryPath;

  ///Sets the directory path of files written on the phone in this application
  static setDirectoryPath() async {
    filePath = (await getApplicationDocumentsDirectory()).path;
    temporaryPath = (await getTemporaryDirectory()).path;
    textsFilePath = filePath + "/texts/";
    registrationsPath = filePath + "/registrations/";
    mixedSongsPath = filePath + "/mixed/";
    //mixedSongsPath = "/data/data/com.catonz.rap_edit/code_cache/rap_editHHRLMD/rap_edit/build/flutter_assets/assets/mixed/";
    //create the folders if there aren't
    Directory(textsFilePath).createSync();
    Directory(registrationsPath).createSync();
    Directory(mixedSongsPath).createSync();
  }

  /// Read the content of the text of the song named as title
  static String readFile(String path) {
    try {
      File file = new File(path);
      return file.readAsStringSync();
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Loads the assets files to a temporary files.
  /// TO IMPROVE (now must be updated for each new file in assets folder)
  static void prepareAssets() {
    copyFileAssets("assets/Hip_Hop_Instrumental_Beat.mp3", "Hip_Hop_Instrumental_Beat.mp3");
    copyFileAssets("assets/metronome_100bpm_4-4.mp3", "metronome_100bpm_4-4.mp3");
    copyFileAssets("assets/metronome_100bpm_6-8.mp3", "metronome_100bpm_6-8.mp3");
    copyFileAssets("assets/Rap_Instrumental_Beat.mp3", "Rap_Instrumental_Beat.mp3");
    copyFileAssets("assets/Trap_Instrumental_Beat.mp3", "Trap_Instrumental_Beat.mp3");
    copyFileAssets("assets/Gemitaiz - Gigante (instrumental).mp3", "Gemitaiz - Gigante (instrumental).mp3");
  }

  /// Writes a file named as the song title (.txt) which content is the text of the song
  static void writeFile(SongFile song) {
    song.path = textsFilePath + song.title + ".txt";
    File file = new File(song.path);
    try {
      file.writeAsStringSync(song.toJsonFormat());
    } catch (ex) {
      Directory(textsFilePath).createSync();
      file.writeAsStringSync(song.toJsonFormat());
    }
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

  /// returns the full path of the asset with given Name
  static String assetPath(String assetName) {
    return join(temporaryPath, assetName);
  }

  /// Creates a temporary file to load the asset for ffmpeg
  static Future<File> copyFileAssets(String assetName, String localName) async {
    final ByteData assetByteData = await rootBundle.load(assetName);

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullTemporaryPath = join(temporaryPath, localName);

    return new File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);
  }

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
    file = Directory("$textsFilePath").listSync();
    debugPrint("$filePath");
    return getSongsFromFiles(file);
  }

  /// Delete the file which correspond to the song
  static deleteFile(SongFile song) {
    loadFileEntityFromSong(song).deleteSync();
  }

  static deleteRegistration(String path) {
    if(SongSingleton.instance.beatPath == path)
      SongSingleton.instance.beatPath = "";
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
    if(name.contains(".txt"))
      newSong = new SongFile().fromJsonFormat(readFile(song.path));
    return newSong;
  }

  static String manageName(String text) {
    String result = text;
    RegExp regExp = RegExp(r'(\({1}[0-9]+\){1})$');
    // if text is like test(1)
    if(regExp.hasMatch(text)) {
      String str = regExp.stringMatch(text);
      int number = int.parse(str.substring(1, str.length - 1));
      number = number + 1;
      result = text.substring(0, text.indexOf(str)) +
      "(" + number.toString() + ")";
    } else {
      int number = numberOfOccurrences(registrationsPath, text);
      if(number == 0)
        return result;
      else
        result = text + "($number)";
    }
    return result;
  }

  static int numberOfOccurrences(String path, String text) {
    int number = 0;
    // if text is like "/data/user/0/.../test.wav"; otherwise, is like "test.wav" or "test"
    if(text.startsWith("/"))
      text = text.substring(text.lastIndexOf("/") + 1);
    Directory dir = Directory(path);
    dir.listSync().forEach((file) {
      String path = file.path;
      if(path.startsWith("/"))
        path = path.substring(path.lastIndexOf("/") + 1);
      if(!path.endsWith(".txt") && path.startsWith(text))
        number = number + 1;
    });
    return number;
  }

  static bool existsRecord(String text) {
    return numberOfOccurrences(registrationsPath, text) != 0;
  }

  static void deleteAllRegistrations() {
    Directory dir = Directory(filePath);
    dir.listSync().forEach((file) {
      if(file.path.endsWith(".wav")) {
        file.deleteSync();
      }
    });
  }

}