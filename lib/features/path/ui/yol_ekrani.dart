import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/db/database.dart';
import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/bortiq_tugma.dart';
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/rasm_plitka.dart';
import '../../../core/widgets/sky_header.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../../library/domain/zikr_holati.dart';
import '../../library/ui/turkum.dart';
import '../../library/ui/widgets/ijro_tugma.dart';
import 'widgets/yol_tugun.dart';

/// Tasbehot yo'li (Figma 03): to'plam qadamlari zigzag yo'l sifatida.
class YolEkrani extends ConsumerWidget {
  const YolEkrani({super.key, required this.toplamId});

  final int toplamId;

  Future<void> _boshla(BuildContext context, WidgetRef ref) async {
    await ref.read(sanagichProvider.notifier).toplamniBoshla(toplamId);
    if (context.mounted) context.go(Yollar.sanagich);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final h = ref.watch(sanagichProvider).value;
    final toplam = h?.toplamById(toplamId);

    Widget tana;
    if (h == null || toplam == null) {
      tana = const SizedBox.shrink();
    } else {
      final yurish = h.yurishlar[toplamId];
      final qadamlar = SanagichHolati.qadamlariniOl(toplam);
      final tugagan = yurish?.qadam ?? 0;
      final joriyIndeks = yurish?.qadam ?? 0;
      final jamiZikr = qadamlar.fold(0, (s, q) => s + q.maqsad);
      final pastki = math.max(MediaQuery.viewPaddingOf(context).bottom, 34.0);

      tana = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              toplam.nomi,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.h2.copyWith(color: c.matn),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BosqichKartasi(
                    yozuv: l.bugunMarta(sonFormat(h.bugunTugaganlar(toplamId) + 1)),
                    sarlavha: l.tasbehotZikr(sonFormat(jamiZikr)),
                    tugagan: tugagan,
                    jami: qadamlar.length,
                  ),
                  const SizedBox(height: 64),
                  _Yol(
                    tugunlar: [
                      for (final (i, q) in qadamlar.indexed)
                        _TugunMalumoti(
                          holat: i < joriyIndeks
                              ? TugunHolati.bajarildi
                              : i == joriyIndeks
                                  ? TugunHolati.joriy
                                  : TugunHolati.yangi,
                          yorliq: _yorliq(l, h.zikrById(q.zikrId), q.maqsad,
                              i == joriyIndeks ? yurish?.son ?? 0 : null),
                        ),
                    ],
                    onJoriy: () => _boshla(context, ref),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, pastki),
            child: AsosiyTugma(
              matn: yurish == null ? l.boshlash : l.davomEtish,
              balandlik: 54,
              onTap: () => _boshla(context, ref),
            ),
          ),
        ],
      );
    }

    final tugagan = h?.yurishlar[toplamId]?.qadam ?? 0;
    final jami = toplam?.qadamlar.length ?? 0;
    return Scaffold(
      backgroundColor: c.fon,
      body: OsmonEkran(
        vaqt: OsmonVaqt.peshin,
        // Sarlavha osmon markazida: tunda oy unga tushmasin.
        oysiz: true,
        yuqoriBalandlik: 52,
        fon: const _FonDoiralar(),
        yuqori: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              IkonkaTugma(
                ikonka: 'assets/svg/icon_plus.svg',
                burchak: -math.pi / 4,
                izoh: l.yopish,
                onTap: () => context.pop(),
              ),
              const Spacer(),
              if (toplam != null) _HolatPill(tugagan: tugagan, jami: jami),
            ],
          ),
        ),
        child: tana,
      ),
    );
  }

  static String _yorliq(AppLocalizations l, ZikrQator? z, int maqsad, int? son) {
    final nomi = z?.korinishNomi ?? '';
    return son == null
        ? l.tugunYorliq(nomi, sonFormat(maqsad))
        : l.tugunJoriy(nomi, sonFormat(son), sonFormat(maqsad));
  }
}

/// O'ngdagi "{tugagan} / {jami}" belgisi (Figma "Pill").
class _HolatPill extends StatelessWidget {
  const _HolatPill({required this.tugagan, required this.jami});

