import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/bortiq_tugma.dart';
import '../../../../core/widgets/maydon.dart';
import '../../../../core/widgets/pastki_panel.dart';
import 'maqsad_qatori.dart';

const engKamMaqsad = 1;
const engKopMaqsad = 10000;

/// "Maxsus" maqsad paneli. Saqlansa tanlangan sonni, yopilsa `null` qaytaradi.
///
/// [tayyorlar] berilsa, maydon ustida tayyor variantlar chiqadi (masalan, kunlik maqsad
/// uchun 100, 300, 1 000); biri bosilsa darhol tanlanadi.
Future<int?> maxsusMaqsadSora(
  BuildContext context, {
  int? joriy,
  String? sarlavha,
  String? yorliq,
  List<int> tayyorlar = const [],
}) {
  final l = AppLocalizations.of(context);
  return pastkiPanelOch<int>(
    context,
    sarlavha: sarlavha ?? l.maxsusSarlavha,
    builder: (_) => _MaxsusMaqsadPaneli(joriy: joriy, yorliq: yorliq, tayyorlar: tayyorlar),
  );
}

class _MaxsusMaqsadPaneli extends StatefulWidget {
  const _MaxsusMaqsadPaneli({this.joriy, this.yorliq, this.tayyorlar = const []});

  final int? joriy;
  final String? yorliq;
  final List<int> tayyorlar;

  @override
  State<_MaxsusMaqsadPaneli> createState() => _MaxsusMaqsadPaneliState();
}

class _MaxsusMaqsadPaneliState extends State<_MaxsusMaqsadPaneli> {
  late final _matn = TextEditingController(text: widget.joriy?.toString() ?? '');

  @override
  void initState() {
    super.initState();
    _matn.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _matn.dispose();
    super.dispose();
  }

  int? get _qiymat {
    final v = int.tryParse(_matn.text);
    if (v == null || v < engKamMaqsad || v > engKopMaqsad) return null;
    return v;
  }

  void _saqla() {
    final v = _qiymat;
    if (v != null) Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final notogri = _matn.text.isNotEmpty && _qiymat == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.tayyorlar.isNotEmpty) ...[
          MaqsadQatori(
            maqsad: widget.joriy,
            tayyorlar: widget.tayyorlar,
            // Tayyor variant darhol tanlanadi; "Maxsus" — pastdagi maydon.
            onTanlash: (m) => Navigator.of(context).pop(m),
            onMaxsus: () {},
          ),
          const SizedBox(height: 16),
        ],
        Maydon(
          yorliq: widget.yorliq ?? l.maxsusYorliq,
          controller: _matn,
          avtoFokus: true,
          klaviatura: TextInputType.number,
          formatlar: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          xato: notogri ? l.maxsusXato(sonFormat(engKopMaqsad)) : null,
          onSubmitted: (_) => _saqla(),
        ),
        const SizedBox(height: 20),
        AsosiyTugma(matn: l.saqlash, onTap: _qiymat == null ? null : _saqla),
      ],
    );
  }
}
