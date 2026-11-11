import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/features/settings/data/zaxira.dart';

import '../../../helpers/test_ilova.dart';

final _hozir = DateTime(2026, 11, 11, 10);

Future<void> _toldir(AppDatabase db) async {
  final vaqt = DateTime(2026, 11, 10, 9);
  await db.into(db.zikr).insert(ZikrCompanion.insert(
        id: const Value(7),
        nomi: 'Hasbunalloh',
        arabcha: 'حَسْبُنَا ٱللَّٰهُ',
        manosi: 'Alloh bizga kifoya',
        maqsad: const Value(99),
        rasm: const Value('yulduz'),
        turkum: 'kun_davomida',
        ozZikri: const Value(true),
        tartib: 7,
      ));
  await db.into(db.zikr).insert(ZikrCompanion.insert(
        id: const Value(8),
        nomi: 'Oʻchirilgan',
        arabcha: '',
        manosi: '',
        turkum: 'kun_davomida',
        ozZikri: const Value(true),
        tartib: 8,
        ochirilgan: const Value(true),
      ));
  await (db.update(db.zikr)..where((z) => z.id.equals(1))).write(const ZikrCompanion(maqsad: Value(108)));
  for (final (zikr, sana, son, jami, ayl) in [
    (1, '2026-11-09', 5, 113, 1),
    (7, '2026-11-10', 12, 210, 2),
    (8, '2026-11-08', 0, 40, 0),
  ]) {
    await db.into(db.sessiya).insert(SessiyaCompanion.insert(
          zikrId: zikr,
          sana: sana,
          son: Value(son),
          jami: Value(jami),
          aylanalar: Value(ayl),
          boshlandi: vaqt,
          yangilandi: vaqt,
        ));
  }
  await db.into(db.toplamYurish).insert(ToplamYurishCompanion.insert(
        toplamId: 1,
        sana: '2026-11-10',
        qadam: const Value(1),
        son: const Value(5),
        boshlandi: vaqt,
        yangilandi: vaqt,
      ));
  await db.into(db.toplamYurish).insert(ToplamYurishCompanion.insert(
        toplamId: 1,
        sana: '2026-11-09',
        qadam: const Value(3),
        tugadi: const Value(true),
        boshlandi: vaqt,
        yangilandi: vaqt,
      ));
  for (final (k, v) in [('mavzu', 'tun'), ('kunlik_maqsad', '300'), ('joriy_zikr_id', '7'), ('eslatma_vaqti', '05:30')]) {
    await db.into(db.sozlama).insertOnConflictUpdate(SozlamaCompanion.insert(kalit: k, qiymat: v));
  }
}

/// Jadvallarni solishtirish uchun (id va vaqtdan tashqari).
Future<Map<String, Object>> _surat(AppDatabase db) async => {
      'zikr': [
        for (final z in await (db.select(db.zikr)..orderBy([(z) => OrderingTerm(expression: z.id)])).get())
          (z.id, z.nomi, z.arabcha, z.manosi, z.maqsad, z.rasm, z.ozZikri, z.ochirilgan, z.tartib),
      ],
      'sessiya': [
        for (final s in await (db.select(db.sessiya)
              ..orderBy([(s) => OrderingTerm(expression: s.sana), (s) => OrderingTerm(expression: s.zikrId)]))
            .get())
          (s.zikrId, s.sana, s.son, s.jami, s.aylanalar, s.boshlandi, s.yangilandi),
      ],
      'yurish': [
        for (final y in await (db.select(db.toplamYurish)..orderBy([(y) => OrderingTerm(expression: y.sana)])).get())
          (y.toplamId, y.sana, y.qadam, y.son, y.tugadi),
      ],
      'sozlama': [
        for (final s in await (db.select(db.sozlama)..orderBy([(s) => OrderingTerm(expression: s.kalit)])).get())
          (s.kalit, s.qiymat),
      ],
    };

