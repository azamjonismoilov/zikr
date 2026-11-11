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

  @override
  String get turkumNamozdanKeyin => 'Namozdan keyin';

  @override
  String get turkumKunDavomida => 'Kun davomida';

  @override
  String get turkumErtalabki => 'Ertalabki';

  @override
  String get turkumKechki => 'Kechki';

  @override
  String get turkumMening => 'Mening';

  @override
  String get izohNamozdanKeyin => 'Har farz namozidan soʻng';

  @override
  String get izohKunDavomida => 'Istalgan vaqtda';

  @override
  String get izohErtalabki => 'Ertalab';

  @override
  String get izohKechki => 'Kechqurun';

  @override
  String get izohMening => 'Oʻzingiz qoʻshgan';

  @override
  String bolimIzohi(String izoh, String soni) {
    return '$izoh · $soni ta zikr';
  }

  @override
  String kartaBajarildi(String maqsad) {
    return '$maqsad / $maqsad';
  }

  @override
  String kartaMarta(String maqsad) {
    return '$maqsad marta';
  }

  @override
  String get kartaCheksiz => 'Cheksiz';

  @override
  String kartaIzoh(String maqsad, String manosi) {
    return '$maqsad · $manosi';
  }

  @override
  String kartaProgress(String son, String maqsad) {
    return '$son/$maqsad';
  }

  @override
  String get bolimniYigish => 'Boʻlimni yigʻish';

  @override
  String get bolimniOchish => 'Boʻlimni ochish';

  @override
  String get qidirish => 'Qidirish';

  @override
  String get ozZikringizYoq => 'Oʻz zikringiz hali yoʻq';

  @override
  String get ozZikringizniQoshish => 'Oʻz zikringizni qoʻshish';

  @override
  String get zikrniTanlang => 'Zikrni tanlang';

  @override
  String get qidiruvMaslahat => 'Zikr nomi yoki maʼnosi';

  @override
  String get hammasi => 'Hammasi';

  @override
  String get hechNarsaTopilmadi => 'Hech narsa topilmadi';

  @override
  String get yangiZikr => 'Yangi zikr';

  @override
  String get zikrniTahrirlash => 'Zikrni tahrirlash';

  @override
  String get rasm => 'Rasm';

  @override
  String get talaffuzi => 'Talaffuzi';

  @override
  String get arabchaMatn => 'Arabcha matn (ixtiyoriy)';

  @override
  String get manosi => 'Maʼnosi';

  @override
  String get maqsad => 'Maqsad';

  @override
  String get ochirish => 'Oʻchirish';

  @override
  String get ochirishSarlavha => 'Zikrni oʻchirish';

  @override
  String get ochirishMatn =>
      'Zikr roʻyxatlardan olib tashlanadi. Statistikadagi hisob saqlanib qoladi.';

  @override
  String get chiqishSarlavha => 'Oʻzgarishlar saqlanmaydi';

  @override
  String get chiqishMatn => 'Yozganlaringiz oʻchib ketadi.';

  @override
  String get chiqish => 'Chiqish';

  @override
  String get tanlangan => 'Tanlangan';

  @override
  String get rasmTasbeh => 'Tasbeh';

  @override
  String get rasmYurak => 'Yurak';

  @override
  String get rasmYulduz => 'Yulduz';

  @override
  String get rasmNamoz => 'Masjid';

  @override
  String get rasmTun => 'Tun';

  @override
  String get rasmTong => 'Tong';

  @override
  String get rasmKitob => 'Kitob';

  @override
  String toplamTeg(String qadam, String jami) {
    return '$qadam / $jami';
  }

  @override
  String get tugatish => 'Tugatish';

  @override
  String tabrikNatija(String qiymat) {
    return '$qiymat / $qiymat';
  }

  @override
  String get tasbehotTugadi => 'Tasbehot tugadi';

  @override
  String get aylanaTugadi => 'Aylana tugadi';

  @override
  String bugunMarta(String n) {
    return 'Bugun $n-marta';
  }

  @override
  String tabrikIzoh(String nomi, String maqsad) {
    return '$nomi · $maqsad marta';
  }

  @override
  String dalda(String n) {
    return '$n kun ketma-ket. Davom eting!';
  }

  @override
  String get tayyor => 'Tayyor';

  @override
  String get davomEtish => 'Davom etish';

  @override
  String get yanaBirMarta => 'Yana bir marta';

  @override
  String get boshqaZikrTanlash => 'Boshqa zikr tanlash';

  @override
  String get boshlash => 'Boshlash';

  @override
  String yolHolati(String tugagan, String jami) {
    return '$tugagan / $jami';
  }

  @override
  String tasbehotZikr(String jami) {
    return 'Tasbehot · $jami zikr';
  }

  @override
  String tugunYorliq(String nomi, String maqsad) {
    return '$nomi · $maqsad';
  }

  @override
  String tugunJoriy(String nomi, String son, String maqsad) {
    return '$nomi · $son/$maqsad';
  }

  @override
  String get maslahatTasbehot =>
      'Namozdan soʻng 33 tasbeh, 33 tahmid va 34 takbir aytiladi.';

  @override
  String get tasbehotYolini => 'Tasbehot yoʻlini ochish';
}
