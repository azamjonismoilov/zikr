import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/db/database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/rasm_plitka.dart';
import '../turkum.dart';

/// Zikr tanlash panelidagi qator (Figma `TanlashQator`: Tanlangan Ha / Yo'q).
class TanlashQator extends StatelessWidget {
  const TanlashQator({
    super.key,
    required this.zikr,
    required this.tanlangan,
    required this.onTap,
  });

  final ZikrQator zikr;
  final bool tanlangan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      button: true,
      selected: tanlangan,
      label: tanlangan ? '${zikr.korinishNomi}, ${l.tanlangan}' : zikr.korinishNomi,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
          decoration: BoxDecoration(
            color: tanlangan ? c.kokOch : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tanlangan ? c.kok : Colors.transparent, width: 1.5),
          ),
          child: Row(
            children: [
              RasmPlitka(zikr.rasm, olcham: 44),
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
                    if (zikr.manosi.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        zikr.manosi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.kichik.copyWith(color: c.matn2),
                      ),
                    ],
                  ],
                ),
              ),
              if (zikr.arabcha.isNotEmpty) ...[
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    zikr.arabcha,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppText.arabKichik.copyWith(color: c.matn),
                  ),
                ),
              ],
              const SizedBox(width: 12),
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tanlangan ? c.kok : null,
                  border: tanlangan ? null : Border.all(color: c.chiziq, width: 2),
                ),
                child: tanlangan
                    ? SvgPicture.asset(
                        'assets/svg/icon_belgi.svg',
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(c.fon, BlendMode.srcIn),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
