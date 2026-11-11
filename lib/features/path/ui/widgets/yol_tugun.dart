import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

enum TugunHolati { bajarildi, joriy, yangi }

/// Yo'l tuguni, 64×70 (Figma `YolTugun`): gradientli doira va ostida 7 px bo'rtiq soya.
class YolTugun extends StatelessWidget {
  const YolTugun(this.holat, {super.key});

  final TugunHolati holat;

  static const kenglik = 64.0;
  static const balandlik = 70.0;
  static const _doira = 60.0;
  static const _chuqurlik = 7.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (yuqori, past, soya, belgi, ikonka) = switch (holat) {
      TugunHolati.bajarildi => (c.tugunYashilYuqori, c.tugunYashilPast, c.tugunYashilSoya, c.belgiOq, 'icon_ijro_belgi'),
      TugunHolati.joriy => (c.tugunKokYuqori, c.tugunKokPast, c.tugunKokSoya, c.belgiOq, 'icon_ijro_play'),
      TugunHolati.yangi => (c.tugunYangiYuqori, c.tugunYangiPast, c.tugunYangiSoya, c.ijroYangiBelgi, 'icon_ijro_play'),
    };

    return ExcludeSemantics(
      child: SizedBox(
        width: kenglik,
        height: balandlik,
        child: Stack(
          children: [
            Positioned(
              left: 2,
              top: 1 + _chuqurlik,
              child: Container(
                width: _doira,
                height: _doira,
                decoration: BoxDecoration(color: soya, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              left: 2,
              top: 1,
              child: Container(
                width: _doira,
                height: _doira,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [yuqori, past],
                  ),
                  border: holat == TugunHolati.yangi
                      ? Border.all(color: c.tugunYangiChegara, width: 1.5)
                      : null,
                ),
                // Ijro ikonkalari 32×32 to'rda chizilgan; tugunda ~1.9 barobar kattaroq.
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/$ikonka.svg',
                    excludeFromSemantics: true,
                    width: 60,
                    height: 60,
                    colorFilter: ColorFilter.mode(belgi, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
