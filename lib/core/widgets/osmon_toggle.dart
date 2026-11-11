import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Toggle, 50×30 (Figma `OsmonToggle`): yoqilganda `kok`, o'chiqda `chiziq`.
class OsmonToggle extends StatelessWidget {
  const OsmonToggle({super.key, required this.yoniq, required this.onChanged});

  final bool yoniq;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      toggled: yoniq,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!yoniq),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 50,
          height: 30,
          padding: const EdgeInsets.all(3),
          alignment: yoniq ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: yoniq ? c.kok : c.chiziq,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: c.belgiOq,
              shape: BoxShape.circle,
              boxShadow: AppShadows.toggle,
            ),
          ),
        ),
      ),
    );
  }
}
