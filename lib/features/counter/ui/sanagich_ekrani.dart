import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/bortiq_tugma.dart';
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tasdiq_dialog.dart';
import '../../library/ui/turkum.dart';
import '../../library/ui/zikr_tanlash_paneli.dart';
import '../../path/domain/tabrik.dart';
import '../domain/sanash.dart';
import 'sanagich_controller.dart';
import 'widgets/halqa.dart';
import 'widgets/maqsad_qatori.dart';
import 'widgets/maxsus_maqsad_paneli.dart';
import 'widgets/tabrik_modali.dart';

class SanagichEkrani extends ConsumerStatefulWidget {
  const SanagichEkrani({super.key});

  @override
  ConsumerState<SanagichEkrani> createState() => _SanagichEkraniState();
}

class _SanagichEkraniState extends ConsumerState<SanagichEkrani> {
  late final AppLifecycleListener _hayot;

  /// Markaziy tugma animatsiyasi uchun bosishlar hisoblagichi.
  int _bosishlar = 0;

  /// Aylana (qadam) tugashlari: halqa yonishi uchun.
  int _aylanalar = 0;

  final _halqaKalit = GlobalKey();
  final _fonKalit = GlobalKey();

  /// Halqa markazi fon qatlami koordinatalarida (fon doiralari shunga bog'lanadi).
  final _halqaMarkazi = ValueNotifier<Offset?>(null);

  SanagichController get _ctrl => ref.read(sanagichProvider.notifier);

  @override
  void initState() {
    super.initState();
    _hayot = AppLifecycleListener(onResume: () => _ctrl.kunniYangila());
  }

  @override
  void dispose() {
    _hayot.dispose();
    _halqaMarkazi.dispose();
    super.dispose();
  }

  void _bos() {
    final h = ref.read(sanagichProvider).value;
    if (h == null) return;
    final hodisa = _ctrl.bos();
    setState(() {
      _bosishlar++;
      if (hodisa.aylanaTugadi) _aylanalar++;
    });
    final tabrik = hodisa.tabrik;
    if (tabrik != null) {
      _tabrikniKorsat(tabrik); // kuchli haptik modal bilan birga
    } else if (h.haptik) {
      hodisa.aylanaTugadi ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
    }
  }

  Future<void> _tabrikniKorsat(Tabrik tabrik) async {
    final h = ref.read(sanagichProvider).requireValue;
    final zikr = h.zikrById(tabrik.zikrId) ?? h.zikr;
    final tanlov = await tabrikModaliniOch(context, tabrik: tabrik, zikr: zikr, haptik: h.haptik);
    if (!mounted || tanlov != TabrikTanlovi.ikkinchi) return;
    if (tabrik.turi == TabrikTuri.toplamTugadi) {
      await _ctrl.toplamniBoshla(tabrik.toplamId!); // "Yana bir marta"
    } else if (mounted) {
      await zikrTanlashPaneliniOch(context); // "Boshqa zikr tanlash"
    }
  }

  void _qadamniOtkaz() {
    final tabrik = _ctrl.qadamniOtkaz();
    if (tabrik != null) _tabrikniKorsat(tabrik);
  }

  Future<void> _maqsadTanla(int? maqsad) async {
    final h = ref.read(sanagichProvider).requireValue;
    if (h.maqsad == maqsad) return;
    if (Sanash.maqsadUchunTasdiqKerak(h.oxirgiQatorlar[h.joriyZikrId])) {
      final l = AppLocalizations.of(context);
      final ha = await tasdiqSora(
        context,
        sarlavha: l.maqsadTasdiqSarlavha,
        matn: l.maqsadTasdiqMatn,
        tasdiqMatni: l.maqsadTasdiqTugma,
      );
      if (!ha) return;
    }
    _ctrl.maqsadniOrnat(maqsad);
  }

  Future<void> _maxsus() async {
    final joriy = ref.read(sanagichProvider).requireValue.maqsad;
    final tanlangan = await maxsusMaqsadSora(
      context,
      joriy: tayyorMaqsadlar.contains(joriy) ? null : joriy,
    );
    if (tanlangan != null && mounted) await _maqsadTanla(tanlangan);
  }

