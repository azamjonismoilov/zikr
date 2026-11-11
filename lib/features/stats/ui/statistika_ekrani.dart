import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/db/database.dart';
import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/pastki_panel.dart';
import '../../../core/widgets/rasm_plitka.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tanlov_qatori.dart';
import '../../counter/domain/kun.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../../library/ui/turkum.dart';
import '../domain/statistika.dart';
import 'stat_matnlar.dart';
import 'widgets/hafta_belgi.dart';

class StatistikaEkrani extends ConsumerWidget {
  const StatistikaEkrani({super.key});

  Future<void> _davrniTanla(BuildContext context, WidgetRef ref, int joriy) async {
    final l = AppLocalizations.of(context);
    final tanlangan = await pastkiPanelOch<int>(
      context,
      sarlavha: l.davrSarlavha,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final n in const [7, 30]) ...[
            TanlovQatori(
              matn: l.davrKun(sonFormat(n)),
              tanlangan: n == joriy,
              onTap: () => Navigator.of(context).pop(n),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
    if (tanlangan != null) ref.read(sanagichProvider.notifier).davrniOrnat(tanlangan);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final h = ref.watch(sanagichProvider).value;

    return OsmonEkran(
      vaqt: OsmonVaqt.peshin,
      yuqori: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l.sarlavhaStatistika,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h1.copyWith(color: c.matn),
                ),
              ),
            ),
            if (h != null)
              _DavrTugma(
                matn: l.davrKun(sonFormat(h.statistikaDavri)),
                onTap: () => _davrniTanla(context, ref, h.statistikaDavri),
              ),
          ],
        ),
      ),
      child: h == null ? const SizedBox.shrink() : _kontent(context, h),
    );
  }

  Widget _kontent(BuildContext context, SanagichHolati h) {
    final kunlar = h.hisoblanganKunlar;
    final streak = h.streak.joriy;
    final jamlar = Statistika.jamlar(h.yigindilar, h.bugun);
    final davr = h.statistikaDavri;
    final tartiblar = {for (final z in h.zikrlar) z.id: z.tartib};
    final engKop = Statistika.engKop(h.zikrKunlari, tartiblar, h.bugun, davr);
    final qator = Statistika.kunlikQator(h.yigindilar, h.bugun, davr);
    // Kapsula tab bar (62) + uning ostidagi joy + 16: oxirgi karta tab bar ostida qolmaydi.
    final pastki = 62.0 + math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0) + 16;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, pastki),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StreakKarta(
            streak: streak,
            bugunHisoblangan: kunlar.contains(h.bugun),
            hafta: Statistika.haftaHolati(kunlar, h.bugun),
            onTap: () => context.push(Yollar.ketmaKetlik),
          ),
          const SizedBox(height: 10),
          _RaqamKartalari(jamlar: jamlar),
          const SizedBox(height: 10),
          _EngKopKarta(
            qatorlar: [
              for (final q in engKop)
                if (h.zikrById(q.zikrId) case final z?) (zikr: z, jami: q.jami),
            ],
          ),
          const SizedBox(height: 10),
          _GrafikKarta(qator: qator, bugun: h.bugun),
        ],
      ),
    );
  }
}

/// Karta umumiy bezagi: `fon`, `chiziq` chegara, radius 20, karta soyasi.
BoxDecoration _kartaBezagi(AppColors c, {Gradient? gradient}) => BoxDecoration(
      color: gradient == null ? c.fon : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.chiziq),
      boxShadow: AppShadows.karta,
    );

class _DavrTugma extends StatelessWidget {
  const _DavrTugma({required this.matn, required this.onTap});

  final String matn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
          decoration: BoxDecoration(
            color: c.fon,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(matn, style: AppText.teg.copyWith(color: c.matn)),
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/svg/icon_pastga.svg',
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(c.matn2, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakKarta extends StatelessWidget {
  const _StreakKarta({
    required this.streak,
    required this.bugunHisoblangan,
    required this.hafta,
    required this.onTap,
  });

  final int streak;
  final bool bugunHisoblangan;
  final List<({Kun kun, HaftaBelgisi belgi})> hafta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final izoh = streak == 0
        ? l.streakBoshlang
        : !bugunHisoblangan
            ? l.streakBugunHali
            : l.streakDavom;

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: _kartaBezagi(
            c,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [c.streakKartaYuqori, c.streakKartaPast],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const RasmPlitka('olov', olcham: 60),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.streakKun(sonFormat(streak)), style: AppText.h1.copyWith(color: c.matn)),
                        const SizedBox(height: 2),
                        Text(izoh, style: AppText.kichik.copyWith(color: c.matn2)),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/icon_ongga.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(c.matn3, BlendMode.srcIn),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final k in hafta)
                    Column(
                      children: [
                        HaftaBelgi(k.belgi),
                        const SizedBox(height: 5),
                        Text(
                          haftaKuniNomi(l, k.kun.haftaKuni),
                          style: AppText.teg.copyWith(
                            color: k.belgi == HaftaBelgisi.bugunKutilmoqda ? c.kok : c.matn2,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RaqamKartalari extends StatelessWidget {
  const _RaqamKartalari({required this.jamlar});

  final Jamlar jamlar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    Widget karta(String ikonka, Color fon, Color rang, int son, String yorliq) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: _kartaBezagi(c),
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: fon, borderRadius: BorderRadius.circular(10)),
                  child: SvgPicture.asset(
                    ikonka,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(rang, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(qisqaSon(l, son), maxLines: 1, style: AppText.h2.copyWith(color: c.matn)),
                ),
                Text(
                  yorliq,
                  textAlign: TextAlign.center,
                  style: AppText.kichik.copyWith(color: c.matn2),
                ),
              ],
            ),
          ),
        );

    // Uchala karta bir xil balandlikda.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          karta('assets/svg/icon_stat_jami.svg', c.kokOch, c.kok, jamlar.jami, l.jamiZikr),
          const SizedBox(width: 10),
          karta('assets/svg/icon_stat_aylana.svg', c.yashilOch, c.yashilChuqur, jamlar.aylanalar, l.aylana),
          const SizedBox(width: 10),
          karta('assets/svg/icon_stat_bugun.svg', c.olovOch, c.olov, jamlar.bugun, l.bugun),
        ],
      ),
    );
  }
}

