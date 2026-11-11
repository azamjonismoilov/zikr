import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/format/son_format.dart';
import 'package:zikr/core/widgets/tanlov_karta.dart';
import 'package:zikr/features/counter/data/sanagich_repository.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/sanagich_ekrani.dart';
import 'package:zikr/features/onboarding/ui/onboarding_ekrani.dart';

import '../../../helpers/soxta_platforma.dart';
import '../../../helpers/test_ilova.dart';

late AppDatabase _db;
final _ming = '${sonFormat(1000)} ta';
late SoxtaPlatforma _platforma;

Future<void> _och(WidgetTester tester, {bool ruxsat = true, bool yangiBaza = true}) async {
  telefonOlchami(tester);
  if (yangiBaza) {
    _db = await testBazasi(onboardingKorildi: false);
    addTearDown(_db.close);
  }
  _platforma = SoxtaPlatforma(ruxsat: ruxsat);
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: testOverrides(_db, platforma: _platforma),
      child: const ZikrApp(),
    ),
  );
  await tester.pumpAndSettle();
}

SanagichHolati _holat(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(ZikrApp))).read(sanagichProvider).requireValue;

Future<void> _bos(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<String?> _sozlama(WidgetTester tester, String kalit) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  final q = await tester.runAsync(
    () => (_db.select(_db.sozlama)..where((s) => s.kalit.equals(kalit))).getSingleOrNull(),
  );
  return q?.qiymat;
}

/// Sarlavhasi bo'yicha variant kartasi tanlanganmi.
bool _tanlangan(WidgetTester tester, String sarlavha) =>
    tester.widget<TanlovKarta>(find.widgetWithText(TanlovKarta, sarlavha)).tanlangan;

bool get _onboardingda => find.byType(OnboardingEkrani).evaluate().isNotEmpty;
bool get _sanagichda => find.byType(SanagichEkrani).hitTestable().evaluate().isNotEmpty;

