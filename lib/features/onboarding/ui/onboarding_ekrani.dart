import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/platforma/platforma.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/bortiq_tugma.dart';
import '../../../core/widgets/bosish_maydoni.dart';
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/rasm_plitka.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tanlov_karta.dart';
import '../../../core/widgets/vaqt_tanlash.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../../counter/ui/widgets/maxsus_maqsad_paneli.dart';
import '../../settings/domain/eslatma.dart';
import '../domain/onboarding.dart';

/// Birinchi ochilish: xush kelibsiz (Figma 10), kunlik maqsad (Figma 11) va eslatma
/// (Figma'da yo'q, 11 qolipida). Tugagach `onboardingKorildi` yoziladi va router
/// Sanagichga o'tkazadi.
class OnboardingEkrani extends ConsumerStatefulWidget {
  const OnboardingEkrani({super.key});

  @override
  ConsumerState<OnboardingEkrani> createState() => _OnboardingEkraniState();
}

/// 2-qadamdagi "Oʻzim belgilayman" varianti indeksi.
const _ozimIndeks = 3;

enum _EslatmaVariant { ertalab, kechqurun, boshqa, kerakEmas }

class _OnboardingEkraniState extends ConsumerState<OnboardingEkrani> {
  static const _qadamlar = 3;

  int _qadam = 0;

  /// 0–2: `Onboarding.maqsadlar`, 3: o'zi belgilagan son.
  int _maqsadIndeks = Onboarding.maqsadlar.indexOf(Onboarding.standartMaqsad);
  int? _ozimMaqsad;

  _EslatmaVariant _eslatma = _EslatmaVariant.kechqurun;
  int? _boshqaVaqt;
  bool _tugamoqda = false;

  SanagichController get _ctrl => ref.read(sanagichProvider.notifier);

  int get _maqsad => _maqsadIndeks == _ozimIndeks ? _ozimMaqsad! : Onboarding.maqsadlar[_maqsadIndeks];

  int? get _eslatmaDaqiqa => switch (_eslatma) {
    _EslatmaVariant.ertalab => Onboarding.ertalab,
    _EslatmaVariant.kechqurun => Onboarding.kechqurun,
    _EslatmaVariant.boshqa => _boshqaVaqt,
    _EslatmaVariant.kerakEmas => null,
  };

  void _otkazibYubor() {
    _ctrl
      ..kunlikMaqsadniOrnat(Onboarding.otkazibMaqsad)
      ..eslatmaniOrnat(yoniq: false)
      ..onboardingniYakunla();
  }

  Future<void> _ozimniSora() async {
    final l = AppLocalizations.of(context);
    final son = await maxsusMaqsadSora(
      context,
      joriy: _ozimMaqsad,
      sarlavha: l.sozKunlikMaqsad,
      yorliq: l.kunlikMaqsadYorliq,
    );
    if (son != null) {
      setState(() {
        _ozimMaqsad = son;
        _maqsadIndeks = _ozimIndeks;
      });
    }
  }

  Future<void> _boshqaVaqtniSora() async {
    final daqiqa = await vaqtSora(context, _boshqaVaqt ?? Eslatma.standartDaqiqa);
    if (daqiqa != null) {
      setState(() {
        _boshqaVaqt = daqiqa;
        _eslatma = _EslatmaVariant.boshqa;
      });
    }
  }

  void _maqsadniSaqla() {
    _ctrl.kunlikMaqsadniOrnat(_maqsad);
    setState(() => _qadam = 2);
  }

