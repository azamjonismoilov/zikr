import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';

import '../../generated_migrations/schema.dart';
import '../../generated_migrations/schema_v1.dart' as v1;
import '../../generated_migrations/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  for (final boshlash in [1, 2]) {
    test('v$boshlash → v3 sxemasi to\'g\'ri', () async {
      final ulanish = await verifier.startAt(boshlash);
      final db = AppDatabase(ulanish);
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, 3);
    });
  }

  test('v2 → v3: zikr va sessiya saqlanadi, ochirilgan false bo\'ladi', () async {
    final schema = await verifier.schemaAt(2);
    final eski = v2.DatabaseAtV2(schema.newConnection());
    await eski.into(eski.zikr).insert(v2.ZikrCompanion.insert(
          nomi: 'SubhanAllah',
          talaffuz: const Value(null),
          arabcha: 'a',
          manosi: 'm',
          turkum: 'namozdan_keyin',
          tartib: 1,
        ));
    await eski.into(eski.sessiya).insert(v2.SessiyaCompanion.insert(
          zikrId: 1,
          son: const Value(7),
          jami: const Value(40),
          aylanalar: const Value(1),
          boshlandi: DateTime(2026, 11, 10).millisecondsSinceEpoch ~/ 1000,
          yangilandi: DateTime(2026, 11, 10).millisecondsSinceEpoch ~/ 1000,
          sana: '2026-11-10',
        ));
    await eski.close();

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    final z = await db.select(db.zikr).getSingle();
    expect((z.nomi, z.ochirilgan), ('SubhanAllah', false));
    final q = await db.select(db.sessiya).getSingle();
    expect((q.son, q.jami, q.aylanalar), (7, 40, 1));
  });

  test('v1 → v3: sessiya qatori saqlanadi, jami 0 bo\'ladi', () async {
    final schema = await verifier.schemaAt(1);
    final eski = v1.DatabaseAtV1(schema.newConnection());
    await eski.into(eski.zikr).insert(v1.ZikrCompanion.insert(
          nomi: 'SubhanAllah',
          talaffuz: const Value(null),
          arabcha: 'a',
          manosi: 'm',
          turkum: 't',
          tartib: 1,
        ));
    await eski.into(eski.sessiya).insert(v1.SessiyaCompanion.insert(
          zikrId: 1,
          son: const Value(5),
          aylanalar: const Value(2),
          // Sxema yordamchilarida DateTime unix soniyalarda saqlanadi.
          boshlandi: DateTime(2026, 11, 10).millisecondsSinceEpoch ~/ 1000,
          yangilandi: DateTime(2026, 11, 10).millisecondsSinceEpoch ~/ 1000,
          sana: '2026-11-10',
        ));
    await eski.close();

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    final q = await db.select(db.sessiya).getSingle();
    expect((q.son, q.aylanalar, q.jami, q.sana), (5, 2, 0, '2026-11-10'));
  });
}
