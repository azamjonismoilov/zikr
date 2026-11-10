import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/db/seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late String json;

  setUpAll(() {
    json = File('assets/seed/zikrlar.json').readAsStringSync();
  });

  test('seed 6 ta zikr va 1 ta toʻplam yuklaydi', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await seedYukla(db, json);

    final zikrlar = await (db.select(db.zikr)..orderBy([(z) => OrderingTerm(expression: z.tartib)])).get();
    expect(zikrlar, hasLength(6));
    expect(zikrlar.map((z) => z.nomi), [
      'SubhanAllah',
      'Alhamdulillah',
      'Allohu Akbar',
      'La ilaha illalloh',
      'Astagʻfirulloh',
      'Salavot',
    ]);
    expect(zikrlar.map((z) => z.maqsad), [33, 33, 34, 100, 100, 10]);
    expect(zikrlar.map((z) => z.talaffuz), everyElement(isNull));
    expect(zikrlar.map((z) => z.rasm), ['tasbeh', 'yurak', 'yulduz', 'namoz', 'tun', 'kitob']);
    for (final z in zikrlar) {
      expect(File('assets/svg/rasm_${z.rasm}.svg').existsSync(), isTrue, reason: z.nomi);
    }

    final toplamlar = await db.select(db.toplam).get();
    expect(toplamlar, hasLength(1));
    final t = toplamlar.single;
    expect(t.nomi, 'Namozdan keyingi tasbehot');
    expect(t.qadamlar.map((q) => (q.zikrId, q.maqsad)), [(1, 33), (2, 33), (3, 34)]);
  });

  test('takroriy chaqiruv seedni ikki marta yozmaydi', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await seedYukla(db, json);
    await seedYukla(db, json);

    expect(await db.select(db.zikr).get(), hasLength(6));
    expect(await db.select(db.toplam).get(), hasLength(1));
  });

  test('ikkinchi ishga tushishda (bazani qayta ochganda) seed takrorlanmaydi', () async {
    final dir = await Directory.systemTemp.createTemp('zikr_seed_test');
    addTearDown(() => dir.delete(recursive: true));
    final fayl = File('${dir.path}/zikr.sqlite');

    final birinchi = AppDatabase(NativeDatabase(fayl));
    await seedYukla(birinchi, json);
    await birinchi.close();

    final ikkinchi = AppDatabase(NativeDatabase(fayl));
    addTearDown(ikkinchi.close);
    await seedYukla(ikkinchi, json);

    expect(await ikkinchi.select(ikkinchi.zikr).get(), hasLength(6));
    expect(await ikkinchi.select(ikkinchi.toplam).get(), hasLength(1));
  });

  test('asset orqali seed (seedniTayyorla) ishlaydi', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.seedniTayyorla();

    expect(await db.select(db.zikr).get(), hasLength(6));
  });
}
