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

  /// Hozirgacha qo'yilgan barcha yozuvlar tugashini kutadi.
  Future<void> tugashiniKut() => _oxirgi;
}
