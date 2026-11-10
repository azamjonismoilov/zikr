import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/zikr_holati.dart';

/// Kartadagi holat belgisi, 32×32 (Figma `IjroTugma`).
class IjroTugma extends StatelessWidget {
  const IjroTugma(this.holat, {super.key});

  final ZikrHolati holat;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fon, belgi, ikonka) = switch (holat) {
      ZikrHolati.bajarildi => (c.yashil, c.belgiOq, 'icon_ijro_belgi'),
      ZikrHolati.jarayonda => (c.kok, c.belgiOq, 'icon_ijro_play'),
      ZikrHolati.yangi => (c.ijroYangiFon, c.ijroYangiBelgi, 'icon_ijro_play'),
    };
    return ExcludeSemantics(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: fon, shape: BoxShape.circle),
        child: SvgPicture.asset(
          'assets/svg/$ikonka.svg',
          colorFilter: ColorFilter.mode(belgi, BlendMode.srcIn),
        ),
      ),
    );
  }
}
