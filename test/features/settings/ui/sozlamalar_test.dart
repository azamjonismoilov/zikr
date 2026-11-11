import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/manzillar.dart';
import 'package:zikr/core/widgets/bortiq_tugma.dart';
import 'package:zikr/core/widgets/osmon_toggle.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/sanagich_ekrani.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';
import 'package:zikr/features/settings/domain/mavzu.dart';
import 'package:zikr/features/settings/ui/sozlamalar_ekrani.dart';

import '../../../helpers/soxta_platforma.dart';
import '../../../helpers/test_ilova.dart';

late AppDatabase _db;
late SoxtaPlatforma _platforma;

Future<void> _och(
  WidgetTester tester, {
  bool android = true,
  bool ruxsat = true,
  bool yangiBaza = true,
  String maxfiylikManzili = '',
}) async {
  telefonOlchami(tester);
  if (yangiBaza) {
    _db = await testBazasi();
    addTearDown(_db.close);
  }
  _platforma = SoxtaPlatforma(android: android, ruxsat: ruxsat);
  await tester.pumpWidget(ProviderScope(
    key: UniqueKey(),
    overrides: [
      ...testOverrides(_db, platforma: _platforma),
      maxfiylikManziliProvider.overrideWithValue(maxfiylikManzili),
    ],
    child: const ZikrApp(),
  ));
  await tester.pumpAndSettle();
}

SanagichHolati _holat(WidgetTester tester) => ProviderScope.containerOf(
      tester.element(find.byType(SanagichEkrani, skipOffstage: false)),
    ).read(sanagichProvider).requireValue;

Finder _sozda(Finder f) => find.descendant(of: find.byType(SozlamalarEkrani), matching: f);

Future<void> _bos(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> _sozlamalargaOt(WidgetTester tester) => _bos(tester, find.bySemanticsLabel('Sozlamalar').first);

/// Qator nomi bo'yicha shu qatordagi toggle.
Finder _toggle(String nomi) => find.descendant(
      of: find.ancestor(of: find.text(nomi), matching: find.byType(Row)).first,
      matching: find.byType(OsmonToggle),
    );

Future<String?> _sozlama(WidgetTester tester, String kalit) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  final q = await tester.runAsync(
    () => (_db.select(_db.sozlama)..where((s) => s.kalit.equals(kalit))).getSingleOrNull(),
  );
  return q?.qiymat;
}

Future<void> _yozuvniKut(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
  await tester.pumpAndSettle();
}

