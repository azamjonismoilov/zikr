import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';

class SozlamalarEkrani extends StatelessWidget {
  const SozlamalarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return OsmonEkran(
      vaqt: OsmonVaqt.shom,
      sarlavha: AppLocalizations.of(context).sarlavhaSozlamalar,
    );
  }
}
