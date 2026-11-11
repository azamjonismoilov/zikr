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
import '../../path/data/yurish_repository.dart';
import '../../path/domain/tabrik.dart';
import '../../path/domain/toplam_sanash.dart';
import '../../path/domain/yurish.dart';
import '../../onboarding/domain/onboarding.dart';
import '../../settings/domain/eslatma.dart';
import '../../settings/domain/mavzu.dart';

final soatProvider = Provider<Soat>((ref) => const TizimSoati());

final sanagichRepositoryProvider =
    Provider<SanagichRepository>((ref) => SanagichRepository(ref.watch(databaseProvider)));

final yurishRepositoryProvider =
    Provider<YurishRepository>((ref) => YurishRepository(ref.watch(databaseProvider)));

final sanagichProvider =
    AsyncNotifierProvider<SanagichController, SanagichHolati>(SanagichController.new);

/// Tabrik modali uchun ma'lumot.
class Tabrik {
  const Tabrik({
    required this.turi,
    required this.zikrId,
    required this.maqsad,
    this.toplamId,
    this.jami = 0,
    this.marta = 0,
    this.streak,
  });

  final TabrikTuri turi;

  /// "Kun hisobga olindi": aylanasi tugagan zikr. "To'plam tugadi": oxirgi qadam zikri.
  final int zikrId;

  /// "{maqsad} / {maqsad}" va "{nomi} · {maqsad} marta" uchun.
  final int maqsad;
  final int? toplamId;

  /// To'plam qadamlari maqsadlari yig'indisi ("100 / 100").
  final int jami;

  /// Bugun to'plam nechanchi marta tugadi.
  final int marta;

  /// Dalda qatori: streak oshgan bo'lsa yangi qiymati, aks holda `null`.
  final int? streak;
}

/// Bosishning UI uchun natijasi.
class BosishHodisasi {
  const BosishHodisasi({this.aylanaTugadi = false, this.tabrik});

  /// Aylana (alohida) yoki qadam (to'plam) tugadi: kuchli haptik, halqa yonadi.
  final bool aylanaTugadi;

  /// `null` — modal chiqmaydi.
  final Tabrik? tabrik;
}

/// To'plam ichida kechiktirilgan "kun hisobga olindi" holati.
typedef KechiktirilganTabrik = ({int zikrId, int maqsad});