  Future<void> _tayyor() async {
    if (_tugamoqda) return;
    setState(() => _tugamoqda = true);
    final daqiqa = _eslatmaDaqiqa;
    if (daqiqa == null) {
      _ctrl.eslatmaniOrnat(yoniq: false);
    } else {
      // Ruxsat rad etilsa eslatma o'chiq qoladi, onboarding baribir tugaydi.
      final bor = await ref.read(platformaProvider).bildirishnomaRuxsatiniSora();
      if (!mounted) return;
      _ctrl.eslatmaniOrnat(yoniq: bor, daqiqa: daqiqa);
    }
    _ctrl.onboardingniYakunla();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final qadam = switch (_qadam) {
      0 => _XushKelibsiz(onBoshlash: () => setState(() => _qadam = 1), onOtkazib: _otkazibYubor),
      1 => _TanlovQadami(
        key: const ValueKey(1),
        qadam: 2,
        jami: _qadamlar,
        rasm: 'yulduz',
        savol: l.onbMaqsadSavol,
        izoh: l.onbMaqsadIzoh,
        tugma: l.onbDavom,
        onOrqaga: () => setState(() => _qadam = 0),
        onTugma: _maqsadniSaqla,
        variantlar: [
          for (final (i, son) in Onboarding.maqsadlar.indexed)
            TanlovKarta(
              sarlavha: l.onbSon(sonFormat(son)),
              izoh: switch (i) {
                0 => l.onbMaqsadIzoh100,
                1 => l.onbMaqsadIzoh300,
                _ => l.onbMaqsadIzoh1000,
              },
              tanlangan: _maqsadIndeks == i,
              onTap: () => setState(() => _maqsadIndeks = i),
            ),
          TanlovKarta(
            sarlavha: _ozimMaqsad == null ? l.onbOzim : l.onbSon(sonFormat(_ozimMaqsad!)),
            izoh: _ozimMaqsad == null ? l.onbOzimIzoh : l.onbOzim,
            tanlangan: _maqsadIndeks == _ozimIndeks,
            onTap: _ozimniSora,
          ),
        ],
      ),
      _ => _TanlovQadami(
        key: const ValueKey(2),
        qadam: 3,
        jami: _qadamlar,
        rasm: 'tong',
        savol: l.onbEslatmaSavol,
        izoh: l.onbEslatmaIzoh,
        tugma: l.onbTayyor,
        onOrqaga: () => setState(() => _qadam = 1),
        onTugma: _tugamoqda ? null : _tayyor,
        variantlar: [
          TanlovKarta(
            sarlavha: l.onbErtalab(Eslatma.matnga(Onboarding.ertalab)),
            tanlangan: _eslatma == _EslatmaVariant.ertalab,
            onTap: () => setState(() => _eslatma = _EslatmaVariant.ertalab),
          ),
          TanlovKarta(
            sarlavha: l.onbKechqurun(Eslatma.matnga(Onboarding.kechqurun)),
            tanlangan: _eslatma == _EslatmaVariant.kechqurun,
            onTap: () => setState(() => _eslatma = _EslatmaVariant.kechqurun),
          ),
          TanlovKarta(
            sarlavha: _boshqaVaqt == null ? l.onbBoshqaVaqt : l.onbBoshqaVaqtTanlangan(Eslatma.matnga(_boshqaVaqt!)),
            tanlangan: _eslatma == _EslatmaVariant.boshqa,
            onTap: _boshqaVaqtniSora,
          ),
          TanlovKarta(
            sarlavha: l.onbKerakEmas,
            tanlangan: _eslatma == _EslatmaVariant.kerakEmas,
            onTap: () => setState(() => _eslatma = _EslatmaVariant.kerakEmas),
          ),
        ],
      ),
    };

    // Tizimning orqaga imo-ishorasi oldingi qadamga qaytaradi; 1-qadamda ilovadan chiqadi.
    return PopScope(
      canPop: _qadam == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _qadam--);
      },
      child: Scaffold(body: qadam),
    );
  }
}

class _XushKelibsiz extends StatelessWidget {
  const _XushKelibsiz({required this.onBoshlash, required this.onOtkazib});

  final VoidCallback onBoshlash;
  final VoidCallback onOtkazib;

  static const _illyustratsiya = 330.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final tun = Theme.of(context).brightness == Brightness.dark;
    final pastki = math.max(MediaQuery.viewPaddingOf(context).bottom, 34.0);

