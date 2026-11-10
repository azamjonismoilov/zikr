import 'package:flutter/widgets.dart' show Alignment;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/app/app.dart';
import 'package:zikr/core/widgets/sky_header.dart';

import '../helpers/test_ilova.dart';

void main() {
  testWidgets('tab bar orqali toʻrt boʻlim orasida oʻtiladi', (tester) async {
    telefonOlchami(tester);
    final db = await testBazasi();
    addTearDown(db.close);
    await tester.pumpWidget(ProviderScope(overrides: testOverrides(db), child: const ZikrApp()));
    await tester.pumpAndSettle();

    SkyHeader osmon() => tester.widget<SkyHeader>(find.byType(SkyHeader).hitTestable(at: Alignment.topCenter));

    expect(osmon().vaqt, OsmonVaqt.peshin);

    await tester.tap(find.bySemanticsLabel('Zikrlar').first);
    await tester.pumpAndSettle();
    expect(find.text('Zikrlar').hitTestable(), findsWidgets);
    expect(osmon().vaqt, OsmonVaqt.bomdod);

    await tester.tap(find.bySemanticsLabel('Statistika').first);
    await tester.pumpAndSettle();
    expect(osmon().vaqt, OsmonVaqt.peshin);

    await tester.tap(find.bySemanticsLabel('Sozlamalar').first);
    await tester.pumpAndSettle();
    expect(osmon().vaqt, OsmonVaqt.shom);
  });
}
