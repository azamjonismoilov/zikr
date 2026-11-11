import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../format/son_format.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text.dart';

/// Tepadagi ko'rsatkich pill'i: ikonka va son (Figma "Pill").
///
/// [jonli] bo'lsa, qiymat oshganda pill qisqa masshtab animatsiyasi bilan "uradi"
/// (masalan, streak modalsiz oshganda).
class KorsatkichPill extends StatefulWidget {
  const KorsatkichPill({
    super.key,
    required this.ikonka,
    required this.rang,
    required this.qiymat,
    required this.izoh,
    this.jonli = false,
    this.onTap,
  });

  final String ikonka;
  final Color rang;
  final int qiymat;

  /// Ekran o'quvchi uchun.
  final String izoh;
  final bool jonli;

  /// Bosilganda (masalan, olov belgisi Ketma-ketlik ekranini ochadi).
  final VoidCallback? onTap;

  @override
  State<KorsatkichPill> createState() => _KorsatkichPillState();
}

class _KorsatkichPillState extends State<KorsatkichPill> with SingleTickerProviderStateMixin {
  late final _urish = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late final _masshtab = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _urish, curve: Curves.easeOut));

  @override
  void didUpdateWidget(KorsatkichPill eski) {
    super.didUpdateWidget(eski);
    if (widget.jonli && widget.qiymat > eski.qiymat) _urish.forward(from: 0);
  }

  @override
  void dispose() {
    _urish.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: widget.onTap != null,
      label: widget.izoh,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _masshtab,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
            decoration: BoxDecoration(
              color: c.fon,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppShadows.pill,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  widget.ikonka,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(widget.rang, BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Text(sonFormat(widget.qiymat), style: AppText.teg.copyWith(color: c.matn)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tepadagi doira ikonka tugma, 40×40 (Figma "IkonkaTugma").
class IkonkaTugma extends StatelessWidget {
  const IkonkaTugma({
    super.key,
    required this.ikonka,
    required this.onTap,
    required this.izoh,
    this.rang,
    this.burchak = 0,
    this.toggled,
  });

  final String ikonka;
  final VoidCallback onTap;
  final String izoh;

  /// Ikonka rangi; standart — `matn`.
  final Color? rang;

  /// Ikonkani burish (radian), masalan plus → yopish.
  final double burchak;
  final bool? toggled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget belgi = SvgPicture.asset(
      ikonka,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(rang ?? c.matn, BlendMode.srcIn),
    );
    if (burchak != 0) belgi = Transform.rotate(angle: burchak, child: belgi);

    return Semantics(
      button: true,
      toggled: toggled,
      label: izoh,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.fon,
            shape: BoxShape.circle,
            boxShadow: AppShadows.ikonkaTugma,
          ),
          child: belgi,
        ),
      ),
    );
  }
}
