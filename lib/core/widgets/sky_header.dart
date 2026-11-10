import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Osmon varianti, Figma `OsmonFon` komponentidagi `Vaqt` xossasi.
enum OsmonVaqt {
  bomdod('assets/svg/osmon_bomdod.svg'),
  peshin('assets/svg/osmon_peshin.svg'),
  shom('assets/svg/osmon_shom.svg'),
  xufton('assets/svg/osmon_xufton.svg');

  const OsmonVaqt(this.asset);
  final String asset;
}

/// Ekran tepasidagi osmon (390×230). Tun rejimida har doim Xufton.
class SkyHeader extends StatelessWidget {
  const SkyHeader({super.key, required this.vaqt});

  static const balandlik = 230.0;

  /// Yorug' rejimdagi variant.
  final OsmonVaqt vaqt;

  @override
  Widget build(BuildContext context) {
    final tun = Theme.of(context).brightness == Brightness.dark;
    final faol = tun ? OsmonVaqt.xufton : vaqt;
    return ExcludeSemantics(
      child: SizedBox(
        height: balandlik,
        width: double.infinity,
        child: SvgPicture.asset(
          faol.asset,
          key: ValueKey(faol),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
