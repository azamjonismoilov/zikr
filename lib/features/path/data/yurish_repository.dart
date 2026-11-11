import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../counter/domain/kun.dart';
import '../domain/yurish.dart';

/// Tugagan yurish: qaysi to'plam va qaysi kuni tugagan.
typedef TugaganYurish = ({int toplamId, Kun kun});

/// `toplam_yurish` jadvaliga kirish.
class YurishRepository {
  YurishRepository(this._db);

  final AppDatabase _db;

  /// Har to'plamning tugallanmagan yurishi.
  Future<Map<int, Yurish>> tugallanmaganlar() async {
    final qatorlar = await (_db.select(_db.toplamYurish)..where((y) => y.tugadi.equals(false))).get();
    return {for (final q in qatorlar) q.toplamId: _yurish(q)};
  }

  /// Tugagan yurishlar (kun — tugagan payt, mahalliy).
  Future<List<TugaganYurish>> tugaganlar() async {
    final qatorlar = await (_db.select(_db.toplamYurish)..where((y) => y.tugadi.equals(true))).get();
    return [for (final q in qatorlar) (toplamId: q.toplamId, kun: Kun.dan(q.yangilandi))];
  }

  Future<Yurish> qosh(Yurish y, DateTime vaqt) async {
    final id = await _db.into(_db.toplamYurish).insert(ToplamYurishCompanion.insert(
          toplamId: y.toplamId,
          sana: y.sana.kalit,
          qadam: Value(y.qadam),
          son: Value(y.son),
          tugadi: Value(y.tugadi),
          boshlandi: vaqt,
          yangilandi: vaqt,
        ));
    return y.copyWith(id: id);
  }

  Future<void> yoz(Yurish y, DateTime vaqt) =>
      (_db.update(_db.toplamYurish)..where((r) => r.id.equals(y.id!))).write(ToplamYurishCompanion(
        qadam: Value(y.qadam),
        son: Value(y.son),
        tugadi: Value(y.tugadi),
        yangilandi: Value(vaqt),
      ));

  Future<void> ochir(int id) => (_db.delete(_db.toplamYurish)..where((r) => r.id.equals(id))).go();

  Yurish _yurish(YurishQator q) => Yurish(
        id: q.id,
        toplamId: q.toplamId,
        sana: Kun.parse(q.sana),
        qadam: q.qadam,
        son: q.son,
        tugadi: q.tugadi,
      );
}
