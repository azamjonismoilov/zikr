import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/db/seed.dart';
import 'package:zikr/core/l10n/generated/app_localizations.dart';
import 'package:zikr/core/platforma/platforma.dart';
import 'package:zikr/core/theme/app_theme.dart';
import 'package:zikr/features/counter/domain/soat.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';

import 'soxta_platforma.dart';

/// Seed yuklangan xotiradagi baza.
Future<AppDatabase> testBazasi() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  await seedYukla(db, File('assets/seed/zikrlar.json').readAsStringSync());
  return db;
}

/// Telefon o'lchami (Figma: 390×844).
void telefonOlchami(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

List<Override> testOverrides(AppDatabase db, {Soat? soat, Platforma? platforma}) => [
      databaseProvider.overrideWithValue(db),
      soatProvider.overrideWithValue(soat ?? QoldaSoat(DateTime(2026, 11, 10, 9))),
      platformaProvider.overrideWithValue(platforma ?? SoxtaPlatforma()),
    ];

/// Bitta ekranni mavzu va lokalizatsiya bilan o'raydi.
Widget testIlova(Widget ekran, List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.yorug,
        darkTheme: AppTheme.tun,
        locale: const Locale('uz'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ekran),
      ),
    );
