import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/app/router.dart';
import 'package:zikr/core/db/database.dart';
import 'package:zikr/core/widgets/osmon_tab_bar.dart';
import 'package:zikr/features/counter/data/sanagich_repository.dart';
import 'package:zikr/features/counter/ui/sanagich_controller.dart';
import 'package:zikr/features/counter/ui/widgets/halqa.dart';
import 'package:zikr/features/library/ui/turkum.dart';

import '../helpers/test_ilova.dart';

/// Asosiy ekranlar: oddiy va 1.3 matn masshtabida overflow yo'q, bosish maydonlari 48 dp dan
/// kichik emas, bosiladigan elementlarda semantik yorliq bor (yorug' va tun).
void main() {
  _elonTesti();
  late AppDatabase db;

  Future<void> och(WidgetTester tester, {required bool tun, required double masshtab, bool onboarding = false}) async {
    telefonOlchami(tester);
    tester.platformDispatcher.textScaleFactorTestValue = masshtab;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    db = await testBazasi(onboardingKorildi: !onboarding);
    addTearDown(db.close);
    await db.into(db.sozlama).insert(SozlamaCompanion.insert(kalit: SozlamaKalit.mavzu, qiymat: tun ? 'tun' : 'yorug'));
    if (!onboarding) await _katta(db);
    await tester.pumpWidget(ProviderScope(overrides: testOverrides(db), child: const ZikrApp()));
    await tester.pumpAndSettle();
  }

  Future<void> bor(WidgetTester tester, String yol) async {
    GoRouter.of(tester.element(find.byType(Navigator).first)).go(yol);
    await tester.pumpAndSettle();
  }

  Future<void> tekshir(WidgetTester tester, String nomi) async {
    expect(tester.takeException(), isNull, reason: '$nomi: overflow yoki xato');
    // Matn kesilmaydi: hech bir paragraf qator chegarasidan oshmaydi (ellipsis yo'q).
    final kesilgan = <String>[
      for (final e in find.byType(RichText).hitTestable().evaluate())
        if ((e.renderObject! as RenderParagraph).didExceedMaxLines)
          (e.widget as RichText).text.toPlainText(),
    ];
    expect(kesilgan, isEmpty, reason: '$nomi: kesilgan matn');
    // Matnlar ustma-ust tushmaydi. Tab bar kapsulasi aylantiriladigan kontent ustida
    // suzib turadi (dizayn bo'yicha), shuning uchun uning yorliqlari hisobga olinmaydi.
    final matnlar = [
      for (final e in find
          .byType(RichText)
          .hitTestable()
          .evaluate()
          .where((e) => find.descendant(of: find.byType(OsmonTabBar), matching: find.byWidget(e.widget)).evaluate().isEmpty))
        (
          (e.widget as RichText).text.toPlainText(),
          MatrixUtils.transformRect(
            (e.renderObject! as RenderBox).getTransformTo(null),
            Offset.zero & (e.renderObject! as RenderBox).size,
          ),
        ),
    ];
    final ustma = <String>[
      for (var i = 0; i < matnlar.length; i++)
        for (var j = i + 1; j < matnlar.length; j++)
          if (_kesishadi(matnlar[i].$2, matnlar[j].$2)) '${matnlar[i].$1} × ${matnlar[j].$1}',
    ];
    expect(ustma, isEmpty, reason: '$nomi: ustma-ust matn');
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: '$nomi: 48 dp');
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: '$nomi: yorliq');
    // Ilovadagi rasmlar bezak: ekran o'qigich ularni "rasm" deb o'qimaydi.
    expect(
      find.semantics.byPredicate((n) => n.getSemanticsData().flagsCollection.isImage),
      findsNothing,
      reason: '$nomi: bezak rasm',
    );
  }

  Future<void> panel(WidgetTester tester, Finder ochuvchi, String nomi) async {
    await tester.tap(ochuvchi);
    await tester.pumpAndSettle();
    await tekshir(tester, nomi);
    await tester.tapAt(const Offset(195, 60)); // panel tashqarisi
    await tester.pumpAndSettle();
  }

  for (final (tun, masshtab) in [(false, 1.0), (false, engKattaMatn), (true, 1.0), (true, engKattaMatn)]) {
    final rejim = '${tun ? 'tun' : 'yorugʻ'}, matn $masshtab';

    testWidgets('asosiy ekranlar, $rejim', (tester) async {
      final semantika = tester.ensureSemantics();
      await och(tester, tun: tun, masshtab: masshtab);
      final toplamId = ProviderScope.containerOf(tester.element(find.byType(ZikrApp)))
          .read(sanagichProvider)
          .requireValue
          .toplamlar
          .first
          .id;

      for (final yol in [
        Yollar.sanagich,
        Yollar.zikrlar,
        Yollar.statistika,
        Yollar.sozlamalar,
        Yollar.ketmaKetlik,
        Yollar.yangiZikr,
        Yollar.yol(toplamId),
      ]) {
        await bor(tester, yol);
        await tekshir(tester, yol);
      }
      semantika.dispose();
    });

    testWidgets('pastki panellar, $rejim', (tester) async {
      final semantika = tester.ensureSemantics();
      await och(tester, tun: tun, masshtab: masshtab);
      await panel(
        tester,
        find.byWidgetPredicate((w) => w is Semantics && w.properties.hint == 'Zikrni tanlang'),
        'zikr tanlash',
      );
      // Tabrik modali: bugungi kun hali hisoblanmagan bazada aylana tugatiladi.
      await _bugunniTozala(db);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(ProviderScope(overrides: testOverrides(db), child: const ZikrApp()));
      await tester.pumpAndSettle();
      for (var i = 0; i < 33; i++) {
        await tester.tap(find.byType(HalqaTugma));
        await tester.pump(const Duration(milliseconds: 30));
      }
      await tester.pumpAndSettle();
      expect(find.text('Davom etish'), findsOneWidget);
      await tekshir(tester, 'tabrik');
      await tester.tap(find.text('Davom etish'));
      await tester.pumpAndSettle();

      await bor(tester, Yollar.sozlamalar);
      for (final qator in ['Kunlik maqsad', 'Mavzu', 'Kunlik eslatma']) {
        await panel(tester, find.text(qator).first, qator);
      }
      semantika.dispose();
    });

    testWidgets('onboarding qadamlari, $rejim', (tester) async {
      final semantika = tester.ensureSemantics();
      await och(tester, tun: tun, masshtab: masshtab, onboarding: true);
      await tekshir(tester, '1-qadam');
      await tester.tap(find.text('Boshlash'));
      await tester.pumpAndSettle();
      await tekshir(tester, '2-qadam');
      await tester.tap(find.text('Davom etish'));
      await tester.pumpAndSettle();
      await tekshir(tester, '3-qadam');
      semantika.dispose();
    });
  }
}

