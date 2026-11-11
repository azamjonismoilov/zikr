import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';

/// Progress halqasi va markaziy bo'rtiq tugma (Figma "Halqa", 292×300).
class HalqaTugma extends StatefulWidget {
  const HalqaTugma({
    super.key,
    required this.son,
    required this.maqsad,
    required this.teg,
    required this.bosishlar,
    this.aylanalar = 0,
  });

  final int son;

  /// `null` — cheksiz: halqa faqat yo'l, teg va "/ maqsad" yo'q.
  final int? maqsad;

  /// Son ustidagi teg ("2-aylana" yoki "2 / 3"); `null` — teg yo'q (∞).
  final String? teg;

  /// Aylana (yoki qadam) tugashlari hisoblagichi: o'zgarsa halqa to'lib qisqa yonadi.
  final int aylanalar;

  /// Har bosishda oshadigan hisoblagich: o'zgarsa tugma pastga tushib qaytadi.
  final int bosishlar;

  static const _olcham = 292.0;

  /// Halqa markazi widget ichida (292×300 maydonning yuqori 292×292 qismi markazi).
  static const markaz = Offset(_olcham / 2, _olcham / 2);
  static const _qalinlik = 14.6;
  static const _tugma = 232.0;
  static const _chuqurlik = 8.0;
  static const _tushish = 4.0;

  @override
  State<HalqaTugma> createState() => _HalqaTugmaState();
}

class _HalqaTugmaState extends State<HalqaTugma> with TickerProviderStateMixin {
  // 40 ms pastga + 40 ms qaytish ≈ 80 ms.
  late final _bosish = AnimationController(vsync: this, duration: const Duration(milliseconds: 40));

  /// Aylana tugaganda halqa to'lib yonadi (≈ 600 ms), keyin nolga qaytadi.
  late final _yonish = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

  @override
  void didUpdateWidget(HalqaTugma eski) {
    super.didUpdateWidget(eski);
    if (widget.aylanalar != eski.aylanalar) _yonish.forward(from: 0);
    if (widget.bosishlar != eski.bosishlar) {
      _bosish.forward(from: 0).then((_) {
        if (mounted) _bosish.reverse();
      });
    }
  }

  @override
  void dispose() {
    _bosish.dispose();
    _yonish.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final maqsad = widget.maqsad;
    final progress = maqsad == null || maqsad == 0 ? 0.0 : (widget.son / maqsad).clamp(0.0, 1.0);
    const ichki = (HalqaTugma._olcham - HalqaTugma._tugma) / 2;

    return SizedBox(
      width: HalqaTugma._olcham,
      height: HalqaTugma._olcham + HalqaTugma._chuqurlik,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: HalqaTugma._olcham,
            height: HalqaTugma._olcham,
            child: AnimatedBuilder(
              animation: _yonish,
              builder: (context, _) {
                final yonmoqda = _yonish.isAnimating;
                // 0 → 1 → 0: o'rtasida eng yorqin.
                final yorqinlik = yonmoqda ? 1 - (_yonish.value - 0.5).abs() * 2 : 0.0;
                return TweenAnimationBuilder<double>(
                  tween: Tween(end: yonmoqda ? 1.0 : progress),
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  builder: (context, p, _) => CustomPaint(
                    painter: _HalqaPainter(
                      progress: p,
                      yol: c.chiziq,
                      rang: c.yashil,
                      qalinlik: HalqaTugma._qalinlik,
                      yorqinlik: yorqinlik,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: ichki,
            top: ichki + HalqaTugma._chuqurlik,
            width: HalqaTugma._tugma,
            height: HalqaTugma._tugma,
            child: DecoratedBox(decoration: BoxDecoration(color: c.chuqurlik, shape: BoxShape.circle)),
          ),
          Positioned(
            left: ichki,
            top: ichki,
            width: HalqaTugma._tugma,
            height: HalqaTugma._tugma,
            child: AnimatedBuilder(
              animation: _bosish,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, HalqaTugma._tushish * _bosish.value),
                child: child,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.chiziq, width: 1.5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [c.tugmaYuqori, c.tugmaPast],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.teg != null)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, a) => ScaleTransition(
                            scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
                            child: child,
                          ),
                          child: Container(
                            key: ValueKey(widget.teg),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: c.yashilOch,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.teg!,
                              style: AppText.teg.copyWith(color: c.yashilChuqur),
                            ),
                          ),
                        ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          sonFormat(widget.son),
                          maxLines: 1,
                          style: AppText.raqam.copyWith(color: c.matn),
                        ),
                      ),
                      if (maqsad != null)
                        Text(
                          l.maqsadKasr(sonFormat(maqsad)),
                          style: AppText.h3.copyWith(color: c.matn3),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HalqaPainter extends CustomPainter {
  _HalqaPainter({
    required this.progress,
    required this.yol,
    required this.rang,
    required this.qalinlik,
    this.yorqinlik = 0,
  });

  final double progress;
  final Color yol;
  final Color rang;
  final double qalinlik;

  /// Aylana tugagandagi yonish kuchi, 0..1.
  final double yorqinlik;

  @override
  void paint(Canvas canvas, Size size) {
    final markaz = size.center(Offset.zero);
    final radius = (size.shortestSide - qalinlik) / 2;
    final chiziq = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = qalinlik;

    canvas.drawCircle(markaz, radius, chiziq..color = yol);

    if (progress > 0 && yorqinlik > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: markaz, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = qalinlik * 1.6
          ..strokeCap = StrokeCap.round
          ..color = rang.withValues(alpha: 0.55 * yorqinlik)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: markaz, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        chiziq
          ..color = rang
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_HalqaPainter eski) =>
      eski.progress != progress ||
      eski.yol != yol ||
      eski.rang != rang ||
      eski.yorqinlik != yorqinlik;
}
