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
  String sanashElon(String nomi, String son, String maqsad) {
    return '$nomi, $son / $maqsad';
  }

  @override
  String sanashElonCheksiz(String nomi, String son) {
    return '$nomi, $son';
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

  @override
  String davrKun(String n) {
    return '$n kun';
  }

  @override
  String get davrSarlavha => 'Davr';

  @override
  String streakKun(String n) {
    return '$n kun';
  }

  @override
  String get streakBoshlang => 'Bugun birinchi kunni boshlang';

  @override
  String get streakBugunHali => 'Bugun hali zikr qilmadingiz';

  @override
  String get streakDavom => 'kun ketma-ket zikr qildingiz';

  @override
  String get jamiZikr => 'Jami zikr';

  @override
  String get aylana => 'Aylana';

  @override
  String get bugun => 'Bugun';

  @override
  String mingQisqa(String son) {
    return '$son ming';
  }

  @override
  String get engKopAytilgan => 'Eng koʻp aytilgan';

  @override
  String get davrdaBosh => 'Bu davrda hali zikr qilinmagan';

  @override
  String oxirgiKun(String n) {
    return 'Oxirgi $n kun';
  }

  @override
  String davrJami(String son) {
    return '$son zikr';
  }

  @override
  String get haftaDu => 'Du';

  @override
  String get haftaSe => 'Se';

  @override
  String get haftaCh => 'Ch';

  @override
  String get haftaPa => 'Pa';

  @override
  String get haftaJu => 'Ju';

  @override
  String get haftaSh => 'Sh';

  @override
  String get haftaYa => 'Ya';

  @override
  String get ketmaKetlik => 'Ketma-ketlik';

  @override
  String get kunKetmaKet => 'kun ketma-ket';

  @override
  String odatSarlavha(String maqsad) {
    return '$maqsad kunlik odat';
  }

  @override
  String odatHolat(String streak, String maqsad) {
    return '$streak / $maqsad kun';
  }

  @override
  String get boshlangan => 'Boshlangan';

  @override
  String get engUzun => 'Eng uzun';

  @override
  String get sanaYoq => '—';

  @override
  String sanaKunOy(String kun, String oy) {
    return '$kun-$oy';
  }

  @override
  String get oy1 => 'yanvar';

  @override
  String get oy2 => 'fevral';

  @override
  String get oy3 => 'mart';

  @override
  String get oy4 => 'aprel';

  @override
  String get oy5 => 'may';

  @override
  String get oy6 => 'iyun';

  @override
  String get oy7 => 'iyul';

  @override
  String get oy8 => 'avgust';

  @override
  String get oy9 => 'sentabr';

  @override
  String get oy10 => 'oktabr';

  @override
  String get oy11 => 'noyabr';

  @override
  String get oy12 => 'dekabr';

  @override
  String get bosqichlar => 'Bosqichlar';

  @override
  String bosqichNomi(String n, String nomi) {
    return '$n kun · $nomi';
  }

  @override
  String bosqichQoldi(String n, String k) {
    return '$n kun · yana $k kun qoldi';
  }

  @override
  String get bosqich7 => 'bir hafta';

  @override
  String get bosqich14 => 'ikki hafta';

  @override
  String get bosqich30 => 'bir oy';

  @override
  String get bosqich60 => 'ikki oy';

  @override
  String get bosqich100 => 'yuz kun';

  @override
  String get bosqich365 => 'bir yil';

  @override
  String get eslatmaSarlavha => 'Zikr vaqti';

  @override
  String eslatmaStreak(String n) {
    return '$n kunlik ketma-ketlikni davom ettiring';
  }

  @override
  String get eslatmaOddiy => 'Bugungi zikringizni unutmang';

  @override
  String get guruhSanash => 'SANASH';

  @override
  String get guruhIlova => 'ILOVA';

  @override
  String get guruhMalumotlar => 'MAʼLUMOTLAR';

  @override
  String get sozTebranish => 'Tebranish';

  @override
  String get sozTovush => 'Bosish tovushi';

  @override
  String get sozOvozTugmasi => 'Ovoz tugmalari bilan sanash';

  @override
  String get sozEkranYoniq => 'Ekran oʻchmasin';

  @override
  String get sozKunlikMaqsad => 'Kunlik maqsad';

  @override
  String get sozMavzu => 'Mavzu';

  @override
  String get sozEslatma => 'Kunlik eslatma';

  @override
  String get sozZaxiraOlish => 'Zaxira nusxa olish';

  @override
  String get sozZaxiradanTiklash => 'Zaxiradan tiklash';

  @override
  String get sozNollash => 'Hisobni nollash';

  @override
  String get mavzuTizim => 'Tizim';

  @override
  String get mavzuYorug => 'Yorugʻ';

  @override
  String get mavzuTun => 'Tun';

  @override
  String get ochiq => 'Oʻchiq';

  @override
  String get maxfiylik =>
      'Maʼlumotlar faqat qurilmangizda. Akkaunt va reklama yoʻq.';

  @override
  String ilovaVersiyasi(String versiya) {
    return 'Zikr $versiya';
  }

  @override
  String get kunlikMaqsadYorliq => 'Kunlik bosishlar soni';

  @override
  String get eslatmaVaqti => 'Vaqt';

  @override
  String get ruxsatYoq => 'Bildirishnomaga ruxsat berilmagan';

  @override
  String get sozlamalarniOchish => 'Sozlamalarni ochish';

  @override
  String get tiklashSarlavha => 'Zaxiradan tiklash';

  @override
  String get tiklashMatn => 'Hozirgi maʼlumot zaxiradagi bilan almashtiriladi.';

  @override
  String get tiklash => 'Tiklash';

  @override
  String get tiklandi => 'Maʼlumot zaxiradan tiklandi.';

  @override
  String get zaxiraNotogri =>
      'Bu fayl Zikr zaxirasi emas. Ulashilgan .json faylni tanlang.';

  @override
  String get zaxiraYangi =>
      'Bu zaxira ilovaning yangiroq versiyasida olingan. Ilovani yangilang.';

  @override
  String get zaxiraBuzuq => 'Zaxira fayli buzilgan. Maʼlumot oʻzgarmadi.';

  @override
  String get zaxiraXatoSarlavha => 'Tiklab boʻlmadi';

  @override
  String get yaxshi => 'Yaxshi';

  @override
  String get nollashBirSarlavha => 'Hisobni nollash';

  @override
  String get nollashBirMatn =>
      'Barcha sessiyalar va tasbehot yoʻllari oʻchadi. Zikrlar va sozlamalar qoladi.';

  @override
  String get avvalZaxira => 'Avval zaxira olish';

  @override
  String get davomEtishTugma => 'Davom etish';

  @override
  String get nollashIkkiSarlavha => 'Rostdan nollaysizmi?';

  @override
  String get nollashIkkiMatn => 'Bu amalni qaytarib boʻlmaydi.';

  @override
  String get nollandi => 'Hisob nollandi.';

  @override
  String get orqaga => 'Orqaga';

  @override
  String get onbOtkazib => 'Oʻtkazib yuborish';

  @override
  String get onbSarlavha => 'Har bir zikr hisobda';

  @override
  String get onbMatn =>
      'Oflayn ishlaydi, reklama va akkaunt yoʻq. Faqat siz va zikringiz.';

  @override
  String get onbBoshlash => 'Boshlash';

  @override
  String onbQadam(String n, String jami) {
    return '$n-qadam, jami $jami';
  }

  @override
  String get onbMaqsadSavol => 'Kuniga qancha zikr qilmoqchisiz?';

  @override
  String get onbMaqsadIzoh => 'Keyin sozlamalarda oʻzgartirishingiz mumkin';

  @override
  String onbSon(String son) {
    return '$son ta';
  }

  @override
  String get onbMaqsadIzoh100 => 'Namozdan keyingi tasbehot';

  @override
  String get onbMaqsadIzoh300 => 'Kun davomida muntazam zikr';

  @override
  String get onbMaqsadIzoh1000 => 'Koʻp zikr qiluvchilar uchun';

  @override
  String get onbOzim => 'Oʻzim belgilayman';

  @override
  String get onbOzimIzoh => 'Istalgan son, 10 000 gacha';

  @override
  String get onbDavom => 'Davom etish';

  @override
  String get onbEslatmaSavol => 'Har kuni eslatib turaymi?';

  @override
  String get onbEslatmaIzoh => 'Bugun zikr qilgan boʻlsangiz, eslatma kelmaydi';

  @override
  String onbErtalab(String vaqt) {
    return 'Ertalab · $vaqt';
  }

  @override
  String onbKechqurun(String vaqt) {
    return 'Kechqurun · $vaqt';
  }

  @override
  String get onbBoshqaVaqt => 'Boshqa vaqt';

  @override
  String onbBoshqaVaqtTanlangan(String vaqt) {
    return 'Boshqa vaqt · $vaqt';
  }

  @override
  String get onbKerakEmas => 'Kerak emas';

  @override
  String get onbTayyor => 'Tayyor';

  @override
  String get sozMaxfiylikSiyosati => 'Maxfiylik siyosati';
}
