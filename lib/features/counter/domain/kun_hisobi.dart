import 'kun.dart';

/// Bir kunning barcha zikrlar bo'yicha yig'indisi.
class KunYigindisi {
  const KunYigindisi({required this.sana, this.aylanalar = 0, this.jami = 0});

  final Kun sana;
  final int aylanalar;
  final int jami;

  KunYigindisi qosh({int aylanalar = 0, int jami = 0}) => KunYigindisi(
        sana: sana,
        aylanalar: this.aylanalar + aylanalar,
        jami: this.jami + jami,
      );
}

class StreakNatijasi {
  const StreakNatijasi({required this.joriy, required this.rekord});

  final int joriy;
  final int rekord;
}

abstract final class KunHisobi {
  /// Kun hisoblanadi: kamida 1 aylana tugagan yoki jami [kunlikMaqsad] ga yetgan.
  static bool hisoblanadimi(KunYigindisi y, int kunlikMaqsad) =>
      y.aylanalar > 0 || y.jami >= kunlikMaqsad;

  static Set<Kun> hisoblanganKunlar(Iterable<KunYigindisi> yigindilar, int kunlikMaqsad) => {
        for (final y in yigindilar)
          if (hisoblanadimi(y, kunlikMaqsad)) y.sana,
      };

  /// Joriy streak: bugundan orqaga uzluksiz kunlar. Bugun hali hisoblanmagan bo'lsa,
  /// sanash kechadan boshlanadi. Rekord: eng uzun uzluksiz qator.
  static StreakNatijasi streak(Set<Kun> kunlar, Kun bugun) {
    var joriy = 0;
    var k = kunlar.contains(bugun) ? bugun : bugun.oldingi;
    while (kunlar.contains(k)) {
      joriy++;
      k = k.oldingi;
    }

    var rekord = 0;
    for (final kun in kunlar) {
      if (kunlar.contains(kun.oldingi)) continue; // qator boshi emas
      var uzunlik = 1;
      var keyingi = kun.keyingi;
      while (kunlar.contains(keyingi)) {
        uzunlik++;
        keyingi = keyingi.keyingi;
      }
      if (uzunlik > rekord) rekord = uzunlik;
    }

    return StreakNatijasi(joriy: joriy, rekord: rekord);
  }
}
