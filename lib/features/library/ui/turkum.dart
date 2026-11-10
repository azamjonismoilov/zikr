import '../../../core/db/database.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/bolimlar.dart';

/// Turkum (va "Mening" bo'limi) nomi, izohi va rasmi — ilovada yagona joy.
class Turkum {
  const Turkum._(this.kalit, this.rasm, this._nomi, this._izoh);

  final String kalit;
  final String rasm;
  final String Function(AppLocalizations) _nomi;
  final String Function(AppLocalizations) _izoh;

  String nomi(AppLocalizations l) => _nomi(l);
  String izoh(AppLocalizations l) => _izoh(l);

  static final _hammasi = <String, Turkum>{
    'namozdan_keyin': Turkum._('namozdan_keyin', 'namoz', (l) => l.turkumNamozdanKeyin, (l) => l.izohNamozdanKeyin),
    'kun_davomida': Turkum._('kun_davomida', 'tasbeh', (l) => l.turkumKunDavomida, (l) => l.izohKunDavomida),
    'ertalabki': Turkum._('ertalabki', 'tong', (l) => l.turkumErtalabki, (l) => l.izohErtalabki),
    'kechki': Turkum._('kechki', 'tun', (l) => l.turkumKechki, (l) => l.izohKechki),
    meningBolimi: Turkum._(meningBolimi, 'yurak', (l) => l.turkumMening, (l) => l.izohMening),
  };

  /// Noma'lum kalit uchun kalitning o'zi nom sifatida, rasm — tasbeh.
  static Turkum ol(String kalit) =>
      _hammasi[kalit] ?? Turkum._(kalit, 'tasbeh', (_) => kalit, (_) => '');
}

extension ZikrKorinishi on ZikrQator {
  /// Ekranda ko'rinadigan nom: talaffuz bo'lsa u, aks holda nom.
  String get korinishNomi => talaffuz ?? nomi;
}

/// Ekranda ishlatiladigan bo'limlar ro'yxati.
List<Bolim<ZikrQator>> zikrBolimlari(Iterable<ZikrQator> zikrlar) =>
    bolimlarga(zikrlar, turkum: (z) => z.turkum, ozZikri: (z) => z.ozZikri);
