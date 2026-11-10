import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';

class StatistikaEkrani extends StatelessWidget {
  const StatistikaEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmonEkran(
      vaqt: OsmonVaqt.peshin,
      sarlavha: AppLocalizations.of(context).sarlavhaStatistika,
    );
  }
}
