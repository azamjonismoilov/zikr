import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/widgets/bortiq_tugma.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/sanagich_ekrani.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';
import 'package:zikr/features/library/domain/oz_zikr.dart';
import 'package:zikr/features/library/ui/oz_zikr_ekrani.dart';
import 'package:zikr/features/library/ui/widgets/dars_karta.dart';
import 'package:zikr/features/library/ui/widgets/tanlash_qator.dart';
import 'package:zikr/features/library/ui/zikrlar_ekrani.dart';

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

Finder _zikrlarda(Finder f) => find.descendant(of: find.byType(ZikrlarEkrani), matching: f);

Future<void> _bos(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await tester.pumpAndSettle();
}

/// Baza `runAsync` ichida ishlatilgan testlarda yozuv soxta vaqtda tugamaydi: real vaqt beriladi.
Future<void> _yozuvniKut(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
  await tester.pumpAndSettle();
}

/// Gorizontal ro'yxatdagi elementni ko'rinadigan qilib bosadi.
Future<void> _korinibBos(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await _bos(tester, f);
}

Future<void> _zikrlargaOt(WidgetTester tester) => _bos(tester, find.bySemanticsLabel('Zikrlar').first);

/// Sanagichdagi nom qatorini bosib panelni ochadi.
Future<void> _panelniOch(WidgetTester tester) => _bos(
      tester,
      find.descendant(of: find.byType(SanagichEkrani), matching: find.text(_holat(tester).zikr.nomi)),
    );