  final int tugagan;
  final int jami;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 5, 6, 5),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.yolHolati(sonFormat(tugagan), sonFormat(jami)), style: AppText.teg.copyWith(color: c.matn)),
          const SizedBox(width: 8),
          SizedBox(
            width: 26,
            height: 26,
            child: FittedBox(
              child: IjroTugma(tugagan > 0 ? ZikrHolati.bajarildi : ZikrHolati.yangi),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bosqich kartasi: rasm, "Bugun n-marta", sarlavha va tugagan qadamlar halqasi.
class _BosqichKartasi extends StatelessWidget {
  const _BosqichKartasi({
    required this.yozuv,
    required this.sarlavha,
    required this.tugagan,
    required this.jami,
  });

  final String yozuv;
  final String sarlavha;
  final int tugagan;
  final int jami;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.chiziq),
        boxShadow: AppShadows.karta,
      ),
      child: Row(
        children: [
          const RasmPlitka('namoz', olcham: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(yozuv, style: AppText.kichik.copyWith(color: c.kok)),
                const SizedBox(height: 2),
                Text(
                  sarlavha,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h3.copyWith(color: c.matn),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 44,
            height: 44,
            child: CustomPaint(
              painter: _KichikHalqa(
                ulush: jami == 0 ? 0 : tugagan / jami,
                yol: c.chiziq,
                rang: c.yashil,
              ),
              child: Center(
                child: Text(sonFormat(tugagan), style: AppText.h3.copyWith(color: c.matn)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KichikHalqa extends CustomPainter {
  _KichikHalqa({required this.ulush, required this.yol, required this.rang});

  final double ulush;
  final Color yol;
  final Color rang;

  static const _qalinlik = 4.4;

  @override
  void paint(Canvas canvas, Size size) {
    final markaz = size.center(Offset.zero);
    final radius = (size.shortestSide - _qalinlik) / 2;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _qalinlik;
    canvas.drawCircle(markaz, radius, p..color = yol);
    if (ulush > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: markaz, radius: radius),
        -math.pi / 2,
        2 * math.pi * ulush,
        false,
        p
          ..color = rang
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_KichikHalqa eski) => eski.ulush != ulush || eski.yol != yol || eski.rang != rang;
}

class _TugunMalumoti {
  const _TugunMalumoti({required this.holat, required this.yorliq});

  final TugunHolati holat;
  final String yorliq;
}

/// Zigzag yo'l (Figma "Yol"): tugunlar orasi 104 px, markazdan siljishlar takrorlanadi.
class _Yol extends StatelessWidget {
  const _Yol({required this.tugunlar, required this.onJoriy});

  final List<_TugunMalumoti> tugunlar;
  final VoidCallback onJoriy;

  /// Tugun markazining yo'l markazidan gorizontal siljishi (Figma: +17, +83, +17, −55).
  static const _siljishlar = [17.0, 83.0, 17.0, -55.0];
  static const _qadam = 104.0;
  static const _yorliqKengligi = 180.0;

  /// Joriy tugun yorlig'ining qator balandligi (`AppText.h3`).
  static const _yorliqQatori = 21.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    // Katta shriftda yorliq balandlashadi: tugunlar orasi va maslahat shuncha pastga suriladi.
    final ortiqcha = MediaQuery.textScalerOf(context).scale(_yorliqQatori) - _yorliqQatori;
    final qadam = _qadam + ortiqcha;
    final balandlik = tugunlar.isEmpty ? 0.0 : (tugunlar.length - 1) * qadam + 98 + ortiqcha;

    return LayoutBuilder(
      builder: (context, chegara) {
        final markaz = chegara.maxWidth / 2;
        return SizedBox(
          height: math.max(balandlik, 217),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Figma: maslahat kartasi chap chetda, ikkinchi tugun balandligida.
              Positioned(left: 0, top: 92 + ortiqcha, width: 150, child: _Maslahat(matn: l.maslahatTasbehot)),
              for (final (i, t) in tugunlar.indexed)
                Positioned(
                  top: i * qadam,
                  left: markaz + _siljishlar[i % _siljishlar.length] - _yorliqKengligi / 2,
                  width: _yorliqKengligi,
                  child: _Tugun(
                    malumot: t,
                    onTap: t.holat == TugunHolati.joriy ? onJoriy : null,
                    rang: switch (t.holat) {
                      TugunHolati.joriy => c.kokChuqur,
                      TugunHolati.bajarildi => c.matn,
                      TugunHolati.yangi => c.matn2,
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Tugun extends StatelessWidget {
  const _Tugun({required this.malumot, required this.onTap, required this.rang});

  final _TugunMalumoti malumot;
  final VoidCallback? onTap;
  final Color rang;

  @override
  Widget build(BuildContext context) {
    final joriy = malumot.holat == TugunHolati.joriy;
    return Semantics(
      button: onTap != null,
      label: malumot.yorliq,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YolTugun(malumot.holat),
            const SizedBox(height: 4),
            // Katta shriftda kesilmaydi va qo'shni tugunga chiqmaydi: bir qatorda kichrayadi.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                malumot.yorliq,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: (joriy ? AppText.h3 : AppText.kichik).copyWith(color: rang),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Maslahat extends StatelessWidget {
  const _Maslahat({required this.matn});

  final String matn;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.kok, width: 1.5),
        boxShadow: AppShadows.karta,
      ),
      child: Text(matn, style: AppText.kichik.copyWith(color: c.matn)),
    );
  }
}

/// Uch fon doirasi (Figma "FonDoira"), ekran tepasidan o'lchanadi.
class _FonDoiralar extends StatelessWidget {
  const _FonDoiralar();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, chegara) {
        // Figma 390 kenglikda: o'ngdagilar o'ng chetga, chapdagi chap chetga bog'lanadi.
        final ong = chegara.maxWidth - 390;
        Widget doira(double left, double top, double olcham, Color rang) => Positioned(
              left: left,
              top: top,
              width: olcham,
              height: olcham,
              child: DecoratedBox(decoration: BoxDecoration(color: rang, shape: BoxShape.circle)),
            );
        return ClipRect(
          child: Stack(
            children: [
              doira(170 + ong, 330, 420, c.kokOch),
              doira(260 + ong, 420, 240, c.kokOch),
              doira(-170, 260, 300, c.fon2),
            ],
          ),
        );
      },
    );
  }
}
