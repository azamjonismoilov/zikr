import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final svglar = Directory('assets/svg')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.svg'))
      .map((f) => f.path)
      .toList()
    ..sort();

  test('8 ta Rasm plitkasi joyida', () {
    const nomlar = ['tong', 'tun', 'namoz', 'tasbeh', 'yurak', 'kitob', 'yulduz', 'olov'];
    for (final n in nomlar) {
      expect(svglar, contains('assets/svg/rasm_$n.svg'));
    }
  });

  for (final yol in svglar) {
    test('$yol flutter_svg bilan oʻqiladi', () async {
      final info = await vg.loadPicture(SvgAssetLoader(yol, assetBundle: rootBundle), null);
      expect(info.size.isEmpty, isFalse);
      info.picture.dispose();
    });
  }
}
