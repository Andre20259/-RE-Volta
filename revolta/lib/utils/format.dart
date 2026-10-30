const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// 230 → "€2.30".
String formatEuros(int cents) => '€${(cents / 100).toStringAsFixed(2)}';

/// 1.5 → "1.5 L", 0.75 → "0.75 L", 2.0 → "2 L".
String formatLiters(double liters) {
  final number = liters.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  return '$number L';
}

/// "Today, 14:02", "Yesterday" or "19 Oct".
String formatScanTime(DateTime time, {DateTime? now}) {
  now ??= DateTime.now();
  if (_sameDay(time, now)) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return 'Today, $hh:$mm';
  }
  if (_sameDay(time, DateTime(now.year, now.month, now.day - 1))) {
    return 'Yesterday';
  }
  return '${time.day} ${_months[time.month - 1]}';
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
