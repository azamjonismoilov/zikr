import 'package:flutter/painting.dart';

abstract final class AppShadows {
  /// Karta soyasi: rgba(15, 41, 82, 0.06), y 3, blur 12.
  static const karta = [
    BoxShadow(color: Color(0x0F0F2952), offset: Offset(0, 3), blurRadius: 12),
  ];

  /// Suzuvchi tab bar kapsulasi: rgba(10, 26, 51, 0.14), y 8, blur 28 (Figma `OsmonTabBar`).
  static const kapsula = [
    BoxShadow(color: Color(0x240A1A33), offset: Offset(0, 8), blurRadius: 28),
  ];

  /// Tepadagi ko'rsatkich pill'lari: rgba(15, 41, 82, 0.08), y 2, blur 8.
  static const pill = [
    BoxShadow(color: Color(0x140F2952), offset: Offset(0, 2), blurRadius: 8),
  ];

  /// Tepadagi doira ikonka tugmalari: rgba(15, 41, 82, 0.1), y 3, blur 10.
  static const ikonkaTugma = [
    BoxShadow(color: Color(0x1A0F2952), offset: Offset(0, 3), blurRadius: 10),
  ];

  /// Bo'rtiq (3D) effekt: xiralashmagan, pastga surilgan soya.
  static List<BoxShadow> bortiq(Color rang, {double balandlik = 4}) => [
        BoxShadow(color: rang, offset: Offset(0, balandlik), blurRadius: 0),
      ];
}