void main() {
  testWidgets('karta bosilganda joriy zikr almashadi va Sanagich ochiladi', (tester) async {
    await _och(tester);
    await _zikrlargaOt(tester);
    expect(_zikrlarda(find.byType(DarsKarta)), findsNWidgets(6));

    await _bos(tester, _zikrlarda(find.text('Alhamdulillah')));

    expect(_holat(tester).zikr.nomi, 'Alhamdulillah');
    expect(find.byType(HalqaTugma).hitTestable(), findsOneWidget); // Sanagich ko'rinib turibdi
    expect(find.descendant(of: find.byType(SanagichEkrani), matching: find.text('Alhamdulillah')),
        findsOneWidget);
  });

  testWidgets('bo\'limlar: Namozdan keyin, Kun davomida va bo\'sh "Mening"', (tester) async {
    await _och(tester);
    await _zikrlargaOt(tester);

    expect(_zikrlarda(find.text('Har farz namozidan soʻng · 3 ta zikr')), findsOneWidget);
    expect(_zikrlarda(find.text('Istalgan vaqtda · 3 ta zikr')), findsOneWidget);
    expect(_zikrlarda(find.text('Ertalabki')), findsNothing); // ichida zikri yo'q turkum yo'q

    // "Mening" tabi bo'limga aylantiradi; bo'sh holat va qo'shish tugmasi ko'rinadi.
    await _bos(tester, _zikrlarda(find.bySemanticsLabel('Mening')));
    expect(_zikrlarda(find.text('Oʻz zikringiz hali yoʻq')).hitTestable(), findsOneWidget);
    expect(_zikrlarda(find.text('Oʻz zikringizni qoʻshish')).hitTestable(), findsOneWidget);
  });

  testWidgets('bo\'limni yig\'ish va ochish', (tester) async {
    await _och(tester);
    await _zikrlargaOt(tester);
    expect(_zikrlarda(find.text('SubhanAllah')), findsOneWidget);

    await _bos(tester, _zikrlarda(find.text('Namozdan keyin')).last);
    expect(_zikrlarda(find.text('SubhanAllah')), findsNothing);
    await _bos(tester, _zikrlarda(find.text('Namozdan keyin')).last);
    expect(_zikrlarda(find.text('SubhanAllah')), findsOneWidget);
  });

  testWidgets('nom qatori panelni ochadi va sanamaydi; qidiruv filtrlaydi', (tester) async {
    await _och(tester);
    await _panelniOch(tester);
    expect(_holat(tester).son, 0);
    expect(find.text('Zikrni tanlang'), findsOneWidget);
    expect(find.byType(TanlashQator), findsNWidgets(6));

    await tester.enterText(find.byType(TextField), 'astagfirulloh');
    await tester.pumpAndSettle();
    expect(find.byType(TanlashQator), findsOneWidget);
    expect(find.descendant(of: find.byType(TanlashQator), matching: find.text('Astagʻfirulloh')), findsOneWidget);

    await tester.enterText(find.byType(TextField), "MAG'FIRAT");
    await tester.pumpAndSettle();
    expect(find.byType(TanlashQator), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(find.byType(TanlashQator), findsNothing);
    expect(find.text('Hech narsa topilmadi'), findsOneWidget);
    expect(find.text('Oʻz zikringizni qoʻshish'), findsWidgets);
  });

  testWidgets('panel chiplari bo\'lim bo\'yicha filtrlaydi', (tester) async {
    await _och(tester);
    await _panelniOch(tester);
    await _korinibBos(tester, find.text('Kun davomida').last);
    expect(find.byType(TanlashQator), findsNWidgets(3));
    await _korinibBos(tester, find.text('Mening').last);
    expect(find.text('Hech narsa topilmadi'), findsOneWidget);
    await _korinibBos(tester, find.text('Hammasi'));
    expect(find.byType(TanlashQator), findsNWidgets(6));
  });

  testWidgets('zikr almashganda tugallanmagan son saqlanadi', (tester) async {
    await _och(tester);
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byType(HalqaTugma));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(_holat(tester).son, 7);

    await _panelniOch(tester);
    await _bos(tester, find.descendant(of: find.byType(TanlashQator), matching: find.text('La ilaha illalloh')));
    expect(find.text('Zikrni tanlang'), findsNothing); // panel yopildi
    expect(_holat(tester).zikr.nomi, 'La ilaha illalloh');
    expect(_holat(tester).son, 0);

    await _panelniOch(tester);
    await _bos(tester, find.descendant(of: find.byType(TanlashQator), matching: find.text('SubhanAllah')));
    expect(_holat(tester).son, 7);
  });

  testWidgets('o\'z zikri: majburiy maydon bo\'sh bo\'lsa saqlash nofaol; saqlangach Sanagich', (tester) async {
    await _och(tester);
    await _zikrlargaOt(tester);
    await _bos(tester, _zikrlarda(find.bySemanticsLabel('Mening')));
    await _bos(tester, _zikrlarda(find.text('Oʻz zikringizni qoʻshish')));

    expect(find.byType(OzZikrEkrani), findsOneWidget);
    expect(find.text('Yangi zikr'), findsOneWidget);
    final pastkiSaqlash = find.widgetWithText(AsosiyTugma, 'Saqlash');
    expect(tester.widget<AsosiyTugma>(pastkiSaqlash).onTap, isNull);
    await _bos(tester, pastkiSaqlash);
    expect(find.byType(OzZikrEkrani), findsOneWidget); // hech narsa bo'lmadi

    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.pump();
    expect(tester.widget<AsosiyTugma>(pastkiSaqlash).onTap, isNull);

    await tester.enterText(find.byType(TextField).first, 'Hasbunalloh');
    await tester.pump();
    expect(tester.widget<AsosiyTugma>(pastkiSaqlash).onTap, isNotNull);
    await _bos(tester, find.byKey(const ValueKey('rasm_yulduz')));
    await _bos(tester, find.text('99'));
    await _bos(tester, pastkiSaqlash);

    expect(find.byType(OzZikrEkrani), findsNothing);
    expect(_holat(tester).zikr.nomi, 'Hasbunalloh');
    expect(_holat(tester).zikr.ozZikri, isTrue);
    expect(_holat(tester).zikr.rasm, 'yulduz');
    expect(_holat(tester).maqsad, 99);
    expect(find.byType(HalqaTugma).hitTestable(), findsOneWidget);
  });

  testWidgets('yozilgan bo\'lsa yopish tasdiq so\'raydi', (tester) async {
    await _och(tester);
    await _panelniOch(tester);
    await _bos(tester, find.text('Oʻz zikringizni qoʻshish'));
    expect(find.byType(OzZikrEkrani), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Biror narsa');
    await _bos(tester, find.bySemanticsLabel('Yopish'));
    expect(find.text('Oʻzgarishlar saqlanmaydi'), findsOneWidget);
    await _bos(tester, find.text('Bekor qilish'));
    expect(find.byType(OzZikrEkrani), findsOneWidget);

    await _bos(tester, find.bySemanticsLabel('Yopish'));
    await _bos(tester, find.text('Chiqish'));
    expect(find.byType(OzZikrEkrani), findsNothing);
  });

  testWidgets('bo\'sh formani yopish tasdiqsiz', (tester) async {
    await _och(tester);
    await _panelniOch(tester);
    await _bos(tester, find.text('Oʻz zikringizni qoʻshish'));
    await _bos(tester, find.bySemanticsLabel('Yopish'));
    expect(find.byType(Dialog), findsNothing);
    expect(find.byType(OzZikrEkrani), findsNothing);
  });

  testWidgets('uzoq bosish tahrirlashni ochadi; o\'chirish tasdiq bilan', (tester) async {
    await _och(tester);
    final ctrl = ProviderScope.containerOf(tester.element(find.byType(SanagichEkrani)))
        .read(sanagichProvider.notifier);
    await tester.runAsync(() => ctrl.ozZikrQosh(const OzZikr(nomi: 'Mening zikrim')));
    await tester.pumpAndSettle();

    await _zikrlargaOt(tester);
    await _bos(tester, _zikrlarda(find.bySemanticsLabel('Mening')));
    final karta = _zikrlarda(find.widgetWithText(DarsKarta, 'Mening zikrim'));
    expect(karta, findsOneWidget);
    expect(_zikrlarda(find.text('Oʻz zikringiz hali yoʻq')), findsNothing);

    await tester.longPress(karta);
    await tester.pumpAndSettle();
    expect(find.text('Zikrni tahrirlash'), findsOneWidget);
    expect(find.text('Mening zikrim'), findsWidgets); // maydon to'ldirilgan

    await tester.enterText(find.byType(TextField).first, 'Yangilangan');
    await _bos(tester, find.widgetWithText(AsosiyTugma, 'Saqlash'));
    await _yozuvniKut(tester);
    expect(find.byType(OzZikrEkrani), findsNothing);
    expect(_zikrlarda(find.text('Yangilangan')), findsOneWidget);

    await tester.longPress(_zikrlarda(find.widgetWithText(DarsKarta, 'Yangilangan')));
    await tester.pumpAndSettle();
    await _bos(tester, find.text('Oʻchirish'));
    expect(find.text('Zikrni oʻchirish'), findsOneWidget);
    await _bos(tester, find.widgetWithText(AsosiyTugma, 'Oʻchirish'));
    await _yozuvniKut(tester);

    expect(find.byType(OzZikrEkrani), findsNothing);
    expect(_zikrlarda(find.text('Yangilangan')), findsNothing);
    expect(_zikrlarda(find.text('Oʻz zikringiz hali yoʻq')), findsOneWidget);
    expect(_holat(tester).zikr.nomi, 'SubhanAllah');
  });
}
