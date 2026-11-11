import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';

/// Kichik olov (30×34), ichida raqam (Figma `KunKapsula` va bosqich qatoridagi "Olov").
class OlovBelgi extends StatelessWidget {
  const OlovBelgi({super.key, required this.rangli, this.raqam, this.kichik = false});

  /// Rangli (hisoblangan, yetilgan) yoki kulrang.
  final bool rangli;
  final String? raqam;

  /// Bosqich qatorida raqam 11 px.
  final bool kichik;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final uslub = kichik ? AppText.olovRaqamKichik : AppText.olovRaqam;
    return ExcludeSemantics(
      child: SizedBox(
        width: 30,
        height: 34,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 4.87,
              top: 2,
              width: 20.26,
              height: 30,
              child: rangli
                  ? SvgPicture.asset('assets/svg/olov_rangli.svg')
                  : SvgPicture.asset(
                      'assets/svg/olov_shakl.svg',
                      colorFilter: ColorFilter.mode(c.chiziq, BlendMode.srcIn),
                    ),
            ),
            if (raqam != null)
              Positioned(
                left: 0,
                right: 0,
                top: 13,
                height: 20,
                child: Center(
                  child: Text(
                    raqam!,
                    maxLines: 1,
                    style: uslub.copyWith(color: rangli ? c.belgiOq : c.matn3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
