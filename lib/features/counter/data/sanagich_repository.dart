import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../domain/kun.dart';
import '../domain/kun_hisobi.dart';
import '../domain/kun_qatori.dart';

/// `sozlama` kalitlari va standart qiymatlari.
abstract final class SozlamaKalit {
  static const joriyZikrId = 'joriy_zikr_id';
  static const haptik = 'haptik';
  static const kunlikMaqsad = 'kunlik_maqsad';

  static const standartKunlikMaqsad = 100;
}

/// Sanagich uchun bazaga kirish. Mantiq yo'q, faqat o'qish va yozish.
class SanagichRepository {
  SanagichRepository(this._db);

  final AppDatabase _db;

  Future<List<ZikrQator>> zikrlar() =>
      (_db.select(_db.zikr)..orderBy([(z) => OrderingTerm(expression: z.tartib)])).get();

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

  KunQatori _kunQatori(SessiyaQator q) => KunQatori(
        zikrId: q.zikrId,
        sana: Kun.parse(q.sana),
        son: q.son,
        jami: q.jami,
        aylanalar: q.aylanalar,
      );
}
