import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/counter/domain/kun.dart';

void main() {
  test('mahalliy vaqtdagi yarim tun kun chegarasi', () {
    expect(Kun.dan(DateTime(2026, 11, 10, 23, 59, 59)), const Kun(2026, 11, 10));
    expect(Kun.dan(DateTime(2026, 11, 11, 0, 0, 0)), const Kun(2026, 11, 11));
  });

  test('kalit va parse bir-birini qaytaradi', () {
    const k = Kun(2026, 3, 7);
    expect(k.kalit, '2026-03-07');
    expect(Kun.parse(k.kalit), k);
  });

  test('oldingi va keyingi oy/yil chegarasida', () {
    expect(const Kun(2026, 3, 1).oldingi, const Kun(2026, 2, 28));
    expect(const Kun(2028, 3, 1).oldingi, const Kun(2028, 2, 29));
    expect(const Kun(2026, 12, 31).keyingi, const Kun(2027, 1, 1));
  });
}
