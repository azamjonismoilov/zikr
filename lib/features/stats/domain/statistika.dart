import '../../counter/domain/kun.dart';
import '../../counter/domain/kun_hisobi.dart';

/// Barcha davrdagi jamlar.
class Jamlar {
  const Jamlar({required this.jami, required this.aylanalar, required this.bugun});

  final int jami;
  final int aylanalar;

  /// Bugungi `jami`.
  final int bugun;
}

/// Kunlik qatordagi bitta kun.
typedef KunJami = ({Kun kun, int jami});

/// "Eng ko'p aytilgan" qatori.
typedef ZikrJami = ({int zikrId, int jami});

/// Statistika ekranining hafta qatori (7 kun, bugun oxirida).
enum HaftaBelgisi { hisoblangan, hisoblanmagan, bugunKutilmoqda }

/// Ketma-ketlik ekranining joriy haftasi (dushanbadan yakshanbagacha).
enum KapsulaHolati { hisoblangan, otibKetgan, kelajak }

typedef HaftaKuni = ({Kun kun, KapsulaHolati holat, int? tartib, bool bugun});

/// Bosqich holati.
enum BosqichHolati { yetilgan, navbatdagi, keyingi }

typedef Bosqich = ({int kun, BosqichHolati holat, int qoldi});

/// Odat maqsadi va shkaladagi uchta belgi.
typedef OdatMaqsadi = ({int maqsad, List<int> belgilar});

/// Statistika hisoblari. Hammasi sessiyalardan hisoblanadi, alohida saqlanmaydi.
abstract final class Statistika {
  static const bosqichKunlari = [7, 14, 30, 60, 100, 365];

  /// Jami zikr, aylana (barcha davr) va bugungi jami. O'chirilgan zikrlar ham kiradi.
  static Jamlar jamlar(Map<Kun, KunYigindisi> yigindilar, Kun bugun) {
    var jami = 0, aylanalar = 0;
    for (final y in yigindilar.values) {
      jami += y.jami;
      aylanalar += y.aylanalar;
    }
    return Jamlar(jami: jami, aylanalar: aylanalar, bugun: yigindilar[bugun]?.jami ?? 0);
  }

  /// Oxirgi [n] kun (bugun bilan, eskisidan yangisiga) har kunning `jami` yig'indisi.
  static List<KunJami> kunlikQator(Map<Kun, KunYigindisi> yigindilar, Kun bugun, int n) => [
        for (var i = n - 1; i >= 0; i--)
          (kun: bugun.qoshish(-i), jami: yigindilar[bugun.qoshish(-i)]?.jami ?? 0),
      ];

  /// Oxirgi [n] kunda `jami` bo'yicha eng ko'p aytilgan [soni] ta zikr.
  ///
  /// [tartiblar] — ro'yxatda ko'rinadigan (o'chirilmagan) zikrlar va ularning `tartib` i.
  /// Teng bo'lsa `tartib` bo'yicha. Davrda aytilmagan zikrlar kirmaydi.
  static List<ZikrJami> engKop(
    Map<int, Map<Kun, int>> zikrKunlari,
    Map<int, int> tartiblar,
    Kun bugun,
    int n, {
    int soni = 3,
  }) {
    final boshi = bugun.qoshish(-(n - 1));
    final royxat = <ZikrJami>[];
    for (final MapEntry(key: id, value: kunlar) in zikrKunlari.entries) {
      if (!tartiblar.containsKey(id)) continue;
      var jami = 0;
      kunlar.forEach((kun, j) {
        if (kun.compareTo(boshi) >= 0 && kun.compareTo(bugun) <= 0) jami += j;
      });
      if (jami > 0) royxat.add((zikrId: id, jami: jami));
    }
    royxat.sort((a, b) {
      final f = b.jami.compareTo(a.jami);
      return f != 0 ? f : tartiblar[a.zikrId]!.compareTo(tartiblar[b.zikrId]!);
    });
    return royxat.take(soni).toList();
  }

