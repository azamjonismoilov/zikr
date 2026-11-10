import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/domain/kun_hisobi.dart';

const _bugun = Kun(2026, 11, 10);

Set<Kun> _kunlar(List<int> oldin) => {for (final n in oldin) _bugun.qoshish(-n)};

void main() {
  group('kun hisobi', () {
    test('kamida 1 aylana tugagan kun hisoblanadi', () {
      expect(KunHisobi.hisoblanadimi(const KunYigindisi(sana: _bugun, aylanalar: 1, jami: 33), 100),
          isTrue);
    });

    test('jami kunlik maqsadga yetsa, aylanasiz ham hisoblanadi', () {
      expect(KunHisobi.hisoblanadimi(const KunYigindisi(sana: _bugun, jami: 100), 100), isTrue);
      expect(KunHisobi.hisoblanadimi(const KunYigindisi(sana: _bugun, jami: 99), 100), isFalse);
    });

    test('aylana ham, yetarli jami ham bo\'lmasa hisoblanmaydi', () {
      expect(KunHisobi.hisoblanadimi(const KunYigindisi(sana: _bugun, jami: 50), 100), isFalse);
    });

    test('hisoblanganKunlar faqat mos kunlarni oladi', () {
      final kunlar = KunHisobi.hisoblanganKunlar([
        const KunYigindisi(sana: Kun(2026, 11, 8), aylanalar: 2),
        const KunYigindisi(sana: Kun(2026, 11, 9), jami: 10),
        const KunYigindisi(sana: _bugun, jami: 120),
      ], 100);
      expect(kunlar, {const Kun(2026, 11, 8), _bugun});
    });
  });

  group('streak', () {
    test('bugun hisoblangan: bugundan orqaga uzluksiz', () {
      final s = KunHisobi.streak(_kunlar([0, 1, 2, 3]), _bugun);
      expect(s.joriy, 4);
    });

    test('bugun hali hisoblanmagan: kechadan boshlanadi, yo\'qolmaydi', () {
      final s = KunHisobi.streak(_kunlar([1, 2, 3]), _bugun);
      expect(s.joriy, 3);
    });

    test('uzilish streakni to\'xtatadi', () {
      final s = KunHisobi.streak(_kunlar([0, 1, 3, 4, 5]), _bugun);
      expect(s.joriy, 2);
    });

    test('kecha ham, bugun ham yo\'q bo\'lsa 0', () {
      final s = KunHisobi.streak(_kunlar([2, 3, 4]), _bugun);
      expect(s.joriy, 0);
    });

    test('rekord — barcha davrdagi eng uzun qator', () {
      final s = KunHisobi.streak(_kunlar([0, 1, 5, 6, 7, 8, 9, 20, 21]), _bugun);
      expect(s.joriy, 2);
      expect(s.rekord, 5);
    });

    test('bo\'sh to\'plam', () {
      final s = KunHisobi.streak({}, _bugun);
      expect(s.joriy, 0);
      expect(s.rekord, 0);
    });

    test('oy va yil chegarasidan o\'tadi', () {
      const yangiYil = Kun(2027, 1, 1);
      final s = KunHisobi.streak({const Kun(2026, 12, 30), const Kun(2026, 12, 31), yangiYil}, yangiYil);
      expect(s.joriy, 3);
    });
  });
}
