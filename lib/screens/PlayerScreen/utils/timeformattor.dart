String formatTime(double seconds) {

  final safeSeconds =
  seconds.floor().clamp(0, double.infinity).toInt();

  final mins = safeSeconds ~/ 60;

  final secs = safeSeconds % 60;

  return "$mins:${secs.toString().padLeft(2, '0')}";
}