    return OsmonEkran(
      vaqt: OsmonVaqt.bomdod,
      oysiz: true,
      yuqoriBalandlik: 36,
      yuqori: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: BosishMaydoni(
            child: Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onOtkazib,
                child: Text(l.onbOtkazib, style: AppText.teg.copyWith(color: c.matn2)),
              ),
            ),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, chegara) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: chegara.maxHeight),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 6, 24, pastki),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExcludeSemantics(
                    child: SvgPicture.asset(
                      excludeFromSemantics: true,
                      tun ? 'assets/svg/onboarding_illyustratsiya_tun.svg' : 'assets/svg/onboarding_illyustratsiya.svg',
                      // SVG pastga 3% chiqadi (Figma: halqa soyasi).
                      width: math.min(_illyustratsiya, chegara.maxWidth - 48),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            l.onbSarlavha,
                            textAlign: TextAlign.center,
                            style: AppText.onbSarlavha.copyWith(color: c.matn),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            l.onbMatn,
                            textAlign: TextAlign.center,
                            style: AppText.matn.copyWith(color: c.matn2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _Nuqtalar(faol: 0, jami: 3),
                      ],
                    ),
                  ),
                  AsosiyTugma(
                    matn: l.onbBoshlash,
                    balandlik: 54,
                    onTap: onBoshlash,
                    oxiridagi: _OnggaBelgi(rang: c.fon),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sahifa nuqtalari: faoli 22×8 `kok`, qolganlari 8×8 `chiziq`.
class _Nuqtalar extends StatelessWidget {
  const _Nuqtalar({required this.faol, required this.jami});

  final int faol;
  final int jami;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      label: l.onbQadam('${faol + 1}', '$jami'),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < jami; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Container(
                width: i == faol ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(color: i == faol ? c.kok : c.chiziq, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OnggaBelgi extends StatelessWidget {
  const _OnggaBelgi({required this.rang});

  final Color rang;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    excludeFromSemantics: true,
    'assets/svg/icon_ongga.svg',
    width: 20,
    height: 20,
    colorFilter: ColorFilter.mode(rang, BlendMode.srcIn),
  );
}

/// 2- va 3-qadam qolipi (Figma 11): orqaga, progress, rasm, savol, izoh, variantlar,
/// pastda asosiy tugma.
class _TanlovQadami extends StatelessWidget {
  const _TanlovQadami({
    super.key,
    required this.qadam,
    required this.jami,
    required this.rasm,
    required this.savol,
    required this.izoh,
    required this.variantlar,
    required this.tugma,
    required this.onOrqaga,
    required this.onTugma,
  });

  final int qadam;
  final int jami;
  final String rasm;
  final String savol;
  final String izoh;
  final List<Widget> variantlar;
  final String tugma;
  final VoidCallback onOrqaga;
  final VoidCallback? onTugma;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final pastki = math.max(MediaQuery.viewPaddingOf(context).bottom, 34.0);

    return OsmonEkran(
      vaqt: OsmonVaqt.bomdod,
      oysiz: true,
      yuqoriBalandlik: 52,
      yuqori: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 24, 6),
        child: Row(
          children: [
            IkonkaTugma(ikonka: 'assets/svg/icon_ongga.svg', burchak: math.pi, izoh: l.orqaga, onTap: onOrqaga),
            const SizedBox(width: 14),
            Expanded(
              child: Semantics(
                label: l.onbQadam('$qadam', '$jami'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: [
                        Positioned.fill(child: ColoredBox(color: c.fon.withValues(alpha: 0.85))),
                        FractionallySizedBox(
                          widthFactor: qadam / jami,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: c.kok, borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                children: [
                  RasmPlitka(rasm, olcham: 100),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Semantics(
                      header: true,
                      child: Text(
                        savol,
                        textAlign: TextAlign.center,
                        style: AppText.onbSavol.copyWith(color: c.matn),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    izoh,
                    textAlign: TextAlign.center,
                    style: AppText.kichik.copyWith(color: c.matn2),
                  ),
                  const SizedBox(height: 22),
                  for (final (i, v) in variantlar.indexed) ...[if (i > 0) const SizedBox(height: 10), v],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, pastki),
            child: AsosiyTugma(
              matn: tugma,
              balandlik: 54,
              onTap: onTugma,
              oxiridagi: _OnggaBelgi(rang: c.fon),
            ),
          ),
        ],
      ),
    );
  }
}
