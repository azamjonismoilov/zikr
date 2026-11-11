import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text.dart';

class OsmonTabElement {
  const OsmonTabElement({required this.ikonka, required this.yorliq});

  /// `assets/svg/` dagi nom, masalan `tasbeh` → `tab_tasbeh.svg` va `tab_tasbeh_faol.svg`.
  final String ikonka;
  final String yorliq;
}

/// Suzuvchi kapsula tab bar (Figma `OsmonTabBar`).
class OsmonTabBar extends StatelessWidget {
  const OsmonTabBar({
    super.key,
    required this.elementlar,
    required this.faolIndeks,
    required this.onTanlash,
  });

  static const _balandlik = 62.0;
  static const _chet = 16.0;

  final List<OsmonTabElement> elementlar;
  final int faolIndeks;
  final ValueChanged<int> onTanlash;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pastki = math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0);
    final radius = BorderRadius.circular(_balandlik / 2);

    Widget kapsula = Container(
      height: _balandlik,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.shisha,
        borderRadius: radius,
        border: Border.all(color: c.shishaChiziq),
      ),
      child: Row(
        children: [
          for (var i = 0; i < elementlar.length; i++)
            Expanded(
              child: _TabTugma(
                element: elementlar[i],
                faol: i == faolIndeks,
                onTap: () => onTanlash(i),
              ),
            ),
        ],
      ),
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      kapsula = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
        child: kapsula,
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(_chet, 0, _chet, pastki),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: AppShadows.kapsula),
        child: ClipRRect(borderRadius: radius, child: kapsula),
      ),
    );
  }
}

class _TabTugma extends StatelessWidget {
  const _TabTugma({required this.element, required this.faol, required this.onTap});

  final OsmonTabElement element;
  final bool faol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rang = faol ? c.kok : c.matn;
    final ikonka = faol ? 'tab_${element.ikonka}_faol' : 'tab_${element.ikonka}';

    return Semantics(
      button: true,
      selected: faol,
      label: element.yorliq,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: faol ? c.shishaFaol : c.shishaFaol.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(27),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/$ikonka.svg',
                excludeFromSemantics: true,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(rang, BlendMode.srcIn),
              ),
              const SizedBox(height: 2),
              Text(
                element.yorliq,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.tabYorliq.copyWith(color: rang),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
