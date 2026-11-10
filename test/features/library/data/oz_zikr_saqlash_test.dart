import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/features/counter/domain/soat.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/library/domain/oz_zikr.dart';

import '../../../helpers/test_ilova.dart';

late AppDatabase _db;

Future<(ProviderContainer, SanagichController)> _och() async {
  final c = ProviderContainer(overrides: testOverrides(_db, soat: QoldaSoat(DateTime(2026, 11, 10, 9))));
  addTearDown(c.dispose);
  await c.read(sanagichProvider.future);
  return (c, c.read(sanagichProvider.notifier));
}

void main() {
  setUp(() async {
    _db = await testBazasi();
    addTearDown(_db.close);
  });

  test('o\'z zikrini qo\'shish: oz_zikri, oxirgi tartib, joriy zikr bo\'ladi', () async {
    final (c, ctrl) = await _och();
    final yangi = await ctrl.ozZikrQosh(const OzZikr(
      nomi: '  Subhanallohi va bihamdihi ',
      arabcha: 'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ',
      manosi: 'Alloh pokdir va Unga hamd boʻlsin',
      rasm: 'yulduz',
      maqsad: 100,
    ));
    await ctrl.navbat.tugashiniKut();

    final q = await (_db.select(_db.zikr)..where((z) => z.id.equals(yangi.id))).getSingle();
    expect(q.nomi, 'Subhanallohi va bihamdihi');
    expect(q.talaffuz, isNull);
    expect(q.ozZikri, isTrue);
    expect(q.ochirilgan, isFalse);
    expect(q.tartib, 7);
    expect((q.rasm, q.maqsad), ('yulduz', 100));

    final h = c.read(sanagichProvider).requireValue;
    expect(h.joriyZikrId, yangi.id);
    expect(h.zikrlar.last.id, yangi.id);
    expect(await _db.select(_db.sozlama).get(), contains(isA<SozlamaQator>().having((s) => s.qiymat, 'qiymat', '${yangi.id}')));
  });

  test('ixtiyoriy maydonlar bo\'sh qoladi', () async {
    final (_, ctrl) = await _och();
    final z = await ctrl.ozZikrQosh(const OzZikr(nomi: 'Hasbunalloh'));
    expect((z.arabcha, z.manosi, z.rasm, z.maqsad), ('', '', 'yurak', 33));
  });

  test('tahrirlash: maydonlar yangilanadi; maqsad o\'zgarsa joriy aylana nollanadi', () async {
    final (c, ctrl) = await _och();
    final z = await ctrl.ozZikrQosh(const OzZikr(nomi: 'Eski', maqsad: 33));
    for (var i = 0; i < 40; i++) {
      ctrl.bos();
    }
    await ctrl.zikrniTahrirla(z.id, const OzZikr(nomi: 'Yangi', manosi: 'maʼno', rasm: 'tun', maqsad: 99));
    await ctrl.navbat.tugashiniKut();

    final q = await (_db.select(_db.zikr)..where((r) => r.id.equals(z.id))).getSingle();
    expect((q.nomi, q.manosi, q.rasm, q.maqsad), ('Yangi', 'maʼno', 'tun', 99));
    final s = await (_db.select(_db.sessiya)..where((r) => r.zikrId.equals(z.id))).getSingle();
    expect((s.son, s.jami, s.aylanalar), (0, 33, 1));
    expect(c.read(sanagichProvider).requireValue.zikr.nomi, 'Yangi');
  });

  test('o\'chirish: ro\'yxatdan yo\'qoladi, sessiyalari qoladi, joriy SubhanAllah\'ga qaytadi', () async {
    final (c, ctrl) = await _och();
    final z = await ctrl.ozZikrQosh(const OzZikr(nomi: 'Vaqtincha'));
    for (var i = 0; i < 40; i++) {
      ctrl.bos();
    }
    await ctrl.zikrniOchir(z.id);
    await ctrl.navbat.tugashiniKut();

    final h = c.read(sanagichProvider).requireValue;
    expect(h.zikrlar.any((r) => r.id == z.id), isFalse);
    expect(h.zikr.nomi, 'SubhanAllah');
    // Statistika buzilmaydi: kun yig'indisida o'chirilgan zikrning aylanasi bor.
    expect(h.bugunTugaganAylanalar, 1);

    final qator = await (_db.select(_db.zikr)..where((r) => r.id.equals(z.id))).getSingle();
    expect(qator.ochirilgan, isTrue);
    final sessiya = await (_db.select(_db.sessiya)..where((r) => r.zikrId.equals(z.id))).getSingle();
    expect((sessiya.jami, sessiya.aylanalar), (40, 1));

    // Qayta ochilganda ham ko'rinmaydi, joriy zikr SubhanAllah.
    final (c2, _) = await _och();
    final h2 = c2.read(sanagichProvider).requireValue;
    expect(h2.zikrlar.map((r) => r.nomi), isNot(contains('Vaqtincha')));
    expect(h2.zikr.nomi, 'SubhanAllah');
    expect(h2.bugunTugaganAylanalar, 1);
  });

  test('joriy bo\'lmagan zikrni o\'chirish joriyni o\'zgartirmaydi', () async {
    final (c, ctrl) = await _och();
    final z = await ctrl.ozZikrQosh(const OzZikr(nomi: 'Biri'));
    ctrl.zikrniTanla(3);
    await ctrl.zikrniOchir(z.id);
    expect(c.read(sanagichProvider).requireValue.zikr.nomi, 'Allohu Akbar');
  });

  test('zikr almashganda har zikrning tugallanmagan soni o\'zida qoladi', () async {
    final (c, ctrl) = await _och();
    for (var i = 0; i < 12; i++) {
      ctrl.bos();
    }
    ctrl.zikrniTanla(4);
    for (var i = 0; i < 5; i++) {
      ctrl.bos();
    }
    ctrl.zikrniTanla(1);
    expect(c.read(sanagichProvider).requireValue.son, 12);
    ctrl.zikrniTanla(4);
    expect(c.read(sanagichProvider).requireValue.son, 5);
    await ctrl.navbat.tugashiniKut();
    expect(await _db.select(_db.sessiya).get(), hasLength(2));
  });

  test('OzZikr.togri: talaffuz 1–40, ma\'no 80 gacha', () {
    expect(const OzZikr(nomi: '').togri, isFalse);
    expect(const OzZikr(nomi: '   ').togri, isFalse);
    expect(const OzZikr(nomi: 'a').togri, isTrue);
    expect(OzZikr(nomi: 'a' * 40).togri, isTrue);
    expect(OzZikr(nomi: 'a' * 41).togri, isFalse);
    expect(OzZikr(nomi: 'a', manosi: 'm' * 81).togri, isFalse);
  });
}
