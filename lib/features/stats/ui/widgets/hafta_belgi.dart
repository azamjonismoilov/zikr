import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library/domain/zikr_holati.dart';
import '../../../library/ui/widgets/ijro_tugma.dart';
import '../../domain/statistika.dart';

/// Statistika kartasidagi kun belgisi (30×30): yashil ✓, ko'k ▶ yoki bo'sh kulrang doira.
class HaftaBelgi extends StatelessWidget {
  const HaftaBelgi(this.belgi, {super.key});

  final HaftaBelgisi belgi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: 30,
      height: 30,
      child: switch (belgi) {
        HaftaBelgisi.hisoblangan => const FittedBox(child: IjroTugma(ZikrHolati.bajarildi)),
        HaftaBelgisi.bugunKutilmoqda => const FittedBox(child: IjroTugma(ZikrHolati.jarayonda)),
        HaftaBelgisi.hisoblanmagan => DecoratedBox(
            decoration: BoxDecoration(
              color: c.fon,
              shape: BoxShape.circle,
              border: Border.all(color: c.chiziq, width: 2),
            ),
          ),
      },
    );
  }
}
