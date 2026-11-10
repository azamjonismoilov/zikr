import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'sky_header.dart';

/// Bo'lim ekranining umumiy qobig'i: tepada osmon, ustida sarlavha, ostida kontent.
class OsmonEkran extends StatelessWidget {
  const OsmonEkran({
    super.key,
    required this.vaqt,
    this.sarlavha,
    this.yuqoriBalandlik = 44,
    this.child = const SizedBox.shrink(),
  });

  final OsmonVaqt vaqt;

  /// `null` bo'lsa, sarlavha o'rnida bo'sh joy qoladi.
  final String? sarlavha;

  /// Status bar ostidagi "Yuqori" qatorining balandligi (Figma).
  final double yuqoriBalandlik;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tun = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: tun ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: c.fon,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SkyHeader(vaqt: vaqt),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: yuqoriBalandlik,
                    child: sarlavha == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Semantics(
                                header: true,
                                child: Text(
                                  sarlavha!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.h1.copyWith(color: c.matn),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
