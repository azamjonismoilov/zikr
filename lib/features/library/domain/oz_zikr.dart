/// O'z zikri formasi qiymatlari va cheklovlari.
class OzZikr {
  const OzZikr({
    required this.nomi,
    this.arabcha = '',
    this.manosi = '',
    this.rasm = standartRasm,
    this.maqsad = 33,
  });

  static const nomiEngKop = 40;
  static const manosiEngKop = 80;
  static const standartRasm = 'yurak';

  /// Tanlash mumkin bo'lgan rasmlar, Figma tartibida.
  static const rasmlar = ['tasbeh', 'yurak', 'yulduz', 'namoz', 'tun', 'tong', 'kitob'];

  /// Talaffuzi (`zikr.nomi` ga yoziladi).
  final String nomi;
  final String arabcha;
  final String manosi;
  final String rasm;

  /// `null` — cheksiz.
  final int? maqsad;

  /// Saqlash mumkinmi: talaffuz 1–40 belgi, ma'no 80 belgigacha.
  bool get togri {
    final n = nomi.trim().length;
    return n >= 1 && n <= nomiEngKop && manosi.trim().length <= manosiEngKop;
  }
}
