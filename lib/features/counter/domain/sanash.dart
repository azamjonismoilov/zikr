import 'kun.dart';
import 'kun_qatori.dart';

/// Bosish natijasi: yangi kun qatori va aylana tugaganmi.
class BosishNatijasi {
  const BosishNatijasi(this.qator, {required this.aylanaTugadi});

  final KunQatori qator;
  final bool aylanaTugadi;
}

/// Sanash qoidalari. Holat saqlanmaydi: har funksiya oxirgi qatordan yangisini qaytaradi.
abstract final class Sanash {
  /// Zikrning [bugun] uchun qatori.
  ///
  /// [oxirgi] — shu zikrning eng so'nggi qatori (bo'lmasa `null`). U o'tgan kunga tegishli
  /// bo'lsa, yangi kun qatori ochiladi: tugallanmagan `son` ko'chadi, `jami` va
  /// `aylanalar` noldan boshlanadi. O'tgan kun qatori o'zgarmaydi.
  static KunQatori bugungiQator(KunQatori? oxirgi, int zikrId, Kun bugun) {
    if (oxirgi == null) return KunQatori(zikrId: zikrId, sana: bugun);
    if (oxirgi.sana == bugun) return oxirgi;
    return KunQatori(zikrId: zikrId, sana: bugun, son: oxirgi.son);
  }

  /// Bitta bosish. [maqsad] `null` bo'lsa (∞) aylana bo'lmaydi.
  static BosishNatijasi bos(KunQatori? oxirgi, int zikrId, int? maqsad, Kun bugun) {
    final q = bugungiQator(oxirgi, zikrId, bugun);
    final son = q.son + 1;
    final jami = q.jami + 1;
    if (maqsad != null && son >= maqsad) {
      return BosishNatijasi(
        q.copyWith(son: 0, jami: jami, aylanalar: q.aylanalar + 1),
        aylanaTugadi: true,
      );
    }
    return BosishNatijasi(q.copyWith(son: son, jami: jami), aylanaTugadi: false);
  }

  /// Joriy aylanani o'chiradi: `jami -= son`, `son = 0`.
  ///
  /// Yarim tundan keyin ko'chgan `son` ning bir qismi kechagi `jami` da turadi.
  /// O'tgan kunlar o'zgarmagani uchun bugungi `jami` noldan pastga tushmaydi.
  static KunQatori nolla(KunQatori? oxirgi, int zikrId, Kun bugun) {
    final q = bugungiQator(oxirgi, zikrId, bugun);
    final ayiriladi = q.son < q.jami ? q.son : q.jami;
    return q.copyWith(son: 0, jami: q.jami - ayiriladi);
  }

  /// Maqsadni almashtirishdan oldin tasdiq kerakmi.
  static bool maqsadUchunTasdiqKerak(KunQatori? oxirgi) => (oxirgi?.son ?? 0) > 0;

  /// Ekranda ko'rinadigan joriy son (yarim tundan keyin ham ko'chgan son ko'rinadi).
  static int joriySon(KunQatori? oxirgi) => oxirgi?.son ?? 0;

  /// Shu zikr bo'yicha bugun tugagan aylanalar.
  static int bugungiAylanalar(KunQatori? oxirgi, Kun bugun) =>
      oxirgi != null && oxirgi.sana == bugun ? oxirgi.aylanalar : 0;
}
