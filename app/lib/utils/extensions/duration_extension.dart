import 'package:rap_edit/utils/utility_functions.dart';

extension DurationExtension on Duration {
  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  double operator /(Duration other) => adjustNanWidth(
      inMilliseconds.toDouble() / other.inMilliseconds.toDouble());

  double operator *(double other) => adjustNanWidth(
      inMilliseconds.toDouble() * other);

  double get ms => inMilliseconds.toDouble();
}
