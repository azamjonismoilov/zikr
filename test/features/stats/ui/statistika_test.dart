import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';
import 'package:zikr/features/stats/ui/ketma_ketlik_ekrani.dart';
import 'package:zikr/features/stats/ui/statistika_ekrani.dart';

import '../../../helpers/test_ilova.dart';

late AppDatabase _db;

/// 2026-11-10 — seshanba.
const _bugun = Kun(2026, 11, 10);

Future<void> _sessiya(int zikrId, int kunOldin, int jami, int aylanalar) async {
  final sana = _bugun.qoshish(-kunOldin);
  final vaqt = DateTime(sana.yil, sana.oy, sana.kun, 9);
  await _db.into(_db.sessiya).insert(SessiyaCompanion.insert(
        zikrId: zikrId,
        sana: sana.kalit,
        jami: Value(jami),
        aylanalar: Value(aylanalar),
        boshlandi: vaqt,
        yangilandi: vaqt,
      ));
}

/// 4 kunlik streak (bugun bilan), kecha La ilaha 150, 20 kun oldin Astag'firulloh 500.
Future<void> _toldir({bool bugunBilan = true}) async {
  for (var i = bugunBilan ? 0 : 1; i <= 3; i++) {
    await _sessiya(1, i, 40, 1);
  }
  await _sessiya(4, 1, 150, 1);
  await _sessiya(5, 20, 500, 5);
}

Future<void> _och(WidgetTester tester, {Future<void> Function()? malumot}) async {
  telefonOlchami(tester);
  _db = await testBazasi();
  addTearDown(_db.close);
  await malumot?.call();
  await tester.pumpWidget(ProviderScope(overrides: testOverrides(_db), child: const ZikrApp()));
  await tester.pumpAndSettle();
}

