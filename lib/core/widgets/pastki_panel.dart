import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Pastdan chiquvchi panel (Figma "Panel"): tutqich, sarlavha, yopish tugmasi.
Future<T?> pastkiPanelOch<T>(
  BuildContext context, {
  required String sarlavha,
  required WidgetBuilder builder,
}) {
  final c = context.colors;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Tab bar kapsulasi bo'lim navigatoridan yuqorida turadi; panel uni ham yopishi kerak.
    useRootNavigator: true,
    backgroundColor: c.fon,
    barrierColor: c.qoplama,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => _PastkiPanel(sarlavha: sarlavha, child: builder(context)),
  );
}

class _PastkiPanel extends StatelessWidget {
  const _PastkiPanel({required this.sarlavha, required this.child});

  final String sarlavha;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final pastki = mq.viewInsets.bottom > 0 ? mq.viewInsets.bottom + 16 : 34.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, pastki),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelSarlavhasi(sarlavha: sarlavha),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Panel tepasi: tutqich, sarlavha (`h2`) va yopish tugmasi (Figma "Panel").
class PanelSarlavhasi extends StatelessWidget {
  const PanelSarlavhasi({super.key, required this.sarlavha});

  final String sarlavha;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(color: c.chiziq, borderRadius: BorderRadius.circular(3)),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: Text(sarlavha, style: AppText.h2.copyWith(color: c.matn))),
            Semantics(
              button: true,
              label: l.yopish,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: c.fon2, borderRadius: BorderRadius.circular(17)),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: -0.785398, // -45°: plus → yopish belgisi
                    child: SvgPicture.asset(
                      'assets/svg/icon_plus.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(c.matn, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
