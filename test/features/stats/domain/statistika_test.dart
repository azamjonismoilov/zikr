import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/domain/kun_hisobi.dart';
import 'package:zikr/features/stats/domain/statistika.dart';

/// 2026-11-10 — seshanba.
const _bugun = Kun(2026, 11, 10);

Kun _oldin(int n) => _bugun.qoshish(-n);

Map<Kun, KunYigindisi> _yig(Map<int, (int, int)> kunlar) => {
      for (final MapEntry(key: n, value: (jami, aylanalar)) in kunlar.entries)
        _oldin(n): KunYigindisi(sana: _oldin(n), jami: jami, aylanalar: aylanalar),
    };

void main() {
  group('jamlar', () {
    test('jami, aylana (barcha davr) va bugun', () {
      final j = Statistika.jamlar(_yig({0: (50, 1), 1: (100, 3), 40: (7, 0)}), _bugun);
      expect((j.jami, j.aylanalar, j.bugun), (157, 4, 50));
    });

    test('bo\'sh baza', () {
      final j = Statistika.jamlar({}, _bugun);
      expect((j.jami, j.aylanalar, j.bugun), (0, 0, 0));
    });
  });

  test('kunlik qator: N kun, bo\'sh kunlar 0, eskisidan bugunga', () {
    final q = Statistika.kunlikQator(_yig({0: (5, 0), 2: (9, 0), 10: (99, 0)}), _bugun, 7);
    expect(q, hasLength(7));
    expect(q.first.kun, _oldin(6));
    expect(q.last.kun, _bugun);
    expect(q.map((k) => k.jami), [0, 0, 0, 0, 9, 0, 5]);
  });

  group('eng ko\'p aytilgan', () {
    final tartiblar = {1: 1, 2: 2, 3: 3, 4: 4};

    test('davrdagi jami bo\'yicha, eng ko\'pi 3 ta', () {
      final r = Statistika.engKop({
        1: {_bugun: 10, _oldin(1): 5},
        2: {_bugun: 40},
        3: {_oldin(3): 20},
        4: {_oldin(2): 1},
      }, tartiblar, _bugun, 7);
      expect(r.map((x) => (x.zikrId, x.jami)), [(2, 40), (3, 20), (1, 15)]);
    });

    test('davrdan tashqari kunlar hisobga kirmaydi', () {
      final r = Statistika.engKop({1: {_oldin(7): 100, _bugun: 1}}, tartiblar, _bugun, 7);
      expect(r.single.jami, 1);
      final r30 = Statistika.engKop({1: {_oldin(7): 100, _bugun: 1}}, tartiblar, _bugun, 30);
      expect(r30.single.jami, 101);
    });

    test('o\'chirilgan zikr ro\'yxatga kirmaydi', () {
      final r = Statistika.engKop({1: {_bugun: 5}, 99: {_bugun: 500}}, tartiblar, _bugun, 7);
      expect(r.map((x) => x.zikrId), [1]);
    });

    test('teng bo\'lsa tartib bo\'yicha; nol jami kirmaydi', () {
      final r = Statistika.engKop({
        3: {_bugun: 10},
        1: {_bugun: 10},
        2: {_bugun: 0},
      }, tartiblar, _bugun, 7);
      expect(r.map((x) => x.zikrId), [1, 3]);
    });
  });

  test('hafta holati: 7 kun, bugun oxirida; bugun hali hisoblanmagan — kutilmoqda', () {
    final h = Statistika.haftaHolati({_oldin(1), _oldin(2), _oldin(5)}, _bugun);
    expect(h.first.kun, _oldin(6));
    expect(h.last.kun, _bugun);
    expect(h.map((x) => x.belgi), [
      HaftaBelgisi.hisoblanmagan,
      HaftaBelgisi.hisoblangan,
      HaftaBelgisi.hisoblanmagan,
      HaftaBelgisi.hisoblanmagan,
      HaftaBelgisi.hisoblangan,
      HaftaBelgisi.hisoblangan,
      HaftaBelgisi.bugunKutilmoqda,
    ]);
    expect(Statistika.haftaHolati({_bugun}, _bugun).last.belgi, HaftaBelgisi.hisoblangan);
  });

  group('joriy hafta', () {
    test('dushanbadan yakshanbagacha; hisoblangan kunda streakdagi tartib raqami', () {
      // 10 kunlik streak: 1-noyabrdan bugungacha.
      final kunlar = {for (var i = 0; i < 10; i++) _oldin(i)};
      final h = Statistika.joriyHafta(kunlar, _bugun);
      expect(h.first.kun, const Kun(2026, 11, 9)); // dushanba
      expect(h.last.kun, const Kun(2026, 11, 15)); // yakshanba
      expect(h.map((x) => x.holat).take(2), everyElement(KapsulaHolati.hisoblangan));
      expect(h.map((x) => x.tartib).take(2), [9, 10]);
      expect(h[1].bugun, isTrue);
      expect(h.skip(2).map((x) => x.holat), everyElement(KapsulaHolati.kelajak));
      expect(h.skip(2).map((x) => x.tartib), everyElement(isNull));
    });

    test('o\'tib ketgan hisoblanmagan kun; bugun hali hisoblanmagan — kelajak (raqamsiz)', () {
      final h = Statistika.joriyHafta({_bugun}, const Kun(2026, 11, 11)); // chorshanba
      expect(h.map((x) => x.holat).take(3), [
        KapsulaHolati.otibKetgan, // dushanba
        KapsulaHolati.hisoblangan, // seshanba (_bugun)
        KapsulaHolati.kelajak, // chorshanba — bugun, hali yo'q
      ]);
      expect(h[2].bugun, isTrue);
    });

    test('yakshanba kuni hafta bugun bilan tugaydi', () {
      const yakshanba = Kun(2026, 11, 15);
      final h = Statistika.joriyHafta({yakshanba}, yakshanba);
      expect(h.last.kun, yakshanba);
      expect((h.last.holat, h.last.tartib, h.last.bugun), (KapsulaHolati.hisoblangan, 1, true));
    });
  });

  test('streak boshlangan sana', () {
    expect(Statistika.streakBoshlangan({}, _bugun), isNull);
    expect(Statistika.streakBoshlangan({_oldin(3)}, _bugun), isNull);
    expect(Statistika.streakBoshlangan({_bugun, _oldin(1), _oldin(2), _oldin(4)}, _bugun), _oldin(2));
    // Bugun hali hisoblanmagan: streak kechagi kun bilan tugaydi.
    expect(Statistika.streakBoshlangan({_oldin(1), _oldin(2)}, _bugun), _oldin(2));
  });

  group('bosqichlar', () {
    test('rekord 0: 7 navbatdagi, qolgani keyingi', () {
      final b = Statistika.bosqichlar(rekord: 0, streak: 0);
      expect(b.map((x) => x.kun), [7, 14, 30, 60, 100, 365]);
      expect((b.first.holat, b.first.qoldi), (BosqichHolati.navbatdagi, 7));
      expect(b.skip(1).map((x) => x.holat), everyElement(BosqichHolati.keyingi));
    });

    test('rekord 12, streak 12: 7 yetilgan, 14 navbatdagi (2 kun qoldi)', () {
      final b = Statistika.bosqichlar(rekord: 12, streak: 12);
      expect(b.map((x) => x.holat).take(3),
          [BosqichHolati.yetilgan, BosqichHolati.navbatdagi, BosqichHolati.keyingi]);
      expect(b[1].qoldi, 2);
    });

    test('streak uzilsa ham yetilgan bosqich ✓ qoladi; qolgan kunlar joriy streakdan', () {
      final b = Statistika.bosqichlar(rekord: 21, streak: 3);
      expect(b.map((x) => x.holat).take(4), [
        BosqichHolati.yetilgan, // 7
        BosqichHolati.yetilgan, // 14
        BosqichHolati.navbatdagi, // 30: rekorddan katta eng kichik
        BosqichHolati.keyingi,
      ]);
      expect(b[2].qoldi, 27);
      expect(b[3].qoldi, 57);
    });

    test('rekord aynan 30: 30 yetilgan; 365 dan keyin hammasi yetilgan', () {
      expect(Statistika.bosqichlar(rekord: 30, streak: 30)[2].holat, BosqichHolati.yetilgan);
      expect(Statistika.bosqichlar(rekord: 30, streak: 30)[3].holat, BosqichHolati.navbatdagi);
      expect(Statistika.bosqichlar(rekord: 400, streak: 0).map((x) => x.holat),
          everyElement(BosqichHolati.yetilgan));
    });
  });

  test('odat maqsadi chegaralari: 29, 30, 99, 100', () {
    void tekshir(int streak, int maqsad, List<int> belgilar) {
      final o = Statistika.odatMaqsadi(streak);
      expect(o.maqsad, maqsad, reason: '$streak');
      expect(o.belgilar, belgilar, reason: '$streak');
    }

    tekshir(0, 30, [7, 14, 30]);
    tekshir(29, 30, [7, 14, 30]);
    tekshir(30, 100, [30, 60, 100]);
    tekshir(99, 100, [30, 60, 100]);
    tekshir(100, 365, [100, 200, 365]);
  });

  test('Kun.haftaKuni va farq', () {
    expect(_bugun.haftaKuni, 2);
    expect(const Kun(2026, 11, 15).haftaKuni, 7);
    expect(_bugun.farq(_oldin(10)), 10);
  });
}
