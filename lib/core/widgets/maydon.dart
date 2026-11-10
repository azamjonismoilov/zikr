import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Matn kiritish maydoni (Figma `Maydon`: Oddiy va Faol holatlari).
class Maydon extends StatefulWidget {
  const Maydon({
    super.key,
    required this.yorliq,
    required this.controller,
    this.klaviatura,
    this.formatlar,
    this.avtoFokus = false,
    this.xato,
    this.onSubmitted,
  });

  final String yorliq;
  final TextEditingController controller;
  final TextInputType? klaviatura;
  final List<TextInputFormatter>? formatlar;
  final bool avtoFokus;

  /// Maydon ostidagi xato matni.
  final String? xato;
  final ValueChanged<String>? onSubmitted;

  @override
  State<Maydon> createState() => _MaydonState();
}

class _MaydonState extends State<Maydon> {
  final _fokus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fokus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fokus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final faol = _fokus.hasFocus;
    final xato = widget.xato;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.yorliq, style: AppText.kichik.copyWith(color: c.matn2)),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: EdgeInsets.all(faol ? 13.5 : 14),
          decoration: BoxDecoration(
            color: c.fon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: faol ? c.kok : c.chiziq, width: faol ? 2 : 1.5),
            boxShadow: faol
                ? [BoxShadow(color: c.kok.withValues(alpha: 0.15), spreadRadius: 4)]
                : const [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _fokus,
            autofocus: widget.avtoFokus,
            keyboardType: widget.klaviatura,
            inputFormatters: widget.formatlar,
            onSubmitted: widget.onSubmitted,
            cursorColor: c.kok,
            style: AppText.matn.copyWith(color: c.matn),
            decoration: const InputDecoration.collapsed(hintText: null),
          ),
        ),
        if (xato != null) ...[
          const SizedBox(height: 6),
          Text(xato, style: AppText.kichik.copyWith(color: c.qizil)),
        ],
      ],
    );
  }
}
