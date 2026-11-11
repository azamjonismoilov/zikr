/// Onboarding qoidalari va variantlari.
abstract final class Onboarding {
  /// Onboarding faqat birinchi ochilishda: sozlama yo'q va bazada sessiya yo'q.
  static bool korildimi({required String? sozlama, required bool sessiyaBor}) =>
      sozlama == '1' || sessiyaBor;

  /// Kunlik maqsad variantlari; "Oʻzim belgilayman" alohida.
  static const maqsadlar = [100, 300, 1000];
  static const standartMaqsad = 300;

  /// O'tkazib yuborilganda yoziladigan kunlik maqsad.
  static const otkazibMaqsad = 100;

  /// Eslatma variantlari, kun boshidan daqiqalar.
  static const ertalab = 6 * 60;
  static const kechqurun = 21 * 60;
}