void main() {
  test('zaxira → tiklash: ma\'lumot aynan tiklanadi', () async {
    final manba = await testBazasi();
    addTearDown(manba.close);
    await _toldir(manba);
    final matn = await ZaxiraXizmati(manba).json(_hozir);

    final json = jsonDecode(matn) as Map<String, Object?>;
    expect((json['format'], json['formatVersiyasi'], json['sxemaVersiyasi']), ('zikr-zaxira', 1, 4));
    expect(ZaxiraXizmati.faylNomi(_hozir), 'zikr-zaxira-2026-11-11.json');

    // Boshqa ma'lumotli bazaga tiklanadi.
    final nishon = await testBazasi();
    addTearDown(nishon.close);
    await nishon.into(nishon.sessiya).insert(SessiyaCompanion.insert(
          zikrId: 2,
          sana: '2026-01-01',
          boshlandi: DateTime(2026),
          yangilandi: DateTime(2026),
        ));
    final xizmat = ZaxiraXizmati(nishon);
    await xizmat.tikla(await xizmat.tekshir(matn));

    expect(await _surat(nishon), await _surat(manba));
  });

  test('buzuq fayllar: ma\'lumot o\'zgarmaydi, xato turi to\'g\'ri', () async {
    final db = await testBazasi();
    addTearDown(db.close);
    await _toldir(db);
    final oldin = await _surat(db);
    final xizmat = ZaxiraXizmati(db);
    final togri = jsonDecode(await xizmat.json(_hozir)) as Map<String, Object?>;

    Future<void> tekshir(String matn, ZaxiraXatoTuri turi) async {
      await expectLater(
        xizmat.tekshir(matn),
        throwsA(isA<ZaxiraXatosi>().having((e) => e.turi, 'turi', turi)),
      );
    }

    await tekshir('bu json emas', ZaxiraXatoTuri.notogriFayl);
    await tekshir('[1, 2]', ZaxiraXatoTuri.notogriFayl);
    await tekshir(jsonEncode({...togri, 'format': 'boshqa'}), ZaxiraXatoTuri.notogriFayl);
    await tekshir(jsonEncode({...togri, 'sxemaVersiyasi': 99}), ZaxiraXatoTuri.yangiVersiya);
    await tekshir(jsonEncode({...togri, 'formatVersiyasi': 2}), ZaxiraXatoTuri.yangiVersiya);
    await tekshir(jsonEncode({...togri, 'sessiyalar': 'yo\'q'}), ZaxiraXatoTuri.buzuq);
    await tekshir(
      jsonEncode({
        ...togri,
        'sessiyalar': [
          {'zikrId': 1, 'sana': '2026-11-10'}, // son, aylanalar, vaqtlar yo'q
        ],
      }),
      ZaxiraXatoTuri.buzuq,
    );
    await tekshir(
      jsonEncode({
        ...togri,
        'sessiyalar': [
          {'zikrId': 999, 'sana': '2026-11-10', 'son': 0, 'aylanalar': 0, 'boshlandi': '2026-11-10T09:00:00.000', 'yangilandi': '2026-11-10T09:00:00.000'},
        ],
      }),
      ZaxiraXatoTuri.buzuq,
    );
    // Faylning yarmi (uzilib qolgan yuklab olish).
    final matn = await xizmat.json(_hozir);
    await tekshir(matn.substring(0, matn.length ~/ 2), ZaxiraXatoTuri.notogriFayl);

    expect(await _surat(db), oldin);
  });

  test('eski sxemadagi zaxira (v2: jami, ochirilgan va yurishlar yo\'q) ham tiklanadi', () async {
    final db = await testBazasi();
    addTearDown(db.close);
    final eski = jsonEncode({
      'format': 'zikr-zaxira',
      'formatVersiyasi': 1,
      'sxemaVersiyasi': 2,
      'ozZikrlar': [
        {'id': 7, 'nomi': 'Eski zikr', 'arabcha': '', 'manosi': '', 'maqsad': 50, 'rasm': 'yurak', 'turkum': 'kun_davomida', 'tartib': 7},
      ],
      'zikrMaqsadlari': [
        {'id': 1, 'maqsad': 33},
      ],
      'sessiyalar': [
        {'zikrId': 1, 'sana': '2026-11-09', 'son': 4, 'aylanalar': 2, 'boshlandi': '2026-11-09T09:00:00.000', 'yangilandi': '2026-11-09T09:00:00.000'},
        {'zikrId': 7, 'sana': '2026-11-09', 'son': 1, 'aylanalar': 1, 'boshlandi': '2026-11-09T09:00:00.000', 'yangilandi': '2026-11-09T09:00:00.000'},
      ],
      'sozlamalar': [
        {'kalit': 'haptik', 'qiymat': '0'},
      ],
    });
    final xizmat = ZaxiraXizmati(db);
    await xizmat.tikla(await xizmat.tekshir(eski));

    final z = await (db.select(db.zikr)..where((z) => z.id.equals(7))).getSingle();
    expect((z.nomi, z.ochirilgan, z.ozZikri), ('Eski zikr', false, true));
    final s = await (db.select(db.sessiya)..orderBy([(s) => OrderingTerm(expression: s.zikrId)])).get();
    // jami yo'q: aylanalar × maqsad + son.
    expect(s.map((x) => (x.zikrId, x.jami)), [(1, 70), (7, 51)]);
    expect(await db.select(db.toplamYurish).get(), isEmpty);
    final haptik = await (db.select(db.sozlama)..where((s) => s.kalit.equals('haptik'))).getSingle();
    expect(haptik.qiymat, '0');
    // Seed belgisi saqlanadi: keyingi ishga tushishda seed qayta yuklanmaydi.
    expect(await (db.select(db.sozlama)..where((s) => s.kalit.equals('seed_versiya'))).getSingleOrNull(), isNotNull);
  });

  test('hisobni nollash: sessiya va yurishlar o\'chadi, zikrlar va sozlamalar qoladi', () async {
    final db = await testBazasi();
    addTearDown(db.close);
    await _toldir(db);
    await db.into(db.sozlama).insert(SozlamaCompanion.insert(kalit: 'joriy_toplam_id', qiymat: '1'));

    await ZaxiraXizmati(db).hisobniNolla();

    expect(await db.select(db.sessiya).get(), isEmpty);
    expect(await db.select(db.toplamYurish).get(), isEmpty);
    expect(await db.select(db.zikr).get(), hasLength(8));
    final z1 = await (db.select(db.zikr)..where((z) => z.id.equals(1))).getSingle();
    expect(z1.maqsad, 108);
    final sozlamalar = {for (final s in await db.select(db.sozlama).get()) s.kalit: s.qiymat};
    expect(sozlamalar['mavzu'], 'tun');
    expect(sozlamalar['kunlik_maqsad'], '300');
    expect(sozlamalar.containsKey('joriy_toplam_id'), isFalse);
  });
}
