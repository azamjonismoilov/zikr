/// Zikrlar ro'yxatining bo'limlari.
///
/// Standart turkumlar shu tartibda keladi; o'z zikrlari turkumidan qat'i nazar
/// [meningBolimi] ga tushadi. Nomi va rasmi UI qatlamidagi `Turkum` da belgilanadi.
const turkumTartibi = ['namozdan_keyin', 'kun_davomida', 'ertalabki', 'kechki'];

/// O'z zikrlari bo'limi kaliti.
const meningBolimi = 'mening';

/// Yangi o'z zikri yoziladigan turkum (bo'limni `oz_zikri` belgilaydi, turkum emas).
const ozZikriTurkumi = 'kun_davomida';

class Bolim<T> {
  const Bolim(this.kalit, this.zikrlar);

  /// Turkum kaliti yoki [meningBolimi].
  final String kalit;
  final List<T> zikrlar;
}

/// Zikrlarni bo'limlarga ajratadi. Ichida zikri bor turkumlar [turkumTartibi] bo'yicha,
/// noma'lum turkumlar ulardan keyin, "Mening" esa har doim oxirida (bo'sh bo'lsa ham).
List<Bolim<T>> bolimlarga<T>(
  Iterable<T> zikrlar, {
  required String Function(T) turkum,
  required bool Function(T) ozZikri,
}) {
  final guruhlar = <String, List<T>>{};
  final mening = <T>[];
  for (final z in zikrlar) {
    if (ozZikri(z)) {
      mening.add(z);
    } else {
      guruhlar.putIfAbsent(turkum(z), () => []).add(z);
    }
  }
  final kalitlar = [
    ...turkumTartibi.where(guruhlar.containsKey),
    ...guruhlar.keys.where((k) => !turkumTartibi.contains(k)),
  ];
  return [
    for (final k in kalitlar) Bolim(k, guruhlar[k]!),
    Bolim(meningBolimi, mening),
  ];
}
