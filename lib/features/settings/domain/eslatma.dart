/// Kunlik eslatma rejasi: keyingi kunlardagi chiqish vaqtlari va matn tanlovi.
class EslatmaRejasi {
  const EslatmaRejasi({required this.vaqtlar, this.streak});

  /// Har kun uchun bitta bildirishnoma, [Eslatma.kunlarSoni] kun oldinga.
  ///
  /// Takrorlanuvchi bitta bildirishnoma ishlatilmaydi: tizim uning birinchi sanasini
  /// "hozirdan keyingi" deb qayta hisoblaydi, bugungisini o'tkazib yuborib bo'lmaydi.
  final List<DateTime> vaqtlar;

  DateTime get birinchi => vaqtlar.first;

  /// Streak 1 dan katta bo'lsa — "{n} kunlik ketma-ketlikni davom ettiring",
  /// aks holda (`null`) — "Bugungi zikringizni unutmang".
  final int? streak;
}

abstract final class Eslatma {
  static const standartDaqiqa = 21 * 60;

  /// Necha kun oldinga rejalashtiriladi. Ilova har ochilganda yangilanadi.
  static const kunlarSoni = 30;

  /// Eslatma o'chiq bo'lsa `null`. Bugun kun allaqachon hisoblangan yoki vaqt o'tib ketgan
  /// bo'lsa, birinchisi ertaga.
  static EslatmaRejasi? rejala({
    required bool yoniq,
    required int daqiqa,
    required DateTime hozir,
    required bool bugunHisoblangan,
    required int streak,
  }) {
    if (!yoniq) return null;
    DateTime kunda(int n) => DateTime(hozir.year, hozir.month, hozir.day + n, daqiqa ~/ 60, daqiqa % 60);
    final boshi = bugunHisoblangan || !kunda(0).isAfter(hozir) ? 1 : 0;
    return EslatmaRejasi(
      vaqtlar: [for (var i = 0; i < kunlarSoni; i++) kunda(boshi + i)],
      streak: streak > 1 ? streak : null,
    );
  }

  /// "21:00" → 1260.
  static int? daqiqaga(String matn) {
    final q = matn.split(':');
    if (q.length != 2) return null;
    final s = int.tryParse(q[0]), d = int.tryParse(q[1]);
    if (s == null || d == null || s < 0 || s > 23 || d < 0 || d > 59) return null;
    return s * 60 + d;
  }

  /// 1260 → "21:00".
  static String matnga(int daqiqa) =>
      '${(daqiqa ~/ 60).toString().padLeft(2, '0')}:${(daqiqa % 60).toString().padLeft(2, '0')}';
}
