import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/widgets/bortiq_tugma.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/sanagich_ekrani.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';
import 'package:zikr/features/library/ui/zikrlar_ekrani.dart';
import 'package:zikr/features/path/ui/yol_ekrani.dart';

import '../../../helpers/test_ilova.dart';

late AppDatabase _db;

Future<void> _och(WidgetTester tester) async {
  telefonOlchami(tester);
  _db = await testBazasi();
  addTearDown(_db.close);
  await tester.pumpWidget(ProviderScope(overrides: testOverrides(_db), child: const ZikrApp()));
  await tester.pumpAndSettle();
}

SanagichHolati _holat(WidgetTester tester) => ProviderScope.containerOf(
      tester.element(find.byType(SanagichEkrani, skipOffstage: false)),
    ).read(sanagichProvider).requireValue;

Finder _sanagichda(Finder f) => find.descendant(of: find.byType(SanagichEkrani), matching: f);

Future<void> _bos(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await tester.pumpAndSettle();
}

/// Halqani [n] marta tez bosadi.
Future<void> _sana(WidgetTester tester, int n) async {
  for (var i = 0; i < n; i++) {
    await tester.tap(find.byType(HalqaTugma));
    await tester.pump(const Duration(milliseconds: 30));
  }
  await tester.pumpAndSettle();
}

/// Zikrlar → "Namozdan keyin" sarlavhasi → Tasbehot yo'li.
Future<void> _yolniOch(WidgetTester tester) async {
  await _bos(tester, find.bySemanticsLabel('Zikrlar').first);
  await _bos(tester, find.descendant(of: find.byType(ZikrlarEkrani), matching: find.text('Har farz namozidan soʻng · 3 ta zikr')));
  expect(find.byType(YolEkrani), findsOneWidget);
}