/// Sanagichning ekran o'qigich e'loni: zikr nomi, son, maqsad va aylana bitta jumlada.
void _elonTesti() {
  testWidgets('sanagich son, maqsad va zikr nomini bitta eʼlon qiladi', (tester) async {
    final semantika = tester.ensureSemantics();
    telefonOlchami(tester);
    final db = await testBazasi();
    addTearDown(db.close);
    await tester.pumpWidget(ProviderScope(overrides: testOverrides(db), child: const ZikrApp()));
    await tester.pumpAndSettle();
    final h = ProviderScope.containerOf(tester.element(find.byType(ZikrApp))).read(sanagichProvider).requireValue;
    expect(find.bySemanticsLabel('${h.zikr.korinishNomi}, 0 / ${h.maqsad}, 1-aylana'), findsOneWidget);
    semantika.dispose();
  });
}

/// Katta sonlar bilan to'ldirilgan tarix: uzun raqamlar ham sig'ishi kerak.
Future<void> _katta(AppDatabase db) async {
  final zikrId = (await db.select(db.zikr).get()).first.id;
  final bugun = DateTime(2026, 11, 10, 9);
  for (var i = 0; i < 40; i++) {
    final kun = bugun.subtract(Duration(days: i));
    final sana = '${kun.year}-${'${kun.month}'.padLeft(2, '0')}-${'${kun.day}'.padLeft(2, '0')}';
    await db
        .into(db.sessiya)
        .insert(
          SessiyaCompanion.insert(
            zikrId: zikrId,
            son: const Value(27),
            aylanalar: const Value(3333),
            jami: const Value(109989),
            boshlandi: kun,
            yangilandi: kun,
            sana: sana,
          ),
        );
  }
}

/// Ikki matn qutisi sezilarli kesishadimi (1 px dan ko'p).
bool _kesishadi(Rect a, Rect b) {
  final k = a.intersect(b);
  return k.width > 1 && k.height > 1;
}

/// Bugungi sessiyalarni o'chiradi: keyingi aylana kunni hisoblatib tabrik chiqaradi.
Future<void> _bugunniTozala(AppDatabase db) =>
    (db.delete(db.sessiya)..where((s) => s.sana.equals('2026-11-10'))).go();
