import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/repositories/beats_repository.dart';
import 'package:rap_edit/utils/constants.dart';
import 'package:rap_edit/utils/enums.dart';

class BeatsController extends GetxController {
  static final BeatsController to = Get.find<BeatsController>();

  final BeatsRepository beatsRepository = BeatsRepository.to;

  final RxBool _isLoadingBeats = false.obs;
  bool get isLoadingBeats => _isLoadingBeats.value;
  set isLoadingBeats(bool value) => _isLoadingBeats.value = value;

  RxList<Beat> beats = <Beat>[].obs;
  RxList<Beat> assetBeats = <Beat>[].obs;
  RxList<Beat> localBeats = <Beat>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxString _searchString = "".obs;
  String get searchString => _searchString.value;
  set searchString(String value) => _searchString.value = value;

  Beat? getBeatWithUrl(String songUrl) =>
      beats.where((Beat beat) => beat.songUrl == songUrl).firstOrNull;

  @override
  void onInit() {
    fetchBeats();
    super.onInit();
  }

  void fetchBeats() async {
    if (beats.isEmpty) {
      isLoadingBeats = true;
      List<Beat> beats = await beatsRepository.getAllBeats();
      if (beats.isEmpty) {
        await beatsRepository.saveBeats(assetsBeats);
        beats = assetsBeats;
      }
      this.beats = beats.obs;
      assetBeats = beats.where((beat) => beat.sourceType == SourceType.asset).toList().obs;
      localBeats = beats.where((beat) => beat.sourceType == SourceType.file).toList().obs;
      isLoadingBeats = false;
    }
  }

  void loadBeat(Beat beat) {
    if (beats.isEmpty) {
      fetchBeats();
    }
    HomeController.to.setSong(beat);
  }

  Future<void> uploadBeatsFromFileSystem() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: musicExtensions,
        onFileLoading: (status) {
          print(status);
        });

    if (result != null) {
      List<Beat> newBeats = result.paths
          .where((path) =>
              path != null && !localBeats.map((beat) => beat.songUrl).contains(path))
          .map((path) => Beat.fromPath(path!))
          .toList();
      beatsRepository.saveBeats(newBeats);
      beats = [...beats, ...newBeats].obs;
      localBeats = [...localBeats, ...newBeats].obs;
    } else {
      // User canceled the picker
    }
  }
}