const _yoq = Object();

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
    this.joriyToplamId,
    this.yurishlar = const {},
    this.tugaganYurishlar = const [],
    this.kechiktirilgan,
    this.zikrKunlari = const {},
    this.statistikaDavri = SozlamaKalit.standartDavr,
    this.tovush = false,
    this.ovozTugmasi = false,
    this.ekranYoniq = true,
    this.mavzu = Mavzu.tizim,
    this.eslatmaYoniq = false,
    this.eslatmaDaqiqa = Eslatma.standartDaqiqa,
    this.onboardingKorildi = true,
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

  /// Bo'sh bo'lmasa, sanagich shu to'plam rejimida (tugallanmagan yurishi bo'lsa).
  final int? joriyToplamId;

  /// Har to'plamning tugallanmagan yurishi.
  final Map<int, Yurish> yurishlar;
  final List<TugaganYurish> tugaganYurishlar;
  final KechiktirilganTabrik? kechiktirilgan;

  /// Har zikrning har kungi `jami` si (statistika uchun, o'chirilganlar ham).
  final Map<int, Map<Kun, int>> zikrKunlari;

  /// Statistika davri: 7 yoki 30 kun.
  final int statistikaDavri;

  /// Har bosishda tizim "click" tovushi.
  final bool tovush;

  /// Ovoz balandligi tugmalari bilan sanash (faqat Android).
  final bool ovozTugmasi;

  /// Sanash paytida ekran o'chmasin.
  final bool ekranYoniq;
  final Mavzu mavzu;
  final bool eslatmaYoniq;

  /// Eslatma vaqti, kun boshidan daqiqalar.
  final int eslatmaDaqiqa;

  /// `false` bo'lsa ilova onboarding'dan boshlanadi.
  final bool onboardingKorildi;

  /// Hisoblangan kunlar (kun hisobi qoidasi bo'yicha).
  Set<Kun> get hisoblanganKunlar => KunHisobi.hisoblanganKunlar(yigindilar.values, kunlikMaqsad);

  ToplamQator? toplamById(int id) {
    for (final t in toplamlar) {
      if (t.id == id) return t;
    }
    return null;
  }

  ZikrQator? zikrById(int id) {
    for (final z in zikrlar) {
      if (z.id == id) return z;
    }
    return null;
  }

  static List<YolQadami> qadamlariniOl(ToplamQator t) =>
      [for (final q in t.qadamlar) YolQadami(zikrId: q.zikrId, maqsad: q.maqsad)];

  /// To'plam rejimidagi to'plam (rejim faol bo'lmasa `null`).
  ToplamQator? get toplam {
    final id = joriyToplamId;
    if (id == null || !yurishlar.containsKey(id)) return null;
    return toplamById(id);
  }

  bool get toplamRejimi => toplam != null;
  Yurish? get yurish => toplamRejimi ? yurishlar[joriyToplamId] : null;
  YolQadami? get joriyQadam {
    final t = toplam, y = yurish;
    if (t == null || y == null) return null;
    return qadamlariniOl(t)[y.qadam];
  }

  /// Ekrandagi zikr: to'plam rejimida joriy qadam zikri.
  ZikrQator get zikr {
    final q = joriyQadam;
    return (q == null ? null : zikrById(q.zikrId)) ?? zikrById(joriyZikrId) ?? zikrlar.first;
  }

  KunQatori? get _qator => oxirgiQatorlar[joriyZikrId];

  /// `null` — cheksiz (∞). To'plam rejimida qadam maqsadi.
  int? get maqsad => joriyQadam?.maqsad ?? zikr.maqsad;

  /// Ekrandagi son: to'plam rejimida joriy qadamdagi son.
  int get son => yurish?.son ?? Sanash.joriySon(_qator);

  /// To'plam rejimida keyingi qadam zikri; oxirgi qadamda `null` ("Tugatish").
  ZikrQator? get keyingiQadamZikri {
    final t = toplam, y = yurish;
    if (t == null || y == null || y.qadam + 1 >= t.qadamlar.length) return null;
    return zikrById(t.qadamlar[y.qadam + 1].zikrId);
  }

  /// Bugun shu to'plam necha marta tugadi.
  int bugunTugaganlar(int toplamId) =>
      tugaganYurishlar.where((y) => y.toplamId == toplamId && y.kun == bugun).length;

  /// Teg uchun: bugungi aylanalar + 1.
  int get aylanaRaqami => Sanash.bugungiAylanalar(_qator, bugun) + 1;

  /// Bugun barcha zikrlar bo'yicha tugagan aylanalar.
  int get bugunTugaganAylanalar => yigindilar[bugun]?.aylanalar ?? 0;

  StreakNatijasi get streak => KunHisobi.streak(hisoblanganKunlar, bugun);

  /// [zikrId] ning bugungi holati (Zikrlar ekranidagi kartalar uchun).
  ZikrHolatMalumoti holat(ZikrQator z) =>
      ZikrHolatHisobi.hisobla(oxirgiQatorlar[z.id], z.maqsad, bugun);

  SanagichHolati copyWith({
    Kun? bugun,
    List<ZikrQator>? zikrlar,
    int? joriyZikrId,
    Map<int, KunQatori>? oxirgiQatorlar,
    Map<Kun, KunYigindisi>? yigindilar,
    bool? haptik,
    Object? joriyToplamId = _yoq,
    Map<int, Yurish>? yurishlar,
    List<TugaganYurish>? tugaganYurishlar,
    Object? kechiktirilgan = _yoq,
    Map<int, Map<Kun, int>>? zikrKunlari,
    int? statistikaDavri,
    int? kunlikMaqsad,
    bool? tovush,
    bool? ovozTugmasi,
    bool? ekranYoniq,
    Mavzu? mavzu,
    bool? eslatmaYoniq,
    int? eslatmaDaqiqa,
    bool? onboardingKorildi,
  }) {
    return SanagichHolati(
      bugun: bugun ?? this.bugun,
      zikrlar: zikrlar ?? this.zikrlar,
      toplamlar: toplamlar,
      joriyZikrId: joriyZikrId ?? this.joriyZikrId,
      oxirgiQatorlar: oxirgiQatorlar ?? this.oxirgiQatorlar,
      yigindilar: yigindilar ?? this.yigindilar,
      haptik: haptik ?? this.haptik,
      kunlikMaqsad: kunlikMaqsad ?? this.kunlikMaqsad,
      joriyToplamId: identical(joriyToplamId, _yoq) ? this.joriyToplamId : joriyToplamId as int?,
      yurishlar: yurishlar ?? this.yurishlar,
      tugaganYurishlar: tugaganYurishlar ?? this.tugaganYurishlar,
      kechiktirilgan: identical(kechiktirilgan, _yoq)
          ? this.kechiktirilgan
          : kechiktirilgan as KechiktirilganTabrik?,
      zikrKunlari: zikrKunlari ?? this.zikrKunlari,
      statistikaDavri: statistikaDavri ?? this.statistikaDavri,
      tovush: tovush ?? this.tovush,
      ovozTugmasi: ovozTugmasi ?? this.ovozTugmasi,
      ekranYoniq: ekranYoniq ?? this.ekranYoniq,
      mavzu: mavzu ?? this.mavzu,
      eslatmaYoniq: eslatmaYoniq ?? this.eslatmaYoniq,
      eslatmaDaqiqa: eslatmaDaqiqa ?? this.eslatmaDaqiqa,
      onboardingKorildi: onboardingKorildi ?? this.onboardingKorildi,
    );
  }
}

