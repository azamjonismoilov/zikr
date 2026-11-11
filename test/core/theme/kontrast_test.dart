import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/theme/app_colors.dart';

/// WCAG kontrast nisbati.
double _kontrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const rejimlar = {'yorugʻ': AppColors.yorug, 'tun': AppColors.tun};

  for (final MapEntry(key: nomi, value: c) in rejimlar.entries) {
    group(nomi, () {
      test('matn va matn2 fon va fon2 ustida kamida 4.5:1', () {
        for (final rang in [c.matn, c.matn2]) {
          expect(_kontrast(rang, c.fon), greaterThanOrEqualTo(4.5));
          expect(_kontrast(rang, c.fon2), greaterThanOrEqualTo(4.5));
        }
      });

      test('qizil matn fon va fon2 ustida kamida 4.5:1', () {
        expect(_kontrast(c.qizil, c.fon), greaterThanOrEqualTo(4.5));
        expect(_kontrast(c.qizil, c.fon2), greaterThanOrEqualTo(4.5));
      });

      test('oq matn qizilTugma ustida kamida 4.5:1', () {
        expect(_kontrast(c.belgiOq, c.qizilTugma), greaterThanOrEqualTo(4.5));
      });
    });
  }
}
