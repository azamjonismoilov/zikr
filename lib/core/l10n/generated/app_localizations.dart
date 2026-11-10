import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('uz')];

  /// Ilova nomi
  ///
  /// In uz, this message translates to:
  /// **'Zikr'**
  String get ilovaNomi;

  /// Tab bar: sanagich bo'limi
  ///
  /// In uz, this message translates to:
  /// **'Sanagich'**
  String get tabSanagich;

  /// Tab bar: zikrlar kutubxonasi
  ///
  /// In uz, this message translates to:
  /// **'Zikrlar'**
  String get tabZikrlar;

  /// Tab bar: statistika bo'limi
  ///
  /// In uz, this message translates to:
  /// **'Statistika'**
  String get tabStatistika;

  /// Tab bar: sozlamalar bo'limi
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get tabSozlamalar;

  /// Zikrlar ekrani sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Zikrlar'**
  String get sarlavhaZikrlar;

  /// Statistika ekrani sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Statistika'**
  String get sarlavhaStatistika;

  /// Sozlamalar ekrani sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get sarlavhaSozlamalar;

  /// Markaziy tugmadagi teg: bugungi aylana raqami
  ///
  /// In uz, this message translates to:
  /// **'{raqam}-aylana'**
  String aylanaTeg(String raqam);

  /// Sonning ostidagi maqsad
  ///
  /// In uz, this message translates to:
  /// **'/ {maqsad}'**
  String maqsadKasr(String maqsad);

  /// Halqa ostidagi ishora
  ///
  /// In uz, this message translates to:
  /// **'Ekranning istalgan joyini bosing'**
  String get sanashIshora;

  /// Cheksiz maqsad tugmasi
  ///
  /// In uz, this message translates to:
  /// **'∞'**
  String get maqsadCheksiz;

  /// Maxsus maqsad tugmasi
  ///
  /// In uz, this message translates to:
  /// **'Maxsus'**
  String get maqsadMaxsus;

  /// To'plamdagi keyingi zikrga o'tish tugmasi
  ///
  /// In uz, this message translates to:
  /// **'Keyingisi: {nomi}'**
  String keyingisi(String nomi);

  /// Tasdiq dialogidagi bekor qilish
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get bekorQilish;

  /// Maqsad almashtirish tasdig'i sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Maqsadni almashtirish'**
  String get maqsadTasdiqSarlavha;

  /// Maqsad almashtirish tasdig'i matni
  ///
  /// In uz, this message translates to:
  /// **'Joriy aylana nollanadi'**
  String get maqsadTasdiqMatn;

  /// Maqsad almashtirishni tasdiqlash
  ///
  /// In uz, this message translates to:
  /// **'Almashtirish'**
  String get maqsadTasdiqTugma;

  /// Nollash tasdig'i sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Aylanani nollash'**
  String get nollashSarlavha;

  /// Nollash tasdig'i matni
  ///
  /// In uz, this message translates to:
  /// **'Joriy aylanadagi {son} ta bosish oʻchiriladi. Tugagan aylanalar saqlanib qoladi.'**
  String nollashMatn(String son);

  /// Nollashni tasdiqlash
  ///
  /// In uz, this message translates to:
  /// **'Nollash'**
  String get nollashTugma;

  /// Maxsus maqsad paneli sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Maxsus maqsad'**
  String get maxsusSarlavha;

  /// Maxsus maqsad maydoni yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Bir aylanadagi son'**
  String get maxsusYorliq;

  /// Maxsus maqsad chegarasi
  ///
  /// In uz, this message translates to:
  /// **'1 dan {eng_kop} gacha son kiriting'**
  String maxsusXato(String eng_kop);

  /// Saqlash tugmasi
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get saqlash;

  /// Panelni yopish (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get yopish;

  /// Olov pill'i (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Ketma-ket kunlar: {kun}'**
  String streakIzoh(String kun);

  /// Tasbeh pill'i (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Bugun tugagan aylanalar: {soni}'**
  String aylanalarIzoh(String soni);

  /// Tebranish tugmasi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tebranish yoqilgan'**
  String get haptikYoqilgan;

  /// Tebranish tugmasi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tebranish oʻchirilgan'**
  String get haptikOchirilgan;

  /// Nollash tugmasi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Joriy aylanani nollash'**
  String get nollashIzoh;

  /// Markaziy tugma (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Sanash, joriy son {son}'**
  String sanashIzoh(String son);

  /// Turkum nomi
  ///
  /// In uz, this message translates to:
  /// **'Namozdan keyin'**
  String get turkumNamozdanKeyin;

  /// Turkum nomi
  ///
  /// In uz, this message translates to:
  /// **'Kun davomida'**
  String get turkumKunDavomida;

  /// Turkum nomi
  ///
  /// In uz, this message translates to:
  /// **'Ertalabki'**
  String get turkumErtalabki;

  /// Turkum nomi
  ///
  /// In uz, this message translates to:
  /// **'Kechki'**
  String get turkumKechki;

  /// O'z zikrlari bo'limi nomi
  ///
  /// In uz, this message translates to:
  /// **'Mening'**
  String get turkumMening;

  /// Bo'lim izohi
  ///
  /// In uz, this message translates to:
  /// **'Har farz namozidan soʻng'**
  String get izohNamozdanKeyin;

  /// Bo'lim izohi
  ///
  /// In uz, this message translates to:
  /// **'Istalgan vaqtda'**
  String get izohKunDavomida;

  /// Bo'lim izohi
  ///
  /// In uz, this message translates to:
  /// **'Ertalab'**
  String get izohErtalabki;

  /// Bo'lim izohi
  ///
  /// In uz, this message translates to:
  /// **'Kechqurun'**
  String get izohKechki;

  /// Bo'lim izohi
  ///
  /// In uz, this message translates to:
  /// **'Oʻzingiz qoʻshgan'**
  String get izohMening;

  /// Bo'lim sarlavhasi ostidagi izoh va zikrlar soni
  ///
  /// In uz, this message translates to:
  /// **'{izoh} · {soni} ta zikr'**
  String bolimIzohi(String izoh, String soni);

  /// Bajarilgan zikr kartasi: maqsad / maqsad
  ///
  /// In uz, this message translates to:
  /// **'{maqsad} / {maqsad}'**
  String kartaBajarildi(String maqsad);

  /// Zikr kartasi: maqsad
  ///
  /// In uz, this message translates to:
  /// **'{maqsad} marta'**
  String kartaMarta(String maqsad);

  /// Zikr kartasi: ∞ maqsad
  ///
  /// In uz, this message translates to:
  /// **'Cheksiz'**
  String get kartaCheksiz;

  /// Zikr kartasi: maqsad va ma'no
  ///
  /// In uz, this message translates to:
  /// **'{maqsad} · {manosi}'**
  String kartaIzoh(String maqsad, String manosi);

  /// Zikr kartasidagi progress yozuvi
  ///
  /// In uz, this message translates to:
  /// **'{son}/{maqsad}'**
  String kartaProgress(String son, String maqsad);

  /// Yig'ish tugmasi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Boʻlimni yigʻish'**
  String get bolimniYigish;

  /// Yig'ish tugmasi yopiq holatda (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Boʻlimni ochish'**
  String get bolimniOchish;

  /// Qidiruv tugmasi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Qidirish'**
  String get qidirish;

  /// Mening bo'limi bo'sh holati
  ///
  /// In uz, this message translates to:
  /// **'Oʻz zikringiz hali yoʻq'**
  String get ozZikringizYoq;

  /// O'z zikrini qo'shish tugmasi
  ///
  /// In uz, this message translates to:
  /// **'Oʻz zikringizni qoʻshish'**
  String get ozZikringizniQoshish;

  /// Zikr tanlash paneli sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Zikrni tanlang'**
  String get zikrniTanlang;

  /// Qidiruv maydoni placeholder'i
  ///
  /// In uz, this message translates to:
  /// **'Zikr nomi yoki maʼnosi'**
  String get qidiruvMaslahat;

  /// Barcha turkumlar chipi
  ///
  /// In uz, this message translates to:
  /// **'Hammasi'**
  String get hammasi;

  /// Qidiruv natijasi bo'sh
  ///
  /// In uz, this message translates to:
  /// **'Hech narsa topilmadi'**
  String get hechNarsaTopilmadi;

  /// O'z zikri ekrani sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Yangi zikr'**
  String get yangiZikr;

  /// Tahrirlash ekrani sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Zikrni tahrirlash'**
  String get zikrniTahrirlash;

  /// Rasm tanlovi yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Rasm'**
  String get rasm;

  /// Talaffuz maydoni yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Talaffuzi'**
  String get talaffuzi;

  /// Arabcha maydon yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Arabcha matn (ixtiyoriy)'**
  String get arabchaMatn;

  /// Ma'no maydoni yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Maʼnosi'**
  String get manosi;

  /// Maqsad tanlovi yorlig'i
  ///
  /// In uz, this message translates to:
  /// **'Maqsad'**
  String get maqsad;

  /// O'chirish tugmasi
  ///
  /// In uz, this message translates to:
  /// **'Oʻchirish'**
  String get ochirish;

  /// O'chirish tasdig'i sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Zikrni oʻchirish'**
  String get ochirishSarlavha;

  /// O'chirish tasdig'i matni
  ///
  /// In uz, this message translates to:
  /// **'Zikr roʻyxatlardan olib tashlanadi. Statistikadagi hisob saqlanib qoladi.'**
  String get ochirishMatn;

  /// Saqlamasdan chiqish tasdig'i sarlavhasi
  ///
  /// In uz, this message translates to:
  /// **'Oʻzgarishlar saqlanmaydi'**
  String get chiqishSarlavha;

  /// Saqlamasdan chiqish tasdig'i matni
  ///
  /// In uz, this message translates to:
  /// **'Yozganlaringiz oʻchib ketadi.'**
  String get chiqishMatn;

  /// Saqlamasdan chiqishni tasdiqlash
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get chiqish;

  /// Tanlangan holat (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tanlangan'**
  String get tanlangan;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tasbeh'**
  String get rasmTasbeh;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Yurak'**
  String get rasmYurak;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Yulduz'**
  String get rasmYulduz;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Masjid'**
  String get rasmNamoz;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tun'**
  String get rasmTun;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Tong'**
  String get rasmTong;

  /// Rasm plitkasi nomi (ekran o'quvchi uchun)
  ///
  /// In uz, this message translates to:
  /// **'Kitob'**
  String get rasmKitob;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
