import 'package:flutter/material.dart';

/// Ilovaning rang tokenlari. Widget'lar ranglarni faqat shu yerdan oladi:
/// `context.colors.kok`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.fon,
    required this.fon2,
    required this.chiziq,
    required this.matn,
    required this.matn2,
    required this.matn3,
    required this.kok,
    required this.kokOch,
    required this.kokChuqur,
    required this.yashil,
    required this.yashilChuqur,
    required this.yashilOch,
    required this.yashilChiziq,
    required this.sariq,
    required this.olov,
    required this.olovOch,
    required this.olovChiziq,
    required this.qizil,
    required this.qizilSoya,
    required this.qizilTugma,
    required this.binafsha,
    required this.shisha,
    required this.shishaFaol,
    required this.shishaChiziq,
    required this.chuqurlik,
    required this.tugmaYuqori,
    required this.tugmaPast,
    required this.bortiq,
    required this.asosiyYuqori,
    required this.asosiyPast,
    required this.asosiySoya,
    required this.qoplama,
    required this.ijroYangiFon,
    required this.ijroYangiBelgi,
    required this.belgiOq,
    required this.tugunYashilYuqori,
    required this.tugunYashilPast,
    required this.tugunYashilSoya,
    required this.tugunKokYuqori,
    required this.tugunKokPast,
    required this.tugunKokSoya,
    required this.tugunYangiYuqori,
    required this.tugunYangiPast,
    required this.tugunYangiSoya,
    required this.tugunYangiChegara,
    required this.streakKartaYuqori,
    required this.streakKartaPast,
    required this.odatBoshi,
    required this.odatOxiri,
  });

  final Color fon;
  final Color fon2;
  final Color chiziq;
  final Color matn;
  final Color matn2;
  final Color matn3;
  final Color kok;
  final Color kokOch;
  final Color kokChuqur;
  final Color yashil;
  final Color yashilChuqur;
  final Color yashilOch;
  final Color yashilChiziq;
  final Color sariq;
  final Color olov;
  final Color olovOch;
  final Color olovChiziq;
  final Color qizil;

  /// To'ldirilgan qizil (xavfli) tugma foni, oq matn bilan.
  final Color qizilTugma;

  /// Xavfli (qizil) tugmaning bo'rtiq soyasi.
  final Color qizilSoya;
  final Color binafsha;
  final Color shisha;
  final Color shishaFaol;
  final Color shishaChiziq;

  /// Markaziy tugma ostidagi bo'rtiq chuqurlik.
  final Color chuqurlik;
  /// Markaziy tugma gradienti, yuqori.
  final Color tugmaYuqori;
  /// Markaziy tugma gradienti, past.
  final Color tugmaPast;
  /// Oq tugmalar ostidagi bo'rtiq soya.
  final Color bortiq;
  /// Asosiy tugma gradienti, yuqori.
  final Color asosiyYuqori;
  /// Asosiy tugma gradienti, past.
  final Color asosiyPast;
  /// Asosiy tugma ostidagi bo'rtiq soya.
  final Color asosiySoya;

  /// Panel va dialog ortidagi xiralik (yorug': matn 42%, tun: qora 55%).
  final Color qoplama;

  /// "Yangi" holatidagi ijro tugmasi foni.
  final Color ijroYangiFon;

  /// "Yangi" holatidagi ijro tugmasi belgisi.
  final Color ijroYangiBelgi;

  /// Rangli doiralar ustidagi oq belgi (ikkala rejimda oq).
  final Color belgiOq;

  /// Bajarilgan yo'l tuguni gradienti, yuqori.
  final Color tugunYashilYuqori;

  /// Bajarilgan yo'l tuguni gradienti, past.
  final Color tugunYashilPast;

  /// Bajarilgan yo'l tuguni bo'rtiq soyasi.
  final Color tugunYashilSoya;

  /// Joriy yo'l tuguni gradienti, yuqori.
  final Color tugunKokYuqori;

  /// Joriy yo'l tuguni gradienti, past.
  final Color tugunKokPast;

  /// Joriy yo'l tuguni bo'rtiq soyasi.
  final Color tugunKokSoya;

  /// Yangi yo'l tuguni gradienti, yuqori.
  final Color tugunYangiYuqori;

  /// Yangi yo'l tuguni gradienti, past.
  final Color tugunYangiPast;

  /// Yangi yo'l tuguni bo'rtiq soyasi.
  final Color tugunYangiSoya;

  /// Yangi yo'l tuguni chegarasi.
  final Color tugunYangiChegara;

  /// Statistikadagi ketma-ketlik kartasi gradienti, yuqori.
  final Color streakKartaYuqori;

  /// Statistikadagi ketma-ketlik kartasi gradienti, past.
  final Color streakKartaPast;

  /// Odat shkalasi gradienti, chap.
  final Color odatBoshi;

  /// Odat shkalasi gradienti, o'ng.
  final Color odatOxiri;

  static const yorug = AppColors(
    fon: Color(0xFFFFFFFF),
    fon2: Color(0xFFF4F9FE),
    chiziq: Color(0xFFE5EAF1),
    matn: Color(0xFF171A21),
    matn2: Color(0xFF5E6573),
    matn3: Color(0xFF9AA2AF),
    kok: Color(0xFF2E9BF2),
    kokOch: Color(0xFFE7F4FE),
    kokChuqur: Color(0xFF1B7FD0),
    yashil: Color(0xFF29C25A),
    yashilChuqur: Color(0xFF1E9E47),
    yashilOch: Color(0xFFEBF9EF),
    yashilChiziq: Color(0xFF9FE0B3),
    sariq: Color(0xFFFFC23D),
    olov: Color(0xFFFF8A1F),
    olovOch: Color(0xFFFFF2E6),
    olovChiziq: Color(0xFFFFCFA3),
    qizil: Color(0xFFD32F46),
    qizilSoya: Color(0xFFA3243A),
    qizilTugma: Color(0xFFD32F46),
    binafsha: Color(0xFF8E63FF),
    shisha: Color(0xB8FFFFFF), // #FFFFFF 72%
    shishaFaol: Color(0x0F000000), // #000000 6%
    shishaChiziq: Color(0xE6FFFFFF), // #FFFFFF 90%
    chuqurlik: Color(0xFFD5E3F1),
    tugmaYuqori: Color(0xFFFFFFFF),
    tugmaPast: Color(0xFFF1F7FD),
    bortiq: Color(0xFFE5EAF1),
    asosiyYuqori: Color(0xFF62BDFF),
    asosiyPast: Color(0xFF2E9BF2),
    asosiySoya: Color(0xFF1B7FD0),
    qoplama: Color(0x6B171A21),
    ijroYangiFon: Color(0xFFEEF2F6),
    ijroYangiBelgi: Color(0xFFA3ACB8),
    belgiOq: Color(0xFFFFFFFF),
    tugunYashilYuqori: Color(0xFF5FD98A),
    tugunYashilPast: Color(0xFF2BC25C),
    tugunYashilSoya: Color(0xFF1E9E47),
    tugunKokYuqori: Color(0xFF6CC2FF),
    tugunKokPast: Color(0xFF2E9BF2),
    tugunKokSoya: Color(0xFF1B7FD0),
    tugunYangiYuqori: Color(0xFFFFFFFF),
    tugunYangiPast: Color(0xFFEEF2F6),
    tugunYangiSoya: Color(0xFFD3DBE4),
    tugunYangiChegara: Color(0xFFD3DBE4),
    streakKartaYuqori: Color(0xFFDDF0FF),
    streakKartaPast: Color(0xFFFFFFFF),
    odatBoshi: Color(0xFFFFB23F),
    odatOxiri: Color(0xFFFF7A1F),
  );

  static const tun = AppColors(
    fon: Color(0xFF0F1726),
    fon2: Color(0xFF142033),
    chiziq: Color(0xFF233149),
    matn: Color(0xFFEEF3FA),
    matn2: Color(0xFFA3B0C2),
    matn3: Color(0xFF6B7A90),
    kok: Color(0xFF4AAEF7),
    kokOch: Color(0xFF16304D),
    kokChuqur: Color(0xFF7CC4FF),
    yashil: Color(0xFF34C76A),
    yashilChuqur: Color(0xFF5FD98A),
    yashilOch: Color(0xFF12301F),
    yashilChiziq: Color(0xFF2C6B43),
    sariq: Color(0xFFFFC23D),
    olov: Color(0xFFFF9A3D),
    olovOch: Color(0xFF2B1E14),
    olovChiziq: Color(0xFF5A3A1E),
    qizil: Color(0xFFFF6B7C),
    qizilSoya: Color(0xFFA3243A),
    qizilTugma: Color(0xFFD32F46),
    binafsha: Color(0xFFA68AFF),
    shisha: Color(0xB81A2438), // #1A2438 72%
    shishaFaol: Color(0x1AFFFFFF), // #FFFFFF 10%
    shishaChiziq: Color(0x14FFFFFF), // #FFFFFF 8%
    chuqurlik: Color(0xFF16304D),
    tugmaYuqori: Color(0xFF1B2A44),
    tugmaPast: Color(0xFF142033),
    bortiq: Color(0xFF0A1220),
    asosiyYuqori: Color(0xFF62BDFF),
    asosiyPast: Color(0xFF2E9BF2),
    asosiySoya: Color(0xFF14548C),
    qoplama: Color(0x8C000000),
    ijroYangiFon: Color(0xFF24334C),
    ijroYangiBelgi: Color(0xFF8796AD),
    belgiOq: Color(0xFFFFFFFF),
    tugunYashilYuqori: Color(0xFF5FD98A),
    tugunYashilPast: Color(0xFF2BC25C),
    tugunYashilSoya: Color(0xFF1E9E47),
    tugunKokYuqori: Color(0xFF6CC2FF),
    tugunKokPast: Color(0xFF2E9BF2),
    tugunKokSoya: Color(0xFF1B7FD0),
    tugunYangiYuqori: Color(0xFF26385A),
    tugunYangiPast: Color(0xFF1B2A44),
    tugunYangiSoya: Color(0xFF0A1220),
    tugunYangiChegara: Color(0xFF2E4066),
    streakKartaYuqori: Color(0xFF16304D),
    streakKartaPast: Color(0xFF151F31),
    odatBoshi: Color(0xFFFFB23F),
    odatOxiri: Color(0xFFFF7A1F),
  );

  /// Barcha tokenlar nomi bilan, `CLAUDE.md` jadvali tartibida.
  Map<String, Color> get tokens => {
        'fon': fon,
        'fon2': fon2,
        'chiziq': chiziq,
        'matn': matn,
        'matn2': matn2,
        'matn3': matn3,
        'kok': kok,
        'kokOch': kokOch,
        'kokChuqur': kokChuqur,
        'yashil': yashil,
        'yashilChuqur': yashilChuqur,
        'yashilOch': yashilOch,
        'yashilChiziq': yashilChiziq,
        'sariq': sariq,
        'olov': olov,
        'olovOch': olovOch,
        'olovChiziq': olovChiziq,
        'qizil': qizil,
        'qizilSoya': qizilSoya,
        'qizilTugma': qizilTugma,
        'binafsha': binafsha,
        'shisha': shisha,
        'shishaFaol': shishaFaol,
        'shishaChiziq': shishaChiziq,
        'chuqurlik': chuqurlik,
        'tugmaYuqori': tugmaYuqori,
        'tugmaPast': tugmaPast,
        'bortiq': bortiq,
        'asosiyYuqori': asosiyYuqori,
        'asosiyPast': asosiyPast,
        'asosiySoya': asosiySoya,
        'qoplama': qoplama,
        'ijroYangiFon': ijroYangiFon,
        'ijroYangiBelgi': ijroYangiBelgi,
        'belgiOq': belgiOq,
        'tugunYashilYuqori': tugunYashilYuqori,
        'tugunYashilPast': tugunYashilPast,
        'tugunYashilSoya': tugunYashilSoya,
        'tugunKokYuqori': tugunKokYuqori,
        'tugunKokPast': tugunKokPast,
        'tugunKokSoya': tugunKokSoya,
        'tugunYangiYuqori': tugunYangiYuqori,
        'tugunYangiPast': tugunYangiPast,
        'tugunYangiSoya': tugunYangiSoya,
        'tugunYangiChegara': tugunYangiChegara,
        'streakKartaYuqori': streakKartaYuqori,
        'streakKartaPast': streakKartaPast,
        'odatBoshi': odatBoshi,
        'odatOxiri': odatOxiri,
      };

  @override
  AppColors copyWith({
    Color? fon,
    Color? fon2,
    Color? chiziq,
    Color? matn,
    Color? matn2,
    Color? matn3,
    Color? kok,
    Color? kokOch,
    Color? kokChuqur,
    Color? yashil,
    Color? yashilChuqur,
    Color? yashilOch,
    Color? yashilChiziq,
    Color? sariq,
    Color? olov,
    Color? olovOch,
    Color? olovChiziq,
    Color? qizil,
    Color? qizilSoya,
    Color? qizilTugma,
    Color? binafsha,
    Color? shisha,
    Color? shishaFaol,
    Color? shishaChiziq,
    Color? chuqurlik,
    Color? tugmaYuqori,
    Color? tugmaPast,
    Color? bortiq,
    Color? asosiyYuqori,
    Color? asosiyPast,
    Color? asosiySoya,
    Color? qoplama,
    Color? ijroYangiFon,
    Color? ijroYangiBelgi,
    Color? belgiOq,
    Color? tugunYashilYuqori,
    Color? tugunYashilPast,
    Color? tugunYashilSoya,
    Color? tugunKokYuqori,
    Color? tugunKokPast,
    Color? tugunKokSoya,
    Color? tugunYangiYuqori,
    Color? tugunYangiPast,
    Color? tugunYangiSoya,
    Color? tugunYangiChegara,
    Color? streakKartaYuqori,
    Color? streakKartaPast,
    Color? odatBoshi,
    Color? odatOxiri,
  }) {
    return AppColors(
      fon: fon ?? this.fon,
      fon2: fon2 ?? this.fon2,
      chiziq: chiziq ?? this.chiziq,
      matn: matn ?? this.matn,
      matn2: matn2 ?? this.matn2,
      matn3: matn3 ?? this.matn3,
      kok: kok ?? this.kok,
      kokOch: kokOch ?? this.kokOch,
      kokChuqur: kokChuqur ?? this.kokChuqur,
      yashil: yashil ?? this.yashil,
      yashilChuqur: yashilChuqur ?? this.yashilChuqur,
      yashilOch: yashilOch ?? this.yashilOch,
      yashilChiziq: yashilChiziq ?? this.yashilChiziq,
      sariq: sariq ?? this.sariq,
      olov: olov ?? this.olov,
      olovOch: olovOch ?? this.olovOch,
      olovChiziq: olovChiziq ?? this.olovChiziq,
      qizil: qizil ?? this.qizil,
      qizilSoya: qizilSoya ?? this.qizilSoya,
      qizilTugma: qizilTugma ?? this.qizilTugma,
      binafsha: binafsha ?? this.binafsha,
      shisha: shisha ?? this.shisha,
      shishaFaol: shishaFaol ?? this.shishaFaol,
      shishaChiziq: shishaChiziq ?? this.shishaChiziq,
      chuqurlik: chuqurlik ?? this.chuqurlik,
      tugmaYuqori: tugmaYuqori ?? this.tugmaYuqori,
      tugmaPast: tugmaPast ?? this.tugmaPast,
      bortiq: bortiq ?? this.bortiq,
      asosiyYuqori: asosiyYuqori ?? this.asosiyYuqori,
      asosiyPast: asosiyPast ?? this.asosiyPast,
      asosiySoya: asosiySoya ?? this.asosiySoya,
      qoplama: qoplama ?? this.qoplama,
      ijroYangiFon: ijroYangiFon ?? this.ijroYangiFon,
      ijroYangiBelgi: ijroYangiBelgi ?? this.ijroYangiBelgi,
      belgiOq: belgiOq ?? this.belgiOq,
      tugunYashilYuqori: tugunYashilYuqori ?? this.tugunYashilYuqori,
      tugunYashilPast: tugunYashilPast ?? this.tugunYashilPast,
      tugunYashilSoya: tugunYashilSoya ?? this.tugunYashilSoya,
      tugunKokYuqori: tugunKokYuqori ?? this.tugunKokYuqori,
      tugunKokPast: tugunKokPast ?? this.tugunKokPast,
      tugunKokSoya: tugunKokSoya ?? this.tugunKokSoya,
      tugunYangiYuqori: tugunYangiYuqori ?? this.tugunYangiYuqori,
      tugunYangiPast: tugunYangiPast ?? this.tugunYangiPast,
      tugunYangiSoya: tugunYangiSoya ?? this.tugunYangiSoya,
      tugunYangiChegara: tugunYangiChegara ?? this.tugunYangiChegara,
      streakKartaYuqori: streakKartaYuqori ?? this.streakKartaYuqori,
      streakKartaPast: streakKartaPast ?? this.streakKartaPast,
      odatBoshi: odatBoshi ?? this.odatBoshi,
      odatOxiri: odatOxiri ?? this.odatOxiri,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      fon: l(fon, other.fon),
      fon2: l(fon2, other.fon2),
      chiziq: l(chiziq, other.chiziq),
      matn: l(matn, other.matn),
      matn2: l(matn2, other.matn2),
      matn3: l(matn3, other.matn3),
      kok: l(kok, other.kok),
      kokOch: l(kokOch, other.kokOch),
      kokChuqur: l(kokChuqur, other.kokChuqur),
      yashil: l(yashil, other.yashil),
      yashilChuqur: l(yashilChuqur, other.yashilChuqur),
      yashilOch: l(yashilOch, other.yashilOch),
      yashilChiziq: l(yashilChiziq, other.yashilChiziq),
      sariq: l(sariq, other.sariq),
      olov: l(olov, other.olov),
      olovOch: l(olovOch, other.olovOch),
      olovChiziq: l(olovChiziq, other.olovChiziq),
      qizil: l(qizil, other.qizil),
      qizilSoya: l(qizilSoya, other.qizilSoya),
      qizilTugma: l(qizilTugma, other.qizilTugma),
      binafsha: l(binafsha, other.binafsha),
      shisha: l(shisha, other.shisha),
      shishaFaol: l(shishaFaol, other.shishaFaol),
      shishaChiziq: l(shishaChiziq, other.shishaChiziq),
      chuqurlik: l(chuqurlik, other.chuqurlik),
      tugmaYuqori: l(tugmaYuqori, other.tugmaYuqori),
      tugmaPast: l(tugmaPast, other.tugmaPast),
      bortiq: l(bortiq, other.bortiq),
      asosiyYuqori: l(asosiyYuqori, other.asosiyYuqori),
      asosiyPast: l(asosiyPast, other.asosiyPast),
      asosiySoya: l(asosiySoya, other.asosiySoya),
      qoplama: l(qoplama, other.qoplama),
      ijroYangiFon: l(ijroYangiFon, other.ijroYangiFon),
      ijroYangiBelgi: l(ijroYangiBelgi, other.ijroYangiBelgi),
      belgiOq: l(belgiOq, other.belgiOq),
      tugunYashilYuqori: l(tugunYashilYuqori, other.tugunYashilYuqori),
      tugunYashilPast: l(tugunYashilPast, other.tugunYashilPast),
      tugunYashilSoya: l(tugunYashilSoya, other.tugunYashilSoya),
      tugunKokYuqori: l(tugunKokYuqori, other.tugunKokYuqori),
      tugunKokPast: l(tugunKokPast, other.tugunKokPast),
      tugunKokSoya: l(tugunKokSoya, other.tugunKokSoya),
      tugunYangiYuqori: l(tugunYangiYuqori, other.tugunYangiYuqori),
      tugunYangiPast: l(tugunYangiPast, other.tugunYangiPast),
      tugunYangiSoya: l(tugunYangiSoya, other.tugunYangiSoya),
      tugunYangiChegara: l(tugunYangiChegara, other.tugunYangiChegara),
      streakKartaYuqori: l(streakKartaYuqori, other.streakKartaYuqori),
      streakKartaPast: l(streakKartaPast, other.streakKartaPast),
      odatBoshi: l(odatBoshi, other.odatBoshi),
      odatOxiri: l(odatOxiri, other.odatOxiri),
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
