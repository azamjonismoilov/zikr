import 'package:go_router/go_router.dart';

import '../features/counter/ui/sanagich_ekrani.dart';
import '../features/library/ui/oz_zikr_ekrani.dart';
import '../features/library/ui/zikrlar_ekrani.dart';
import '../features/onboarding/ui/onboarding_ekrani.dart';
import '../features/path/ui/yol_ekrani.dart';
import '../features/settings/ui/sozlamalar_ekrani.dart';
import '../features/stats/ui/ketma_ketlik_ekrani.dart';
import '../features/stats/ui/statistika_ekrani.dart';
import 'app_shell.dart';

abstract final class Yollar {
  static const sanagich = '/';
  static const zikrlar = '/zikrlar';
  static const statistika = '/statistika';
  static const sozlamalar = '/sozlamalar';
  static const yangiZikr = '/zikr/yangi';
  static String zikrniTahrirlash(int id) => '/zikr/$id';
  static String yol(int toplamId) => '/yol/$toplamId';
  static const ketmaKetlik = '/ketma-ketlik';
  static const onboarding = '/onboarding';
}

/// [onboardingKorildi] — holat yuklanmagan bo'lsa `null`. `false` bo'lsa har qanday yo'l
/// onboarding'ga, `true` bo'lsa onboarding Sanagichga yo'naltiriladi.
GoRouter routerYarat({required bool? Function() onboardingKorildi}) {
  return GoRouter(
    initialLocation: Yollar.sanagich,
    redirect: (_, state) {
      final korildi = onboardingKorildi();
      if (korildi == null) return null;
      final onboardingda = state.matchedLocation == Yollar.onboarding;
      if (!korildi && !onboardingda) return Yollar.onboarding;
      if (korildi && onboardingda) return Yollar.sanagich;
      return null;
    },
    routes: [
      GoRoute(path: Yollar.onboarding, builder: (_, _) => const OnboardingEkrani()),
      // To'liq ekranli sahifalar shell'dan tashqarida: tab bar ustidan ochiladi.
      GoRoute(path: Yollar.yangiZikr, builder: (_, _) => const OzZikrEkrani()),
      GoRoute(
        path: '/zikr/:id',
        builder: (_, state) => OzZikrEkrani(zikrId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/yol/:id',
        builder: (_, state) => YolEkrani(toplamId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(path: Yollar.ketmaKetlik, builder: (_, _) => const KetmaKetlikEkrani()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Yollar.sanagich, builder: (_, _) => const SanagichEkrani()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Yollar.zikrlar, builder: (_, _) => const ZikrlarEkrani()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Yollar.statistika, builder: (_, _) => const StatistikaEkrani()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Yollar.sozlamalar, builder: (_, _) => const SozlamalarEkrani()),
          ]),
        ],
      ),
    ],
  );
}