Future<void> _sana(WidgetTester tester, int n) async {
  for (var i = 0; i < n; i++) {
    await tester.tap(find.byType(HalqaTugma));
    await tester.pump(const Duration(milliseconds: 30));
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('toggle\'lar sozlamani saqlaydi va qayta ochilganda tiklanadi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('Tebranish')), findsOneWidget);
    expect(_sozda(find.text('Zikr 1.0.0')), findsOneWidget);
    expect(_sozda(find.text('Til')), findsNothing);

    await _bos(tester, _toggle('Tebranish'));
    await _bos(tester, _toggle('Bosish tovushi'));
    await _bos(tester, _toggle('Ovoz tugmalari bilan sanash'));
    await _bos(tester, _toggle('Ekran oʻchmasin'));

    expect(await _sozlama(tester, 'haptik'), '0');
    expect(await _sozlama(tester, 'tovush'), '1');
    expect(await _sozlama(tester, 'ovoz_tugmasi'), '1');
    expect(await _sozlama(tester, 'ekran_yoniq'), '0');

    // Ilova qayta ochiladi.
    await _och(tester, yangiBaza: false);
    final h = _holat(tester);
    expect((h.haptik, h.tovush, h.ovozTugmasi, h.ekranYoniq), (false, true, true, false));
  });

  testWidgets('iOS\'da ovoz tugmasi qatori ko\'rsatilmaydi', (tester) async {
    await _och(tester, android: false);
    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('Ovoz tugmalari bilan sanash')), findsNothing);
  });

  testWidgets('mavzu tanlangach darhol qo\'llanadi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('Tizim')), findsOneWidget);
    expect(Theme.of(tester.element(find.byType(SozlamalarEkrani))).brightness, Brightness.light);

    await _bos(tester, _sozda(find.text('Mavzu')));
    await _bos(tester, find.text('Tun').last);

    expect(Theme.of(tester.element(find.byType(SozlamalarEkrani))).brightness, Brightness.dark);
    expect(_holat(tester).mavzu, Mavzu.tun);
    expect(await _sozlama(tester, 'mavzu'), 'tun');
  });

  testWidgets('kunlik maqsad o\'zgarishi kun hisobiga ta\'sir qiladi', (tester) async {
    await _och(tester);
    // ∞ maqsad bilan 60 bosish: kunlik 100 da kun hisoblanmaydi.
    await _bos(tester, find.descendant(of: find.byType(SanagichEkrani), matching: find.text('∞')));
    await _sana(tester, 60);
    expect(_holat(tester).streak.joriy, 0);

    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('100')), findsOneWidget);
    await _bos(tester, _sozda(find.text('Kunlik maqsad')));
    await tester.enterText(find.byType(TextField), '50');
    await _bos(tester, find.text('Saqlash'));

    expect(_holat(tester).kunlikMaqsad, 50);
    expect(_holat(tester).streak.joriy, 1);
    expect(await _sozlama(tester, 'kunlik_maqsad'), '50');

    // Tayyor variant darhol tanlanadi.
    await _bos(tester, _sozda(find.text('Kunlik maqsad')));
    await _bos(tester, find.text('1 000'));
    expect(_holat(tester).kunlikMaqsad, 1000);
    expect(_holat(tester).streak.joriy, 0);
  });

  testWidgets('hisobni nollash: ikki bosqichli tasdiq', (tester) async {
    await _och(tester);
    await _sana(tester, 33);
    await _bos(tester, find.text('Davom etish')); // tabrik
    expect(_holat(tester).oxirgiQatorlar, isNotEmpty);

    await _sozlamalargaOt(tester);
    await _bos(tester, _sozda(find.text('Hisobni nollash')));
    expect(find.text('Avval zaxira olish'), findsOneWidget);
    // Birinchi oynadagi tugma oddiy, faqat oxirgi tasdiq qizil.
    expect(tester.widget<AsosiyTugma>(find.widgetWithText(AsosiyTugma, 'Davom etish')).xavfli, isFalse);
    await _bos(tester, find.text('Bekor qilish'));
    expect(_holat(tester).oxirgiQatorlar, isNotEmpty);

    await _bos(tester, _sozda(find.text('Hisobni nollash')));
    await _bos(tester, find.text('Davom etish'));
    expect(find.text('Rostdan nollaysizmi?'), findsOneWidget);
    expect(tester.widget<AsosiyTugma>(find.widgetWithText(AsosiyTugma, 'Nollash')).xavfli, isTrue);
    await _bos(tester, find.text('Nollash'));
    await _yozuvniKut(tester);
    await _bos(tester, find.text('Yaxshi'));

    expect(_holat(tester).oxirgiQatorlar, isEmpty);
    expect(_holat(tester).zikrlar, hasLength(6));
    final sessiyalar = await tester.runAsync(() => _db.select(_db.sessiya).get());
    expect(sessiyalar, isEmpty);
  });

  testWidgets('nollashda "Avval zaxira olish" zaxira faylini ulashadi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    await _bos(tester, _sozda(find.text('Hisobni nollash')));
    await _bos(tester, find.text('Avval zaxira olish'));
    await _yozuvniKut(tester);
    expect(_platforma.ulashilganlar.single.$1, 'zikr-zaxira-2026-11-10.json');
    expect(find.text('Rostdan nollaysizmi?'), findsNothing);
  });

  testWidgets('zaxira olish va noto\'g\'ri fayldan tiklash', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    await _bos(tester, _sozda(find.text('Zaxira nusxa olish')));
    await _yozuvniKut(tester);
    expect(_platforma.ulashilganlar, hasLength(1));

    _platforma.tanlanadiganFayl = 'bu json emas';
    await _bos(tester, _sozda(find.text('Zaxiradan tiklash')));
    await _yozuvniKut(tester);
    expect(find.text('Bu fayl Zikr zaxirasi emas. Ulashilgan .json faylni tanlang.'), findsOneWidget);
  });

  testWidgets('eslatma: yoqilganda ruxsat so\'raladi va rejalashtiriladi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('Oʻchiq')), findsOneWidget);
    await _bos(tester, _sozda(find.text('Kunlik eslatma')));
    await _bos(tester, find.descendant(of: find.byType(BottomSheet), matching: find.byType(OsmonToggle)));

    expect(_holat(tester).eslatmaYoniq, isTrue);
    expect(_platforma.rejalar.last.$1, DateTime(2026, 11, 10, 21));
    expect(_platforma.rejalar.last.$2, 'Zikr vaqti');
    expect(_platforma.rejalar.last.$3, 'Bugungi zikringizni unutmang');
    expect(await _sozlama(tester, 'eslatma_yoniq'), '1');
  });

  testWidgets('eslatma: ruxsat rad etilsa toggle o\'chiq qoladi, sozlamalarni ochish tugmasi', (tester) async {
    await _och(tester, ruxsat: false);
    await _sozlamalargaOt(tester);
    await _bos(tester, _sozda(find.text('Kunlik eslatma')));
    await _bos(tester, find.descendant(of: find.byType(BottomSheet), matching: find.byType(OsmonToggle)));

    expect(_holat(tester).eslatmaYoniq, isFalse);
    expect(find.text('Bildirishnomaga ruxsat berilmagan'), findsOneWidget);
    await _bos(tester, find.text('Sozlamalarni ochish'));
    expect(_platforma.sozlamalarOchildi, 1);
  });

  testWidgets('kun hisoblanganda bugungi eslatma ertaga suriladi', (tester) async {
    await _och(tester);
    await tester.runAsync(() async {
      await _db.into(_db.sozlama).insert(SozlamaCompanion.insert(kalit: 'eslatma_yoniq', qiymat: '1'));
    });
    await _och(tester, yangiBaza: false);
    expect(_platforma.rejalar.last.$1, DateTime(2026, 11, 10, 21));

    await _sana(tester, 33);
    expect(_platforma.rejalar.last.$1, DateTime(2026, 11, 11, 21));
  });

  testWidgets('bosish tovushi, ovoz tugmasi va ekran yoniqligi sanagichda', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    await _bos(tester, _toggle('Bosish tovushi'));
    await _bos(tester, _toggle('Ovoz tugmalari bilan sanash'));
    expect(_platforma.ovozUshlanmoqda, isFalse); // Sanagich ko'rinmayapti

    await _bos(tester, find.bySemanticsLabel('Sanagich').first);
    expect(_platforma.ovozUshlanmoqda, isTrue);

    await _sana(tester, 2);
    expect(_platforma.tovushlar, 2);
    expect(_platforma.ekranYoniqHolati, isTrue);

    _platforma.ovozTugmasiniBos();
    await tester.pumpAndSettle();
    expect(_holat(tester).son, 3);

    // 2 daqiqa bosilmasa ekran odatdagi holatga qaytadi.
    await tester.pump(const Duration(minutes: 2));
    expect(_platforma.ekranYoniqHolati, isFalse);

    // Boshqa bo'limga o'tilganda ovoz tugmasi qo'yib yuboriladi, ekran ham.
    await _sana(tester, 1);
    expect(_platforma.ekranYoniqHolati, isTrue);
    await _sozlamalargaOt(tester);
    expect(_platforma.ovozUshlanmoqda, isFalse);
    expect(_platforma.ekranYoniqHolati, isFalse);
    _platforma.ovozTugmasiniBos();
    await tester.pumpAndSettle();
    expect(_holat(tester).son, 4);
  });

  testWidgets('bildirishnoma bosilsa Sanagich ochiladi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    _platforma.bildirishnomaniBos();
    await tester.pumpAndSettle();
    expect(find.byType(HalqaTugma).hitTestable(), findsOneWidget);
  });

  testWidgets('maxfiylik siyosati: manzil boʻsh boʻlsa qator yoʻq, boʻlsa brauzerda ochiladi', (tester) async {
    await _och(tester);
    await _sozlamalargaOt(tester);
    expect(_sozda(find.text('Maxfiylik siyosati')), findsNothing);

    const manzil = 'https://example.org/maxfiylik/';
    await _och(tester, maxfiylikManzili: manzil);
    await _sozlamalargaOt(tester);
    await _bos(tester, _sozda(find.text('Maxfiylik siyosati')));
    expect(_platforma.ochilganHavolalar, [manzil]);
  });
}
