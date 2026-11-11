import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../library/domain/bolimlar.dart';
import '../../library/domain/oz_zikr.dart';
import '../domain/kun.dart';
import '../domain/kun_hisobi.dart';
import '../domain/kun_qatori.dart';

/// `sozlama` kalitlari va standart qiymatlari.
abstract final class SozlamaKalit {
  static const joriyZikrId = 'joriy_zikr_id';
  static const haptik = 'haptik';
  static const kunlikMaqsad = 'kunlik_maqsad';

  /// Bo'sh bo'lmasa, sanagich shu to'plam rejimida.
  static const joriyToplamId = 'joriy_toplam_id';

  static const tovush = 'tovush';
  static const ovozTugmasi = 'ovoz_tugmasi';
  static const ekranYoniq = 'ekran_yoniq';
  static const mavzu = 'mavzu';
  static const eslatmaYoniq = 'eslatma_yoniq';

  /// "HH:MM", mahalliy vaqt.
  static const eslatmaVaqti = 'eslatma_vaqti';

    /// Statistika davri: `7` yoki `30` kun.
  static const statistikaDavri = 'statistika_davri';
  static const standartDavr = 7;

  static const standartKunlikMaqsad = 100;

  /// `1` — onboarding o'tilgan yoki o'tkazib yuborilgan.
  static const onboardingKorildi = 'onboarding_korildi';
}

/// Sanagich uchun bazaga kirish. Mantiq yo'q, faqat o'qish va yozish.
class SanagichRepository {
  SanagichRepository(this._db);

  final AppDatabase _db;

  /// O'chirilmagan zikrlar, `tartib` bo'yicha.
  Future<List<ZikrQator>> zikrlar() => (_db.select(_db.zikr)
        ..where((z) => z.ochirilgan.equals(false))
        ..orderBy([(z) => OrderingTerm(expression: z.tartib)]))
      .get();

  /// Yangi o'z zikri. Ro'yxat oxiriga qo'yiladi.
  Future<ZikrQator> ozZikrQosh(OzZikr z) async {
    final engKatta = _db.zikr.tartib.max();
    final tartib = await (_db.selectOnly(_db.zikr)..addColumns([engKatta]))
        .map((r) => r.read(engKatta) ?? 0)
        .getSingle();
    return _db.into(_db.zikr).insertReturning(ZikrCompanion.insert(
          nomi: z.nomi.trim(),
          arabcha: z.arabcha.trim(),
          manosi: z.manosi.trim(),
          maqsad: Value(z.maqsad),
          rasm: Value(z.rasm),
          turkum: ozZikriTurkumi,
          ozZikri: const Value(true),
          tartib: tartib + 1,
        ));
  }

  Future<ZikrQator> zikrniYangila(int id, OzZikr z) async {
    final yangi = await (_db.update(_db.zikr)..where((r) => r.id.equals(id))).writeReturning(
      ZikrCompanion(
        nomi: Value(z.nomi.trim()),
        arabcha: Value(z.arabcha.trim()),
        manosi: Value(z.manosi.trim()),
        maqsad: Value(z.maqsad),
        rasm: Value(z.rasm),
      ),
    );
    return yangi.single;
  }

  /// Zikrni ro'yxatlardan yashiradi; `sessiya` qatorlari o'zgarmaydi.
  Future<void> zikrniOchir(int id) => (_db.update(_db.zikr)..where((z) => z.id.equals(id)))
      .write(const ZikrCompanion(ochirilgan: Value(true)));

  Future<List<ToplamQator>> toplamlar() =>
      (_db.select(_db.toplam)..orderBy([(t) => OrderingTerm(expression: t.id)])).get();

  /// Har zikrning eng so'nggi kun qatori.
  Future<Map<int, KunQatori>> oxirgiQatorlar() async {
    final qatorlar = await (_db.select(_db.sessiya)
          ..orderBy([(s) => OrderingTerm(expression: s.sana, mode: OrderingMode.desc)]))
        .get();
    final natija = <int, KunQatori>{};
    for (final q in qatorlar) {
      natija.putIfAbsent(q.zikrId, () => _kunQatori(q));
    }
    return natija;
  }

  /// Har zikrning har kungi `jami` si (o'chirilgan zikrlar ham).
  Future<Map<int, Map<Kun, int>>> zikrKunlari() async {
    final qatorlar = await _db.select(_db.sessiya).get();
    final natija = <int, Map<Kun, int>>{};
    for (final q in qatorlar) {
      natija.putIfAbsent(q.zikrId, () => {})[Kun.parse(q.sana)] = q.jami;
    }
    return natija;
  }

  /// Har kun bo'yicha barcha zikrlar yig'indisi.
  Future<List<KunYigindisi>> kunlikYigindilar() async {
    final aylanalar = _db.sessiya.aylanalar.sum();
    final jami = _db.sessiya.jami.sum();
    final so = _db.selectOnly(_db.sessiya)
      ..addColumns([_db.sessiya.sana, aylanalar, jami])
      ..groupBy([_db.sessiya.sana]);
    final qatorlar = await so.get();
    return [
      for (final r in qatorlar)
        KunYigindisi(
          sana: Kun.parse(r.read(_db.sessiya.sana)!),
          aylanalar: r.read(aylanalar) ?? 0,
          jami: r.read(jami) ?? 0,
        ),
    ];
  }

  /// Kun qatorini yozadi: (zikr_id, sana) bo'yicha bor bo'lsa yangilaydi.
  Future<void> qatorniYoz(KunQatori q, DateTime vaqt) {
    return _db.into(_db.sessiya).insert(
          SessiyaCompanion.insert(
            zikrId: q.zikrId,
            sana: q.sana.kalit,
            son: Value(q.son),
            jami: Value(q.jami),
            aylanalar: Value(q.aylanalar),
            boshlandi: vaqt,
            yangilandi: vaqt,
          ),
          onConflict: DoUpdate(
            (_) => SessiyaCompanion(
              son: Value(q.son),
              jami: Value(q.jami),
              aylanalar: Value(q.aylanalar),
              yangilandi: Value(vaqt),
            ),
            target: [_db.sessiya.zikrId, _db.sessiya.sana],
          ),
        );
  }

  Future<void> maqsadniYoz(int zikrId, int? maqsad) =>
      (_db.update(_db.zikr)..where((z) => z.id.equals(zikrId)))
          .write(ZikrCompanion(maqsad: Value(maqsad)));

  Future<String?> sozlama(String kalit) async {
    final q = await (_db.select(_db.sozlama)..where((s) => s.kalit.equals(kalit)))
        .getSingleOrNull();
    return q?.qiymat;
  }

  Future<void> sozlamaniYoz(String kalit, String qiymat) => _db
      .into(_db.sozlama)
      .insertOnConflictUpdate(SozlamaCompanion.insert(kalit: kalit, qiymat: qiymat));

  Future<void> sozlamaniOchir(String kalit) =>
      (_db.delete(_db.sozlama)..where((s) => s.kalit.equals(kalit))).go();

  KunQatori _kunQatori(SessiyaQator q) => KunQatori(
        zikrId: q.zikrId,
        sana: Kun.parse(q.sana),
        son: q.son,
        jami: q.jami,
        aylanalar: q.aylanalar,
      );
}
