import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Pastki paneldagi bitta tanlov (davr, mavzu): tanlangani `kokOch` fon, `kok` chegara va ✓.
class TanlovQatori extends StatelessWidget {
  const TanlovQatori({super.key, required this.matn, required this.tanlangan, required this.onTap});

  final String matn;
  final bool tanlangan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: tanlangan,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: tanlangan ? c.kokOch : c.fon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tanlangan ? c.kok : c.chiziq, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  matn,
                  style: tanlangan
                      ? AppText.h3.copyWith(color: c.kokChuqur)
                      : AppText.matn.copyWith(color: c.matn),
                ),
              ),
              if (tanlangan)
                SvgPicture.asset(
                  'assets/svg/icon_belgi.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(c.kok, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
