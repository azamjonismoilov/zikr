import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/db/database.dart';
import 'core/platforma/platforma.dart';
import 'core/platforma/tizim_platformasi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final db = AppDatabase();
  await db.seedniTayyorla();
  final platforma = TizimPlatformasi();
  // Kutilmaydi: birinchi kadr tezroq chiqadi, bildirishnoma keyinroq tayyor bo'ladi.
  unawaited(platforma.tayyorla());

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        platformaProvider.overrideWithValue(platforma),
      ],
      child: const ZikrApp(),
    ),
  );
}
