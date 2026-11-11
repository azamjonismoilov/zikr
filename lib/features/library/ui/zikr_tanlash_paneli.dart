import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/db/database.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/pastki_panel.dart';
import '../../counter/ui/sanagich_controller.dart';
import '../domain/qidiruv.dart';
import 'turkum.dart';
import 'widgets/qoshish_tugma.dart';
import 'widgets/tanlash_qator.dart';

/// Zikr tanlash panelini (Figma 06) ochadi.
///
/// [qidiruvFaol] — qidiruv maydoni darhol fokusda. [sanagichgaOtish] — zikr tanlangach
/// Sanagich bo'limiga o'tadi (Zikrlar ekranidan ochilganda).
Future<void> zikrTanlashPaneliniOch(
  BuildContext context, {
  bool qidiruvFaol = false,
  bool sanagichgaOtish = false,
}) {
  final c = context.colors;
  final router = GoRouter.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: c.fon,
    barrierColor: c.qoplama,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => _ZikrTanlashPaneli(
      qidiruvFaol: qidiruvFaol,
      onTanlandi: () {
        Navigator.of(context).pop();
        if (sanagichgaOtish) router.go(Yollar.sanagich);
      },
      onQoshish: () {
        Navigator.of(context).pop();
        router.push(Yollar.yangiZikr);
      },
    ),
  );
}

class _ZikrTanlashPaneli extends ConsumerStatefulWidget {
  const _ZikrTanlashPaneli({
    required this.qidiruvFaol,
    required this.onTanlandi,
    required this.onQoshish,
  });

  final bool qidiruvFaol;
  final VoidCallback onTanlandi;
  final VoidCallback onQoshish;

  @override
  ConsumerState<_ZikrTanlashPaneli> createState() => _ZikrTanlashPaneliState();
}

class _ZikrTanlashPaneliState extends ConsumerState<_ZikrTanlashPaneli> {
  final _sorov = TextEditingController();

  /// Tanlangan chip: `null` — "Hammasi", aks holda bo'lim kaliti.
  String? _bolim;

  @override
  void initState() {
    super.initState();
    _sorov.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sorov.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final h = ref.watch(sanagichProvider).value;
    if (h == null) return const SizedBox.shrink();

    final bolimlar = zikrBolimlari(h.zikrlar);
    // Bo'limlar faqat ichida zikri bor turkumlardan va har doim "Mening" dan iborat.
    final chiplar = [for (final b in bolimlar) b.kalit];
    final bolimdagi = _bolim == null
        ? h.zikrlar
        : bolimlar.firstWhere((b) => b.kalit == _bolim, orElse: () => bolimlar.last).zikrlar;
    final royxat = [
      for (final z in bolimdagi)
        if (qidiruvgaMos(_sorov.text, [z.nomi, z.talaffuz, z.manosi])) z,
    ];
    final mq = MediaQuery.of(context);
    final pastki = mq.viewInsets.bottom > 0 ? 16.0 : 34.0;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scroll) => Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, pastki),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PanelSarlavhasi(sarlavha: l.zikrniTanlang),
              const SizedBox(height: 14),
              _QidiruvMaydoni(controller: _sorov, avtoFokus: widget.qidiruvFaol),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _Chip(matn: l.hammasi, faol: _bolim == null, onTap: () => setState(() => _bolim = null)),
                    for (final k in chiplar) ...[
                      const SizedBox(width: 8),
                      _Chip(
                        matn: Turkum.ol(k).nomi(l),
                        faol: _bolim == k,
                        onTap: () => setState(() => _bolim = k),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: royxat.isEmpty
                    ? ListView(
                        controller: scroll,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            l.hechNarsaTopilmadi,
                            textAlign: TextAlign.center,
                            style: AppText.matn.copyWith(color: c.matn2),
                          ),
                        ],
                      )
                    : ListView.separated(
                        controller: scroll,
                        itemCount: royxat.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, i) {
                          final z = royxat[i];
                          return TanlashQator(
                            zikr: z,
                            tanlangan: z.id == h.joriyZikrId,
                            onTap: () => _tanla(z),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 14),
              QoshishTugma(onTap: widget.onQoshish),
            ],
          ),
        ),
      ),
    );
  }

  void _tanla(ZikrQator z) {
    ref.read(sanagichProvider.notifier).zikrniTanla(z.id);
    widget.onTanlandi();
  }
}

class _QidiruvMaydoni extends StatelessWidget {
  const _QidiruvMaydoni({required this.controller, required this.avtoFokus});

  final TextEditingController controller;
  final bool avtoFokus;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(color: c.fon2, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/icon_qidiruv.svg',
            excludeFromSemantics: true,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(c.matn3, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: avtoFokus,
              cursorColor: c.kok,
              textInputAction: TextInputAction.search,
              style: AppText.matn.copyWith(color: c.matn),
              // Vertikal chekinish maydonning o'zida: bosish maydoni 48 dp.
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                hintText: l.qidiruvMaslahat,
                hintStyle: AppText.matn.copyWith(color: c.matn3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.matn, required this.faol, required this.onTap});

  final String matn;
  final bool faol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: faol,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: faol ? c.matn : c.fon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: faol ? c.matn : c.chiziq, width: 1.5),
          ),
          child: Text(matn, style: AppText.teg.copyWith(color: faol ? c.fon : c.matn)),
        ),
      ),
    );
  }
}