  /// Oxirgi 7 kun (bugun oxirida). Bugun hali hisoblanmagan bo'lsa — "kutilmoqda".
  static List<({Kun kun, HaftaBelgisi belgi})> haftaHolati(Set<Kun> hisoblangan, Kun bugun) => [
        for (var i = 6; i >= 0; i--)
          (
            kun: bugun.qoshish(-i),
            belgi: hisoblangan.contains(bugun.qoshish(-i))
                ? HaftaBelgisi.hisoblangan
                : i == 0
                    ? HaftaBelgisi.bugunKutilmoqda
                    : HaftaBelgisi.hisoblanmagan,
          ),
      ];

  /// Joriy hafta (dushanba–yakshanba). Hisoblangan kunda — uning uzluksiz qatordagi tartib
  /// raqami (joriy streak uchun streakdagi raqami). Bugun hali hisoblanmagan bo'lsa "kelajak".
  static List<HaftaKuni> joriyHafta(Set<Kun> hisoblangan, Kun bugun) {
    final dushanba = bugun.qoshish(-(bugun.haftaKuni - 1));
    return [
      for (var i = 0; i < 7; i++)
        () {
          final kun = dushanba.qoshish(i);
          final KapsulaHolati holat;
          if (hisoblangan.contains(kun)) {
            holat = KapsulaHolati.hisoblangan;
          } else if (kun.compareTo(bugun) < 0) {
            holat = KapsulaHolati.otibKetgan;
          } else {
            holat = KapsulaHolati.kelajak;
          }
          return (
            kun: kun,
            holat: holat,
            tartib: holat == KapsulaHolati.hisoblangan ? _qatordagiTartib(hisoblangan, kun) : null,
            bugun: kun == bugun,
          );
        }(),
    ];
  }

  static int _qatordagiTartib(Set<Kun> hisoblangan, Kun kun) {
    var tartib = 1;
    var k = kun.oldingi;
    while (hisoblangan.contains(k)) {
      tartib++;
      k = k.oldingi;
    }
    return tartib;
  }

  /// Joriy streakning birinchi kuni; streak 0 bo'lsa `null`.
  static Kun? streakBoshlangan(Set<Kun> hisoblangan, Kun bugun) {
    final streak = KunHisobi.streak(hisoblangan, bugun).joriy;
    if (streak == 0) return null;
    final oxirgi = hisoblangan.contains(bugun) ? bugun : bugun.oldingi;
    return oxirgi.qoshish(-(streak - 1));
  }

  /// Bosqichlar holati. Yetilgani [rekord] bo'yicha: bir marta yetilgan bosqich streak uzilsa
  /// ham ✓ bo'lib qoladi. Navbatdagi — rekorddan katta eng kichik bosqich; qolgan kunlar
  /// joriy [streak] dan hisoblanadi.
  static List<Bosqich> bosqichlar({required int rekord, required int streak}) {
    final natija = <Bosqich>[];
    var navbatBor = false;
    for (final n in bosqichKunlari) {
      final BosqichHolati holat;
      if (rekord >= n) {
        holat = BosqichHolati.yetilgan;
      } else if (!navbatBor) {
        holat = BosqichHolati.navbatdagi;
        navbatBor = true;
      } else {
        holat = BosqichHolati.keyingi;
      }
      natija.add((kun: n, holat: holat, qoldi: holat == BosqichHolati.yetilgan ? 0 : n - streak));
    }
    return natija;
  }

  /// Streak < 30 → 30 (7, 14, 30); < 100 → 100 (30, 60, 100); aks holda 365 (100, 200, 365).
  static OdatMaqsadi odatMaqsadi(int streak) {
    if (streak < 30) return (maqsad: 30, belgilar: const [7, 14, 30]);
    if (streak < 100) return (maqsad: 100, belgilar: const [30, 60, 100]);
    return (maqsad: 365, belgilar: const [100, 200, 365]);
  }
}
