import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/onboarding/domain/onboarding.dart';

void main() {
  test('onboarding faqat sozlama yoʻq va sessiya yoʻq boʻlsa koʻrsatiladi', () {
    expect(Onboarding.korildimi(sozlama: null, sessiyaBor: false), isFalse);
    expect(Onboarding.korildimi(sozlama: '1', sessiyaBor: false), isTrue);
    expect(Onboarding.korildimi(sozlama: null, sessiyaBor: true), isTrue);
    expect(Onboarding.korildimi(sozlama: '1', sessiyaBor: true), isTrue);
  });

  test('variantlar va standart qiymatlar', () {
    expect(Onboarding.maqsadlar, [100, 300, 1000]);
    expect(Onboarding.maqsadlar, contains(Onboarding.standartMaqsad));
    expect(Onboarding.otkazibMaqsad, 100);
    expect(Onboarding.ertalab, 6 * 60);
    expect(Onboarding.kechqurun, 21 * 60);
  });
}
