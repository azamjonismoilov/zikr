import 'package:intl/intl.dart';

final _format = NumberFormat.decimalPattern('uz');

/// Sonni ming ajratgichi bilan yozadi: 1248 → "1 248".
String sonFormat(int son) => _format.format(son);