  Future<void> _nolla() async {
    final h = ref.read(sanagichProvider).requireValue;
    if (h.son == 0) return;
    final l = AppLocalizations.of(context);
    final ha = await tasdiqSora(
      context,
      sarlavha: l.nollashSarlavha,
      matn: l.nollashMatn(sonFormat(h.son)),
      tasdiqMatni: l.nollashTugma,
    );
    if (ha) _ctrl.nolla();
  }

  /// Layout'dan keyin halqa markazini fon qatlamiga nisbatan o'lchaydi.
  void _markazniOlcha() {
    final halqa = _halqaKalit.currentContext?.findRenderObject() as RenderBox?;
    final fon = _fonKalit.currentContext?.findRenderObject() as RenderBox?;
    if (halqa == null || fon == null || !halqa.attached || !fon.attached) return;
    _halqaMarkazi.value = fon.globalToLocal(halqa.localToGlobal(HalqaTugma.markaz));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _markazniOlcha());
    final holat = ref.watch(sanagichProvider);
    final h = holat.value;

    return OsmonEkran(
      vaqt: OsmonVaqt.peshin,
      yuqoriBalandlik: 52,
      fon: _FonDoiralar(key: _fonKalit, markaz: _halqaMarkazi),
      yuqori: h == null
          ? null
          : _YuqoriQator(
              streak: h.streak.joriy,
              aylanalar: h.bugunTugaganAylanalar,
              haptik: h.haptik,
              onHaptik: _ctrl.haptikniAlmashtir,
            ),
      child: h == null ? const SizedBox.shrink() : _kontent(context, h),
    );
  }

  Widget _kontent(BuildContext context, SanagichHolati h) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final zikr = h.zikr;
    final toplam = h.toplam;
    final yurish = h.yurish;
    // Tab bar kapsulasi (62) + uning ostidagi joy + 16 oraliq (Figma: 103).
    final pastki = 62.0 + math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0) + 16;

    // Alohida rejimda nollash maqsad qatorida; to'plam rejimida pastki qatorda.
    final nollash = _NollashTugma(onTap: _nolla, maqsadQatorida: toplam == null);
    final String? teg;
    if (toplam != null && yurish != null) {
      teg = l.toplamTeg(sonFormat(yurish.qadam + 1), sonFormat(toplam.qadamlar.length));
    } else {
      teg = h.maqsad == null ? null : l.aylanaTeg(sonFormat(h.aylanaRaqami));
    }
    final keyingi = h.keyingiQadamZikri;

    final ustun = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ZikrBloki(
          arabcha: zikr.arabcha,
          nomi: zikr.korinishNomi,
          manosi: zikr.manosi,
          onNomi: () => zikrTanlashPaneliniOch(context),
        ),
        Column(
          children: [
            Semantics(
              button: true,
              label: l.sanashIzoh(sonFormat(h.son)),
              onTap: _bos,
              excludeSemantics: true,
              child: HalqaTugma(
                key: _halqaKalit,
                son: h.son,
                maqsad: h.maqsad,
                teg: teg,
                bosishlar: _bosishlar,
                aylanalar: _aylanalar,
              ),
            ),
            const SizedBox(height: 12),
            Text(l.sanashIshora, style: AppText.kichik.copyWith(color: c.matn3)),
          ],
        ),
        if (toplam == null)
          MaqsadQatori(
            maqsad: h.maqsad,
            onTanlash: _maqsadTanla,
            onMaxsus: _maxsus,
            oxiridagi: nollash,
          )
        else
          _HarakatQatori(
            nollash: nollash,
            // Oxirgi qadamda "Tugatish".
            matn: keyingi == null ? l.tugatish : l.keyingisi(keyingi.korinishNomi),
            onKeyingisi: _qadamniOtkaz,
          ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _bos,
      child: NotificationListener<ScrollNotification>(
        // Past ekranlarda kontent aylantirilsa, fon doiralari halqaga ergashadi.
        onNotification: (_) {
          _markazniOlcha();
          return false;
        },
        child: LayoutBuilder(
          builder: (context, chegara) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: chegara.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, pastki),
                  child: ustun,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ekran ortidagi ikki yumshoq doira (Figma "FonDoira").
///
/// Figma'da ikkalasining markazi halqa markazidan [_pastga] px pastda, gorizontal markazda.
/// Osmon ortida turishi uchun fon qatlamida chiziladi va halqaning o'lchangan joyiga ergashadi.
class _FonDoiralar extends StatelessWidget {
  const _FonDoiralar({super.key, required this.markaz});

  final ValueListenable<Offset?> markaz;

  static const _pastga = 186.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRect(
      child: ValueListenableBuilder<Offset?>(
        valueListenable: markaz,
        builder: (context, m, _) {
          if (m == null) return const SizedBox.expand();
          final y = m.dy + _pastga;
          Widget doira(String nom, double olcham, Color rang) => Positioned(
                key: ValueKey(nom),
                left: m.dx - olcham / 2,
                top: y - olcham / 2,
                width: olcham,
                height: olcham,
                child: DecoratedBox(decoration: BoxDecoration(color: rang, shape: BoxShape.circle)),
              );
          return Stack(
            children: [
              doira('fonDoira1', 560, c.kokOch),
              doira('fonDoira2', 400, c.fon2),
            ],
          );
        },
      ),
    );
  }
}

class _YuqoriQator extends StatelessWidget {
  const _YuqoriQator({
    required this.streak,
    required this.aylanalar,
    required this.haptik,
    required this.onHaptik,
  });

  final int streak;
  final int aylanalar;
  final bool haptik;
  final VoidCallback onHaptik;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          KorsatkichPill(
            ikonka: 'assets/svg/icon_olov.svg',
            rang: c.olov,
            jonli: true,
            qiymat: streak,
            izoh: l.streakIzoh(sonFormat(streak)),
          ),
          const SizedBox(width: 8),
          KorsatkichPill(
            ikonka: 'assets/svg/icon_tasbeh_kichik.svg',
            rang: c.yashil,
            qiymat: aylanalar,
            izoh: l.aylanalarIzoh(sonFormat(aylanalar)),
          ),
          const Spacer(),
          IkonkaTugma(
            ikonka: 'assets/svg/icon_tebranish.svg',
            onTap: onHaptik,
            toggled: haptik,
            izoh: haptik ? l.haptikYoqilgan : l.haptikOchirilgan,
            rang: haptik ? c.matn : c.matn3,
          ),
        ],
      ),
    );
  }
}

