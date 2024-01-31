import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rap_edit/utils/constants.dart';

String extractNameFromPath(String path) {
  String name;
  if (path.contains("/")) {
    name = path.split("/").last;
  } else {
    if (path.contains("\\")) {
      name = path.split("\\").last;
    } else {
      name = path;
    }
  }
  for (String musicExtension in musicExtensions) {
    if (name.endsWith(musicExtension)) {
      name = name.replaceAll(musicExtension, "");
    }
  }
  return name;
}

double adjustNanWidth(double width) =>
    width.isInfinite || width.isNaN ? 0 : width;

bool isConnectionOnline(ConnectivityResult result) => [
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet
    ].contains(result);
