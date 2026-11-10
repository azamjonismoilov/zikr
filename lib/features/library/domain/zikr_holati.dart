import '../../counter/domain/kun.dart';
import '../../counter/domain/kun_qatori.dart';
import '../../counter/domain/sanash.dart';

/// Zikrning bugungi holati (Figma `DarsKarta` va `IjroTugma` holatlari).
enum ZikrHolati { bajarildi, jarayonda, yangi }

class ZikrHolatMalumoti {
  const ZikrHolatMalumoti(this.holat, {this.son = 0, this.progress});

  final ZikrHolati holat;

  /// Joriy aylanadagi son.
  final int son;

  /// `son / maqsad`, 0..1. Maqsad ∞ bo'lsa `null` (progress chizig'i yo'q).
  final double? progress;
}

abstract final class ZikrHolatHisobi {
  /// Bajarildi: bugun kamida 1 aylana tugagan. Jarayonda: joriy aylanada son bor.
  /// Yangi: qolgan hollar.
  ///
  /// Yarim tundan keyin ko'chgan tugallanmagan son ham "jarayonda" hisoblanadi:
  /// sanagich uni ko'rsatib turadi, karta ham shunga mos bo'lishi kerak.
  static ZikrHolatMalumoti hisobla(KunQatori? oxirgi, int? maqsad, Kun bugun) {
    if (Sanash.bugungiAylanalar(oxirgi, bugun) > 0) {
      return const ZikrHolatMalumoti(ZikrHolati.bajarildi);
    }
    final son = Sanash.joriySon(oxirgi);
    if (son > 0) {
      final progress = maqsad == null || maqsad <= 0 ? null : (son / maqsad).clamp(0.0, 1.0);
      return ZikrHolatMalumoti(ZikrHolati.jarayonda, son: son, progress: progress);
    }
    return const ZikrHolatMalumoti(ZikrHolati.yangi);
  }
}
