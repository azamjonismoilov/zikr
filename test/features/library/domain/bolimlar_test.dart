import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/library/domain/bolimlar.dart';

typedef _Z = ({String nom, String turkum, bool oz});

List<Bolim<_Z>> _ajrat(List<_Z> z) => bolimlarga(z, turkum: (x) => x.turkum, ozZikri: (x) => x.oz);

void main() {
  test('faqat ichida zikri bor turkumlar, standart tartibda; "Mening" har doim oxirida', () {
    final b = _ajrat([
      (nom: 'a', turkum: 'kun_davomida', oz: false),
      (nom: 'b', turkum: 'namozdan_keyin', oz: false),
      (nom: 'c', turkum: 'kun_davomida', oz: false),
    ]);
    expect(b.map((x) => x.kalit), ['namozdan_keyin', 'kun_davomida', meningBolimi]);
    expect(b[1].zikrlar.map((z) => z.nom), ['a', 'c']);
    expect(b.last.zikrlar, isEmpty);
  });

  test('o\'z zikrlari turkumidan qat\'i nazar "Mening" da', () {
    final b = _ajrat([
      (nom: 'a', turkum: 'namozdan_keyin', oz: false),
      (nom: 'oz', turkum: 'namozdan_keyin', oz: true),
    ]);
    expect(b.first.zikrlar.map((z) => z.nom), ['a']);
    expect(b.last.kalit, meningBolimi);
    expect(b.last.zikrlar.map((z) => z.nom), ['oz']);
  });

  test('noma\'lum turkum standartlardan keyin, "Mening" dan oldin', () {
    final b = _ajrat([
      (nom: 'x', turkum: 'boshqa', oz: false),
      (nom: 'y', turkum: 'kechki', oz: false),
    ]);
    expect(b.map((x) => x.kalit), ['kechki', 'boshqa', meningBolimi]);
  });
}