class SanagichController extends AsyncNotifier<SanagichHolati> {
  final navbat = YozuvNavbati();

  SanagichRepository get _repo => ref.read(sanagichRepositoryProvider);
  YurishRepository get _yurishRepo => ref.read(yurishRepositoryProvider);
  Soat get _soat => ref.read(soatProvider);
  SanagichHolati get _h => state.requireValue;

  @override
  Future<SanagichHolati> build() async {
    final repo = _repo;
    final zikrlar = await repo.zikrlar();
    final saqlanganId = int.tryParse(await repo.sozlama(SozlamaKalit.joriyZikrId) ?? '');
    final joriyId = zikrlar.any((z) => z.id == saqlanganId) ? saqlanganId! : zikrlar.first.id;
    final kunlik = int.tryParse(await repo.sozlama(SozlamaKalit.kunlikMaqsad) ?? '');
    final toplamId = int.tryParse(await repo.sozlama(SozlamaKalit.joriyToplamId) ?? '');
    final davr = int.tryParse(await repo.sozlama(SozlamaKalit.statistikaDavri) ?? '');
    final yigindilar = {for (final y in await repo.kunlikYigindilar()) y.sana: y};
    final onboardingSozlama = await repo.sozlama(SozlamaKalit.onboardingKorildi);
    final onboardingKorildi =
        Onboarding.korildimi(sozlama: onboardingSozlama, sessiyaBor: yigindilar.isNotEmpty);
    // Mavjud foydalanuvchi belgilab qo'yiladi: hisob nollansa ham onboarding qaytmaydi.
    if (onboardingKorildi && onboardingSozlama != '1') {
      await repo.sozlamaniYoz(SozlamaKalit.onboardingKorildi, '1');
    }

    return SanagichHolati(
      bugun: Kun.dan(_soat.hozir()),
      zikrlar: zikrlar,
      toplamlar: await repo.toplamlar(),
      joriyZikrId: joriyId,
      oxirgiQatorlar: await repo.oxirgiQatorlar(),
      yigindilar: yigindilar,
      haptik: await repo.sozlama(SozlamaKalit.haptik) != '0',
      kunlikMaqsad: kunlik ?? SozlamaKalit.standartKunlikMaqsad,
      joriyToplamId: toplamId,
      yurishlar: await _yurishRepo.tugallanmaganlar(),
      tugaganYurishlar: await _yurishRepo.tugaganlar(),
      zikrKunlari: await repo.zikrKunlari(),
      statistikaDavri: davr == 30 ? 30 : SozlamaKalit.standartDavr,
      tovush: await repo.sozlama(SozlamaKalit.tovush) == '1',
      ovozTugmasi: await repo.sozlama(SozlamaKalit.ovozTugmasi) == '1',
      ekranYoniq: await repo.sozlama(SozlamaKalit.ekranYoniq) != '0',
      mavzu: Mavzu.ol(await repo.sozlama(SozlamaKalit.mavzu)),
      eslatmaYoniq: await repo.sozlama(SozlamaKalit.eslatmaYoniq) == '1',
      eslatmaDaqiqa: Eslatma.daqiqaga(await repo.sozlama(SozlamaKalit.eslatmaVaqti) ?? '') ??
          Eslatma.standartDaqiqa,
      onboardingKorildi: onboardingKorildi,
    );
  }

