import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';

class ZikrlarEkrani extends StatelessWidget {
  const ZikrlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmonEkran(
      vaqt: OsmonVaqt.bomdod,
      sarlavha: AppLocalizations.of(context).sarlavhaZikrlar,
      yuqoriBalandlik: 60,
    );
  }
}
