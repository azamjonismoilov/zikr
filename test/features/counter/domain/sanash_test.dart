import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/domain/kun_qatori.dart';
import 'package:zikr/features/counter/domain/sanash.dart';

const _zikr = 1;
const _bugun = Kun(2026, 11, 10);

/// [n] marta bosadi va oxirgi qator hamda tugagan aylanalar sonini qaytaradi.
(KunQatori, int) _bosN(KunQatori? q, int n, int? maqsad, [Kun kun = _bugun]) {
  var tugadi = 0;
  for (var i = 0; i < n; i++) {
    final r = Sanash.bos(q, _zikr, maqsad, kun);
    q = r.qator;
    if (r.aylanaTugadi) tugadi++;
  }
  return (q!, tugadi);
}

void main() {
  group('bosish va aylana', () {
    test('har bosish son va jamini oshiradi', () {
      final r = Sanash.bos(null, _zikr, 33, _bugun);
      expect(r.qator, const KunQatori(zikrId: _zikr, sana: _bugun, son: 1, jami: 1));
      expect(r.aylanaTugadi, isFalse);
    });

    test('maqsadga yetganda son 0 ga qaytadi, aylana +1, hodisa chiqadi', () {
      final (q32, _) = _bosN(null, 32, 33);
      expect(q32.son, 32);

      final r = Sanash.bos(q32, _zikr, 33, _bugun);
      expect(r.aylanaTugadi, isTrue);
      expect(r.qator.son, 0);
      expect(r.qator.aylanalar, 1);
      expect(r.qator.jami, 33);
    });

    test('bir necha aylana ketma-ket', () {
      final (q, tugadi) = _bosN(null, 70, 33);
      expect(tugadi, 2);
      expect(q.aylanalar, 2);
      expect(q.son, 4);
      expect(q.jami, 70);
    });

    test('∞ maqsadda aylana bo\'lmaydi', () {
      final (q, tugadi) = _bosN(null, 500, null);
      expect(tugadi, 0);
      expect(q.son, 500);
      expect(q.jami, 500);
      expect(q.aylanalar, 0);
    });
  });

  group('nollash', () {
    test('faqat joriy aylanani o\'chiradi: jami -= son, son = 0', () {
      final (q, _) = _bosN(null, 40, 33); // 1 aylana + 7
      final n = Sanash.nolla(q, _zikr, _bugun);
      expect(n.son, 0);
      expect(n.jami, 33);
      expect(n.aylanalar, 1);
    });

    test('yarim tundan keyin: o\'tgan kun o\'zgarmaydi, bugungi jami manfiy bo\'lmaydi', () {
      final kecha = _bugun.oldingi;
      final (kechagi, _) = _bosN(null, 20, 33, kecha);
      final (bugungi, _) = _bosN(kechagi, 1, 33); // son 21 ko'chdi, jami 1
      expect(bugungi.son, 21);
      expect(bugungi.jami, 1);

      final n = Sanash.nolla(bugungi, _zikr, _bugun);
      expect(n.sana, _bugun);
      expect(n.son, 0);
      expect(n.jami, 0);
      expect(kechagi.jami, 20); // o'zgarmas obyekt — kechagi qator tegilmagan
    });

    test('oxirgi qator kechagi bo\'lsa, bugungi bo\'sh qator ochiladi', () {
      final (kechagi, _) = _bosN(null, 5, 33, _bugun.oldingi);
      final n = Sanash.nolla(kechagi, _zikr, _bugun);
      expect(n, const KunQatori(zikrId: _zikr, sana: _bugun));
    });
  });

  group('maqsadni almashtirish', () {
    test('son 0 bo\'lsa tasdiq kerak emas', () {
      expect(Sanash.maqsadUchunTasdiqKerak(null), isFalse);
      final (q, _) = _bosN(null, 33, 33); // aylana tugadi, son 0
      expect(Sanash.maqsadUchunTasdiqKerak(q), isFalse);
    });

    test('son > 0 bo\'lsa tasdiq kerak', () {
      final (q, _) = _bosN(null, 5, 33);
      expect(Sanash.maqsadUchunTasdiqKerak(q), isTrue);
    });

    test('yangi maqsad keyingi bosishlarda qo\'llanadi', () {
      final (q, _) = _bosN(null, 5, 33);
      final nol = Sanash.nolla(q, _zikr, _bugun);
      final (q99, tugadi) = _bosN(nol, 99, 99);
      expect(tugadi, 1);
      expect(q99.son, 0);
      expect(q99.aylanalar, 1);
    });
  });

  group('yarim tun', () {
    test('yangi kunda birinchi bosish yangi qator ochadi, son ko\'chadi', () {
      final kecha = _bugun.oldingi;
      final (kechagi, _) = _bosN(null, 40, 33, kecha); // 1 aylana, son 7, jami 40
      final r = Sanash.bos(kechagi, _zikr, 33, _bugun);

      expect(r.qator.sana, _bugun);
      expect(r.qator.son, 8);
      expect(r.qator.jami, 1);
      expect(r.qator.aylanalar, 0);
      expect(kechagi.sana, kecha);
      expect(kechagi.jami, 40);
    });

    test('ko\'chgan aylana yangi kunda tugaydi va bugunga yoziladi', () {
      final (kechagi, _) = _bosN(null, 30, 33, _bugun.oldingi);
      final (bugungi, tugadi) = _bosN(kechagi, 3, 33);
      expect(tugadi, 1);
      expect(bugungi.aylanalar, 1);
      expect(bugungi.jami, 3);
      expect(bugungi.son, 0);
    });

    test('ekranda: son ko\'chadi, bugungi aylanalar noldan', () {
      final (kechagi, _) = _bosN(null, 40, 33, _bugun.oldingi);
      expect(Sanash.joriySon(kechagi), 7);
      expect(Sanash.bugungiAylanalar(kechagi, _bugun), 0);
      expect(Sanash.bugungiAylanalar(kechagi, _bugun.oldingi), 1);
    });
  });
}
