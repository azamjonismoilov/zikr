import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/sanagich_repository.dart';
import '../data/yozuv_navbati.dart';
import '../domain/kun.dart';
import '../domain/kun_hisobi.dart';
import '../domain/kun_qatori.dart';
import '../domain/sanash.dart';
import '../domain/soat.dart';
import '../../library/domain/oz_zikr.dart';
import '../../library/domain/zikr_holati.dart';

final soatProvider = Provider<Soat>((ref) => const TizimSoati());

final sanagichRepositoryProvider =
    Provider<SanagichRepository>((ref) => SanagichRepository(ref.watch(databaseProvider)));

final sanagichProvider =
    AsyncNotifierProvider<SanagichController, SanagichHolati>(SanagichController.new);

/// Sanagich ekranining to'liq holati. O'zgarmas; har amal yangisini yaratadi.
class SanagichHolati {
  const SanagichHolati({
    required this.bugun,
    required this.zikrlar,
    required this.toplamlar,
    required this.joriyZikrId,
    required this.oxirgiQatorlar,
    required this.yigindilar,
    required this.haptik,
    required this.kunlikMaqsad,
  });

  final Kun bugun;
  final List<ZikrQator> zikrlar;
  final List<ToplamQator> toplamlar;
  final int joriyZikrId;

  /// Har zikrning eng so'nggi kun qatori (bugungi yoki o'tgan kun).
  final Map<int, KunQatori> oxirgiQatorlar;

  /// Har kun bo'yicha barcha zikrlar yig'indisi.
  final Map<Kun, KunYigindisi> yigindilar;
  final bool haptik;
  final int kunlikMaqsad;

  ZikrQator get zikr => zikrlar.firstWhere((z) => z.id == joriyZikrId);
  KunQatori? get _qator => oxirgiQatorlar[joriyZikrId];

  /// `null` — cheksiz (∞).
  int? get maqsad => zikr.maqsad;
  int get son => Sanash.joriySon(_qator);

  /// Teg uchun: bugungi aylanalar + 1.
  int get aylanaRaqami => Sanash.bugungiAylanalar(_qator, bugun) + 1;

  /// Bugun barcha zikrlar bo'yicha tugagan aylanalar.
  int get bugunTugaganAylanalar => yigindilar[bugun]?.aylanalar ?? 0;

  StreakNatijasi get streak => KunHisobi.streak(
        KunHisobi.hisoblanganKunlar(yigindilar.values, kunlikMaqsad),
        bugun,
      );

  /// [zikrId] ning bugungi holati (Zikrlar ekranidagi kartalar uchun).
  ZikrHolatMalumoti holat(ZikrQator z) =>
      ZikrHolatHisobi.hisobla(oxirgiQatorlar[z.id], z.maqsad, bugun);

  /// Joriy zikr to'plamda bo'lsa, to'plamdagi keyingi zikr (oxirgisidan keyin birinchisi).
  ZikrQator? get keyingiZikr {
    for (final t in toplamlar) {
      final i = t.qadamlar.indexWhere((q) => q.zikrId == joriyZikrId);
      if (i < 0) continue;
      final keyingiId = t.qadamlar[(i + 1) % t.qadamlar.length].zikrId;
      for (final z in zikrlar) {
        if (z.id == keyingiId) return z;
      }
    }
    return null;
  }

  SanagichHolati copyWith({
    Kun? bugun,
    List<ZikrQator>? zikrlar,
    int? joriyZikrId,
    Map<int, KunQatori>? oxirgiQatorlar,
    Map<Kun, KunYigindisi>? yigindilar,
    bool? haptik,
  }) {
    return SanagichHolati(
      bugun: bugun ?? this.bugun,
      zikrlar: zikrlar ?? this.zikrlar,
      toplamlar: toplamlar,
      joriyZikrId: joriyZikrId ?? this.joriyZikrId,
      oxirgiQatorlar: oxirgiQatorlar ?? this.oxirgiQatorlar,
      yigindilar: yigindilar ?? this.yigindilar,
      haptik: haptik ?? this.haptik,
      kunlikMaqsad: kunlikMaqsad,
    );
  }
}

class SanagichController extends AsyncNotifier<SanagichHolati> {
  final navbat = YozuvNavbati();

  SanagichRepository get _repo => ref.read(sanagichRepositoryProvider);
  Soat get _soat => ref.read(soatProvider);
  SanagichHolati get _h => state.requireValue;

  @override
  Future<SanagichHolati> build() async {
    final repo = _repo;
    final zikrlar = await repo.zikrlar();
    final saqlanganId = int.tryParse(await repo.sozlama(SozlamaKalit.joriyZikrId) ?? '');
    final joriyId = zikrlar.any((z) => z.id == saqlanganId) ? saqlanganId! : zikrlar.first.id;
    final kunlik = int.tryParse(await repo.sozlama(SozlamaKalit.kunlikMaqsad) ?? '');

    return SanagichHolati(
      bugun: Kun.dan(_soat.hozir()),
      zikrlar: zikrlar,
      toplamlar: await repo.toplamlar(),
      joriyZikrId: joriyId,
      oxirgiQatorlar: await repo.oxirgiQatorlar(),
      yigindilar: {for (final y in await repo.kunlikYigindilar()) y.sana: y},
      haptik: await repo.sozlama(SozlamaKalit.haptik) != '0',
      kunlikMaqsad: kunlik ?? SozlamaKalit.standartKunlikMaqsad,
    );
  }

