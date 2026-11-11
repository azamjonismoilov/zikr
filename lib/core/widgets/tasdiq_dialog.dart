import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'bortiq_tugma.dart';

/// Tasdiq so'rovi. Foydalanuvchi tasdiqlasa `true`, aks holda `false`.
///
/// [qoshimchaMatn] berilsa, asosiy tugmalar ustida yana bitta tugma chiqadi: u dialogni
/// `false` bilan yopadi va [onQoshimcha] ni chaqiradi (masalan, "Avval zaxira olish").
/// [xavfli] — tasdiq tugmasi qizil (qaytarib bo'lmaydigan amal).
Future<bool> tasdiqSora(
  BuildContext context, {
  required String sarlavha,
  required String matn,
  required String tasdiqMatni,
  String? qoshimchaMatn,
  VoidCallback? onQoshimcha,
  bool xavfli = false,
}) async {
  final natija = await showDialog<bool>(
    context: context,
    barrierColor: context.colors.qoplama,
    builder: (context) => _TasdiqDialog(
      sarlavha: sarlavha,
      matn: matn,
      tasdiqMatni: tasdiqMatni,
      qoshimchaMatn: qoshimchaMatn,
      onQoshimcha: onQoshimcha,
      xavfli: xavfli,
    ),
  );
  return natija ?? false;
}

/// Bitta "Yaxshi" tugmali xabar.
Future<void> xabarniKorsat(BuildContext context, {required String sarlavha, required String matn}) {
  return showDialog<void>(
    context: context,
    barrierColor: context.colors.qoplama,
    builder: (context) => _TasdiqDialog(sarlavha: sarlavha, matn: matn, tasdiqMatni: null),
  );
}

class _TasdiqDialog extends StatelessWidget {
  const _TasdiqDialog({
    required this.sarlavha,
    required this.matn,
    required this.tasdiqMatni,
    this.qoshimchaMatn,
    this.onQoshimcha,
    this.xavfli = false,
  });

  final String sarlavha;
  final String matn;

  /// `null` — faqat "Yaxshi" tugmasi (xabar).
  final String? tasdiqMatni;
  final String? qoshimchaMatn;
  final VoidCallback? onQoshimcha;
  final bool xavfli;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: c.fon,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: c.chiziq),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sarlavha, style: AppText.h2.copyWith(color: c.matn)),
            const SizedBox(height: 8),
            Text(matn, style: AppText.matn.copyWith(color: c.matn2)),
            const SizedBox(height: 20),
            if (qoshimchaMatn != null) ...[
              OqTugma(
                radius: 26,
                onTap: () {
                  Navigator.of(context).pop(false);
                  onQoshimcha?.call();
                },
                child: SizedBox(
                  height: 52,
                  child: Center(
                    child: Text(qoshimchaMatn!, style: AppText.tugma.copyWith(color: c.kokChuqur)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (tasdiqMatni == null)
              AsosiyTugma(matn: l.yaxshi, onTap: () => Navigator.of(context).pop(true))
            else
              Row(
                children: [
                  Expanded(
                    child: OqTugma(
                      radius: 26,
                      onTap: () => Navigator.of(context).pop(false),
                      child: SizedBox(
                        height: 52,
                        child: Center(
                          child: Text(l.bekorQilish, style: AppText.tugma.copyWith(color: c.matn)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AsosiyTugma(
                      matn: tasdiqMatni!,
                      xavfli: xavfli,
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