  /// Bitta bosish (alohida yoki to'plam rejimida).
  BosishHodisasi bos() {
    final h = _h;
    final vaqt = _soat.hozir();
    final bugun = Kun.dan(vaqt);
    final oldinHisoblangan = _kunHisoblanadimi(h, bugun);
    if (h.toplamRejimi) return _toplamdaBos(h, vaqt, bugun, oldinHisoblangan);

    final eski = h.oxirgiQatorlar[h.joriyZikrId];
    final natija = Sanash.bos(eski, h.joriyZikrId, h.maqsad, bugun);
    _qatorniOrnat(h, eski, natija.qator, bugun, vaqt);

    final qaror = TabrikHisobi.qaror(
      toplamRejimi: false,
      aylanaKunniHisoblatdi:
          natija.aylanaTugadi && !oldinHisoblangan && _kunHisoblanadimi(_h, bugun),
      toplamTugadi: false,
      kechiktirilgan: false,
    );
    Tabrik? tabrik;
    if (qaror.turi == TabrikTuri.kunHisoblandi) {
      tabrik = Tabrik(
        turi: TabrikTuri.kunHisoblandi,
        zikrId: h.joriyZikrId,
        maqsad: h.maqsad!, // aylana tugagan: maqsad ∞ emas
        streak: _h.streak.joriy,
      );
    }
    return BosishHodisasi(aylanaTugadi: natija.aylanaTugadi, tabrik: tabrik);
  }

  BosishHodisasi _toplamdaBos(SanagichHolati h, DateTime vaqt, Kun bugun, bool oldinHisoblangan) {
    final t = h.toplam!;
    final qadamlar = SanagichHolati.qadamlariniOl(t);
    final qadam = qadamlar[h.yurish!.qadam];
    final eski = h.oxirgiQatorlar[qadam.zikrId];
    final r = ToplamSanash.bos(h.yurish!, qadamlar, eski, bugun);
    _qatorniOrnat(h, eski, r.sessiya, bugun, vaqt);
    _yurishniOrnat(r.yurish, vaqt);

    final kunYangi = r.qadamTugadi && !oldinHisoblangan && _kunHisoblanadimi(_h, bugun);
    final qaror = TabrikHisobi.qaror(
      toplamRejimi: true,
      aylanaKunniHisoblatdi: kunYangi,
      toplamTugadi: r.toplamTugadi,
      kechiktirilgan: h.kechiktirilgan != null,
    );
    state = AsyncData(_h.copyWith(
      kechiktirilgan: qaror.kechiktirilgan
          ? (h.kechiktirilgan ?? (zikrId: qadam.zikrId, maqsad: qadam.maqsad))
          : null,
    ));

    Tabrik? tabrik;
    if (qaror.turi == TabrikTuri.toplamTugadi) {
      tabrik = Tabrik(
        turi: TabrikTuri.toplamTugadi,
        zikrId: qadam.zikrId,
        maqsad: qadam.maqsad,
        toplamId: t.id,
        jami: qadamlar.fold(0, (s, q) => s + q.maqsad),
        marta: _h.bugunTugaganlar(t.id),
        streak: qaror.dalda ? _h.streak.joriy : null,
      );
      // To'plam tugadi: rejimdan chiqib, birinchi zikrga qaytadi (modal ustida turadi).
      _toplamdanChiq(qadamlar.first.zikrId);
    }
    return BosishHodisasi(aylanaTugadi: r.qadamTugadi, tabrik: tabrik);
  }

