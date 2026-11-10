import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/bortiq_tugma.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tasdiq_dialog.dart';
import '../domain/sanash.dart';
import 'sanagich_controller.dart';
import 'widgets/halqa.dart';
import 'widgets/maqsad_qatori.dart';
import 'widgets/maxsus_maqsad_paneli.dart';

class SanagichEkrani extends ConsumerStatefulWidget {
  const SanagichEkrani({super.key});

  @override
  ConsumerState<SanagichEkrani> createState() => _SanagichEkraniState();
}

class _SanagichEkraniState extends ConsumerState<SanagichEkrani> {
  late final AppLifecycleListener _hayot;

  /// Markaziy tugma animatsiyasi uchun bosishlar hisoblagichi.
  int _bosishlar = 0;

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
    final tugadi = _ctrl.bos();
    setState(() => _bosishlar++);
    if (h.haptik) {
      tugadi ? HapticFeedback.heavyImpact() : HapticFeedback.lightImpact();
    }
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
    final keyingi = h.keyingiZikr;
    // Tab bar kapsulasi (62) + uning ostidagi joy + 16 oraliq (Figma: 103).
    final pastki = 62.0 + math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0) + 16;

    final nollash = _NollashTugma(onTap: _nolla, maqsadQatorida: keyingi == null);

    final ustun = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ZikrBloki(
          arabcha: zikr.arabcha,
          nomi: zikr.talaffuz ?? zikr.nomi,
          manosi: zikr.manosi,
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
                aylanaRaqami: h.aylanaRaqami,
                bosishlar: _bosishlar,
              ),
            ),
            const SizedBox(height: 12),
            Text(l.sanashIshora, style: AppText.kichik.copyWith(color: c.matn3)),
          ],
        ),
        MaqsadQatori(
          maqsad: h.maqsad,
          onTanlash: _maqsadTanla,
          onMaxsus: _maxsus,
          // "Keyingisi" yo'q bo'lsa nollash shu qatorning o'ng chetida, pastki qator yo'q.
          oxiridagi: keyingi == null ? nollash : null,
        ),
        if (keyingi != null)
          _HarakatQatori(
            nollash: nollash,
            keyingiNomi: keyingi.talaffuz ?? keyingi.nomi,
            onKeyingisi: _ctrl.keyingisiga,
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
          _Pill(
            ikonka: 'assets/svg/icon_olov.svg',
            rang: c.olov,
            qiymat: streak,
            izoh: l.streakIzoh(sonFormat(streak)),
          ),
          const SizedBox(width: 8),
          _Pill(
            ikonka: 'assets/svg/icon_tasbeh_kichik.svg',
            rang: c.yashil,
            qiymat: aylanalar,
            izoh: l.aylanalarIzoh(sonFormat(aylanalar)),
          ),
          const Spacer(),
          Semantics(
            button: true,
            toggled: haptik,
            label: haptik ? l.haptikYoqilgan : l.haptikOchirilgan,
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onHaptik,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.fon,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.ikonkaTugma,
                ),
                child: SvgPicture.asset(
                  'assets/svg/icon_tebranish.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(haptik ? c.matn : c.matn3, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.ikonka, required this.rang, required this.qiymat, required this.izoh});

  final String ikonka;
  final Color rang;
  final int qiymat;
  final String izoh;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: izoh,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
        decoration: BoxDecoration(
          color: c.fon,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              ikonka,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(rang, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            Text(sonFormat(qiymat), style: AppText.teg.copyWith(color: c.matn)),
          ],
        ),
      ),
    );
  }
}

class _ZikrBloki extends StatelessWidget {
  const _ZikrBloki({required this.arabcha, required this.nomi, required this.manosi});

  final String arabcha;
  final String nomi;
  final String manosi;

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
        Row(
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
            // Zikr tanlash paneli keyingi topshiriqda; hozircha faqat belgi.
            SvgPicture.asset(
              'assets/svg/icon_pastga.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.matn2, BlendMode.srcIn),
            ),
          ],
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

class _HarakatQatori extends StatelessWidget {
  const _HarakatQatori({
    required this.nollash,
    required this.keyingiNomi,
    required this.onKeyingisi,
  });

  final Widget nollash;
  final String keyingiNomi;
  final VoidCallback onKeyingisi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        nollash,
        const SizedBox(width: 12),
        Expanded(
          child: AsosiyTugma(
            matn: l.keyingisi(keyingiNomi),
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
