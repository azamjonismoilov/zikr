import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'bosish_maydoni.dart';

/// Bo'rtiq (3D) tugma: ostida xiralashmagan soya, bosilganda yuzasi soyaga tushadi.
///
/// Soya layout joyini egallamaydi (Figma'dagi `shadow` kabi), faqat pastga chizadi.
class BortiqTugma extends StatefulWidget {
  const BortiqTugma({
    super.key,
    required this.yuza,
    required this.soya,
    required this.radius,
    required this.child,
    required this.onTap,
    this.chuqurlik = 4,
    this.semanticLabel,
    this.bosilganda,
  });

  /// Tugma yuzasi (rang/gradient va chegara). `borderRadius` shu yerda berilmaydi.
  final BoxDecoration yuza;
  final Color soya;
  final double radius;
  final Widget child;
  final VoidCallback? onTap;
  final double chuqurlik;
  final String? semanticLabel;

  /// Bosish boshlanganda (tap down), masalan haptik uchun.
  final VoidCallback? bosilganda;

  @override
  State<BortiqTugma> createState() => _BortiqTugmaState();
}

class _BortiqTugmaState extends State<BortiqTugma> {
  bool _bosilgan = false;

  void _holat(bool v) {
    if (widget.onTap == null || _bosilgan == v) return;
    setState(() => _bosilgan = v);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.radius);
    return BosishMaydoni(
      child: Semantics(
        button: true,
        enabled: widget.onTap != null,
        label: widget.semanticLabel,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            _holat(true);
            widget.bosilganda?.call();
          },
          onTapUp: (_) => _holat(false),
          onTapCancel: () => _holat(false),
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: widget.chuqurlik,
                bottom: -widget.chuqurlik,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: widget.soya, borderRadius: radius),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 60),
                transform: Matrix4.translationValues(0, _bosilgan ? widget.chuqurlik : 0, 0),
                decoration: widget.yuza.copyWith(borderRadius: radius),
                clipBehavior: Clip.antiAlias,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Asosiy (ko'k gradientli) tugma. [xavfli] bo'lsa qizil fon, oq matn (qaytarib
/// bo'lmaydigan amalning oxirgi tasdig'i).
class AsosiyTugma extends StatelessWidget {
  const AsosiyTugma({
    super.key,
    required this.matn,
    required this.onTap,
    this.oxiridagi,
    this.balandlik = 52,
    this.xavfli = false,
  });

  final String matn;
  final VoidCallback? onTap;

  /// Matndan keyingi ikonka.
  final Widget? oxiridagi;
  final double balandlik;
  final bool xavfli;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: BortiqTugma(
        onTap: onTap,
        radius: balandlik / 2,
        soya: xavfli ? c.qizilSoya : c.asosiySoya,
        yuza: xavfli
            ? BoxDecoration(color: c.qizilTugma)
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [c.asosiyYuqori, c.asosiyPast],
                ),
              ),
        child: SizedBox(
          height: balandlik,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  matn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.tugma.copyWith(color: xavfli ? c.belgiOq : c.fon),
                ),
              ),
              if (oxiridagi != null) ...[const SizedBox(width: 8), oxiridagi!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Oq (fon rangli) bo'rtiq tugma, `chiziq` chegarasi bilan.
class OqTugma extends StatelessWidget {
  const OqTugma({
    super.key,
    required this.child,
    required this.onTap,
    this.radius = 16,
    this.chuqurlik = 4,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final double chuqurlik;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BortiqTugma(
      onTap: onTap,
      radius: radius,
      chuqurlik: chuqurlik,
      soya: c.bortiq,
      semanticLabel: semanticLabel,
      yuza: BoxDecoration(
        color: c.fon,
        border: Border.all(color: c.chiziq, width: 1.5),
      ),
      child: child,
    );
  }
}
