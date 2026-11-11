import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/db/database.dart';
import '../../../../core/format/son_format.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/bortiq_tugma.dart';
import '../../../../core/widgets/rasm_plitka.dart';
import '../../../../core/widgets/sky_header.dart';
import '../../../library/ui/turkum.dart';
import '../../../path/domain/tabrik.dart';
import '../sanagich_controller.dart';

/// Foydalanuvchi qaysi tugmani bosdi. Fonga bosib yopilsa `null`.
enum TabrikTanlovi { asosiy, ikkinchi }

/// Tabrik modalini (Figma 07) ochadi. [haptik] — kuchli tebranish.
Future<TabrikTanlovi?> tabrikModaliniOch(
  BuildContext context, {
  required Tabrik tabrik,
  required ZikrQator zikr,
  required bool haptik,
}) {
  if (haptik) HapticFeedback.heavyImpact();
  return showDialog<TabrikTanlovi>(
    context: context,
    barrierColor: context.colors.qoplama,
    builder: (context) => _TabrikModali(tabrik: tabrik, zikr: zikr),
  );
}

class _TabrikModali extends StatelessWidget {
  const _TabrikModali({required this.tabrik, required this.zikr});

  final Tabrik tabrik;
  final ZikrQator zikr;

  static const _osmon = 230.0;
  static const _rasm = 100.8;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    final toplam = tabrik.turi == TabrikTuri.toplamTugadi;
    final natija = toplam ? tabrik.jami : tabrik.maqsad;
    final streak = tabrik.streak;

    void tanla(TabrikTanlovi t) => Navigator.of(context).pop(t);

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: c.fon,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppShadows.tabrik,
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _osmon,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Figma: 390 kenglikdagi osmon kartaga 16 px chapga surilib kesilgan.
                    Positioned.fill(
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        child: SizedBox(width: 390, child: SkyHeader(vaqt: OsmonVaqt.peshin, oysiz: true)),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_rasm / 4),
                            boxShadow: [
                              BoxShadow(
                                color: c.yashilChuqur.withValues(alpha: 0.28),
                                offset: const Offset(0, 14),
                                blurRadius: 28,
                              ),
                            ],
                          ),
                          child: const RasmPlitka('tasbeh', olcham: _rasm),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: ExcludeSemantics(
                        child: SvgPicture.asset('assets/svg/uchqunlar.svg', excludeFromSemantics: true, fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      top: 154.8,
                      left: 0,
                      right: 0,
                      child: Center(child: _Natija(matn: l.tabrikNatija(sonFormat(natija)))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!toplam && zikr.arabcha.isNotEmpty) ...[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          zikr.arabcha,
                          maxLines: 1,
                          textDirection: TextDirection.rtl,
                          style: AppText.arabOrta.copyWith(color: c.matn),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      toplam ? l.tasbehotTugadi : l.aylanaTugadi,
                      textAlign: TextAlign.center,
                      style: AppText.h1.copyWith(color: c.matn),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      toplam
                          ? l.bugunMarta(sonFormat(tabrik.marta))
                          : l.tabrikIzoh(zikr.korinishNomi, sonFormat(tabrik.maqsad)),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.matn.copyWith(color: c.matn2),
                    ),
                    if (streak != null) ...[
                      const SizedBox(height: 12),
                      _Dalda(matn: l.dalda(sonFormat(streak))),
                    ],
                    const SizedBox(height: 12),
                    AsosiyTugma(
                      matn: toplam ? l.tayyor : l.davomEtish,
                      balandlik: 54,
                      onTap: () => tanla(TabrikTanlovi.asosiy),
                      oxiridagi: SvgPicture.asset(
                        'assets/svg/icon_ongga.svg',
                        excludeFromSemantics: true,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(c.fon, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _IkkinchiTugma(
                      matn: toplam ? l.yanaBirMarta : l.boshqaZikrTanlash,
                      ikonka: toplam ? 'assets/svg/icon_qaytarish.svg' : null,
                      onTap: () => tanla(TabrikTanlovi.ikkinchi),
                    ),
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

/// Rasm ostidagi yashil natija belgisi (Figma "Natija").
class _Natija extends StatelessWidget {
  const _Natija({required this.matn});

  final String matn;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 7, 14, 7),
      decoration: BoxDecoration(
        color: c.yashil,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.bortiq(c.yashilChuqur, balandlik: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/icon_belgi.svg',
            excludeFromSemantics: true,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(c.belgiOq, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(matn, style: AppText.teg.copyWith(color: c.belgiOq)),
        ],
      ),
    );
  }
}

class _Dalda extends StatelessWidget {
  const _Dalda({required this.matn});

  final String matn;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
      decoration: BoxDecoration(color: c.olovOch, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const RasmPlitka('olov', olcham: 34),
          const SizedBox(width: 10),
          Expanded(child: Text(matn, style: AppText.kichik.copyWith(color: c.matn))),
        ],
      ),
    );
  }
}

class _IkkinchiTugma extends StatelessWidget {
  const _IkkinchiTugma({required this.matn, required this.onTap, this.ikonka});

  final String matn;
  final String? ikonka;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ikonka != null) ...[
                SvgPicture.asset(
                  ikonka!,
                  excludeFromSemantics: true,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(c.kokChuqur, BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
              ],
              Text(matn, style: AppText.tugma.copyWith(color: c.kokChuqur)),
            ],
          ),
        ),
      ),
    );
  }
}
