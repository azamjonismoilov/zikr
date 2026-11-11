import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aloqa va sayt manzillari. Hali yo'q: bo'sh qoldirilgan, to'ldirilgach ilova ishlatadi.
abstract final class Manzillar {
  /// Aloqa emaili. Maxfiylik sahifasida (`sayt/maxfiylik/index.html`) `ALOQA_EMAIL`
  /// belgisi o'rniga ham shu yoziladi.
  static const aloqaEmail = '';

  /// Maxfiylik siyosati sahifasi. Bo'sh bo'lsa Sozlamalarda "Maxfiylik siyosati"
  /// qatori ko'rsatilmaydi.
  static const maxfiylikSahifasi = '';
}

/// Maxfiylik sahifasi manzili (testlarda almashtiriladi).
final maxfiylikManziliProvider = Provider<String>((_) => Manzillar.maxfiylikSahifasi);
