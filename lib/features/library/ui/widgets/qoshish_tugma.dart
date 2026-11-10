import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text.dart';

/// "Oʻz zikringizni qoʻshish" tugmasi (Figma 06 panelidagi "Qoshish").
class QoshishTugma extends StatelessWidget {
  const QoshishTugma({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(color: c.kokOch, borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/icon_plus.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(c.kokChuqur, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  l.ozZikringizniQoshish,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.tugma.copyWith(color: c.kokChuqur),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
