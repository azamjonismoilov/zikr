import 'package:go_router/go_router.dart';

import '../features/counter/ui/sanagich_ekrani.dart';
import '../features/library/ui/oz_zikr_ekrani.dart';
import '../features/library/ui/zikrlar_ekrani.dart';
import '../features/settings/ui/sozlamalar_ekrani.dart';
import '../features/stats/ui/statistika_ekrani.dart';
import 'app_shell.dart';

abstract final class Yollar {
  static const sanagich = '/';
  static const zikrlar = '/zikrlar';
  static const statistika = '/statistika';
  static const sozlamalar = '/sozlamalar';
  static const yangiZikr = '/zikr/yangi';
  static String zikrniTahrirlash(int id) => '/zikr/$id';
}

GoRouter routerYarat() {
  return GoRouter(
    initialLocation: Yollar.sanagich,
    routes: [
      // To'liq ekranli sahifalar shell'dan tashqarida: tab bar ustidan ochiladi.
      GoRoute(path: Yollar.yangiZikr, builder: (_, _) => const OzZikrEkrani()),
      GoRoute(
        path: '/zikr/:id',
        builder: (_, state) => OzZikrEkrani(zikrId: int.parse(state.pathParameters['id']!)),
      ),
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
