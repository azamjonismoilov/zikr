import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../counter/domain/kun.dart';

/// Ikki harfli hafta kuni nomi: 1 — Du, 7 — Ya.
String haftaKuniNomi(AppLocalizations l, int haftaKuni) => switch (haftaKuni) {
      1 => l.haftaDu,
      2 => l.haftaSe,
      3 => l.haftaCh,
      4 => l.haftaPa,
      5 => l.haftaJu,
      6 => l.haftaSh,
      _ => l.haftaYa,
    };

String oyNomi(AppLocalizations l, int oy) => switch (oy) {
      1 => l.oy1,
      2 => l.oy2,
      3 => l.oy3,
      4 => l.oy4,
      5 => l.oy5,
      6 => l.oy6,
      7 => l.oy7,
      8 => l.oy8,
      9 => l.oy9,
      10 => l.oy10,
      11 => l.oy11,
      _ => l.oy12,
    };

/// "17-oktabr"; sana yo'q bo'lsa "—".
String sanaMatni(AppLocalizations l, Kun? kun) =>
    kun == null ? l.sanaYoq : l.sanaKunOy('${kun.kun}', oyNomi(l, kun.oy));

/// Ming ajratgichi bilan; 100 000 dan katta son qisqartiriladi ("124 ming").
String qisqaSon(AppLocalizations l, int son) =>
    son > 100000 ? l.mingQisqa(sonFormat(son ~/ 1000)) : sonFormat(son);
