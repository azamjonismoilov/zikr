import 'dart:convert';

import 'package:drift/drift.dart';

/// To'plamdagi bitta qadam.
class Qadam {
  const Qadam({required this.zikrId, required this.maqsad});

  final int zikrId;
  final int maqsad;

  factory Qadam.fromJson(Map<String, dynamic> json) =>
      Qadam(zikrId: json['zikr_id'] as int, maqsad: json['maqsad'] as int);

  Map<String, dynamic> toJson() => {'zikr_id': zikrId, 'maqsad': maqsad};
}

class QadamlarConverter extends TypeConverter<List<Qadam>, String> {
  const QadamlarConverter();

  @override
  List<Qadam> fromSql(String fromDb) => (jsonDecode(fromDb) as List)
      .map((e) => Qadam.fromJson(e as Map<String, dynamic>))
      .toList();

  @override
  String toSql(List<Qadam> value) =>
      jsonEncode(value.map((q) => q.toJson()).toList());
}

@DataClassName('ZikrQator')
class Zikr extends Table {
  @override
  String get tableName => 'zikr';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomi => text()();
  /// `null` — nomining o'zi talaffuz.
  TextColumn get talaffuz => text().nullable()();
  TextColumn get arabcha => text()();
  TextColumn get manosi => text()();

  /// `null` — cheksiz (∞), aylana bo'lmaydi.
  IntColumn get maqsad => integer().nullable()();
  /// `assets/svg/rasm_<rasm>.svg` dagi nom, masalan `tasbeh`.
  TextColumn get rasm => text().nullable()();
  TextColumn get turkum => text()();
  BoolColumn get ozZikri => boolean().named('oz_zikri').withDefault(const Constant(false))();
  IntColumn get tartib => integer()();

  /// O'chirilgan zikr ro'yxatlarda ko'rinmaydi, sessiyalari saqlanadi (v3).
  BoolColumn get ochirilgan => boolean().withDefault(const Constant(false))();
}

@DataClassName('ToplamQator')
class Toplam extends Table {
  @override
  String get tableName => 'toplam';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomi => text()();
  TextColumn get qadamlar => text().map(const QadamlarConverter())();
}

/// Har zikr uchun har kalendar kunga bitta qator.
@DataClassName('SessiyaQator')
@TableIndex(name: 'sessiya_zikr_sana', columns: {#zikrId, #sana}, unique: true)
class Sessiya extends Table {
  @override
  String get tableName => 'sessiya';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get zikrId => integer().named('zikr_id').references(Zikr, #id)();
  IntColumn get toplamId => integer().named('toplam_id').nullable().references(Toplam, #id)();

  /// Joriy aylanadagi son.
  IntColumn get son => integer().withDefault(const Constant(0))();

  /// Shu kuni tugagan aylanalar.
  IntColumn get aylanalar => integer().withDefault(const Constant(0))();

  /// Shu kuni shu zikr bo'yicha barcha bosishlar (v2).
  IntColumn get jami => integer().withDefault(const Constant(0))();
  DateTimeColumn get boshlandi => dateTime()();
  DateTimeColumn get yangilandi => dateTime()();

  /// Mahalliy kalendar kuni, `YYYY-MM-DD`.
  TextColumn get sana => text()();
}

/// To'plam bo'yicha bitta o'tish (Tasbehot yo'li). Tugaganlari saqlanadi (kunlik soni uchun).
/// Har to'plamga bir vaqtda ko'pi bilan bitta tugallanmagan yurish (qisman unikal indeks).
@DataClassName('YurishQator')
@TableIndex.sql(
  'CREATE UNIQUE INDEX toplam_yurish_tugallanmagan ON toplam_yurish (toplam_id) WHERE tugadi = 0',
)
class ToplamYurish extends Table {
  @override
  String get tableName => 'toplam_yurish';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get toplamId => integer().named('toplam_id').references(Toplam, #id)();

  /// Boshlangan mahalliy kun, `YYYY-MM-DD`.
  TextColumn get sana => text()();

  /// Joriy qadam indeksi, 0 dan.
  IntColumn get qadam => integer().withDefault(const Constant(0))();

  /// Joriy qadamdagi son.
  IntColumn get son => integer().withDefault(const Constant(0))();
  BoolColumn get tugadi => boolean().withDefault(const Constant(false))();
  DateTimeColumn get boshlandi => dateTime()();
  DateTimeColumn get yangilandi => dateTime()();
}

@DataClassName('SozlamaQator')
class Sozlama extends Table {
  @override
  String get tableName => 'sozlama';

  TextColumn get kalit => text()();
  TextColumn get qiymat => text()();

  @override
  Set<Column> get primaryKey => {kalit};
}
