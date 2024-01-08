import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/utils/constants.dart';

class BeatsController extends GetxController {
  final RxBool _isLoadingBeats = false.obs;
  bool get isLoadingBeats => _isLoadingBeats.value;
  set isLoadingBeats(bool value) => _isLoadingBeats.value = value;

  final RxList<Beat> _beats = <Beat>[].obs;
  List<Beat> get beats => _beats;
  set beats(List<Beat> value) => _beats.value = value;

  void loadBeats() async {
    if (beats.isEmpty) {
      isLoadingBeats = true;
      beats = assetsBeats;
      isLoadingBeats = false;
    }
  }

  void loadBeat(int index) {}
}
