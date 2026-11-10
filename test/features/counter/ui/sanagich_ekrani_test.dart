import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/widgets/bortiq_tugma.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/sanagich_ekrani.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';

import '../../../helpers/test_ilova.dart';

late AppDatabase _db;

Future<void> _och(WidgetTester tester) async {
  telefonOlchami(tester);
  _db = await testBazasi();
  addTearDown(_db.close);
  await tester.pumpWidget(testIlova(const SanagichEkrani(), testOverrides(_db)));
  await tester.pumpAndSettle();
}

SanagichHolati _holat(WidgetTester tester) => ProviderScope.containerOf(
      tester.element(find.byType(SanagichEkrani)),
    ).read(sanagichProvider).requireValue;

/// Markaziy son matni.
String _son(WidgetTester tester) {
  final matnlar = tester.widgetList<Text>(
    find.descendant(of: find.byType(HalqaTugma), matching: find.byType(Text)),
  );
  return matnlar.map((t) => t.data!).firstWhere((m) => RegExp(r'^[\d ]+$').hasMatch(m));
}

Future<void> _bos(WidgetTester tester, Finder f, [int marta = 1]) async {
  for (var i = 0; i < marta; i++) {
    await tester.tap(f);
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('markaziy tugma va kontentning bo\'sh joyiga bosish sonni oshiradi', (tester) async {
    await _och(tester);
    expect(_son(tester), '0');
    expect(find.text('SubhanAllah'), findsOneWidget);
    expect(find.text('/ 33'), findsOneWidget);
    expect(find.text('1-aylana'), findsOneWidget);

    await _bos(tester, find.byType(HalqaTugma), 3);
    expect(_son(tester), '3');

    // Zikr matni ham kontent maydonida: bosish sanaydi.
    await _bos(tester, find.text('Alloh pokdir'));
    expect(_son(tester), '4');

    // Ishora matni ostidagi bo'sh joy.
    await _bos(tester, find.text('Ekranning istalgan joyini bosing'));
    expect(_son(tester), '5');
  });

  testWidgets('aylana tugaganda teg yangilanadi', (tester) async {
    await _och(tester);
    await _bos(tester, find.byType(HalqaTugma), 33);
    expect(_son(tester), '0');
    expect(find.text('2-aylana'), findsOneWidget);
    expect(find.text('1'), findsWidgets); // tasbeh pill'i: bugun 1 aylana
  });

  testWidgets('boshqaruv elementlariga bosish sanamaydi', (tester) async {
    await _och(tester);

    await _bos(tester, find.bySemanticsLabel('Tebranish yoqilgan'));
    expect(_holat(tester).haptik, isFalse);
    expect(_son(tester), '0');

    await _bos(tester, find.text('99'));
    expect(_holat(tester).maqsad, 99);
    expect(_son(tester), '0');

    // Nollash son 0 da hech narsa qilmaydi (dialog ham yo'q).
    await _bos(tester, find.bySemanticsLabel('Joriy aylanani nollash'));
    expect(find.byType(Dialog), findsNothing);
    expect(_son(tester), '0');

    await _bos(tester, find.text('Keyingisi: Alhamdulillah'));
    expect(_holat(tester).zikr.nomi, 'Alhamdulillah');
    expect(_son(tester), '0');
    expect(find.text('Keyingisi: Allohu Akbar'), findsOneWidget);

    await _bos(tester, find.text('Maxsus'));
    expect(find.text('Maxsus maqsad'), findsOneWidget);
    await _bos(tester, find.bySemanticsLabel('Yopish'));
    expect(_son(tester), '0');

    expect(_holat(tester).oxirgiQatorlar, isEmpty);
  });

  testWidgets('son > 0 da maqsad almashtirish tasdiq so\'raydi', (tester) async {
    await _och(tester);
    await _bos(tester, find.byType(HalqaTugma), 3);

    await _bos(tester, find.text('99'));
    expect(find.text('Joriy aylana nollanadi'), findsOneWidget);
    await _bos(tester, find.text('Bekor qilish'));
    expect(_holat(tester).maqsad, 33);
    expect(_son(tester), '3');

    await _bos(tester, find.text('99'));
    await _bos(tester, find.text('Almashtirish'));
    expect(_holat(tester).maqsad, 99);
    expect(_son(tester), '0');
    expect(find.text('/ 99'), findsOneWidget);
  });

  testWidgets('son 0 da maqsad darhol almashadi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('99'));
    expect(find.byType(Dialog), findsNothing);
    expect(_holat(tester).maqsad, 99);
  });

  testWidgets('∞ maqsadda teg va "/ maqsad" yashiriladi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('∞'));
    expect(_holat(tester).maqsad, isNull);
    expect(find.textContaining('-aylana'), findsNothing);
    expect(find.textContaining('/ '), findsNothing);

    await _bos(tester, find.byType(HalqaTugma), 40);
    expect(_son(tester), '40');
  });

  testWidgets('maxsus maqsad: 1–10 000 oralig\'i, faol ko\'rinadi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Maxsus'));

    await tester.enterText(find.byType(TextField), '0');
    await tester.pump();
    expect(find.text('1 dan 10 000 gacha son kiriting'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '1248');
    await tester.pump();
    await _bos(tester, find.text('Saqlash'));

    expect(_holat(tester).maqsad, 1248);
    expect(find.text('1 248'), findsOneWidget); // Maxsus o'rnida son
    expect(find.text('/ 1 248'), findsOneWidget);
    expect(find.text('Maxsus'), findsNothing);
  });

  testWidgets('nollash tasdiq bilan faqat joriy aylanani o\'chiradi', (tester) async {
    await _och(tester);
    await _bos(tester, find.byType(HalqaTugma), 35);
    expect(_son(tester), '2');

    await _bos(tester, find.bySemanticsLabel('Joriy aylanani nollash'));
    expect(find.byType(Dialog), findsOneWidget);
    await _bos(tester, find.text('Nollash'));

    expect(_son(tester), '0');
    expect(find.text('2-aylana'), findsOneWidget);
  });

  testWidgets('to\'plamda bo\'lmagan zikrda "Keyingisi" yashiriladi', (tester) async {
    telefonOlchami(tester);
    _db = await testBazasi();
    addTearDown(_db.close);
    await _db.into(_db.sozlama).insert(SozlamaCompanion.insert(kalit: 'joriy_zikr_id', qiymat: '4'));

    await tester.pumpWidget(testIlova(const SanagichEkrani(), testOverrides(_db)));
    await tester.pumpAndSettle();

    expect(find.text('La ilaha illalloh'), findsOneWidget);
    expect(find.textContaining('Keyingisi'), findsNothing);
    expect(find.byType(AsosiyTugma), findsNothing); // pastki qator yo'q
    expect(find.text('/ 100'), findsOneWidget);

    // Nollash maqsad qatorining o'ng chetida: 33 · 99 · ∞ · Maxsus · nollash.
    final nollash = find.bySemanticsLabel('Joriy aylanani nollash');
    // Maqsad 100 — Maxsus faol va o'rnida son yozilgan.
    final maxsus = tester.getRect(find.text('100'));
    final tugma = tester.getRect(nollash);
    expect(tugma.center.dy, moreOrLessEquals(tester.getCenter(find.text('33')).dy, epsilon: 2));
    expect(tugma.left, greaterThan(maxsus.right));
    expect(tugma.right, moreOrLessEquals(390 - 16, epsilon: 1));

    // U yerda ham ishlaydi va sanamaydi.
    await _bos(tester, find.byType(HalqaTugma), 2);
    await _bos(tester, nollash);
    await _bos(tester, find.text('Nollash'));
    expect(_son(tester), '0');
  });

  testWidgets('to\'plamdagi zikrda nollash pastki qatorda, "Keyingisi" yonida', (tester) async {
    await _och(tester);
    final nollash = tester.getRect(find.bySemanticsLabel('Joriy aylanani nollash'));
    final keyingisi = tester.getRect(find.byType(AsosiyTugma));
    expect(nollash.center.dy, moreOrLessEquals(keyingisi.center.dy, epsilon: 2));
    expect(nollash.center.dy, greaterThan(tester.getCenter(find.text('33')).dy));
  });

  for (final balandlik in [844.0, 700.0, 960.0]) {
    testWidgets('fon doiralari halqa markaziga bog\'langan (ekran $balandlik)', (tester) async {
      tester.view.physicalSize = Size(1170, balandlik * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      _db = await testBazasi();
      addTearDown(_db.close);
      await tester.pumpWidget(testIlova(const SanagichEkrani(), testOverrides(_db)));
      await tester.pumpAndSettle();

      final halqa = tester.getTopLeft(find.byType(HalqaTugma)) + HalqaTugma.markaz;
      for (final nom in ['fonDoira1', 'fonDoira2']) {
        final doira = tester.getCenter(find.byKey(ValueKey(nom)));
        expect(doira.dx, moreOrLessEquals(halqa.dx, epsilon: 0.5), reason: nom);
        expect(doira.dy - halqa.dy, moreOrLessEquals(186, epsilon: 0.5), reason: nom);
      }
    });
  }
}
