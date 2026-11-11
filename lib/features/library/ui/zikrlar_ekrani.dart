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
import '../../../core/widgets/korsatkich.dart';
import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/rasm_plitka.dart';
import '../../../core/widgets/sky_header.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../domain/bolimlar.dart';
import '../domain/zikr_holati.dart';
import 'turkum.dart';
import 'widgets/dars_karta.dart';
import 'widgets/qoshish_tugma.dart';
import 'zikr_tanlash_paneli.dart';

class ZikrlarEkrani extends ConsumerStatefulWidget {
  const ZikrlarEkrani({super.key});

  @override
  ConsumerState<ZikrlarEkrani> createState() => _ZikrlarEkraniState();
}

class _ZikrlarEkraniState extends ConsumerState<ZikrlarEkrani> {
  final _scroll = ScrollController();
  final _royxatKalit = GlobalKey();
  final _bolimKalitlari = <String, GlobalKey>{};
  final _yopiq = <String>{};

  String? _faol;

  /// Tab bosilib, sahifa dasturiy aylanayotgan payt: faol tab qayta hisoblanmaydi.
  bool _dasturiy = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_faolniHisobla);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  GlobalKey _kalit(String bolim) => _bolimKalitlari.putIfAbsent(bolim, GlobalKey.new);

  /// Ko'rinib turgan bo'limni topadi: yuqori chetdan o'tgan oxirgi bo'lim.
  void _faolniHisobla() {
    if (_dasturiy || !_scroll.hasClients) return;
    final royxat = _royxatKalit.currentContext?.findRenderObject() as RenderBox?;
    if (royxat == null) return;
    final h = ref.read(sanagichProvider).value;
    if (h == null) return;
    final kalitlar = [for (final b in zikrBolimlari(h.zikrlar)) b.kalit];
    if (kalitlar.isEmpty) return;

    String yangi = kalitlar.first;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 1) {
      yangi = kalitlar.last;
    } else {
      for (final k in kalitlar) {
        final box = _bolimKalitlari[k]?.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) continue;
        final y = box.localToGlobal(Offset.zero, ancestor: royxat).dy;
        if (y <= _tepaOraliq * 2) yangi = k;
      }
    }
    if (yangi != _faol) setState(() => _faol = yangi);
  }

  /// Ro'yxat tepasidagi oraliq (Figma: Kontent `py 24`). Bo'limga o'tganda ham saqlanadi.
  static const _tepaOraliq = 24.0;

  Future<void> _bolimgaOt(String bolim) async {
    setState(() => _faol = bolim);
    final box = _bolimKalitlari[bolim]?.currentContext?.findRenderObject() as RenderBox?;
    final royxat = _royxatKalit.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || royxat == null || !_scroll.hasClients) return;
    final y = box.localToGlobal(Offset.zero, ancestor: royxat).dy;
    final pos = _scroll.position;
    final manzil = (pos.pixels + y - _tepaOraliq).clamp(0.0, pos.maxScrollExtent);
    _dasturiy = true;
    await _scroll.animateTo(manzil, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    _dasturiy = false;
  }

  void _tanla(ZikrQator z) {
    ref.read(sanagichProvider.notifier).zikrniTanla(z.id);
    context.go(Yollar.sanagich);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final h = ref.watch(sanagichProvider).value;

    return OsmonEkran(
      vaqt: OsmonVaqt.bomdod,
      yuqoriBalandlik: 60,
      yuqori: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l.sarlavhaZikrlar,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h1.copyWith(color: c.matn),
                ),
              ),
            ),
            if (h != null) ...[
              KorsatkichPill(
                ikonka: 'assets/svg/icon_olov.svg',
                rang: c.olov,
                jonli: true,
                qiymat: h.streak.joriy,
                izoh: l.streakIzoh(sonFormat(h.streak.joriy)),
              ),
              const SizedBox(width: 8),
            ],
            IkonkaTugma(
              ikonka: 'assets/svg/icon_qidiruv.svg',
              izoh: l.qidirish,
              onTap: () => zikrTanlashPaneliniOch(context, qidiruvFaol: true, sanagichgaOtish: true),
            ),
          ],
        ),
      ),
      child: h == null ? const SizedBox.shrink() : _kontent(context, h),
    );
  }

  Widget _kontent(BuildContext context, SanagichHolati h) {
    final bolimlar = zikrBolimlari(h.zikrlar);
    final faol = bolimlar.any((b) => b.kalit == _faol) ? _faol! : bolimlar.first.kalit;
    final toplamdagilar = {for (final t in h.toplamlar) for (final q in t.qadamlar) q.zikrId};

    /// Bo'lim zikrlari to'liq bitta to'plamga kirsa, shu to'plam (sarlavha yo'lni ochadi).
    int? bolimToplami(Bolim<ZikrQator> b) {
      for (final t in h.toplamlar) {
        final idlar = {for (final q in t.qadamlar) q.zikrId};
        if (b.zikrlar.isNotEmpty && b.zikrlar.every((z) => idlar.contains(z.id))) return t.id;
      }
      return null;
    }
    // Kapsula tab bar (62) + uning ostidagi joy + 24: oxirgi karta tab bar ostida qolmaydi.
    final pastki = 62.0 + math.max(MediaQuery.viewPaddingOf(context).bottom, 8.0) + 24;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _TurkumTablari(
            bolimlar: [for (final b in bolimlar) b.kalit],
            faol: faol,
            onTanlash: _bolimgaOt,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            key: _royxatKalit,
            controller: _scroll,
            padding: EdgeInsets.fromLTRB(16, _tepaOraliq, 16, pastki),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, b) in bolimlar.indexed) ...[
                  if (i > 0) const SizedBox(height: 32),
                  _Bolim(
                    key: _kalit(b.kalit),
                    bolim: b,
                    holat: h,
                    yopiq: _yopiq.contains(b.kalit),
                    // Faqat to'plamga kiruvchi bo'limda kartalar chiziq bilan bog'lanadi.
                    boglangan: b.zikrlar.length > 1 && b.zikrlar.every((z) => toplamdagilar.contains(z.id)),
                    onYigish: () => setState(() {
                      if (!_yopiq.remove(b.kalit)) _yopiq.add(b.kalit);
                    }),
                    onSarlavha: switch (bolimToplami(b)) {
                      final id? => () => context.push(Yollar.yol(id)),
                      null => null,
                    },
                    onTanlash: _tanla,
                    onTahrirlash: (z) => context.push(Yollar.zikrniTahrirlash(z.id)),
                    onQoshish: () => context.push(Yollar.yangiZikr),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Turkumlar kartasi (Figma "Turkumlar"). Tablar sig'masa, karta ichida gorizontal aylanadi.
class _TurkumTablari extends StatelessWidget {
  const _TurkumTablari({required this.bolimlar, required this.faol, required this.onTanlash});

  final List<String> bolimlar;
  final String faol;
  final ValueChanged<String> onTanlash;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.chiziq),
        boxShadow: AppShadows.turkumKarta,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: LayoutBuilder(
          builder: (context, chegara) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(6),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: chegara.maxWidth - 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final k in bolimlar)
                    _Tab(
                      turkum: Turkum.ol(k),
                      nomi: Turkum.ol(k).nomi(l),
                      faol: k == faol,
                      onTap: () => onTanlash(k),
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

class _Tab extends StatefulWidget {
  const _Tab({required this.turkum, required this.nomi, required this.faol, required this.onTap});

  final Turkum turkum;
  final String nomi;
  final bool faol;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  @override
  void didUpdateWidget(_Tab eski) {
    super.didUpdateWidget(eski);
    // Faol bo'lgan tab karta ichida ko'rinib tursin.
    if (widget.faol && !eski.faol) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 250),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 250),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: widget.faol,
      label: widget.nomi,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: widget.faol ? c.kokOch : c.kokOch.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RasmPlitka(widget.turkum.rasm, olcham: 36),
              const SizedBox(height: 6),
              Text(
                widget.nomi,
                maxLines: 1,
                style: AppText.teg.copyWith(color: widget.faol ? c.kokChuqur : c.matn2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bolim extends StatelessWidget {
  const _Bolim({
    super.key,
    required this.bolim,
    required this.holat,
    required this.yopiq,
    required this.boglangan,
    required this.onYigish,
    this.onSarlavha,
    required this.onTanlash,
    required this.onTahrirlash,
    required this.onQoshish,
  });

  final Bolim<ZikrQator> bolim;
  final SanagichHolati holat;
  final bool yopiq;
  final bool boglangan;
  final VoidCallback onYigish;

  /// Sarlavha bosilganda (to'plam bo'limida — Tasbehot yo'li). `null` bo'lsa sarlavha yig'adi.
  final VoidCallback? onSarlavha;
  final ValueChanged<ZikrQator> onTanlash;
  final ValueChanged<ZikrQator> onTahrirlash;
  final VoidCallback onQoshish;

  bool get _mening => bolim.kalit == meningBolimi;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final turkum = Turkum.ol(bolim.kalit);
    final holatlar = [for (final z in bolim.zikrlar) holat.holat(z)];

    final royxat = <Widget>[];
    for (final (i, z) in bolim.zikrlar.indexed) {
      if (i > 0) {
        royxat.add(boglangan
            ? _Boglovchi(bajarilgan: holatlar[i - 1].holat == ZikrHolati.bajarildi)
            : const SizedBox(height: 10));
      }
      royxat.add(DarsKarta(
        zikr: z,
        holat: holatlar[i],
        onTap: () => onTanlash(z),
        onLongPress: z.ozZikri ? () => onTahrirlash(z) : null,
      ));
    }
    if (_mening) {
      if (bolim.zikrlar.isEmpty) {
        royxat.add(_BoshMening(onQoshish: onQoshish));
      } else {
        royxat
          ..add(const SizedBox(height: 10))
          ..add(QoshishTugma(onTap: onQoshish));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: onSarlavha != null ? l.tasbehotYolini : (yopiq ? l.bolimniOchish : l.bolimniYigish),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSarlavha ?? onYigish,
            child: Row(
              children: [
                RasmPlitka(turkum.rasm, olcham: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        turkum.nomi(l),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.h3.copyWith(color: c.matn),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l.bolimIzohi(turkum.izoh(l), sonFormat(bolim.zikrlar.length)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.kichik.copyWith(color: c.matn2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _YigishTugma(yopiq: yopiq, onTap: onYigish),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: yopiq
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: royxat),
                ),
        ),
      ],
    );
  }
}

/// Bo'limni yig'ish va ochish tugmasi (Figma "Yigish", 28×28).
class _YigishTugma extends StatelessWidget {
  const _YigishTugma({required this.yopiq, required this.onTap});

  final bool yopiq;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Semantics(
      // Sarlavha tugmasidan alohida tugun: ekran o'quvchi ikkalasini ajratib o'qiydi.
      container: true,
      button: true,
      label: yopiq ? l.bolimniOchish : l.bolimniYigish,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.fon,
            shape: BoxShape.circle,
            border: Border.all(color: c.chiziq),
          ),
          child: AnimatedRotation(
            turns: yopiq ? -0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              'assets/svg/icon_pastga.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(c.matn2, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartalar orasidagi bog'lovchi chiziq bo'lagi (Figma "Bogʻlovchi", 3 px).
class _Boglovchi extends StatelessWidget {
  const _Boglovchi({required this.bajarilgan});

  /// Oldingi qadam bajarilganmi: chiziq `yashil`, aks holda `chiziq`.
  final bool bajarilgan;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 10,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: DarsKarta.rasmMarkaziX - 1.5),
          child: SizedBox(
            width: 3,
            height: double.infinity,
            child: ColoredBox(color: bajarilgan ? c.yashil : c.chiziq),
          ),
        ),
      ),
    );
  }
}

class _BoshMening extends StatelessWidget {
  const _BoshMening({required this.onQoshish});

  final VoidCallback onQoshish;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.fon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.chiziq),
        boxShadow: AppShadows.darsKarta,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.ozZikringizYoq,
            textAlign: TextAlign.center,
            style: AppText.matn.copyWith(color: c.matn2),
          ),
          const SizedBox(height: 12),
          QoshishTugma(onTap: onQoshish),
        ],
      ),
    );
  }
}
