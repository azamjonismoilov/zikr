import 'package:flutter/painting.dart';

/// Matn stillari. Rang bu yerda berilmaydi: u mavzudan yoki
/// `AppText.h1.copyWith(color: context.colors.matn)` orqali keladi.
abstract final class AppText {
  static const _inter = 'Inter';
  static const _amiri = 'Amiri';

  static TextStyle _stil({
    required String family,
    required FontWeight weight,
    required double size,
    required double lineHeight,
    double trackingPct = 0,
  }) {
    return TextStyle(
      fontFamily: family,
      fontWeight: weight,
      fontSize: size,
      height: lineHeight / size,
      letterSpacing: size * trackingPct / 100,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static final raqam = _stil(family: _inter, weight: FontWeight.w800, size: 84, lineHeight: 84, trackingPct: -4);
  static final h1 = _stil(family: _inter, weight: FontWeight.w700, size: 26, lineHeight: 32, trackingPct: -2);
  static final h2 = _stil(family: _inter, weight: FontWeight.w700, size: 20, lineHeight: 26, trackingPct: -1.5);
  static final h3 = _stil(family: _inter, weight: FontWeight.w700, size: 16, lineHeight: 21, trackingPct: -1);
  static final matn = _stil(family: _inter, weight: FontWeight.w500, size: 14, lineHeight: 20, trackingPct: -0.5);
  static final kichik = _stil(family: _inter, weight: FontWeight.w500, size: 13, lineHeight: 18, trackingPct: -0.3);
  static final teg = _stil(family: _inter, weight: FontWeight.w600, size: 12, lineHeight: 16);
  static final tugma = _stil(family: _inter, weight: FontWeight.w600, size: 16, lineHeight: 20, trackingPct: -0.5);
  static final arab = _stil(family: _amiri, weight: FontWeight.w400, size: 34, lineHeight: 56);

  /// Ro'yxat qatoridagi arabcha matn (Figma `TanlashQator`).
  static final arabKichik = _stil(family: _amiri, weight: FontWeight.w400, size: 19, lineHeight: 30);

  /// Tabrik modalidagi arabcha matn (Figma 07).
  static final arabOrta = _stil(family: _amiri, weight: FontWeight.w400, size: 28, lineHeight: 46);

  /// Arabcha matn kiritish maydoni (Figma 08 · O'z zikringiz).
  static final arabMaydon =
      _stil(family: _amiri, weight: FontWeight.w400, size: 21, lineHeight: 30, trackingPct: -0.5);

  /// Tab bar yorlig'i. `CLAUDE.md` jadvalida yo'q, Figma'dagi `OsmonTabBar` dan olingan.
  static final tabYorliq = _stil(family: _inter, weight: FontWeight.w600, size: 10, lineHeight: 12);
}
