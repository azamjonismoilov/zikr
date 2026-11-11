import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/domain/kun_qatori.dart';
import 'package:zikr/features/path/domain/toplam_sanash.dart';
import 'package:zikr/features/path/domain/yurish.dart';

const _bugun = Kun(2026, 11, 10);
const _qadamlar = [
  YolQadami(zikrId: 1, maqsad: 33),
  YolQadami(zikrId: 2, maqsad: 33),
  YolQadami(zikrId: 3, maqsad: 34),
];

/// Yurishni [n] marta bosadi; sessiya qatorlari zikr bo'yicha yig'iladi.
(Yurish, Map<int, KunQatori>, List<ToplamBosishNatijasi>) _bos(
  Yurish y,
  int n, {
  Map<int, KunQatori>? sessiyalar,
  Kun kun = _bugun,
}) {
  final s = {...?sessiyalar};
  final natijalar = <ToplamBosishNatijasi>[];
  for (var i = 0; i < n; i++) {
    final zikrId = _qadamlar[y.qadam].zikrId;
    final r = ToplamSanash.bos(y, _qadamlar, s[zikrId], kun);
    y = r.yurish;
    s[zikrId] = r.sessiya;
    natijalar.add(r);
  }
  return (y, s, natijalar);
}

void main() {
  final yangi = ToplamSanash.yangi(1, _bugun);

  test('bosish: yurish.son + 1, qadam zikrining jami + 1, alohida son o\'zgarmaydi', () {
    const alohida = KunQatori(zikrId: 1, sana: _bugun, son: 12, jami: 12);
    final r = ToplamSanash.bos(yangi, _qadamlar, alohida, _bugun);
    expect(r.yurish.son, 1);
    expect(r.yurish.qadam, 0);
    expect(r.sessiya.jami, 13);
    expect(r.sessiya.son, 12);
    expect(r.sessiya.aylanalar, 0);
    expect(r.qadamTugadi, isFalse);
  });

  test('qadam maqsadiga yetganda: aylana + 1, keyingi qadamga avtomatik o\'tadi', () {
    final (y, s, n) = _bos(yangi, 33);
    expect(n.last.qadamTugadi, isTrue);
    expect(n.last.toplamTugadi, isFalse);
    expect((y.qadam, y.son, y.tugadi), (1, 0, false));
    expect((s[1]!.jami, s[1]!.aylanalar, s[1]!.son), (33, 1, 0));
    expect(n.where((r) => r.qadamTugadi), hasLength(1));
  });

  test('qadam maqsadi to\'plamdan olinadi: 3-qadam 34 ta', () {
    final (y, _, _) = _bos(yangi, 66 + 33);
    expect((y.qadam, y.son), (2, 33));
    final (y2, _, n) = _bos(y, 1);
    expect(n.single.toplamTugadi, isTrue);
    expect(y2.tugadi, isTrue);
  });

  test('to\'plam tugashi: 100 bosishdan keyin yurish tugaydi, har zikrda 1 aylana', () {
    final (y, s, n) = _bos(yangi, 100);
    expect(y.tugadi, isTrue);
    expect(y.qadam, 3);
    expect(n.where((r) => r.qadamTugadi), hasLength(3));
    expect(n.where((r) => r.toplamTugadi), hasLength(1));
    expect(n.last.toplamTugadi, isTrue);
    expect([s[1]!.aylanalar, s[2]!.aylanalar, s[3]!.aylanalar], [1, 1, 1]);
    expect([s[1]!.jami, s[2]!.jami, s[3]!.jami], [33, 33, 34]);
  });

  test('o\'tkazib yuborish o\'rtada: keyingi qadam, son 0, aylana qo\'shilmaydi', () {
    final (y, _, _) = _bos(yangi, 10);
    final o = ToplamSanash.otkazibYubor(y, _qadamlar.length)!;
    expect((o.qadam, o.son, o.tugadi), (1, 0, false));
  });

  test('o\'tkazib yuborish oxirgi qadamda: yurish yopiladi (null)', () {
    final y = yangi.copyWith(qadam: 2, son: 5);
    expect(ToplamSanash.otkazibYubor(y, _qadamlar.length), isNull);
  });

  test('nollash: jami -= yurish.son, yurish.son = 0, alohida son va aylana o\'zgarmaydi', () {
    const alohida = KunQatori(zikrId: 1, sana: _bugun, son: 7, jami: 40, aylanalar: 1);
    final (y, s, _) = _bos(yangi, 12, sessiyalar: {1: alohida});
    expect(s[1]!.jami, 52);
    final (y2, s2) = ToplamSanash.nolla(y, 1, s[1], _bugun);
    expect(y2.son, 0);
    expect(y2.qadam, 0);
    expect((s2.jami, s2.son, s2.aylanalar), (40, 7, 1));
  });

  test('yarim tun: yurish uzilmaydi, bosishlar yangi kun qatoriga yoziladi', () {
    final kecha = _bugun.oldingi;
    final (y, s, _) = _bos(ToplamSanash.yangi(1, kecha), 20, kun: kecha);
    expect(s[1]!.sana, kecha);

    final (y2, s2, n) = _bos(y, 13, sessiyalar: s);
    expect(y2.sana, kecha); // boshlangan kun o'zgarmaydi
    expect((y2.qadam, y2.son), (1, 0));
    expect(n.last.qadamTugadi, isTrue);
    expect(s2[1]!.sana, _bugun);
    expect((s2[1]!.jami, s2[1]!.aylanalar), (13, 1));
    expect(s[1]!.jami, 20); // kechagi qator tegilmagan
  });

  test('nollash yarim tundan keyin bugungi jamini manfiy qilmaydi', () {
    final kecha = _bugun.oldingi;
    final (y, s, _) = _bos(ToplamSanash.yangi(1, kecha), 20, kun: kecha);
    final (y2, s2, _) = _bos(y, 1, sessiyalar: s);
    expect(y2.son, 21);
    final (y3, s3) = ToplamSanash.nolla(y2, 1, s2[1], _bugun);
    expect(y3.son, 0);
    expect(s3.jami, 0);
  });
}
