import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/db/seed.dart';
import 'package:zikr/features/counter/domain/soat.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/path/domain/tabrik.dart';

import '../../../helpers/test_ilova.dart';

late AppDatabase _db;
late QoldaSoat _soat;

Future<(ProviderContainer, SanagichController)> _och([AppDatabase? db]) async {
  final c = ProviderContainer(overrides: testOverrides(db ?? _db, soat: _soat));
  addTearDown(c.dispose);
  await c.read(sanagichProvider.future);
  return (c, c.read(sanagichProvider.notifier));
}

List<BosishHodisasi> _bos(SanagichController ctrl, int n) => [for (var i = 0; i < n; i++) ctrl.bos()];

void main() {
  setUp(() async {
    _db = await testBazasi();
    addTearDown(_db.close);
    _soat = QoldaSoat(DateTime(2026, 11, 10, 13));
  });

  test('boshlash: yurish yaratiladi, rejim yoqiladi, qadam maqsadi 33', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    final h = c.read(sanagichProvider).requireValue;
    expect(h.toplamRejimi, isTrue);
    expect((h.zikr.nomi, h.son, h.maqsad), ('SubhanAllah', 0, 33));
    expect(await _db.select(_db.toplamYurish).get(), hasLength(1));
    expect(
      await (_db.select(_db.sozlama)..where((s) => s.kalit.equals('joriy_toplam_id'))).getSingle(),
      isA<SozlamaQator>().having((s) => s.qiymat, 'qiymat', '1'),
    );
  });

  test('33 bosishdan keyin keyingi zikr, tabrik yo\'q (kun kechiktiriladi), alohida son tegilmagan', () async {
    final (c, ctrl) = await _och();
    for (var i = 0; i < 5; i++) {
      ctrl.bos(); // alohida rejimda SubhanAllah: son 5
    }
    await ctrl.toplamniBoshla(1);
    final hodisalar = _bos(ctrl, 33);
    expect(hodisalar.last.aylanaTugadi, isTrue);
    expect(hodisalar.map((x) => x.tabrik), everyElement(isNull));

    final h = c.read(sanagichProvider).requireValue;
    expect((h.zikr.nomi, h.son, h.yurish!.qadam), ('Alhamdulillah', 0, 1));
    expect(h.kechiktirilgan, isNotNull);
    expect(h.oxirgiQatorlar[1]!.son, 5);
    expect(h.oxirgiQatorlar[1]!.jami, 38);
    expect(h.oxirgiQatorlar[1]!.aylanalar, 1);
  });

  test('to\'plam tugashi: bitta tabrik (dalda bilan), rejimdan chiqadi, yurish saqlanadi', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    final hodisalar = _bos(ctrl, 100);
    final tabriklar = [for (final x in hodisalar) if (x.tabrik != null) x.tabrik!];
    expect(tabriklar, hasLength(1));
    final t = tabriklar.single;
    expect(t.turi, TabrikTuri.toplamTugadi);
    expect((t.jami, t.marta, t.streak, t.toplamId), (100, 1, 1, 1));

    final h = c.read(sanagichProvider).requireValue;
    expect(h.toplamRejimi, isFalse);
    expect(h.joriyToplamId, isNull);
    expect(h.zikr.nomi, 'SubhanAllah');
    expect(h.bugunTugaganlar(1), 1);

    await ctrl.navbat.tugashiniKut();
    final yurish = await _db.select(_db.toplamYurish).getSingle();
    expect((yurish.tugadi, yurish.qadam), (true, 3));
  });

  test('"Yana bir marta": yangi yurish; ikkinchi tugashda "Bugun 2-marta", dalda yo\'q', () async {
    final (_, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 100);
    await ctrl.toplamniBoshla(1);
    final t = _bos(ctrl, 100).last.tabrik!;
    expect((t.marta, t.streak), (2, null));
    await ctrl.navbat.tugashiniKut();
    expect(await _db.select(_db.toplamYurish).get(), hasLength(2));
  });

  test('qayta ochilganda rejim, qadam va son tiklanadi', () async {
    final dir = await Directory.systemTemp.createTemp('zikr_yol');
    addTearDown(() => dir.delete(recursive: true));
    final fayl = File('${dir.path}/z.sqlite');
    final db1 = AppDatabase(NativeDatabase(fayl));
    await seedYukla(db1, File('assets/seed/zikrlar.json').readAsStringSync());
    final (c1, ctrl1) = await _och(db1);
    await ctrl1.toplamniBoshla(1);
    _bos(ctrl1, 45);
    await ctrl1.navbat.tugashiniKut();
    c1.dispose();
    await db1.close();

    final db2 = AppDatabase(NativeDatabase(fayl));
    addTearDown(db2.close);
    final (c2, _) = await _och(db2);
    final h = c2.read(sanagichProvider).requireValue;
    expect(h.toplamRejimi, isTrue);
    expect((h.zikr.nomi, h.yurish!.qadam, h.son, h.maqsad), ('Alhamdulillah', 1, 12, 33));
  });

  test('bir to\'plamga bitta tugallanmagan yurish (bazada qisman unikal indeks)', () async {
    final (_, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    await ctrl.toplamniBoshla(1); // ikkinchi chaqiruv yangisini yaratmaydi
    await ctrl.navbat.tugashiniKut();
    expect(await _db.select(_db.toplamYurish).get(), hasLength(1));

    final vaqt = DateTime(2026, 11, 10);
    Future<int> qosh(bool tugadi) => _db.into(_db.toplamYurish).insert(ToplamYurishCompanion.insert(
          toplamId: 1,
          sana: '2026-11-10',
          tugadi: Value(tugadi),
          boshlandi: vaqt,
          yangilandi: vaqt,
        ));
    await expectLater(qosh(false), throwsA(isA<SqliteException>()));
    await qosh(true); // tugaganlari cheklanmaydi
    await qosh(true);
  });

  test('rejimdan chiqish (zikr tanlash) va yo\'ldan davom ettirish', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 40);
    ctrl.zikrniTanla(4);
    var h = c.read(sanagichProvider).requireValue;
    expect(h.toplamRejimi, isFalse);
    expect(h.zikr.nomi, 'La ilaha illalloh');
    _bos(ctrl, 3);
    expect(c.read(sanagichProvider).requireValue.yurishlar[1]!.son, 7); // yurish tegilmagan

    await ctrl.toplamniBoshla(1);
    h = c.read(sanagichProvider).requireValue;
    expect((h.zikr.nomi, h.son, h.yurish!.qadam), ('Alhamdulillah', 7, 1));
  });

  test('joriy zikrni qayta tanlash ham rejimdan chiqaradi', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    ctrl.zikrniTanla(1);
    expect(c.read(sanagichProvider).requireValue.toplamRejimi, isFalse);
  });

  test('qadamni o\'tkazish va oxirgi qadamda yurishni yopish', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 10);
    expect(ctrl.qadamniOtkaz(), isNull);
    var h = c.read(sanagichProvider).requireValue;
    expect((h.yurish!.qadam, h.son, h.oxirgiQatorlar[1]!.aylanalar), (1, 0, 0));
    ctrl.qadamniOtkaz();
    expect(ctrl.qadamniOtkaz(), isNull); // oxirgi qadam: kun hisoblanmagan, tabrik yo'q

    h = c.read(sanagichProvider).requireValue;
    expect(h.toplamRejimi, isFalse);
    expect(h.yurishlar, isEmpty);
    expect(h.zikr.nomi, 'SubhanAllah');
    await ctrl.navbat.tugashiniKut();
    expect(await _db.select(_db.toplamYurish).get(), isEmpty);
  });

  test('oxirgi qadam o\'tkazilsa, kechiktirilgan "kun hisoblandi" tabrigi chiqadi', () async {
    final (_, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 33); // 1-qadam tugadi: kun hisobga olindi, kechiktirildi
    ctrl.qadamniOtkaz();
    final t = ctrl.qadamniOtkaz()!;
    expect((t.turi, t.zikrId, t.maqsad, t.streak), (TabrikTuri.kunHisoblandi, 1, 33, 1));
  });

  test('to\'plamda nollash: faqat joriy qadam, sessiya jami kamayadi', () async {
    final (c, ctrl) = await _och();
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 40);
    ctrl.nolla();
    final h = c.read(sanagichProvider).requireValue;
    expect((h.yurish!.qadam, h.son), (1, 0));
    expect(h.oxirgiQatorlar[2]!.jami, 0);
    expect(h.oxirgiQatorlar[1]!.jami, 33);
  });

  test('alohida rejim: birinchi aylana — tabrik, ikkinchisi — yo\'q', () async {
    final (_, ctrl) = await _och();
    final birinchi = _bos(ctrl, 33).last;
    expect(birinchi.aylanaTugadi, isTrue);
    expect(birinchi.tabrik?.turi, TabrikTuri.kunHisoblandi);
    expect((birinchi.tabrik!.maqsad, birinchi.tabrik!.streak), (33, 1));
    final ikkinchi = _bos(ctrl, 33).last;
    expect(ikkinchi.aylanaTugadi, isTrue);
    expect(ikkinchi.tabrik, isNull);
  });

  test('alohida rejim: ∞ maqsadda kun kunlik jami orqali hisoblansa — modal yo\'q, streak oshadi',
      () async {
    final (c, ctrl) = await _och();
    ctrl.maqsadniOrnat(null);
    final h = _bos(ctrl, 100);
    expect(h.map((x) => x.tabrik), everyElement(isNull));
    expect(c.read(sanagichProvider).requireValue.streak.joriy, 1);
  });

  test('alohida rejim: kun aylana o\'rtasida hisoblansa modal yo\'q, keyingi aylanada ham yo\'q',
      () async {
    final (c, ctrl) = await _och();
    ctrl.maqsadniOrnat(150);
    final oldin = _bos(ctrl, 100); // kunlik 100 ga yetdi, aylana hali tugamagan
    expect(oldin.map((x) => x.tabrik), everyElement(isNull));
    expect(c.read(sanagichProvider).requireValue.streak.joriy, 1);
    final keyin = _bos(ctrl, 50); // aylana tugadi, lekin kun allaqachon hisoblangan
    expect(keyin.last.aylanaTugadi, isTrue);
    expect(keyin.last.tabrik, isNull);
  });

  test('to\'plam: kun qadam o\'rtasida kunlik jami orqali hisoblansa — kechiktirilmaydi, dalda yo\'q',
      () async {
    final (c, ctrl) = await _och();
    ctrl.zikrniTanla(4);
    ctrl.maqsadniOrnat(null);
    _bos(ctrl, 90); // alohida: bugungi jami 90, kun hali hisoblanmagan
    await ctrl.toplamniBoshla(1);
    _bos(ctrl, 10); // jami 100: kun 1-qadam o'rtasida hisoblandi
    final h = c.read(sanagichProvider).requireValue;
    expect(h.streak.joriy, 1);
    expect(h.kechiktirilgan, isNull);
    final t = _bos(ctrl, 90).last.tabrik!;
    expect(t.turi, TabrikTuri.toplamTugadi);
    expect(t.streak, isNull);
  });
}
