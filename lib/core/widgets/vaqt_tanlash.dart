import 'package:flutter/material.dart';

/// Tizim vaqt tanlagichi (24 soatlik). Tanlangan vaqtni kun boshidan daqiqalarda,
/// yopilsa `null` qaytaradi.
Future<int?> vaqtSora(BuildContext context, int joriy) async {
  final tanlangan = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: joriy ~/ 60, minute: joriy % 60),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: child!,
    ),
  );
  return tanlangan == null ? null : tanlangan.hour * 60 + tanlangan.minute;
}