class _ZikrBloki extends StatelessWidget {
  const _ZikrBloki({
    required this.arabcha,
    required this.nomi,
    required this.manosi,
    required this.onNomi,
  });

  final String arabcha;
  final String nomi;
  final String manosi;

  /// Nom qatori bosilganda (zikr tanlash paneli). Bu bosish sanalmaydi.
  final VoidCallback onNomi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            arabcha,
            maxLines: 1,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppText.arab.copyWith(color: c.matn),
          ),
        ),
        Semantics(
          button: true,
          hint: AppLocalizations.of(context).zikrniTanlang,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNomi,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    nomi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.h1.copyWith(color: c.matn),
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/svg/icon_pastga.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(c.matn2, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
        Text(
          manosi,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppText.matn.copyWith(color: c.matn2),
        ),
      ],
    );
  }
}

/// To'plam rejimidagi pastki qator: nollash va qadamni o'tkazib yuborish.
class _HarakatQatori extends StatelessWidget {
  const _HarakatQatori({
    required this.nollash,
    required this.matn,
    required this.onKeyingisi,
  });

  final Widget nollash;
  final String matn;
  final VoidCallback onKeyingisi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        nollash,
        const SizedBox(width: 12),
        Expanded(
          child: AsosiyTugma(
            matn: matn,
            onTap: onKeyingisi,
            oxiridagi: SvgPicture.asset(
              'assets/svg/icon_ongga.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.fon, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}

/// Nollash tugmasi. Harakat qatorida 54×52 (Figma), maqsad qatorida chiplar o'lchamida.
class _NollashTugma extends StatelessWidget {
  const _NollashTugma({required this.onTap, required this.maqsadQatorida});

  final VoidCallback onTap;
  final bool maqsadQatorida;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final tun = Theme.of(context).brightness == Brightness.dark;
    return OqTugma(
      radius: maqsadQatorida ? maqsadTugmaRadiusi : 16,
      chuqurlik: maqsadQatorida ? maqsadChuqurligi(tun) : 4,
      onTap: onTap,
      semanticLabel: l.nollashIzoh,
      child: SizedBox(
        width: 54,
        height: maqsadQatorida ? maqsadTugmaBalandligi : 52,
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/icon_qaytarish.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(c.matn, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
