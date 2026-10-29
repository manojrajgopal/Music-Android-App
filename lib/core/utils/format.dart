import 'package:intl/intl.dart';

String formatDuration(Duration? d) {
  if (d == null || d.isNegative) return '--:--';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

String formatMs(int? ms) => formatDuration(ms == null ? null : Duration(milliseconds: ms));

/// Human readable listening time, e.g. "3 h 12 min" or "45 min".
String formatListening(int ms) {
  final minutes = ms ~/ 60000;
  if (minutes < 60) return '$minutes min';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h h' : '$h h $m min';
}

String formatBytes(int? bytes) {
  if (bytes == null) return '—';
  const units = ['B', 'KB', 'MB', 'GB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}

String formatDate(DateTime d) => DateFormat.yMMMd().format(d);

/// Local calendar day (midnight) for streaks and daily buckets.
DateTime localDay(DateTime t) {
  final l = t.toLocal();
  return DateTime(l.year, l.month, l.day);
}

/// Monday 00:00 of the local week containing [now].
DateTime startOfLocalWeek(DateTime now) {
  final day = localDay(now);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}