void main() {
  testWidgets('yo\'ldan boshlash Sanagichni to\'plam rejimida ochadi', (tester) async {
    await _och(tester);
    await _yolniOch(tester);
    expect(find.text('Namozdan keyingi tasbehot'), findsOneWidget);
    expect(find.text('Bugun 1-marta'), findsOneWidget);
    expect(find.text('Tasbehot · 100 zikr'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    expect(find.text('SubhanAllah · 0/33'), findsOneWidget); // joriy tugun
    expect(find.text('Alhamdulillah · 33'), findsOneWidget);

    await _bos(tester, find.widgetWithText(AsosiyTugma, 'Boshlash'));

    expect(find.byType(YolEkrani), findsNothing);
    expect(_holat(tester).toplamRejimi, isTrue);
    expect(_sanagichda(find.text('1 / 3')), findsOneWidget); // teg: qadam / jami
    expect(_sanagichda(find.text('/ 33')), findsOneWidget);
    expect(_sanagichda(find.text('99')), findsNothing); // maqsad qatori yo'q
    expect(_sanagichda(find.text('Keyingisi: Alhamdulillah')), findsOneWidget);
  });

  testWidgets('33 bosishdan keyin zikr o\'zi almashadi, oyna chiqmaydi; oxirida modal', (tester) async {
    await _och(tester);
    await _yolniOch(tester);
    await _bos(tester, find.widgetWithText(AsosiyTugma, 'Boshlash'));

    await _sana(tester, 33);
    expect(find.byType(Dialog), findsNothing);
    expect(_holat(tester).zikr.nomi, 'Alhamdulillah');
    expect(_sanagichda(find.text('2 / 3')), findsOneWidget);
    expect(_sanagichda(find.text('Keyingisi: Allohu Akbar')), findsOneWidget);

    await _sana(tester, 33);
    expect(find.byType(Dialog), findsNothing);
    expect(_sanagichda(find.text('3 / 3')), findsOneWidget);
    expect(_sanagichda(find.text('/ 34')), findsOneWidget);
    expect(_sanagichda(find.widgetWithText(AsosiyTugma, 'Tugatish')), findsOneWidget);

    await _sana(tester, 34);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Tasbehot tugadi'), findsOneWidget);
    expect(find.text('100 / 100'), findsOneWidget);
    expect(find.text('Bugun 1-marta'), findsOneWidget);
    expect(find.text('1 kun ketma-ket. Davom eting!'), findsOneWidget);

    await _bos(tester, find.text('Tayyor'));
    expect(find.byType(Dialog), findsNothing);
    expect(_holat(tester).toplamRejimi, isFalse);
    expect(_holat(tester).zikr.nomi, 'SubhanAllah');
    expect(_sanagichda(find.text('99')), findsOneWidget); // alohida rejim qaytdi
  });

  testWidgets('"Yana bir marta" yangi yurish boshlaydi', (tester) async {
    await _och(tester);
    final ctrl = ProviderScope.containerOf(tester.element(find.byType(SanagichEkrani)))
        .read(sanagichProvider.notifier);
    await tester.runAsync(() => ctrl.toplamniBoshla(1));
    await tester.pumpAndSettle();

    await _sana(tester, 100);
    await _bos(tester, find.text('Yana bir marta'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    final h = _holat(tester);
    expect(h.toplamRejimi, isTrue);
    expect((h.yurish!.qadam, h.son), (0, 0));
    expect(h.bugunTugaganlar(1), 1);
    expect(_sanagichda(find.text('1 / 3')), findsOneWidget);
  });

  testWidgets('alohida rejimda oddiy aylana modal chiqarmaydi', (tester) async {
    await _och(tester);
    // Birinchi aylana kunni hisobga oladi: bu modal.
    await _sana(tester, 33);
    expect(find.text('Aylana tugadi'), findsOneWidget);
    expect(find.text('SubhanAllah · 33 marta'), findsOneWidget);
    await _bos(tester, find.text('Davom etish'));

    // Ikkinchi aylana: modal yo'q, teg yangilanadi.
    await _sana(tester, 33);
    expect(find.byType(Dialog), findsNothing);
    expect(_sanagichda(find.text('3-aylana')), findsOneWidget);
  });

  testWidgets('yo\'l: yarim yurishda "Davom etish" va joriy tugun yozuvi', (tester) async {
    await _och(tester);
    final ctrl = ProviderScope.containerOf(tester.element(find.byType(SanagichEkrani)))
        .read(sanagichProvider.notifier);
    await tester.runAsync(() => ctrl.toplamniBoshla(1));
    await tester.pumpAndSettle();
    await _sana(tester, 38);

    await _yolniOch(tester);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('Alhamdulillah · 5/33'), findsOneWidget);
    expect(find.widgetWithText(AsosiyTugma, 'Davom etish'), findsOneWidget);

    // Joriy tugunni bosish ham Sanagichni ochadi.
    await _bos(tester, find.text('Alhamdulillah · 5/33'));
    expect(find.byType(YolEkrani), findsNothing);
    expect(_holat(tester).son, 5);
  });

  testWidgets('"Tugatish" oxirgi qadamni o\'tkazib, rejimdan chiqadi', (tester) async {
    await _och(tester);
    final ctrl = ProviderScope.containerOf(tester.element(find.byType(SanagichEkrani)))
        .read(sanagichProvider.notifier);
    await tester.runAsync(() => ctrl.toplamniBoshla(1));
    await tester.pumpAndSettle();

    await _bos(tester, _sanagichda(find.widgetWithText(AsosiyTugma, 'Keyingisi: Alhamdulillah')));
    await _bos(tester, _sanagichda(find.widgetWithText(AsosiyTugma, 'Keyingisi: Allohu Akbar')));
    await _bos(tester, _sanagichda(find.widgetWithText(AsosiyTugma, 'Tugatish')));
    expect(find.byType(Dialog), findsNothing);
    expect(_holat(tester).toplamRejimi, isFalse);
    expect(_holat(tester).yurishlar, isEmpty);
  });

  testWidgets('∞ maqsadda kun kunlik jami orqali hisoblansa modal yo\'q, streak yangilanadi', (tester) async {
    await _och(tester);
    await _bos(tester, _sanagichda(find.text('∞')));
    expect(find.bySemanticsLabel('Ketma-ket kunlar: 0'), findsOneWidget);
    await _sana(tester, 100);
    expect(find.byType(Dialog), findsNothing);
    expect(find.bySemanticsLabel('Ketma-ket kunlar: 1'), findsOneWidget);
  });
}
