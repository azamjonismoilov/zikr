import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Zikr, Toplam, Sessiya, Sozlama])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'zikr'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(sessiya, sessiya.jami);
            await m.create(sessiyaZikrSana);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Birinchi ishga tushishda `assets/seed/zikrlar.json` ni yuklaydi.
  Future<void> seedniTayyorla() async {
    await seedYukla(this, await rootBundle.loadString('assets/seed/zikrlar.json'));
  }
}

/// `main.dart` da ochilgan baza bilan almashtiriladi.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider main() da beriladi'),
);
