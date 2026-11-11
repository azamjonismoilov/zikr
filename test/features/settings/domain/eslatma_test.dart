import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/settings/domain/eslatma.dart';

final _hozir = DateTime(2026, 11, 10, 9, 30);

EslatmaRejasi? _reja({bool yoniq = true, int daqiqa = 21 * 60, DateTime? hozir, bool hisoblangan = false, int streak = 0}) =>
    Eslatma.rejala(
      yoniq: yoniq,
      daqiqa: daqiqa,
      hozir: hozir ?? _hozir,
      bugunHisoblangan: hisoblangan,
      streak: streak,
    );

void main() {
  test('o\'chiq bo\'lsa reja yo\'q', () {
    expect(_reja(yoniq: false), isNull);
  });

  test('vaqt hali kelmagan va kun hisoblanmagan — bugun', () {
    expect(_reja()!.birinchi, DateTime(2026, 11, 10, 21));
  });

  test('vaqt o\'tib ketgan — ertaga', () {
    expect(_reja(daqiqa: 5 * 60 + 30)!.birinchi, DateTime(2026, 11, 11, 5, 30));
    expect(_reja(daqiqa: 9 * 60 + 30)!.birinchi, DateTime(2026, 11, 11, 9, 30)); // aynan hozir
  });

  test('bugun kun allaqachon hisoblangan — bugungisi yo\'q, ertadan', () {
    expect(_reja(hisoblangan: true)!.birinchi, DateTime(2026, 11, 11, 21));
  });

  test('30 kun oldinga, har kunga bitta; bugun hisoblangan bo\'lsa ertadan', () {
    final r = _reja(hisoblangan: true)!;
    expect(r.vaqtlar, hasLength(Eslatma.kunlarSoni));
    expect(r.vaqtlar.first, DateTime(2026, 11, 11, 21));
    expect(r.vaqtlar.last, DateTime(2026, 12, 10, 21));
    expect(_reja()!.vaqtlar.first, DateTime(2026, 11, 10, 21));
  });

  test('oy oxirida ertangi kun to\'g\'ri hisoblanadi', () {
    expect(_reja(hozir: DateTime(2026, 11, 30, 22), daqiqa: 21 * 60)!.birinchi, DateTime(2026, 12, 1, 21));
  });

  test('matn tanlovi: streak 1 dan katta bo\'lsa streak, aks holda oddiy', () {
    expect(_reja(streak: 0)!.streak, isNull);
    expect(_reja(streak: 1)!.streak, isNull);
    expect(_reja(streak: 2)!.streak, 2);
    expect(_reja(streak: 12)!.streak, 12);
  });

  test('vaqt matni', () {
    expect(Eslatma.daqiqaga('21:00'), 1260);
    expect(Eslatma.daqiqaga('05:30'), 330);
    expect(Eslatma.daqiqaga('24:00'), isNull);
    expect(Eslatma.daqiqaga('abc'), isNull);
    expect(Eslatma.matnga(330), '05:30');
    expect(Eslatma.matnga(Eslatma.standartDaqiqa), '21:00');
  });
}
