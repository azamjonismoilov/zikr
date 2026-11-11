import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Zikr va turkum illyustratsiyasi (Figma `Rasm/...`), `assets/svg/rasm_<nom>.svg`.
class RasmPlitka extends StatelessWidget {
  const RasmPlitka(this.nom, {super.key, required this.olcham});

  /// Rasm nomi; `null` bo'lsa tasbeh.
  final String? nom;
  final double olcham;

  static const _standart = 'tasbeh';
  static const mavjud = {'tasbeh', 'yurak', 'yulduz', 'namoz', 'tun', 'tong', 'kitob', 'olov'};

  @override
  Widget build(BuildContext context) {
    final n = mavjud.contains(nom) ? nom! : _standart;
    return ExcludeSemantics(
      child: SvgPicture.asset('assets/svg/rasm_$n.svg', excludeFromSemantics: true, width: olcham, height: olcham),
    );
  }
}
