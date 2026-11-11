import '../../counter/domain/kun.dart';
import '../../counter/domain/kun_qatori.dart';
import '../../counter/domain/sanash.dart';
import 'yurish.dart';

class ToplamBosishNatijasi {
  const ToplamBosishNatijasi({
    required this.yurish,
    required this.sessiya,
    required this.qadamTugadi,
    required this.toplamTugadi,
  });

  final Yurish yurish;

  /// Shu qadam zikrining bugungi `sessiya` qatori (`jami`, `aylanalar` o'zgargan).
  final KunQatori sessiya;
  final bool qadamTugadi;
  final bool toplamTugadi;
}

/// To'plam rejimidagi sanash qoidalari. Alohida rejimning `sessiya.son` qiymatiga tegilmaydi.
abstract final class ToplamSanash {
  static Yurish yangi(int toplamId, Kun bugun) => Yurish(toplamId: toplamId, sana: bugun);

  /// Bitta bosish: `yurish.son + 1`, qadam zikrining bugungi `jami + 1`.
  /// Qadam maqsadiga yetsa: `aylanalar + 1`, keyingi qadamga o'tadi; oxirgisi bo'lsa yurish tugaydi.
  ///
  /// [sessiyaOxirgi] — qadam zikrining eng so'nggi qatori. Yarim tundan keyin yangi kun
  /// qatori ochiladi, yurish esa uzilmaydi.
  static ToplamBosishNatijasi bos(
    Yurish yurish,
    List<YolQadami> qadamlar,
    KunQatori? sessiyaOxirgi,
    Kun bugun,
  ) {
    final qadam = qadamlar[yurish.qadam];
    final s = Sanash.bugungiQator(sessiyaOxirgi, qadam.zikrId, bugun);
    final son = yurish.son + 1;

    if (son < qadam.maqsad) {
      return ToplamBosishNatijasi(
        yurish: yurish.copyWith(son: son),
        sessiya: s.copyWith(jami: s.jami + 1),
        qadamTugadi: false,
        toplamTugadi: false,
      );
    }

    final sessiya = s.copyWith(jami: s.jami + 1, aylanalar: s.aylanalar + 1);
    final keyingi = yurish.qadam + 1;
    final oxirgi = keyingi >= qadamlar.length;
    return ToplamBosishNatijasi(
      yurish: yurish.copyWith(son: 0, qadam: keyingi, tugadi: oxirgi),
      sessiya: sessiya,
      qadamTugadi: true,
      toplamTugadi: oxirgi,
    );
  }

  /// Qadamni o'tkazib yuboradi (aylana qo'shilmaydi). Oxirgi qadamda `null`: yurish
  /// tugallanmagan holda yopiladi (qatori o'chiriladi).
  static Yurish? otkazibYubor(Yurish yurish, int qadamlarSoni) {
    final keyingi = yurish.qadam + 1;
    if (keyingi >= qadamlarSoni) return null;
    return yurish.copyWith(qadam: keyingi, son: 0);
  }

  /// Joriy qadamni nolga qaytaradi: `sessiya.jami -= yurish.son`, `yurish.son = 0`.
  /// Bugungi `jami` noldan pastga tushmaydi (yarim tundan oldingi bosishlar kechagi kunda).
  static (Yurish, KunQatori) nolla(Yurish yurish, int zikrId, KunQatori? sessiyaOxirgi, Kun bugun) {
    final s = Sanash.bugungiQator(sessiyaOxirgi, zikrId, bugun);
    final ayiriladi = yurish.son < s.jami ? yurish.son : s.jami;
    return (yurish.copyWith(son: 0), s.copyWith(jami: s.jami - ayiriladi));
  }
}
