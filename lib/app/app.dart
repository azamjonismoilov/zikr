import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../core/platforma/platforma.dart';
import '../core/theme/app_theme.dart';
import '../features/counter/ui/sanagich_controller.dart';
import '../features/settings/domain/eslatma.dart';
import '../features/settings/domain/mavzu.dart';
import 'router.dart';
import 'sanagich_korinishi.dart';

/// Matn masshtabining yuqori chegarasi.
const engKattaMatn = 1.3;

class ZikrApp extends ConsumerStatefulWidget {
  const ZikrApp({super.key});

  @override
  ConsumerState<ZikrApp> createState() => _ZikrAppState();
}

class _ZikrAppState extends ConsumerState<ZikrApp> {
  late final GoRouter _router = routerYarat(
    onboardingKorildi: () => ref.read(sanagichProvider).value?.onboardingKorildi,
  );
  late final AppLifecycleListener _hayot;
  StreamSubscription<void>? _bosildi;

  /// Oxirgi rejalashtirilgan eslatma kaliti: o'zgarmasa qayta rejalashtirilmaydi.
  Object? _eslatmaKaliti;

  Platforma get _platforma => ref.read(platformaProvider);

  @override
  void initState() {
    super.initState();
    _router.routerDelegate.addListener(_joyniKuzat);
    // Bildirishnoma bosilsa ilova Sanagichda ochiladi.
    _bosildi = _platforma.bildirishnomaBosildi.listen((_) => _router.go(Yollar.sanagich));
    // Ilova qayta ochilganda eslatma matni va kuni yangilanadi.
    _hayot = AppLifecycleListener(onResume: () => _eslatmaniYangila(majburiy: true));
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_joyniKuzat);
    _bosildi?.cancel();
    _hayot.dispose();
    _router.dispose();
    super.dispose();
  }

  void _joyniKuzat() {
    final yol = _router.routerDelegate.currentConfiguration.uri.path;
    ref.read(sanagichKorinadiProvider.notifier).ornat(yol == Yollar.sanagich);
  }

  /// Ovoz tugmasini faqat Sanagich ko'rinib turganda va sozlama yoqilganda ushlaydi.
  void _ovozTugmasiniYangila() {
    final h = ref.read(sanagichProvider).value;
    final korinadi = ref.read(sanagichKorinadiProvider);
    _platforma.ovozTugmasiniUshlash(h != null && h.ovozTugmasi && korinadi && _platforma.android);
  }

  Future<void> _eslatmaniYangila({bool majburiy = false}) async {
    final h = ref.read(sanagichProvider).value;
    if (h == null) return;
    final bugunHisoblangan = h.hisoblanganKunlar.contains(h.bugun);
    final streak = h.streak.joriy;
    final kalit = (h.eslatmaYoniq, h.eslatmaDaqiqa, h.bugun, bugunHisoblangan, streak);
    if (!majburiy && kalit == _eslatmaKaliti) return;
    _eslatmaKaliti = kalit;

    final reja = Eslatma.rejala(
      yoniq: h.eslatmaYoniq,
      daqiqa: h.eslatmaDaqiqa,
      hozir: ref.read(soatProvider).hozir(),
      bugunHisoblangan: bugunHisoblangan,
      streak: streak,
    );
    try {
      if (reja == null) {
        await _platforma.eslatmaniBekorQil();
        return;
      }
      final l = lookupAppLocalizations(const Locale('uz'));
      final n = reja.streak;
      await _platforma.eslatmalarniRejalashtir(
        reja.vaqtlar,
        sarlavha: l.eslatmaSarlavha,
        matn: n == null ? l.eslatmaOddiy : l.eslatmaStreak('$n'),
      );
    } catch (e) {
      debugPrint('Eslatmani rejalashtirib bo\'lmadi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sanagichProvider, (_, _) {
      _ovozTugmasiniYangila();
      _eslatmaniYangila();
    });
    ref.listen(sanagichKorinadiProvider, (_, _) => _ovozTugmasiniYangila());
    // Holat yuklanganda va onboarding tugaganda yo'nalish qayta tekshiriladi.
    ref.listen(sanagichProvider.select((h) => h.value?.onboardingKorildi), (_, _) => _router.refresh());
    final mavzu = ref.watch(sanagichProvider.select((h) => h.value?.mavzu ?? Mavzu.tizim));

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).ilovaNomi,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.yorug,
      darkTheme: AppTheme.tun,
      themeMode: switch (mavzu) {
        Mavzu.tizim => ThemeMode.system,
        Mavzu.yorug => ThemeMode.light,
        Mavzu.tun => ThemeMode.dark,
      },
      locale: const Locale('uz'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      // Tizim shrift o'lchami 1.3 gacha qo'llanadi: undan kattasida maket buziladi.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: engKattaMatn,
        child: child!,
      ),
    );
  }
}