void main() {
  testWidgets('birinchi ochilishda chiqadi, tugagach ikkinchisida chiqmaydi', (tester) async {
    await _och(tester);
    expect(_onboardingda, isTrue);
    expect(find.text('Har bir zikr hisobda'), findsOneWidget);

    await _bos(tester, find.text('Boshlash'));
    await _bos(tester, find.text('Davom etish'));
    await _bos(tester, find.text('Tayyor'));
    expect(_sanagichda, isTrue);
    expect(await _sozlama(tester, SozlamaKalit.onboardingKorildi), '1');

    await _och(tester, yangiBaza: false);
    expect(_onboardingda, isFalse);
    expect(_sanagichda, isTrue);
  });

  testWidgets('mavjud maʼlumotli bazada chiqmaydi va belgilab qoʻyiladi', (tester) async {
    _db = await testBazasi(onboardingKorildi: false);
    addTearDown(_db.close);
    final zikrId = (await _db.select(_db.zikr).get()).first.id;
    final vaqt = DateTime(2026, 11, 9, 8);
    await _db
        .into(_db.sessiya)
        .insert(
          SessiyaCompanion.insert(
            zikrId: zikrId,
            son: const Value(5),
            jami: const Value(5),
            boshlandi: vaqt,
            yangilandi: vaqt,
            sana: '2026-11-09',
          ),
        );

    await _och(tester, yangiBaza: false);
    expect(_onboardingda, isFalse);
    expect(_sanagichda, isTrue);
    // Hisob nollansa ham onboarding qaytmasligi uchun belgi yoziladi.
    expect(await _sozlama(tester, SozlamaKalit.onboardingKorildi), '1');
  });

  testWidgets('oʻtkazib yuborish standart qiymatlarni yozadi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Oʻtkazib yuborish'));

    expect(_sanagichda, isTrue);
    final h = _holat(tester);
    expect(h.kunlikMaqsad, 100);
    expect(h.eslatmaYoniq, isFalse);
    expect(h.onboardingKorildi, isTrue);
    expect(await _sozlama(tester, SozlamaKalit.eslatmaYoniq), '0');
    expect(await _sozlama(tester, SozlamaKalit.onboardingKorildi), '1');
    expect(_platforma.rejalar, isEmpty);
  });

  testWidgets('tanlovlar saqlanadi: maqsad 1000, ertalab 06:00, ruxsat bor', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Boshlash'));
    expect(_tanlangan(tester, '300 ta'), isTrue, reason: 'standart 300');

    await _bos(tester, find.text(_ming));
    expect(_tanlangan(tester, _ming), isTrue);
    expect(_tanlangan(tester, '300 ta'), isFalse);
    await _bos(tester, find.text('Davom etish'));
    expect(_holat(tester).kunlikMaqsad, 1000);

    expect(_tanlangan(tester, 'Kechqurun · 21:00'), isTrue, reason: 'standart kechqurun');
    await _bos(tester, find.text('Ertalab · 06:00'));
    await _bos(tester, find.text('Tayyor'));

    expect(_sanagichda, isTrue);
    final h = _holat(tester);
    expect(h.kunlikMaqsad, 1000);
    expect(h.eslatmaYoniq, isTrue);
    expect(h.eslatmaDaqiqa, 6 * 60);
    expect(await _sozlama(tester, SozlamaKalit.kunlikMaqsad), '1000');
    expect(await _sozlama(tester, SozlamaKalit.eslatmaYoniq), '1');
    expect(await _sozlama(tester, SozlamaKalit.eslatmaVaqti), '06:00');
    expect(_platforma.rejalar, isNotEmpty);
    expect(_platforma.rejalar.last.$1.hour, 6);
  });

  testWidgets('"Oʻzim belgilayman": panel ochiladi, son kartada koʻrinadi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Boshlash'));
    await _bos(tester, find.text('Oʻzim belgilayman'));
    await tester.enterText(find.byType(TextField), '750');
    await _bos(tester, find.text('Saqlash'));

    expect(_tanlangan(tester, '750 ta'), isTrue);
    await _bos(tester, find.text('Davom etish'));
    expect(_holat(tester).kunlikMaqsad, 750);
  });

  testWidgets('ruxsat rad etilsa eslatma oʻchiq qoladi, onboarding baribir tugaydi', (tester) async {
    await _och(tester, ruxsat: false);
    await _bos(tester, find.text('Boshlash'));
    await _bos(tester, find.text('Davom etish'));
    await _bos(tester, find.text('Tayyor'));

    expect(_sanagichda, isTrue);
    expect(_holat(tester).eslatmaYoniq, isFalse);
    expect(await _sozlama(tester, SozlamaKalit.eslatmaYoniq), '0');
    expect(await _sozlama(tester, SozlamaKalit.onboardingKorildi), '1');
  });

  testWidgets('"Kerak emas": ruxsat soʻralmaydi, eslatma oʻchiq', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Boshlash'));
    await _bos(tester, find.text('Davom etish'));
    await _bos(tester, find.text('Kerak emas'));
    await _bos(tester, find.text('Tayyor'));

    expect(_sanagichda, isTrue);
    expect(_holat(tester).eslatmaYoniq, isFalse);
  });

  testWidgets('orqaga qaytish (tugma va tizim imo-ishorasi) tanlovlarni saqlaydi', (tester) async {
    await _och(tester);
    await _bos(tester, find.text('Boshlash'));
    await _bos(tester, find.text(_ming));
    await _bos(tester, find.text('Davom etish'));
    await _bos(tester, find.text('Kerak emas'));

    // Orqaga tugmasi: 3 → 2.
    await _bos(tester, find.bySemanticsLabel('Orqaga'));
    expect(_tanlangan(tester, _ming), isTrue);

    await _bos(tester, find.text('Davom etish'));
    expect(_tanlangan(tester, 'Kerak emas'), isTrue);

    // Tizimning orqaga imo-ishorasi: 3 → 2 → 1, ilova yopilmaydi.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Kuniga qancha zikr qilmoqchisiz?'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Har bir zikr hisobda'), findsOneWidget);

    await _bos(tester, find.text('Boshlash'));
    expect(_tanlangan(tester, _ming), isTrue);
  });
}
