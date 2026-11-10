// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get ilovaNomi => 'Zikr';

  @override
  String get tabSanagich => 'Sanagich';

  @override
  String get tabZikrlar => 'Zikrlar';

  @override
  String get tabStatistika => 'Statistika';

  @override
  String get tabSozlamalar => 'Sozlamalar';

  @override
  String get sarlavhaZikrlar => 'Zikrlar';

  @override
  String get sarlavhaStatistika => 'Statistika';

  @override
  String get sarlavhaSozlamalar => 'Sozlamalar';

  @override
  String aylanaTeg(String raqam) {
    return '$raqam-aylana';
  }

  @override
  String maqsadKasr(String maqsad) {
    return '/ $maqsad';
  }

  @override
  String get sanashIshora => 'Ekranning istalgan joyini bosing';

  @override
  String get maqsadCheksiz => '∞';

  @override
  String get maqsadMaxsus => 'Maxsus';

  @override
  String keyingisi(String nomi) {
    return 'Keyingisi: $nomi';
  }

  @override
  String get bekorQilish => 'Bekor qilish';

  @override
  String get maqsadTasdiqSarlavha => 'Maqsadni almashtirish';

  @override
  String get maqsadTasdiqMatn => 'Joriy aylana nollanadi';

  @override
  String get maqsadTasdiqTugma => 'Almashtirish';

  @override
  String get nollashSarlavha => 'Aylanani nollash';

  @override
  String nollashMatn(String son) {
    return 'Joriy aylanadagi $son ta bosish oʻchiriladi. Tugagan aylanalar saqlanib qoladi.';
  }

  @override
  String get nollashTugma => 'Nollash';

  @override
  String get maxsusSarlavha => 'Maxsus maqsad';

  @override
  String get maxsusYorliq => 'Bir aylanadagi son';

  @override
  String maxsusXato(String eng_kop) {
    return '1 dan $eng_kop gacha son kiriting';
  }

  @override
  String get saqlash => 'Saqlash';

  @override
  String get yopish => 'Yopish';

  @override
  String streakIzoh(String kun) {
    return 'Ketma-ket kunlar: $kun';
  }

  @override
  String aylanalarIzoh(String soni) {
    return 'Bugun tugagan aylanalar: $soni';
  }

  @override
  String get haptikYoqilgan => 'Tebranish yoqilgan';

  @override
  String get haptikOchirilgan => 'Tebranish oʻchirilgan';

  @override
  String get nollashIzoh => 'Joriy aylanani nollash';

  @override
  String sanashIzoh(String son) {
    return 'Sanash, joriy son $son';
  }
}