Future<void> _bos(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Finder _statda(Finder f) => find.descendant(of: find.byType(StatistikaEkrani), matching: f);
Finder _ketmada(Finder f) => find.descendant(of: find.byType(KetmaKetlikEkrani), matching: f);

Future<void> _statistikagaOt(WidgetTester tester) =>
    _bos(tester, find.bySemanticsLabel('Statistika').first);

void main() {
  testWidgets('bo\'sh baza: nollar va bo\'sh holatlar', (tester) async {
    await _och(tester);
    await _statistikagaOt(tester);

    expect(_statda(find.text('0 kun')), findsOneWidget);
    expect(_statda(find.text('Bugun birinchi kunni boshlang')), findsOneWidget);
    expect(_statda(find.text('0')), findsNWidgets(3)); // jami, aylana, bugun
    expect(_statda(find.text('Bu davrda hali zikr qilinmagan')), findsOneWidget);
    expect(_statda(find.text('Oxirgi 7 kun')), findsOneWidget);
    expect(_statda(find.text('0 zikr')), findsOneWidget);
  });

  testWidgets('ma\'lumot bilan: streak, raqamlar, eng ko\'p aytilgan, grafik', (tester) async {
    await _och(tester, malumot: _toldir);
    await _statistikagaOt(tester);

    expect(_statda(find.text('4 kun')), findsOneWidget);
    expect(_statda(find.text('kun ketma-ket zikr qildingiz')), findsOneWidget);
    expect(_statda(find.text('810')), findsOneWidget); // jami zikr
    expect(_statda(find.text('10')), findsOneWidget); // aylana: 4 + 1 + 5
    expect(_statda(find.text('40')), findsOneWidget); // bugun
    expect(_statda(find.text('160')), findsOneWidget); // SubhanAllah, 7 kunda
    expect(_statda(find.text('150')), findsOneWidget); // La ilaha illalloh
    expect(_statda(find.text('Astagʻfirulloh')), findsNothing); // 20 kun oldin
    expect(_statda(find.text('310 zikr')), findsOneWidget);
    // Hafta qatori: Ch Pa Ju Sh Ya Du Se — bugun (seshanba) oxirida.
    expect(tester.getCenter(_statda(find.text('Se')).first).dx,
        greaterThan(tester.getCenter(_statda(find.text('Du')).first).dx));
  });

  testWidgets('davr almashganda grafik va ro\'yxat yangilanadi, tanlov saqlanadi', (tester) async {
    await _och(tester, malumot: _toldir);
    await _statistikagaOt(tester);

    await _bos(tester, _statda(find.text('7 kun')));
    await _bos(tester, find.text('30 kun').last);

    expect(_statda(find.text('Oxirgi 30 kun')), findsOneWidget);
    expect(_statda(find.text('810 zikr')), findsOneWidget);
    expect(_statda(find.text('Astagʻfirulloh')), findsOneWidget);
    expect(_statda(find.text('500')), findsOneWidget);
    // Raqam kartalari davrga bog'liq emas.
    expect(_statda(find.text('810')), findsOneWidget);

    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    final q = await tester.runAsync(
      () => (_db.select(_db.sozlama)..where((s) => s.kalit.equals('statistika_davri'))).getSingle(),
    );
    expect(q!.qiymat, '30');
  });

  testWidgets('karta bosilganda Ketma-ketlik ochiladi', (tester) async {
    await _och(tester, malumot: _toldir);
    await _statistikagaOt(tester);
    await _bos(tester, _statda(find.text('4 kun')));

    expect(find.byType(KetmaKetlikEkrani), findsOneWidget);
    expect(_ketmada(find.text('4')), findsWidgets);
    expect(_ketmada(find.text('kun ketma-ket')), findsOneWidget);
    expect(_ketmada(find.text('30 kunlik odat')), findsOneWidget);
    expect(_ketmada(find.text('4 / 30 kun')), findsOneWidget);
    expect(_ketmada(find.text('7-noyabr')), findsOneWidget); // boshlangan
    expect(_ketmada(find.text('4 kun')), findsOneWidget); // eng uzun
    expect(_ketmada(find.text('7 kun · yana 3 kun qoldi')), findsOneWidget);
    expect(_ketmada(find.text('14 kun · ikki hafta')), findsOneWidget);
    expect(_ketmada(find.text('Bugun hali zikr qilmadingiz')), findsNothing);

    await _bos(tester, find.bySemanticsLabel('Yopish'));
    expect(find.byType(KetmaKetlikEkrani), findsNothing);
  });

  testWidgets('sanagichdagi olov belgisi Ketma-ketlikni ochadi; streak 0 holati', (tester) async {
    await _och(tester);
    await _bos(tester, find.bySemanticsLabel('Ketma-ket kunlar: 0'));
    expect(find.byType(KetmaKetlikEkrani), findsOneWidget);
    expect(_ketmada(find.text('0')), findsOneWidget);
    expect(_ketmada(find.text('Bugun birinchi kunni boshlang')), findsOneWidget);
    expect(_ketmada(find.text('—')), findsOneWidget); // boshlangan sana yo'q
    expect(_ketmada(find.text('0 kun')), findsOneWidget); // eng uzun
    expect(_ketmada(find.text('7 kun · yana 7 kun qoldi')), findsOneWidget);
  });

  testWidgets('bugun hali hisoblanmagan: streak saqlanadi, ogohlantirish ko\'rinadi', (tester) async {
    await _och(tester, malumot: () => _toldir(bugunBilan: false));
    await _statistikagaOt(tester);
    expect(_statda(find.text('3 kun')), findsOneWidget);
    expect(_statda(find.text('Bugun hali zikr qilmadingiz')), findsOneWidget);

    await _bos(tester, _statda(find.text('3 kun')));
    expect(_ketmada(find.text('3')), findsWidgets);
    expect(_ketmada(find.text('Bugun hali zikr qilmadingiz')), findsOneWidget);
    expect(_ketmada(find.text('7-noyabr')), findsOneWidget);
  });

  testWidgets('sanagichdagi o\'zgarish statistikada darhol ko\'rinadi', (tester) async {
    await _och(tester);
    for (var i = 0; i < 33; i++) {
      await tester.tap(find.byType(HalqaTugma));
      await tester.pump(const Duration(milliseconds: 30));
    }
    await tester.pumpAndSettle();
    await _bos(tester, find.text('Davom etish')); // kun hisobga olindi tabrigi

    await _statistikagaOt(tester);
    expect(_statda(find.text('1 kun')), findsOneWidget);
    expect(_statda(find.text('33')), findsWidgets);
    expect(_statda(find.text('33 zikr')), findsOneWidget);
  });

  testWidgets('streak uzilgan: rekordda yetilgan bosqich ✓, odat joriy streak bo\'yicha', (tester) async {
    await _och(tester, malumot: () async {
      for (var i = 10; i <= 17; i++) {
        await _sessiya(1, i, 40, 1); // 8 kunlik eski qator
      }
      await _sessiya(1, 1, 40, 1); // kecha
      await _sessiya(1, 0, 40, 1); // bugun: joriy streak 2
    });
    await _bos(tester, find.bySemanticsLabel('Ketma-ket kunlar: 2'));

    expect(_ketmada(find.text('7 kun · bir hafta')), findsOneWidget); // rekord 8 — yetilgan
    expect(_ketmada(find.text('14 kun · yana 12 kun qoldi')), findsOneWidget);
    expect(_ketmada(find.text('2 / 30 kun')), findsOneWidget);
    expect(_ketmada(find.text('8 kun')), findsOneWidget); // eng uzun
  });
}
