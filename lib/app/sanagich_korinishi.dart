import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sanagich ekrani hozir ko'rinib turibdimi (boshqa bo'lim yoki ustidagi sahifa ochiq emas).
/// Ovoz tugmasi bilan sanash va ekran yoniqligi shunga bog'liq.
final sanagichKorinadiProvider =
    NotifierProvider<SanagichKorinishi, bool>(SanagichKorinishi.new);

class SanagichKorinishi extends Notifier<bool> {
  @override
  bool build() => true;

  void ornat(bool korinadi) {
    if (state != korinadi) state = korinadi;
  }
}
