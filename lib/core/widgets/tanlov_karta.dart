import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Onboarding varianti (Figma `TanlovKarta`): sarlavha, izoh va o'ngda belgi katakchasi.
/// Tanlangani `kokOch` fon, `kok` chegara; tanlanmagani `chiziq` chegara va bo'rtiq soya.
class TanlovKarta extends StatelessWidget {
  const TanlovKarta({super.key, required this.sarlavha, this.izoh, required this.tanlangan, required this.onTap});

  final String sarlavha;
  final String? izoh;
  final bool tanlangan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: tanlangan,
      inMutuallyExclusiveGroup: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: tanlangan ? c.kokOch : c.fon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tanlangan ? c.kok : c.chiziq, width: 1.5),
            boxShadow: tanlangan ? null : [BoxShadow(color: c.chiziq, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sarlavha, style: AppText.h3.copyWith(color: c.matn)),
                    if (izoh != null) ...[
                      const SizedBox(height: 2),
                      Text(izoh!, style: AppText.kichik.copyWith(color: c.matn2)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _Belgi(tanlangan: tanlangan),
            ],
          ),
        ),
      ),
    );
  }
}

class _Belgi extends StatelessWidget {
  const _Belgi({required this.tanlangan});

  final bool tanlangan;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tanlangan ? c.kok : null,
        borderRadius: BorderRadius.circular(7),
        border: tanlangan ? null : Border.all(color: c.chiziq, width: 2),
      ),
      child: tanlangan
          ? SvgPicture.asset(
              excludeFromSemantics: true,
              'assets/svg/icon_belgi.svg',
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(c.belgiOq, BlendMode.srcIn),
            )
          : null,
    );
  }
}
