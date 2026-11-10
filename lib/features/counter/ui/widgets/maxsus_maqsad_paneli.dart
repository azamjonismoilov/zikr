import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/bortiq_tugma.dart';
import '../../../../core/widgets/maydon.dart';
import '../../../../core/widgets/pastki_panel.dart';

const engKamMaqsad = 1;
const engKopMaqsad = 10000;

/// "Maxsus" maqsad paneli. Saqlansa tanlangan sonni, yopilsa `null` qaytaradi.
Future<int?> maxsusMaqsadSora(BuildContext context, {int? joriy}) {
  return pastkiPanelOch<int>(
    context,
    sarlavha: AppLocalizations.of(context).maxsusSarlavha,
    builder: (_) => _MaxsusMaqsadPaneli(joriy: joriy),
  );
}

class _MaxsusMaqsadPaneli extends StatefulWidget {
  const _MaxsusMaqsadPaneli({this.joriy});

  final int? joriy;

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
        Maydon(
          yorliq: l.maxsusYorliq,
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
