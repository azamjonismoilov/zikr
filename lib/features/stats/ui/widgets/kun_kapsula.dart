import 'package:flutter/material.dart';

import '../../../../core/format/son_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text.dart';
import '../../domain/statistika.dart';
import 'olov_belgi.dart';

/// Joriy haftadagi kun (Figma `KunKapsula`, 44×88).
class KunKapsula extends StatelessWidget {
  const KunKapsula({super.key, required this.kun, required this.nomi});

  final HaftaKuni kun;
  final String nomi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hisoblangan = kun.holat == KapsulaHolati.hisoblangan;
    final tartib = kun.tartib;
    return Semantics(
      label: tartib == null ? nomi : '$nomi, ${sonFormat(tartib)}',
      excludeSemantics: true,
      child: Container(
        width: 44,
        height: 88,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: c.fon,
          borderRadius: BorderRadius.circular(22),
          // Bugun: olov chegara; hisoblangan: olovChiziq; qolgani: chiziq.
          border: Border.all(
            color: kun.bugun ? c.olov : (hisoblangan ? c.olovChiziq : c.chiziq),
            width: kun.bugun ? 2 : 1.5,
          ),
          boxShadow: AppShadows.kunKapsula,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nomi,
              style: AppText.teg.copyWith(color: hisoblangan || kun.bugun ? c.olov : c.matn2),
            ),
            OlovBelgi(rangli: hisoblangan, raqam: tartib == null ? null : sonFormat(tartib)),
          ],
        ),
      ),
    );
  }
}
