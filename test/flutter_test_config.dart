import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Barcha testlardan oldin ilova shriftlarini (Inter, Amiri) yuklaydi.
/// Aks holda test shrifti har harfni kvadrat qilib chizadi va o'lchamlar real bo'lmaydi.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  Future<void> yukla(String oila, List<String> fayllar) async {
    final loader = FontLoader(oila);
    for (final f in fayllar) {
      loader.addFont(Future.value(ByteData.sublistView(File('assets/fonts/$f').readAsBytesSync())));
    }
    await loader.load();
  }

  await yukla('Inter', ['Inter-Medium.ttf', 'Inter-SemiBold.ttf', 'Inter-Bold.ttf', 'Inter-ExtraBold.ttf']);
  await yukla('Amiri', ['Amiri-Regular.ttf']);
  await testMain();
}
