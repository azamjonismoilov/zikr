import 'package:flutter/material.dart';

import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/bortiq_tugma.dart';

/// Maqsad tugmalari ostidagi bo'rtiq. Figma: yorug'da 3, tunda 4.
double maqsadChuqurligi(bool tun) => tun ? 4 : 3;

/// Maqsad qatoridagi tugmalar o'lchami.
const maqsadTugmaBalandligi = _MaqsadTugma.balandlik;
const maqsadTugmaRadiusi = _MaqsadTugma.radius;

/// Tayyor maqsadlar. `null` — cheksiz.
const tayyorMaqsadlar = <int?>[33, 99, null];

/// Maqsad tanlash qatori: 33, 99, ∞, Maxsus.
class MaqsadQatori extends StatelessWidget {
  const MaqsadQatori({
    super.key,
    required this.maqsad,
    required this.onTanlash,
    required this.onMaxsus,
    this.oxiridagi,
  });

  final int? maqsad;
  final ValueChanged<int?> onTanlash;
  final VoidCallback onMaxsus;

  /// Qator oxiridagi qo'shimcha tugma (masalan, "Keyingisi" yo'q bo'lganda nollash).
  final Widget? oxiridagi;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maxsusFaol = !tayyorMaqsadlar.contains(maqsad);

    Widget tugma(String matn, bool faol, VoidCallback onTap) =>
        Expanded(child: _MaqsadTugma(matn: matn, faol: faol, onTap: onTap));

    return Row(
      children: [
        for (final m in tayyorMaqsadlar) ...[
          tugma(m == null ? l.maqsadCheksiz : sonFormat(m), maqsad == m, () => onTanlash(m)),
          const SizedBox(width: 8),
        ],
        tugma(maxsusFaol ? sonFormat(maqsad!) : l.maqsadMaxsus, maxsusFaol, onMaxsus),
        if (oxiridagi != null) ...[const SizedBox(width: 8), oxiridagi!],
      ],
    );
  }
}

class _MaqsadTugma extends StatelessWidget {
  const _MaqsadTugma({required this.matn, required this.faol, required this.onTap});

  final String matn;
  final bool faol;
  final VoidCallback onTap;

  static const balandlik = 44.0;
  static const radius = 14.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final yorliq = Text(
      matn,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: faol
          ? AppText.h3.copyWith(color: c.kokChuqur)
          : AppText.matn.copyWith(color: c.matn2),
    );

    if (faol) {
      return Semantics(
        button: true,
        selected: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: balandlik,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.kokOch,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: c.kok, width: 1.5),
            ),
            child: yorliq,
          ),
        ),
      );
    }

    final tun = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      selected: false,
      child: OqTugma(
        radius: radius,
        chuqurlik: maqsadChuqurligi(tun),
        onTap: onTap,
        child: SizedBox(height: balandlik, child: Center(child: yorliq)),
      ),
    );
  }
}
