import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

/// Seed yuklangani shu kalit bilan `sozlama` jadvalida belgilanadi.
const seedKalit = 'seed_versiya';
const seedVersiya = '1';

/// Standart zikrlar va to'plamlarni bir marta yuklaydi.
/// Ikkinchi chaqiruvda hech narsa qilmaydi.
Future<void> seedYukla(AppDatabase db, String json) async {
  final data = jsonDecode(json) as Map<String, dynamic>;

  await db.transaction(() async {
    final belgi = await (db.select(db.sozlama)..where((s) => s.kalit.equals(seedKalit)))
        .getSingleOrNull();
    if (belgi != null) return;

    for (final z in (data['zikrlar'] as List).cast<Map<String, dynamic>>()) {
      await db.into(db.zikr).insert(ZikrCompanion.insert(
            id: Value(z['id'] as int),
            nomi: z['nomi'] as String,
            talaffuz: Value(z['talaffuz'] as String?),
            arabcha: z['arabcha'] as String,
            manosi: z['manosi'] as String,
            maqsad: Value(z['maqsad'] as int?),
            rasm: Value(z['rasm'] as String?),
            turkum: z['turkum'] as String,
            tartib: z['tartib'] as int,
          ));
    }

    for (final t in (data['toplamlar'] as List).cast<Map<String, dynamic>>()) {
      await db.into(db.toplam).insert(ToplamCompanion.insert(
            id: Value(t['id'] as int),
            nomi: t['nomi'] as String,
            qadamlar: (t['qadamlar'] as List)
                .map((q) => Qadam.fromJson(q as Map<String, dynamic>))
                .toList(),
          ));
    }

    await db.into(db.sozlama).insert(
          SozlamaCompanion.insert(kalit: seedKalit, qiymat: seedVersiya),
        );
  });
}
