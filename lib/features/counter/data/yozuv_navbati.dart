import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bazaga yozuvlarni bittadan, kelgan tartibda bajaradi.
///
/// UI holatni xotirada darhol yangilaydi va yozuvni shu yerga qo'yadi; yozuvni kutmaydi.
/// Bir yozuv xato bersa, keyingilari to'xtamaydi.
class YozuvNavbati {
  Future<void> _oxirgi = Future.value();
  int _kutilmoqda = 0;

  int get kutilmoqda => _kutilmoqda;

  void qosh(Future<void> Function() yozuv) {
    _kutilmoqda++;
    _oxirgi = _oxirgi.then((_) async {
      try {
        await yozuv();
      } catch (e, st) {
        debugPrint('Yozuv xatosi: $e\n$st');
      } finally {
        _kutilmoqda--;
      }
    });
  }

  /// Yozuvni navbatga qo'yadi va uning natijasini qaytaradi (masalan, yangi qator id'si).
  /// Xato chaqiruvchiga qaytariladi, navbat to'xtamaydi.
  Future<T> bajar<T>(Future<T> Function() yozuv) {
    final natija = Completer<T>();
    qosh(() async {
      try {
        natija.complete(await yozuv());
      } catch (e, st) {
        natija.completeError(e, st);
      }
    });
    return natija.future;
  }

  /// Hozirgacha qo'yilgan barcha yozuvlar tugashini kutadi.
  Future<void> tugashiniKut() => _oxirgi;
}
