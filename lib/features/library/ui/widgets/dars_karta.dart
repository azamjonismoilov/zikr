import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/rasm_plitka.dart';
import '../../domain/zikr_holati.dart';
import '../turkum.dart';
import 'ijro_tugma.dart';

/// Zikrlar ro'yxatidagi karta (Figma `DarsKarta`: Bajarildi, Jarayonda, Yangi).
class DarsKarta extends StatelessWidget {
  const DarsKarta({
    super.key,
    required this.zikr,
    required this.holat,
    required this.onTap,
    this.onLongPress,
  });

  final ZikrQator zikr;
  final ZikrHolatMalumoti holat;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// Rasm markazi kartaning chap chetidan (bog'lovchi chiziq uchun).
  static const rasmMarkaziX = 12.0 + 52 / 2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final maqsad = zikr.maqsad;

    final (fon, chegara, qalinlik) = switch (holat.holat) {
      ZikrHolati.bajarildi => (c.yashilOch, c.yashilChiziq, 1.5),
      ZikrHolati.jarayonda => (c.fon, c.kok, 1.5),
      ZikrHolati.yangi => (c.fon, c.chiziq, 1.0),
    };

    final maqsadMatni = maqsad == null
        ? l.kartaCheksiz
        : holat.holat == ZikrHolati.bajarildi
            ? l.kartaBajarildi(sonFormat(maqsad))
            : l.kartaMarta(sonFormat(maqsad));
    final izoh = zikr.manosi.isEmpty ? maqsadMatni : l.kartaIzoh(maqsadMatni, zikr.manosi);

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            color: fon,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: chegara, width: qalinlik),
            boxShadow: AppShadows.darsKarta,
          ),
          child: Row(
            children: [
              RasmPlitka(zikr.rasm, olcham: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zikr.korinishNomi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.h3.copyWith(color: c.matn),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      izoh,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.kichik.copyWith(color: c.matn2),
                    ),
                    if (holat.holat == ZikrHolati.jarayonda) ...[
                      const SizedBox(height: 3),
                      _Progress(son: holat.son, maqsad: maqsad, progress: holat.progress),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IjroTugma(holat.holat),
            ],
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.son, required this.maqsad, required this.progress});

  final int son;
  final int? maqsad;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final p = progress;
    final maqsad = this.maqsad;
    // ∞ maqsadda chiziq yo'q, faqat son.
    final yozuv = maqsad == null ? sonFormat(son) : l.kartaProgress(sonFormat(son), sonFormat(maqsad));

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          if (p != null) ...[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      Positioned.fill(child: ColoredBox(color: c.chiziq)),
                      FractionallySizedBox(
                        widthFactor: p,
                        heightFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: c.yashil,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(yozuv, style: AppText.teg.copyWith(color: c.matn2)),
        ],
      ),
    );
  }
}
