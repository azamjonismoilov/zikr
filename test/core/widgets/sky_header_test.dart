import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/theme/app_theme.dart';
import 'package:zikr/core/widgets/sky_header.dart';

String _asset(WidgetTester tester) =>
    (tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName;

Future<void> _chiz(WidgetTester tester, {required ThemeData mavzu, bool oysiz = false}) =>
    tester.pumpWidget(MaterialApp(
      theme: mavzu,
      home: SkyHeader(vaqt: OsmonVaqt.peshin, oysiz: oysiz),
    ));

void main() {
  testWidgets('tunda har doim Xufton; oysiz bo\'lsa oysiz varianti', (tester) async {
    await _chiz(tester, mavzu: AppTheme.tun);
    expect(_asset(tester), 'assets/svg/osmon_xufton.svg');

    await _chiz(tester, mavzu: AppTheme.tun, oysiz: true);
    expect(_asset(tester), 'assets/svg/osmon_xufton_oysiz.svg');
  });

  testWidgets('yorug\' rejimda oysiz parametri ta\'sir qilmaydi', (tester) async {
    await _chiz(tester, mavzu: AppTheme.yorug, oysiz: true);
    expect(_asset(tester), 'assets/svg/osmon_peshin.svg');
  });
}
