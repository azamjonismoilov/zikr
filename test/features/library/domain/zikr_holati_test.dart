import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';
import 'package:zikr/features/counter/domain/kun_qatori.dart';
import 'package:zikr/features/library/domain/zikr_holati.dart';

const _bugun = Kun(2026, 11, 10);

KunQatori _q({Kun sana = _bugun, int son = 0, int aylanalar = 0}) =>
    KunQatori(zikrId: 1, sana: sana, son: son, jami: son, aylanalar: aylanalar);

void main() {
  test('hech bosilmagan zikr — yangi', () {
    expect(ZikrHolatHisobi.hisobla(null, 33, _bugun).holat, ZikrHolati.yangi);
    expect(ZikrHolatHisobi.hisobla(_q(), 33, _bugun).holat, ZikrHolati.yangi);
  });

  test('bugun aylana tugagan — bajarildi (yangi aylana boshlangan bo\'lsa ham)', () {
    expect(ZikrHolatHisobi.hisobla(_q(aylanalar: 1), 33, _bugun).holat, ZikrHolati.bajarildi);
    expect(ZikrHolatHisobi.hisobla(_q(aylanalar: 1, son: 5), 33, _bugun).holat, ZikrHolati.bajarildi);
  });

  test('son > 0, aylana yo\'q — jarayonda, progress son/maqsad', () {
    final m = ZikrHolatHisobi.hisobla(_q(son: 12), 34, _bugun);
    expect(m.holat, ZikrHolati.jarayonda);
    expect(m.son, 12);
    expect(m.progress, closeTo(12 / 34, 1e-9));
  });

  test('∞ maqsad: jarayonda, progress chizig\'i yo\'q', () {
    final m = ZikrHolatHisobi.hisobla(_q(son: 250), null, _bugun);
    expect(m.holat, ZikrHolati.jarayonda);
    expect(m.son, 250);
    expect(m.progress, isNull);
  });

  test('kechagi aylana bugun hisoblanmaydi; ko\'chgan son jarayonda', () {
    final kecha = _bugun.oldingi;
    expect(ZikrHolatHisobi.hisobla(_q(sana: kecha, aylanalar: 3), 33, _bugun).holat, ZikrHolati.yangi);
    expect(ZikrHolatHisobi.hisobla(_q(sana: kecha, son: 7), 33, _bugun).holat, ZikrHolati.jarayonda);
  });
}
