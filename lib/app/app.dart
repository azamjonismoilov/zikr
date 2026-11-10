import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class ZikrApp extends StatefulWidget {
  const ZikrApp({super.key});

  @override
  State<ZikrApp> createState() => _ZikrAppState();
}

class _ZikrAppState extends State<ZikrApp> {
  late final GoRouter _router = routerYarat();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).ilovaNomi,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.yorug,
      darkTheme: AppTheme.tun,
      themeMode: ThemeMode.system,
      locale: const Locale('uz'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
