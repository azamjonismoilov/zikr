import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../domain/statistika.dart';
import 'stat_matnlar.dart';
import 'widgets/kun_kapsula.dart';
import 'widgets/olov_belgi.dart';

/// Ketma-ketlik (Figma 12): streak, joriy hafta, odat maqsadi, bosqichlar.
class KetmaKetlikEkrani extends ConsumerWidget {
  const KetmaKetlikEkrani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final h = ref.watch(sanagichProvider).value;

    Widget tana = const SizedBox.shrink();
    if (h != null) {
      final kunlar = h.hisoblanganKunlar;
      final streak = h.streak;
      final bugunHisoblangan = kunlar.contains(h.bugun);
      final odat = Statistika.odatMaqsadi(streak.joriy);
      tana = SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + MediaQuery.viewPaddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Qahramon(streak: streak.joriy, bugunHisoblangan: bugunHisoblangan),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final k in Statistika.joriyHafta(kunlar, h.bugun))
                  KunKapsula(kun: k, nomi: haftaKuniNomi(l, k.kun.haftaKuni)),
              ],
            ),
            const SizedBox(height: 14),
            _OdatKarta(streak: streak.joriy, odat: odat),
            const SizedBox(height: 14),
            _Korsatkichlar(
              boshlangan: sanaMatni(l, Statistika.streakBoshlangan(kunlar, h.bugun)),
              engUzun: l.streakKun(sonFormat(streak.rekord)),
            ),
            const SizedBox(height: 14),
            Text(l.bosqichlar, style: AppText.h3.copyWith(color: c.matn)),
            const SizedBox(height: 14),
            for (final (i, b) in Statistika.bosqichlar(rekord: streak.rekord, streak: streak.joriy).indexed) ...[
              if (i > 0) const SizedBox(height: 10),
              _BosqichQatori(bosqich: b),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.fon,
      body: OsmonEkran(
        vaqt: OsmonVaqt.shom,
        oysiz: true,
        yuqoriBalandlik: 52,
        yuqori: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l.ketmaKetlik, style: AppText.h1.copyWith(color: c.matn)),
                ),
              ),
              IkonkaTugma(
                ikonka: 'assets/svg/icon_plus.svg',
                burchak: -math.pi / 4,
                izoh: l.yopish,
                onTap: () => context.pop(),
              ),
            ],
          ),
        ),
        child: tana,
      ),
    );
  }
}

class _Qahramon extends StatelessWidget {
  const _Qahramon({required this.streak, required this.bugunHisoblangan});

  final int streak;
  final bool bugunHisoblangan;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    // Streak 0: olov kulrang (`matn3`), Figma'dagi kulrang olovlar kabi tekis.
    final olov = SvgPicture.asset(
      'assets/svg/qahramon_olov.svg',
      excludeFromSemantics: true,
      width: 110.4,
      height: 121.44,
      colorFilter: streak == 0 ? ColorFilter.mode(c.matn3, BlendMode.srcIn) : null,
    );

    return Column(
      children: [
        ExcludeSemantics(child: olov),
        Text(sonFormat(streak), style: AppText.qahramon.copyWith(color: c.olov)),
        Text(
          streak == 0 ? l.streakBoshlang : l.kunKetmaKet,
          textAlign: TextAlign.center,
          style: AppText.h2.copyWith(color: c.olov),
        ),
        if (streak > 0 && !bugunHisoblangan) ...[
          const SizedBox(height: 4),
          Text(l.streakBugunHali, style: AppText.matn.copyWith(color: c.matn2)),
        ],
      ],
    );
  }
}

class _OdatKarta extends StatelessWidget {
  const _OdatKarta({required this.streak, required this.odat});

  final int streak;
  final OdatMaqsadi odat;

  static const _belgi = 32.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.chiziq),
        boxShadow: AppShadows.karta,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.odatSarlavha(sonFormat(odat.maqsad)), style: AppText.h3.copyWith(color: c.matn)),
              ),
              Text(
                l.odatHolat(sonFormat(streak), sonFormat(odat.maqsad)),
                style: AppText.kichik.copyWith(color: c.matn2),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, chegara) {
              final w = chegara.maxWidth;
              final ulush = (streak / odat.maqsad).clamp(0.0, 1.0);
              return SizedBox(
                height: _belgi,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 11,
                      height: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: c.chiziq, borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 11,
                      height: 10,
                      width: w * ulush,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(colors: [c.odatBoshi, c.odatOxiri]),
                        ),
                      ),
                    ),
                    for (final b in odat.belgilar)
                      Positioned(
                        // Belgi markazi shkaladagi joyiga to'g'ri keladi, chetdan chiqmaydi.
                        left: (w * b / odat.maqsad - _belgi / 2).clamp(0.0, w - _belgi),
                        top: 0,
                        child: _ShkalaBelgisi(son: b, yetilgan: streak >= b),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ShkalaBelgisi extends StatelessWidget {
  const _ShkalaBelgisi({required this.son, required this.yetilgan});

  final int son;
  final bool yetilgan;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: yetilgan ? c.olov : c.fon,
        shape: BoxShape.circle,
        border: Border.all(color: yetilgan ? c.fon : c.chiziq, width: 2),
        boxShadow: AppShadows.bosqichBelgi,
      ),
      child: Text(sonFormat(son), style: AppText.teg.copyWith(color: yetilgan ? c.fon : c.matn2)),
    );
  }
}

class _Korsatkichlar extends StatelessWidget {
  const _Korsatkichlar({required this.boshlangan, required this.engUzun});

  final String boshlangan;
  final String engUzun;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    Widget ustun(String qiymat, String izoh) => Expanded(
          child: Column(
            children: [
              Text(qiymat, style: AppText.h3.copyWith(color: c.matn)),
              const SizedBox(height: 2),
              Text(izoh, style: AppText.kichik.copyWith(color: c.matn2)),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.chiziq),
        boxShadow: AppShadows.karta,
      ),
      child: Row(
        children: [
          ustun(boshlangan, l.boshlangan),
          Container(width: 1, height: 40, color: c.chiziq),
          ustun(engUzun, l.engUzun),
        ],
      ),
    );
  }
}

class _BosqichQatori extends StatelessWidget {
  const _BosqichQatori({required this.bosqich});

  final Bosqich bosqich;

  static String _nomi(AppLocalizations l, int kun) => switch (kun) {
        7 => l.bosqich7,
        14 => l.bosqich14,
        30 => l.bosqich30,
        60 => l.bosqich60,
        100 => l.bosqich100,
        _ => l.bosqich365,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final yetilgan = bosqich.holat == BosqichHolati.yetilgan;
    final kun = sonFormat(bosqich.kun);
    final matn = bosqich.holat == BosqichHolati.navbatdagi
        ? l.bosqichQoldi(kun, sonFormat(bosqich.qoldi))
        : l.bosqichNomi(kun, _nomi(l, bosqich.kun));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: yetilgan ? c.olovOch : c.fon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: yetilgan ? c.olovChiziq : c.chiziq, width: 1.5),
      ),
      child: Row(
        children: [
          OlovBelgi(rangli: yetilgan, raqam: kun, kichik: true),
          const SizedBox(width: 12),
          Expanded(child: Text(matn, style: AppText.matn.copyWith(color: c.matn))),
          if (yetilgan)
            SvgPicture.asset(
              'assets/svg/icon_belgi.svg',
              excludeFromSemantics: true,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.olov, BlendMode.srcIn),
            ),
        ],
      ),
    );
  }
}