class _EngKopKarta extends StatelessWidget {
  const _EngKopKarta({required this.qatorlar});

  final List<({ZikrQator zikr, int jami})> qatorlar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final engKatta = qatorlar.isEmpty ? 1 : qatorlar.first.jami;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _kartaBezagi(c),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.engKopAytilgan, style: AppText.h3.copyWith(color: c.matn)),
          const SizedBox(height: 16),
          if (qatorlar.isEmpty)
            Text(l.davrdaBosh, style: AppText.matn.copyWith(color: c.matn2))
          else
            for (final (i, q) in qatorlar.indexed) ...[
              if (i > 0) const SizedBox(height: 16),
              Row(
                children: [
                  RasmPlitka(q.zikr.rasm, olcham: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                q.zikr.korinishNomi,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.matn.copyWith(color: c.matn),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(sonFormat(q.jami), style: AppText.teg.copyWith(color: c.matn2)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _Shkala(ulush: q.jami / engKatta),
                      ],
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }
}

class _Shkala extends StatelessWidget {
  const _Shkala({required this.ulush});

  final double ulush;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: c.chiziq)),
            FractionallySizedBox(
              widthFactor: ulush.clamp(0.0, 1.0),
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: c.yashil, borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Oxirgi 7 yoki 30 kun ustunli grafigi (tashqi kutubxonasiz).
class _GrafikKarta extends StatelessWidget {
  const _GrafikKarta({required this.qator, required this.bugun});

  final List<KunJami> qator;
  final Kun bugun;

  static const _engBaland = 64.0;
  static const _engPast = 4.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final jami = qator.fold(0, (s, k) => s + k.jami);
    final engKatta = qator.fold(0, (m, k) => math.max(m, k.jami));
    final yetti = qator.length <= 7;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _kartaBezagi(c),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.oxirgiKun(sonFormat(qator.length)), style: AppText.h3.copyWith(color: c.matn)),
              ),
              Text(l.davrJami(sonFormat(jami)), style: AppText.h3.copyWith(color: c.kokChuqur)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: yetti ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: [
              for (final (i, k) in qator.indexed)
                _ustun(
                  context,
                  k,
                  balandlik: engKatta == 0
                      ? _engPast
                      : math.max(_engPast, _engBaland * k.jami / engKatta),
                  bugunmi: k.kun == bugun,
                  // 30 kunda yozuv har 5-kunda (bugundan orqaga sanab).
                  yorliq: yetti
                      ? haftaKuniNomi(l, k.kun.haftaKuni)
                      : (qator.length - 1 - i) % 5 == 0
                          ? '${k.kun.kun}'
                          : null,
                  yetti: yetti,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ustun(
    BuildContext context,
    KunJami k, {
    required double balandlik,
    required bool bugunmi,
    required String? yorliq,
    required bool yetti,
  }) {
    final c = context.colors;
    final ustun = Container(
      width: yetti ? 28 : null,
      height: balandlik,
      margin: yetti ? null : const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: bugunmi ? c.kok : c.kokOch,
        borderRadius: BorderRadius.circular(yetti ? 8 : 3),
      ),
    );
    final matn = SizedBox(
      height: 16,
      child: yorliq == null
          ? null
          : OverflowBox(
              maxWidth: 40,
              child: Text(
                yorliq,
                textAlign: TextAlign.center,
                style: AppText.teg.copyWith(color: bugunmi ? c.matn : c.matn3),
              ),
            ),
    );
    final ustunVaYozuv = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ustun, const SizedBox(height: 6), matn],
    );
    final izohli = Semantics(
      label: '${yorliq ?? ''} ${sonFormat(k.jami)}',
      excludeSemantics: true,
      child: ustunVaYozuv,
    );
    // Expanded to'g'ridan-to'g'ri Row ichida bo'lishi kerak.
    return yetti ? SizedBox(width: 28, child: izohli) : Expanded(child: izohli);
  }
}
