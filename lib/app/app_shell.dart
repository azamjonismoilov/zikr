import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/widgets/osmon_tab_bar.dart';

/// To'rt bo'limli qobiq: tanlangan bo'lim va ustida suzuvchi tab bar.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: OsmonTabBar(
              faolIndeks: navigationShell.currentIndex,
              onTanlash: (i) => navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              ),
              elementlar: [
                OsmonTabElement(ikonka: 'tasbeh', yorliq: l.tabSanagich),
                OsmonTabElement(ikonka: 'kitob', yorliq: l.tabZikrlar),
                OsmonTabElement(ikonka: 'statistika', yorliq: l.tabStatistika),
                OsmonTabElement(ikonka: 'sozlama', yorliq: l.tabSozlamalar),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