  /// Bitta bosish. Natijada aylana tugaganmi.
  bool bos() {
    final h = _h;
    final vaqt = _soat.hozir();
    final bugun = Kun.dan(vaqt);
    final eski = h.oxirgiQatorlar[h.joriyZikrId];
    final natija = Sanash.bos(eski, h.joriyZikrId, h.maqsad, bugun);
    _qatorniOrnat(h, eski, natija.qator, bugun, vaqt);
    return natija.aylanaTugadi;
  }

  /// Joriy (yoki [zikrId]) zikrning aylanasini nollaydi. `son == 0` bo'lsa hech narsa qilmaydi.
  void nolla([int? zikrId]) {
    final h = _h;
    final id = zikrId ?? h.joriyZikrId;
    final eski = h.oxirgiQatorlar[id];
    if (Sanash.joriySon(eski) == 0) return;
    final vaqt = _soat.hozir();
    final bugun = Kun.dan(vaqt);
    _qatorniOrnat(h, eski, Sanash.nolla(eski, id, bugun), bugun, vaqt);
  }

  /// Maqsadni o'rnatadi (`null` — ∞). `son > 0` bo'lsa avval nollaydi;
  /// tasdiqni UI so'raydi ([Sanash.maqsadUchunTasdiqKerak]).
  void maqsadniOrnat(int? maqsad) {
    if (_h.maqsad == maqsad) return;
    nolla();
    final h = _h;
    final id = h.joriyZikrId;
    state = AsyncData(h.copyWith(
      zikrlar: [
        for (final z in h.zikrlar) z.id == id ? z.copyWith(maqsad: Value(maqsad)) : z,
      ],
    ));
    navbat.qosh(() => _repo.maqsadniYoz(id, maqsad));
  }

  void haptikniAlmashtir() {
    final yangi = !_h.haptik;
    state = AsyncData(_h.copyWith(haptik: yangi));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.haptik, yangi ? '1' : '0'));
  }

  /// Joriy zikrni almashtiradi. Har zikrning tugallanmagan soni o'z qatorida qoladi.
  void zikrniTanla(int id) {
    final h = _h;
    if (h.joriyZikrId == id || !h.zikrlar.any((z) => z.id == id)) return;
    state = AsyncData(h.copyWith(joriyZikrId: id));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.joriyZikrId, '$id'));
  }

  /// Yangi o'z zikrini qo'shadi va uni joriy qiladi.
  Future<ZikrQator> ozZikrQosh(OzZikr z) async {
    final yangi = await navbat.bajar(() => _repo.ozZikrQosh(z));
    state = AsyncData(_h.copyWith(zikrlar: [..._h.zikrlar, yangi]));
    zikrniTanla(yangi.id);
    return yangi;
  }

  /// O'z zikrini yangilaydi. Maqsad o'zgarsa, joriy aylana nollanadi
  /// (tasdiqni UI so'raydi, [Sanash.maqsadUchunTasdiqKerak]).
  Future<void> zikrniTahrirla(int id, OzZikr z) async {
    final eski = _h.zikrlar.firstWhere((r) => r.id == id);
    if (eski.maqsad != z.maqsad) nolla(id);
    final yangi = await navbat.bajar(() => _repo.zikrniYangila(id, z));
    state = AsyncData(_h.copyWith(
      zikrlar: [for (final r in _h.zikrlar) r.id == id ? yangi : r],
    ));
  }

  /// Zikrni o'chiradi (sessiyalari qoladi). Joriy bo'lsa, birinchi zikrga (SubhanAllah) qaytadi.
  Future<void> zikrniOchir(int id) async {
    await navbat.bajar(() => _repo.zikrniOchir(id));
    final h = _h;
    final qolgan = [for (final z in h.zikrlar) if (z.id != id) z];
    final joriy = h.joriyZikrId == id ? qolgan.first.id : h.joriyZikrId;
    state = AsyncData(h.copyWith(zikrlar: qolgan, joriyZikrId: joriy));
    if (joriy != h.joriyZikrId) {
      navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.joriyZikrId, '$joriy'));
    }
  }

  /// To'plamdagi keyingi zikrga o'tadi.
  void keyingisiga() {
    final keyingi = _h.keyingiZikr;
    if (keyingi == null) return;
    state = AsyncData(_h.copyWith(joriyZikrId: keyingi.id));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.joriyZikrId, '${keyingi.id}'));
  }

  /// Ilova qayta ochilganda (masalan, yarim tundan keyin) bugungi kunni yangilaydi.
  void kunniYangila() {
    final h = state.value;
    if (h == null) return;
    final bugun = Kun.dan(_soat.hozir());
    if (bugun != h.bugun) state = AsyncData(h.copyWith(bugun: bugun));
  }

  void _qatorniOrnat(
    SanagichHolati h,
    KunQatori? eski,
    KunQatori yangi,
    Kun bugun,
    DateTime vaqt,
  ) {
    // Kun yig'indisi o'zgarishi: bugungi qatorning eski va yangi qiymatlari farqi.
    final oldingi = Sanash.bugungiQator(eski, yangi.zikrId, bugun);
    final yigindi = (h.yigindilar[bugun] ?? KunYigindisi(sana: bugun)).qosh(
      aylanalar: yangi.aylanalar - oldingi.aylanalar,
      jami: yangi.jami - oldingi.jami,
    );

    state = AsyncData(h.copyWith(
      bugun: bugun,
      oxirgiQatorlar: {...h.oxirgiQatorlar, yangi.zikrId: yangi},
      yigindilar: {...h.yigindilar, bugun: yigindi},
    ));
    navbat.qosh(() => _repo.qatorniYoz(yangi, vaqt));
  }
}