  /// To'plam rejimida joriy qadamni o'tkazib yuboradi. Oxirgi qadamda yurish tugallanmagan
  /// holda yopiladi; kechiktirilgan "kun hisobga olindi" bo'lsa, shu tabrik qaytadi.
  Tabrik? qadamniOtkaz() {
    final h = _h;
    final t = h.toplam, y = h.yurish;
    if (t == null || y == null) return null;
    final vaqt = _soat.hozir();
    final keyingi = ToplamSanash.otkazibYubor(y, t.qadamlar.length);
    if (keyingi != null) {
      _yurishniOrnat(keyingi, vaqt);
      return null;
    }

    navbat.qosh(() => _yurishRepo.ochir(y.id!));
    state = AsyncData(h.copyWith(yurishlar: {...h.yurishlar}..remove(t.id)));
    _toplamdanChiq(t.qadamlar.first.zikrId);

    final kech = h.kechiktirilgan;
    final qaror = TabrikHisobi.qaror(
      toplamRejimi: true,
      aylanaKunniHisoblatdi: false,
      toplamTugadi: false,
      yurishYopildi: true,
      kechiktirilgan: kech != null,
    );
    if (qaror.turi != TabrikTuri.kunHisoblandi || kech == null) return null;
    return Tabrik(
      turi: TabrikTuri.kunHisoblandi,
      zikrId: kech.zikrId,
      maqsad: kech.maqsad,
      streak: _h.streak.joriy,
    );
  }

