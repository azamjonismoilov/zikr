import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/db/database.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/bortiq_tugma.dart';
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/maydon.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/rasm_plitka.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tasdiq_dialog.dart';
import '../../counter/domain/sanash.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../../counter/ui/widgets/maqsad_qatori.dart';
import '../../counter/ui/widgets/maxsus_maqsad_paneli.dart';
import '../domain/oz_zikr.dart';

/// O'z zikri qo'shish (Figma 08) yoki [zikrId] berilsa tahrirlash.
class OzZikrEkrani extends ConsumerStatefulWidget {
  const OzZikrEkrani({super.key, this.zikrId});

  final int? zikrId;

  @override
  ConsumerState<OzZikrEkrani> createState() => _OzZikrEkraniState();
}

class _OzZikrEkraniState extends ConsumerState<OzZikrEkrani> {
  static const _tayyorlar = <int?>[33, 99, 100];

  final _nomi = TextEditingController();
  final _arabcha = TextEditingController();
  final _manosi = TextEditingController();
  String _rasm = OzZikr.standartRasm;
  int? _maqsad = 33;

  /// Tahrirlashda boshlang'ich qiymatlar ("o'zgarish bormi" uchun).
  late final OzZikr _boshlangich;
  bool _saqlanmoqda = false;

  ZikrQator? get _tahrirdagi {
    final id = widget.zikrId;
    if (id == null) return null;
    final zikrlar = ref.read(sanagichProvider).value?.zikrlar ?? const [];
    for (final z in zikrlar) {
      if (z.id == id) return z;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final z = _tahrirdagi;
    if (z != null) {
      _nomi.text = z.nomi;
      _arabcha.text = z.arabcha;
      _manosi.text = z.manosi;
      _rasm = z.rasm ?? OzZikr.standartRasm;
      _maqsad = z.maqsad;
    }
    _boshlangich = _qiymat;
    for (final c in [_nomi, _arabcha, _manosi]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nomi.dispose();
    _arabcha.dispose();
    _manosi.dispose();
    super.dispose();
  }

  OzZikr get _qiymat => OzZikr(
        nomi: _nomi.text,
        arabcha: _arabcha.text,
        manosi: _manosi.text,
        rasm: _rasm,
        maqsad: _maqsad,
      );

  bool get _ozgargan {
    final q = _qiymat, b = _boshlangich;
    return q.nomi != b.nomi ||
        q.arabcha != b.arabcha ||
        q.manosi != b.manosi ||
        (widget.zikrId != null && (q.rasm != b.rasm || q.maqsad != b.maqsad));
  }

  Future<bool> _chiqishniTasdiqla() async {
    if (!_ozgargan) return true;
    final l = AppLocalizations.of(context);
    return tasdiqSora(context, sarlavha: l.chiqishSarlavha, matn: l.chiqishMatn, tasdiqMatni: l.chiqish);
  }

  Future<void> _yopish() async {
    if (await _chiqishniTasdiqla() && mounted) context.pop();
  }

  Future<void> _maxsus() async {
    final tanlangan = await maxsusMaqsadSora(
      context,
      joriy: _tayyorlar.contains(_maqsad) ? null : _maqsad,
    );
    if (tanlangan != null) setState(() => _maqsad = tanlangan);
  }

  Future<void> _saqla() async {
    final q = _qiymat;
    if (!q.togri || _saqlanmoqda) return;
    final ctrl = ref.read(sanagichProvider.notifier);
    final l = AppLocalizations.of(context);
    final id = widget.zikrId;

    if (id == null) {
      setState(() => _saqlanmoqda = true);
      await ctrl.ozZikrQosh(q);
      if (mounted) context.go(Yollar.sanagich);
      return;
    }

    // Maqsad o'zgarsa va aylanada son bo'lsa, sanagichdagidek tasdiq so'raladi.
    final h = ref.read(sanagichProvider).requireValue;
    if (q.maqsad != _boshlangich.maqsad && Sanash.maqsadUchunTasdiqKerak(h.oxirgiQatorlar[id])) {
      final ha = await tasdiqSora(
        context,
        sarlavha: l.maqsadTasdiqSarlavha,
        matn: l.maqsadTasdiqMatn,
        tasdiqMatni: l.maqsadTasdiqTugma,
      );
      if (!ha) return;
    }
    setState(() => _saqlanmoqda = true);
    await ctrl.zikrniTahrirla(id, q);
    if (mounted) context.pop();
  }

  Future<void> _ochir() async {
    final id = widget.zikrId;
    if (id == null) return;
    final l = AppLocalizations.of(context);
    final ha = await tasdiqSora(
      context,
      sarlavha: l.ochirishSarlavha,
      matn: l.ochirishMatn,
      tasdiqMatni: l.ochirish,
    );
    if (!ha || !mounted) return;
    setState(() => _saqlanmoqda = true);
    await ref.read(sanagichProvider.notifier).zikrniOchir(id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final tahrir = widget.zikrId != null;
    final saqlashMumkin = _qiymat.togri && !_saqlanmoqda;
    final pastki = math.max(MediaQuery.viewPaddingOf(context).bottom, 16.0);

    return PopScope(
      canPop: !_ozgargan || _saqlanmoqda,
      onPopInvokedWithResult: (chiqdi, _) async {
        if (chiqdi) return;
        if (await _chiqishniTasdiqla() && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: c.fon,
        body: OsmonEkran(
          vaqt: OsmonVaqt.peshin,
          // Sarlavha osmon markazida: tunda oy unga tushmasin.
          oysiz: true,
          yuqoriBalandlik: 52,
          yuqori: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  tahrir ? l.zikrniTahrirlash : l.yangiZikr,
                  style: AppText.h3.copyWith(color: c.matn),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IkonkaTugma(
                    ikonka: 'assets/svg/icon_plus.svg',
                    burchak: -math.pi / 4,
                    izoh: l.yopish,
                    onTap: _yopish,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _SaqlashPill(onTap: saqlashMumkin ? _saqla : null),
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.rasm, style: AppText.kichik.copyWith(color: c.matn2)),
                      const SizedBox(height: 8),
                      _RasmTanlovi(tanlangan: _rasm, onTanlash: (r) => setState(() => _rasm = r)),
                      const SizedBox(height: 16),
                      Maydon(
                        yorliq: l.talaffuzi,
                        controller: _nomi,
                        avtoFokus: !tahrir,
                        formatlar: [LengthLimitingTextInputFormatter(OzZikr.nomiEngKop)],
                      ),
                      const SizedBox(height: 16),
                      Maydon(
                        yorliq: l.arabchaMatn,
                        controller: _arabcha,
                        uslub: AppText.arabMaydon,
                        yonalish: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      Maydon(
                        yorliq: l.manosi,
                        controller: _manosi,
                        formatlar: [LengthLimitingTextInputFormatter(OzZikr.manosiEngKop)],
                      ),
                      const SizedBox(height: 16),
                      Text(l.maqsad, style: AppText.kichik.copyWith(color: c.matn2)),
                      const SizedBox(height: 8),
                      MaqsadQatori(
                        maqsad: _maqsad,
                        tayyorlar: _tayyorlar,
                        onTanlash: (m) => setState(() => _maqsad = m),
                        onMaxsus: _maxsus,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, pastki),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AsosiyTugma(matn: l.saqlash, balandlik: 54, onTap: saqlashMumkin ? _saqla : null),
                    if (tahrir) ...[
                      const SizedBox(height: 8),
                      Semantics(
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _saqlanmoqda ? null : _ochir,
                          child: SizedBox(
                            height: 44,
                            child: Center(
                              child: Text(l.ochirish, style: AppText.tugma.copyWith(color: c.qizil)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tepadagi "Saqlash" pill'i (Figma "Saqlash").
class _SaqlashPill extends StatelessWidget {
  const _SaqlashPill({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.5 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: c.fon,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppShadows.ikonkaTugma,
            ),
            child: Text(l.saqlash, style: AppText.teg.copyWith(color: c.kokChuqur)),
          ),
        ),
      ),
    );
  }
}

String _rasmNomi(AppLocalizations l, String r) => switch (r) {
      'tasbeh' => l.rasmTasbeh,
      'yurak' => l.rasmYurak,
      'yulduz' => l.rasmYulduz,
      'namoz' => l.rasmNamoz,
      'tun' => l.rasmTun,
      'tong' => l.rasmTong,
      'kitob' => l.rasmKitob,
      _ => l.rasm,
    };

/// 7 ta rasm plitkasi; tanlangani `kok` halqa bilan (Figma "Tanlov").
class _RasmTanlovi extends StatelessWidget {
  const _RasmTanlovi({required this.tanlangan, required this.onTanlash});

  final String tanlangan;
  final ValueChanged<String> onTanlash;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final r in OzZikr.rasmlar)
          Semantics(
            button: true,
            selected: r == tanlangan,
            label: _rasmNomi(AppLocalizations.of(context), r),
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTanlash(r),
              child: Container(
                key: ValueKey('rasm_$r'),
                width: 46,
                height: 46,
                // 3 px chegara bolani o'zi ichkariga suradi: plitka 40×40 qoladi.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: r == tanlangan ? c.kok : c.kok.withValues(alpha: 0),
                    width: 3,
                  ),
                ),
                child: RasmPlitka(r, olcham: 40),
              ),
            ),
          ),
      ],
    );
  }
}
