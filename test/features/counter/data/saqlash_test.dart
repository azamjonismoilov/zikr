import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/db/seed.dart';
import 'package:zikr/features/counter/data/sanagich_repository.dart';
import 'package:zikr/features/counter/domain/soat.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';

late String _seed;

Future<AppDatabase> _baza([QueryExecutor? e]) async {
  final db = AppDatabase(e ?? NativeDatabase.memory());
  await seedYukla(db, _seed);
  return db;
}

ProviderContainer _container(AppDatabase db, Soat soat) {
  final c = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(db),
    soatProvider.overrideWithValue(soat),
  ]);
  addTearDown(c.dispose);
  return c;
}

Future<SanagichController> _controller(ProviderContainer c) async {
  await c.read(sanagichProvider.future);
  return c.read(sanagichProvider.notifier);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUpAll(() => _seed = File('assets/seed/zikrlar.json').readAsStringSync());

  test('100 ta tez bosish yo\'qolmaydi: bazada jami 100', () async {
    final db = await _baza();
    addTearDown(db.close);
    final c = _container(db, QoldaSoat(DateTime(2026, 11, 10, 9)));
    final ctrl = await _controller(c);

    for (var i = 0; i < 100; i++) {
      ctrl.bos(); // kutmasdan, ketma-ket
    }
    // Ekran holati darhol yangilangan: 100 = 3 × 33 + 1.
    final h = c.read(sanagichProvider).requireValue;
    expect(h.son, 1);
    expect(h.aylanaRaqami, 4);

    await ctrl.navbat.tugashiniKut();
    final qator = await db.select(db.sessiya).getSingle();
    expect(qator.jami, 100);
    expect(qator.aylanalar, 3);
    expect(qator.son, 1);
  });

  test('qayta ochilganda joriy zikr, son, aylana va maqsad tiklanadi', () async {
    final dir = await Directory.systemTemp.createTemp('zikr_saqlash');
    addTearDown(() => dir.delete(recursive: true));
    final fayl = File('${dir.path}/zikr.sqlite');
    final soat = QoldaSoat(DateTime(2026, 11, 10, 9));

    // Birinchi ishga tushish.
    final db1 = await _baza(NativeDatabase(fayl));
    final c1 = _container(db1, soat);
    final ctrl1 = await _controller(c1);
    ctrl1.zikrniTanla(2); // SubhanAllah → Alhamdulillah
    ctrl1.maqsadniOrnat(99);
    for (var i = 0; i < 120; i++) {
      ctrl1.bos();
    }
    ctrl1.haptikniAlmashtir();
    await ctrl1.navbat.tugashiniKut();
    c1.dispose();
    await db1.close();

    // "O'ldirilgan" ilova qayta ochiladi.
    final db2 = AppDatabase(NativeDatabase(fayl));
    addTearDown(db2.close);
    final c2 = _container(db2, soat);
    await _controller(c2);
    final h = c2.read(sanagichProvider).requireValue;

    expect(h.zikr.nomi, 'Alhamdulillah');
    expect(h.maqsad, 99);
    expect(h.son, 21);
    expect(h.aylanaRaqami, 2);
    expect(h.bugunTugaganAylanalar, 1);
    expect(h.haptik, isFalse);
  });

  test('har zikr va har kun uchun bitta qator', () async {
    final db = await _baza();
    addTearDown(db.close);
    final soat = QoldaSoat(DateTime(2026, 11, 10, 23, 58));
    final c = _container(db, soat);
    final ctrl = await _controller(c);

    for (var i = 0; i < 10; i++) {
      ctrl.bos();
    }
    ctrl.zikrniTanla(2);
    for (var i = 0; i < 5; i++) {
      ctrl.bos();
    }
    soat.sur(const Duration(minutes: 5)); // yarim tundan o'tdi
    for (var i = 0; i < 3; i++) {
      ctrl.bos();
    }
    await ctrl.navbat.tugashiniKut();

    final qatorlar = await (db.select(db.sessiya)
          ..orderBy([(s) => OrderingTerm(expression: s.sana), (s) => OrderingTerm(expression: s.zikrId)]))
        .get();
    expect(
      qatorlar.map((q) => (q.zikrId, q.sana, q.son, q.jami)),
      [(1, '2026-11-10', 10, 10), (2, '2026-11-10', 5, 5), (2, '2026-11-11', 8, 3)],
    );
  });

  test('nollash va maqsad o\'zgarishi bazaga yoziladi', () async {
    final db = await _baza();
    addTearDown(db.close);
    final c = _container(db, QoldaSoat(DateTime(2026, 11, 10, 9)));
    final ctrl = await _controller(c);

    for (var i = 0; i < 40; i++) {
      ctrl.bos();
    }
    ctrl.nolla();
    ctrl.maqsadniOrnat(null);
    await ctrl.navbat.tugashiniKut();

    final q = await db.select(db.sessiya).getSingle();
    expect((q.son, q.jami, q.aylanalar), (0, 33, 1));
    final zikr = await (db.select(db.zikr)..where((z) => z.id.equals(1))).getSingle();
    expect(zikr.maqsad, isNull);
  });

  test('sozlama standartlari: SubhanAllah, haptik yoqilgan, kunlik maqsad 100', () async {
    final db = await _baza();
    addTearDown(db.close);
    final c = _container(db, QoldaSoat(DateTime(2026, 11, 10, 9)));
    await _controller(c);
    final h = c.read(sanagichProvider).requireValue;

    expect(h.zikr.nomi, 'SubhanAllah');
    expect(h.haptik, isTrue);
    expect(h.kunlikMaqsad, SozlamaKalit.standartKunlikMaqsad);
    expect(h.kunlikMaqsad, 100);
  });

  test('streak va bugungi aylanalar sessiyalardan hisoblanadi', () async {
    final db = await _baza();
    addTearDown(db.close);
    final soat = QoldaSoat(DateTime(2026, 11, 8, 9));
    final c = _container(db, soat);
    final ctrl = await _controller(c);

    // 8-noyabr: 1 aylana. 9-noyabr: ∞ bilan 100 bosish (kunlik maqsad). 10-noyabr: hali yo'q.
    for (var i = 0; i < 33; i++) {
      ctrl.bos();
    }
    soat.vaqt = DateTime(2026, 11, 9, 9);
    ctrl.maqsadniOrnat(null);
    for (var i = 0; i < 100; i++) {
      ctrl.bos();
    }
    soat.vaqt = DateTime(2026, 11, 10, 9);
    ctrl.kunniYangila();
    await ctrl.navbat.tugashiniKut();

    var h = c.read(sanagichProvider).requireValue;
    expect(h.streak.joriy, 2);
    expect(h.bugunTugaganAylanalar, 0);

    // Qayta ochilganda ham xuddi shunday (yig'indilar bazadan).
    final c2 = _container(db, soat);
    await _controller(c2);
    h = c2.read(sanagichProvider).requireValue;
    expect(h.streak.joriy, 2);
    expect(h.streak.rekord, 2);
  });
}