  /// To'plam rejimini boshlaydi yoki tugallanmagan yurishni davom ettiradi.
  Future<void> toplamniBoshla(int toplamId) async {
    if (_h.toplamById(toplamId) == null) return;
    final vaqt = _soat.hozir();
    final Yurish y = _h.yurishlar[toplamId] ??
        await navbat.bajar<Yurish>(
          () => _yurishRepo.qosh(ToplamSanash.yangi(toplamId, Kun.dan(vaqt)), vaqt),
        );
    state = AsyncData(_h.copyWith(
      yurishlar: {..._h.yurishlar, toplamId: y},
      joriyToplamId: toplamId,
      kechiktirilgan: null,
    ));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.joriyToplamId, '$toplamId'));
  }

  /// Joriy (yoki [zikrId]) zikrning aylanasini nollaydi. `son == 0` bo'lsa hech narsa qilmaydi.
  void nolla([int? zikrId]) {
    final h = _h;
    if (zikrId == null && h.toplamRejimi) {
      _toplamdaNolla(h);
      return;
    }
    final id = zikrId ?? h.joriyZikrId;
    final eski = h.oxirgiQatorlar[id];
    if (Sanash.joriySon(eski) == 0) return;
    final vaqt = _soat.hozir();
    final bugun = Kun.dan(vaqt);
    _qatorniOrnat(h, eski, Sanash.nolla(eski, id, bugun), bugun, vaqt);
  }

  void _toplamdaNolla(SanagichHolati h) {
    final y = h.yurish!;
    if (y.son == 0) return;
    final vaqt = _soat.hozir();
    final bugun = Kun.dan(vaqt);
    final zikrId = h.joriyQadam!.zikrId;
    final eski = h.oxirgiQatorlar[zikrId];
    final (yurish, sessiya) = ToplamSanash.nolla(y, zikrId, eski, bugun);
    _qatorniOrnat(h, eski, sessiya, bugun, vaqt);
    _yurishniOrnat(yurish, vaqt);
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

  /// Statistika davrini (7 yoki 30 kun) o'rnatadi.
  void davrniOrnat(int kunlar) {
    if (kunlar != 7 && kunlar != 30 || kunlar == _h.statistikaDavri) return;
    state = AsyncData(_h.copyWith(statistikaDavri: kunlar));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.statistikaDavri, '$kunlar'));
  }

  void tovushniAlmashtir() => _bool(SozlamaKalit.tovush, !_h.tovush, (v) => _h.copyWith(tovush: v));

  void ovozTugmasiniAlmashtir() =>
      _bool(SozlamaKalit.ovozTugmasi, !_h.ovozTugmasi, (v) => _h.copyWith(ovozTugmasi: v));

  void ekranYoniqniAlmashtir() =>
      _bool(SozlamaKalit.ekranYoniq, !_h.ekranYoniq, (v) => _h.copyWith(ekranYoniq: v));

  void mavzuniOrnat(Mavzu mavzu) {
    state = AsyncData(_h.copyWith(mavzu: mavzu));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.mavzu, mavzu.kalit));
  }

  /// Eslatmani yoqadi/o'chiradi yoki vaqtini o'zgartiradi. Ruxsatni UI so'raydi.
  void eslatmaniOrnat({bool? yoniq, int? daqiqa}) {
    final h = _h.copyWith(eslatmaYoniq: yoniq, eslatmaDaqiqa: daqiqa);
    state = AsyncData(h);
    navbat.qosh(() async {
      await _repo.sozlamaniYoz(SozlamaKalit.eslatmaYoniq, h.eslatmaYoniq ? '1' : '0');
      await _repo.sozlamaniYoz(SozlamaKalit.eslatmaVaqti, Eslatma.matnga(h.eslatmaDaqiqa));
    });
  }

  /// Kunlik maqsad (1–10 000). Kun hisobi va streak shu bilan qayta hisoblanadi.
  void kunlikMaqsadniOrnat(int maqsad) {
    if (maqsad < 1 || maqsad > 10000 || maqsad == _h.kunlikMaqsad) return;
    state = AsyncData(_h.copyWith(kunlikMaqsad: maqsad));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.kunlikMaqsad, '$maqsad'));
  }

  /// Onboarding tugadi: keyingi ochilishlarda ko'rsatilmaydi.
  void onboardingniYakunla() {
    state = AsyncData(_h.copyWith(onboardingKorildi: true));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.onboardingKorildi, '1'));
  }

  /// Zaxiradan tiklash yoki nollashdan keyin: yozuvlar tugagach holat bazadan qayta o'qiladi.
  Future<void> qaytaYukla() async {
    await navbat.tugashiniKut();
    ref.invalidateSelf();
    await future;
  }

  void _bool(String kalit, bool qiymat, SanagichHolati Function(bool) yangi) {
    state = AsyncData(yangi(qiymat));
    navbat.qosh(() => _repo.sozlamaniYoz(kalit, qiymat ? '1' : '0'));
  }

  void haptikniAlmashtir() {
    final yangi = !_h.haptik;
    state = AsyncData(_h.copyWith(haptik: yangi));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.haptik, yangi ? '1' : '0'));
  }

  /// Joriy zikrni almashtiradi. Har zikrning tugallanmagan soni o'z qatorida qoladi.
  ///
  /// To'plam rejimidan chiqadi; yurish saqlanib qoladi va yo'ldan davom ettiriladi.
  void zikrniTanla(int id) {
    final h = _h;
    if (!h.zikrlar.any((z) => z.id == id)) return;
    if (h.joriyToplamId != null) {
      _toplamdanChiq(id);
      return;
    }
    if (h.joriyZikrId == id) return;
    state = AsyncData(h.copyWith(joriyZikrId: id));
    navbat.qosh(() => _repo.sozlamaniYoz(SozlamaKalit.joriyZikrId, '$id'));
  }

  /// To'plam rejimidan chiqib, [zikrId] ni joriy qiladi.
  void _toplamdanChiq(int zikrId) {
    state = AsyncData(_h.copyWith(joriyToplamId: null, joriyZikrId: zikrId, kechiktirilgan: null));
    navbat.qosh(() async {
      await _repo.sozlamaniOchir(SozlamaKalit.joriyToplamId);
      await _repo.sozlamaniYoz(SozlamaKalit.joriyZikrId, '$zikrId');
    });
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
      zikrKunlari: {
        ...h.zikrKunlari,
        yangi.zikrId: {...?h.zikrKunlari[yangi.zikrId], bugun: yangi.jami},
      },
    ));
    navbat.qosh(() => _repo.qatorniYoz(yangi, vaqt));
  }

  /// Yurishni holatga qo'yadi va yozadi. Tugagan bo'lsa tugaganlar ro'yxatiga o'tadi.
  void _yurishniOrnat(Yurish y, DateTime vaqt) {
    final h = _h;
    state = AsyncData(h.copyWith(
      yurishlar: y.tugadi ? ({...h.yurishlar}..remove(y.toplamId)) : {...h.yurishlar, y.toplamId: y},
      tugaganYurishlar: y.tugadi
          ? [...h.tugaganYurishlar, (toplamId: y.toplamId, kun: Kun.dan(vaqt))]
          : null,
    ));
    navbat.qosh(() => _yurishRepo.yoz(y, vaqt));
  }

  bool _kunHisoblanadimi(SanagichHolati h, Kun bugun) => KunHisobi.hisoblanadimi(
        h.yigindilar[bugun] ?? KunYigindisi(sana: bugun),
        h.kunlikMaqsad,
      );
}
