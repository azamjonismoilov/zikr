import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/db/database.dart';
import '../../../core/format/son_format.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/platforma/platforma.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/osmon_toggle.dart';
import '../../../core/widgets/pastki_panel.dart';
import '../../../core/widgets/sky_header.dart';
import '../../../core/widgets/tanlov_qatori.dart';
import '../../../core/widgets/tasdiq_dialog.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../../counter/ui/widgets/maxsus_maqsad_paneli.dart';
import '../data/zaxira.dart';
import '../domain/eslatma.dart';
import '../domain/mavzu.dart';

final _versiyaProvider = FutureProvider<String>((ref) => ref.read(platformaProvider).ilovaVersiyasi());

class SozlamalarEkrani extends ConsumerWidget {
  const SozlamalarEkrani({super.key});

  static const kunlikTayyorlar = [100, 300, 1000];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final h = ref.watch(sanagichProvider).value;
    final ctrl = ref.read(sanagichProvider.notifier);
    final platforma = ref.read(platformaProvider);
    final versiya = ref.watch(_versiyaProvider).value;
    // Kapsula tab bar (62) + uning ostidagi joy + 16: oxirgi qator tab bar ostida qolmaydi.
    final pastki = 62.0 + math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0) + 16;

    Widget tana = const SizedBox.shrink();
    if (h != null) {
      tana = SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 24, 16, pastki),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Guruh(
              nomi: l.guruhSanash,
              qatorlar: [
                _Qator(
                  ikonka: 'tebranish',
                  rang: c.kok,
                  nomi: l.sozTebranish,
                  oxiri: OsmonToggle(yoniq: h.haptik, onChanged: (_) => ctrl.haptikniAlmashtir()),
                ),
                _Qator(
                  ikonka: 'ovoz',
                  rang: c.binafsha,
                  nomi: l.sozTovush,
                  oxiri: OsmonToggle(yoniq: h.tovush, onChanged: (_) => ctrl.tovushniAlmashtir()),
                ),
                if (platforma.android)
                  _Qator(
                    ikonka: 'telefon',
                    rang: c.yashil,
                    nomi: l.sozOvozTugmasi,
                    oxiri: OsmonToggle(
                      yoniq: h.ovozTugmasi,
                      onChanged: (_) => ctrl.ovozTugmasiniAlmashtir(),
                    ),
                  ),
                _Qator(
                  ikonka: 'qulf',
                  rang: c.sariq,
                  nomi: l.sozEkranYoniq,
                  oxiri: OsmonToggle(yoniq: h.ekranYoniq, onChanged: (_) => ctrl.ekranYoniqniAlmashtir()),
                ),
                _Qator(
                  ikonka: 'olov',
                  rang: c.olov,
                  nomi: l.sozKunlikMaqsad,
                  qiymat: sonFormat(h.kunlikMaqsad),
                  onTap: () => _kunlikMaqsad(context, ref, h.kunlikMaqsad),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Guruh(
              nomi: l.guruhIlova,
              qatorlar: [
                _Qator(
                  ikonka: 'oy',
                  rang: c.kokChuqur,
                  nomi: l.sozMavzu,
                  qiymat: _mavzuNomi(l, h.mavzu),
                  onTap: () => _mavzuTanla(context, ref, h.mavzu),
                ),
                _Qator(
                  ikonka: 'qongiroq',
                  rang: c.sariq,
                  nomi: l.sozEslatma,
                  qiymat: h.eslatmaYoniq ? Eslatma.matnga(h.eslatmaDaqiqa) : l.ochiq,
                  onTap: () => pastkiPanelOch<void>(
                    context,
                    sarlavha: l.sozEslatma,
                    builder: (_) => const _EslatmaPaneli(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Guruh(
              nomi: l.guruhMalumotlar,
              qatorlar: [
                _Qator(
                  ikonka: 'yuklash',
                  rang: c.kok,
                  nomi: l.sozZaxiraOlish,
                  strelka: true,
                  onTap: () => _zaxiraOl(ref),
                ),
                _Qator(
                  ikonka: 'qaytarish',
                  rang: c.yashil,
                  nomi: l.sozZaxiradanTiklash,
                  strelka: true,
                  onTap: () => _tikla(context, ref),
                ),
                _Qator(
                  ikonka: 'savat',
                  rang: c.qizil,
                  nomi: l.sozNollash,
                  nomiRangi: c.qizil,
                  strelka: true,
                  onTap: () => _nolla(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/sozlama_qalqon.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(c.yashil, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l.maxfiylik, style: AppText.kichik.copyWith(color: c.matn2))),
                ],
              ),
            ),
            if (versiya != null) ...[
              const SizedBox(height: 12),
              Text(
                l.ilovaVersiyasi(versiya),
                textAlign: TextAlign.center,
                style: AppText.kichik.copyWith(color: c.matn3),
              ),
            ],
          ],
        ),
      );
    }

    return OsmonEkran(
      vaqt: OsmonVaqt.shom,
      sarlavha: l.sarlavhaSozlamalar,
      child: tana,
    );
  }

  static String _mavzuNomi(AppLocalizations l, Mavzu m) => switch (m) {
        Mavzu.tizim => l.mavzuTizim,
        Mavzu.yorug => l.mavzuYorug,
        Mavzu.tun => l.mavzuTun,
      };

  Future<void> _kunlikMaqsad(BuildContext context, WidgetRef ref, int joriy) async {
    final l = AppLocalizations.of(context);
    final tanlangan = await maxsusMaqsadSora(
      context,
      joriy: joriy,
      sarlavha: l.sozKunlikMaqsad,
      yorliq: l.kunlikMaqsadYorliq,
      tayyorlar: kunlikTayyorlar,
    );
    if (tanlangan != null) ref.read(sanagichProvider.notifier).kunlikMaqsadniOrnat(tanlangan);
  }

  Future<void> _mavzuTanla(BuildContext context, WidgetRef ref, Mavzu joriy) async {
    final l = AppLocalizations.of(context);
    final tanlangan = await pastkiPanelOch<Mavzu>(
      context,
      sarlavha: l.sozMavzu,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final m in Mavzu.values) ...[
            TanlovQatori(
              matn: _mavzuNomi(l, m),
              tanlangan: m == joriy,
              onTap: () => Navigator.of(context).pop(m),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
    if (tanlangan != null) ref.read(sanagichProvider.notifier).mavzuniOrnat(tanlangan);
  }

  static Future<void> _zaxiraOl(WidgetRef ref) async {
    final hozir = ref.read(soatProvider).hozir();
    await ref.read(sanagichProvider.notifier).navbat.tugashiniKut();
    final matn = await ZaxiraXizmati(ref.read(databaseProvider)).json(hozir);
    await ref
        .read(platformaProvider)
        .faylniUlash(ZaxiraXizmati.faylNomi(hozir), utf8.encode(matn));
  }

  Future<void> _tikla(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final matn = await ref.read(platformaProvider).faylniTanlash();
    if (matn == null || !context.mounted) return;

    final xizmat = ZaxiraXizmati(ref.read(databaseProvider));
    final ZaxiraMalumoti malumot;
    try {
      malumot = await xizmat.tekshir(matn);
    } on ZaxiraXatosi catch (e) {
      if (!context.mounted) return;
      await xabarniKorsat(
        context,
        sarlavha: l.zaxiraXatoSarlavha,
        matn: switch (e.turi) {
          ZaxiraXatoTuri.notogriFayl => l.zaxiraNotogri,
          ZaxiraXatoTuri.yangiVersiya => l.zaxiraYangi,
          ZaxiraXatoTuri.buzuq => l.zaxiraBuzuq,
        },
      );
      return;
    }
    if (!context.mounted) return;
    final ha = await tasdiqSora(
      context,
      sarlavha: l.tiklashSarlavha,
      matn: l.tiklashMatn,
      tasdiqMatni: l.tiklash,
    );
    if (!ha) return;
    final ctrl = ref.read(sanagichProvider.notifier);
    await ctrl.navbat.tugashiniKut();
    await xizmat.tikla(malumot);
    await ctrl.qaytaYukla();
    if (context.mounted) await xabarniKorsat(context, sarlavha: l.tiklashSarlavha, matn: l.tiklandi);
  }

  /// Ikki bosqichli tasdiq; birinchisida "Avval zaxira olish" ham bor.
  Future<void> _nolla(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final birinchi = await tasdiqSora(
      context,
      sarlavha: l.nollashBirSarlavha,
      matn: l.nollashBirMatn,
      tasdiqMatni: l.davomEtishTugma,
      qoshimchaMatn: l.avvalZaxira,
      onQoshimcha: () => _zaxiraOl(ref),
    );
    if (!birinchi || !context.mounted) return;
    final ikkinchi = await tasdiqSora(
      context,
      sarlavha: l.nollashIkkiSarlavha,
      matn: l.nollashIkkiMatn,
      tasdiqMatni: l.nollashTugma,
      xavfli: true,
    );
    if (!ikkinchi) return;
    final ctrl = ref.read(sanagichProvider.notifier);
    await ctrl.navbat.tugashiniKut();
    await ZaxiraXizmati(ref.read(databaseProvider)).hisobniNolla();
    await ctrl.qaytaYukla();
    if (context.mounted) await xabarniKorsat(context, sarlavha: l.nollashBirSarlavha, matn: l.nollandi);
  }
}

/// Guruh: kichik sarlavha (Figma "SANASH") va qatorlar kartasi.
class _Guruh extends StatelessWidget {
  const _Guruh({required this.nomi, required this.qatorlar});

  final String nomi;
  final List<Widget> qatorlar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (nomi.isNotEmpty) ...[
          Text(nomi, style: AppText.teg.copyWith(color: c.matn2)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: c.fon,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.chiziq),
            boxShadow: AppShadows.karta,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (i, q) in qatorlar.indexed) ...[
                if (i > 0) Container(height: 1, color: c.chiziq),
                q,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Sozlama qatori (Figma "Karta" ichidagi qator): rangli ikonka plitkasi, nom, o'ng tomoni.
class _Qator extends StatelessWidget {
  const _Qator({
    required this.ikonka,
    required this.rang,
    required this.nomi,
    this.nomiRangi,
    this.oxiri,
    this.qiymat,
    this.strelka = false,
    this.onTap,
  });

  /// `assets/svg/sozlama_<ikonka>.svg`.
  final String ikonka;
  final Color rang;
  final String nomi;
  final Color? nomiRangi;

  /// O'ngdagi toggle.
  final Widget? oxiri;

  /// O'ngdagi qiymat ("100", "Tizim"); bo'lsa ostidan "›" ham chiqadi.
  final String? qiymat;
  final bool strelka;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final qator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: rang, borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/svg/sozlama_$ikonka.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(c.belgiOq, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(nomi, style: AppText.matn.copyWith(color: nomiRangi ?? c.matn))),
          ?oxiri,
          if (qiymat != null) ...[
            const SizedBox(width: 12),
            Text(qiymat!, style: AppText.matn.copyWith(color: c.matn3)),
          ],
          if (qiymat != null || strelka) ...[
            const SizedBox(width: 12),
            SvgPicture.asset(
              'assets/svg/sozlama_ongga.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(c.matn3, BlendMode.srcIn),
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return Semantics(container: true, child: qator);
    return Semantics(
      button: true,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: qator),
    );
  }
}

/// Kunlik eslatma paneli: yoqish toggle'i, vaqt tanlash, ruxsat rad etilgan holat.
class _EslatmaPaneli extends ConsumerStatefulWidget {
  const _EslatmaPaneli();

  @override
  ConsumerState<_EslatmaPaneli> createState() => _EslatmaPaneliState();
}

class _EslatmaPaneliState extends ConsumerState<_EslatmaPaneli> {
  bool _ruxsatYoq = false;

  Future<void> _almashtir(bool yoniq) async {
    final ctrl = ref.read(sanagichProvider.notifier);
    if (!yoniq) {
      ctrl.eslatmaniOrnat(yoniq: false);
      return;
    }
    // Ruxsat faqat foydalanuvchi eslatmani yoqqanda so'raladi.
    final bor = await ref.read(platformaProvider).bildirishnomaRuxsatiniSora();
    if (!mounted) return;
    setState(() => _ruxsatYoq = !bor);
    if (bor) ctrl.eslatmaniOrnat(yoniq: true);
  }

  Future<void> _vaqtTanla(int joriy) async {
    final tanlangan = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: joriy ~/ 60, minute: joriy % 60),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (tanlangan != null) {
      ref.read(sanagichProvider.notifier).eslatmaniOrnat(daqiqa: tanlangan.hour * 60 + tanlangan.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final h = ref.watch(sanagichProvider).value;
    if (h == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Guruh(
          nomi: '',
          qatorlar: [
            _Qator(
              ikonka: 'qongiroq',
              rang: c.sariq,
              nomi: l.sozEslatma,
              oxiri: OsmonToggle(yoniq: h.eslatmaYoniq, onChanged: _almashtir),
            ),
            _Qator(
              ikonka: 'oy',
              rang: c.kokChuqur,
              nomi: l.eslatmaVaqti,
              qiymat: Eslatma.matnga(h.eslatmaDaqiqa),
              onTap: () => _vaqtTanla(h.eslatmaDaqiqa),
            ),
          ],
        ),
        if (_ruxsatYoq) ...[
          const SizedBox(height: 14),
          Text(l.ruxsatYoq, style: AppText.matn.copyWith(color: c.qizil)),
          const SizedBox(height: 10),
          TanlovQatori(
            matn: l.sozlamalarniOchish,
            tanlangan: false,
            onTap: () => ref.read(platformaProvider).bildirishnomaSozlamalariniOch(),
          ),
        ],
      ],
    );
  }
}
