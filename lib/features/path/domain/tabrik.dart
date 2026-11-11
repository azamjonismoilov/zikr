/// Tabrik modali turi.
enum TabrikTuri { toplamTugadi, kunHisoblandi }

class TabrikQarori {
  const TabrikQarori({this.turi, this.dalda = false, required this.kechiktirilgan});

  /// `null` — modal chiqmaydi.
  final TabrikTuri? turi;

  /// Shu modal bilan streak oshdimi ("{n} kun ketma-ket" qatori).
  final bool dalda;

  /// To'plam ichida kun hisobga olingan, modal to'plam oxirigacha kechiktirilgan.
  final bool kechiktirilgan;
}

/// Modal faqat mazmunli paytda chiqadi: to'plam tugaganda yoki aylana tugashi bugungi kunni
/// birinchi marta hisoblatganda. Oddiy aylana tugashi modal chiqarmaydi. Kun aylana o'rtasida
/// kunlik maqsad orqali hisoblansa (∞ maqsad ham), modal yo'q: faqat streak belgisi yangilanadi.
abstract final class TabrikHisobi {
  /// [aylanaKunniHisoblatdi] — shu bosishda aylana (to'plamda qadam) tugadi va aynan shu
  /// bugun birinchi marta "kun hisoblanadi" shartini bajardi. [yurishYopildi] — oxirgi qadam o'tkazib yuborilib, yurish tugallanmagan
  /// holda yopildi. [kechiktirilgan] — oldinroq to'plam ichida kechiktirilgan holat bor.
  static TabrikQarori qaror({
    required bool toplamRejimi,
    required bool aylanaKunniHisoblatdi,
    required bool toplamTugadi,
    bool yurishYopildi = false,
    required bool kechiktirilgan,
  }) {
    if (!toplamRejimi) {
      return TabrikQarori(
        turi: aylanaKunniHisoblatdi ? TabrikTuri.kunHisoblandi : null,
        dalda: aylanaKunniHisoblatdi,
        kechiktirilgan: false,
      );
    }
    final kunBor = aylanaKunniHisoblatdi || kechiktirilgan;
    if (toplamTugadi) {
      return TabrikQarori(turi: TabrikTuri.toplamTugadi, dalda: kunBor, kechiktirilgan: false);
    }
    if (yurishYopildi) {
      // To'plam tugamadi, lekin kechiktirilgan "kun hisobga olindi" endi ko'rsatiladi.
      return TabrikQarori(
        turi: kunBor ? TabrikTuri.kunHisoblandi : null,
        dalda: kunBor,
        kechiktirilgan: false,
      );
    }
    return TabrikQarori(kechiktirilgan: kunBor);
  }
}
