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
