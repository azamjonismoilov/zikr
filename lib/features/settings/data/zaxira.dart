import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../counter/data/sanagich_repository.dart';
import '../../counter/domain/kun.dart';

/// Zaxira fayli noto'g'ri bo'lganda. Ma'lumot o'zgarmaydi.
enum ZaxiraXatoTuri {
  /// JSON emas yoki zaxira fayli emas.
  notogriFayl,

  /// Ilovaning yangiroq versiyasida olingan zaxira.
  yangiVersiya,

  /// Format to'g'ri, lekin ichidagi ma'lumot buzilgan.
  buzuq,
}

class ZaxiraXatosi implements Exception {
  const ZaxiraXatosi(this.turi, [this.tafsilot]);

  final ZaxiraXatoTuri turi;
  final String? tafsilot;

  @override
  String toString() => 'ZaxiraXatosi($turi${tafsilot == null ? '' : ': $tafsilot'})';
}

/// Zaxira olish, tiklash va hisobni nollash.
///
/// Zaxiraga o'z zikrlari, standart zikrlarning maqsadlari, sessiyalar, yurishlar va
/// sozlamalar kiradi. Standart zikrlar matni seed'dan keladi, zaxirada saqlanmaydi.
class ZaxiraXizmati {
  ZaxiraXizmati(this._db);

  final AppDatabase _db;

  static const format = 'zikr-zaxira';
  static const formatVersiyasi = 1;

  /// Seed va onboarding holati zaxiraga kirmaydi: tiklangan bazada o'z qiymati qoladi.
  static const _tashqaridagiSozlamalar = {'seed_versiya', SozlamaKalit.onboardingKorildi};

  static String faylNomi(DateTime hozir) => 'zikr-zaxira-${Kun.dan(hozir).kalit}.json';

  Future<Map<String, Object?>> yarat(DateTime hozir) async {
    final zikrlar = await _db.select(_db.zikr).get();
    final sessiyalar = await _db.select(_db.sessiya).get();
    final yurishlar = await _db.select(_db.toplamYurish).get();
    final sozlamalar = await _db.select(_db.sozlama).get();
    return {
      'format': format,
      'formatVersiyasi': formatVersiyasi,
      'sxemaVersiyasi': _db.schemaVersion,
      'yaratildi': hozir.toIso8601String(),
      'ozZikrlar': [
        for (final z in zikrlar)
          if (z.ozZikri)
            {
              'id': z.id,
              'nomi': z.nomi,
              'talaffuz': z.talaffuz,
              'arabcha': z.arabcha,
              'manosi': z.manosi,
              'maqsad': z.maqsad,
              'rasm': z.rasm,
              'turkum': z.turkum,
              'tartib': z.tartib,
              'ochirilgan': z.ochirilgan,
            },
      ],
      'zikrMaqsadlari': [
        for (final z in zikrlar)
          if (!z.ozZikri) {'id': z.id, 'maqsad': z.maqsad},
      ],
      'sessiyalar': [
        for (final s in sessiyalar)
          {
            'zikrId': s.zikrId,
            'toplamId': s.toplamId,
            'sana': s.sana,
            'son': s.son,
            'jami': s.jami,
            'aylanalar': s.aylanalar,
            'boshlandi': s.boshlandi.toIso8601String(),
            'yangilandi': s.yangilandi.toIso8601String(),
          },
      ],
      'yurishlar': [
        for (final y in yurishlar)
          {
            'toplamId': y.toplamId,
            'sana': y.sana,
            'qadam': y.qadam,
            'son': y.son,
            'tugadi': y.tugadi,
            'boshlandi': y.boshlandi.toIso8601String(),
            'yangilandi': y.yangilandi.toIso8601String(),
          },
      ],
      'sozlamalar': [
        for (final s in sozlamalar)
          if (!_tashqaridagiSozlamalar.contains(s.kalit)) {'kalit': s.kalit, 'qiymat': s.qiymat},
      ],
    };
  }

  /// Zaxira faylining matni (UTF-8 JSON).
  Future<String> json(DateTime hozir) async =>
      const JsonEncoder.withIndent(' ').convert(await yarat(hozir));

  /// Faylni tekshiradi; to'g'ri bo'lsa tiklashga tayyor ma'lumotni qaytaradi.
  /// Eski sxema versiyasidagi zaxirada yo'q maydonlar standart qiymat oladi.
  Future<ZaxiraMalumoti> tekshir(String matn) async {
    final Object? xom;
    try {
      xom = jsonDecode(matn);
    } on FormatException {
      throw const ZaxiraXatosi(ZaxiraXatoTuri.notogriFayl);
    }
    if (xom is! Map<String, Object?> || xom['format'] != format) {
      throw const ZaxiraXatosi(ZaxiraXatoTuri.notogriFayl);
    }
    final fv = xom['formatVersiyasi'], sv = xom['sxemaVersiyasi'];
    if (fv is! int || sv is! int) throw const ZaxiraXatosi(ZaxiraXatoTuri.buzuq, 'versiya');
    if (fv > formatVersiyasi || sv > _db.schemaVersion) {
      throw const ZaxiraXatosi(ZaxiraXatoTuri.yangiVersiya);
    }

    try {
      final ozZikrlar = [
        for (final z in _royxat(xom, 'ozZikrlar'))
          ZikrCompanion.insert(
            id: Value(z['id'] as int),
            nomi: z['nomi'] as String,
            talaffuz: Value(z['talaffuz'] as String?),
            arabcha: (z['arabcha'] as String?) ?? '',
            manosi: (z['manosi'] as String?) ?? '',
            maqsad: Value(z['maqsad'] as int?),
            rasm: Value(z['rasm'] as String?),
            turkum: (z['turkum'] as String?) ?? 'kun_davomida',
            ozZikri: const Value(true),
            tartib: z['tartib'] as int,
            // v3 dan oldin `ochirilgan` yo'q edi.
            ochirilgan: Value((z['ochirilgan'] as bool?) ?? false),
          ),
      ];
      final maqsadlar = <int, int?>{
        for (final z in _royxat(xom, 'zikrMaqsadlari')) z['id'] as int: z['maqsad'] as int?,
      };
      // Eski zaxirada `jami` bo'lmasa, taxminan tiklanadi: aylanalar × maqsad + son.
      final seedMaqsad = {
        for (final z in await (_db.select(_db.zikr)..where((z) => z.ozZikri.equals(false))).get())
          z.id: z.maqsad,
      };
      int? zikrMaqsadi(int id) {
        for (final z in ozZikrlar) {
          if (z.id.value == id) return z.maqsad.value;
        }
        return maqsadlar.containsKey(id) ? maqsadlar[id] : seedMaqsad[id];
      }

      final mavjudIdlar = {...seedMaqsad.keys, for (final z in ozZikrlar) z.id.value};
      final sessiyalar = [
        for (final s in _royxat(xom, 'sessiyalar'))
          () {
            final zikrId = s['zikrId'] as int;
            if (!mavjudIdlar.contains(zikrId)) throw FormatException('zikr $zikrId yo\'q');
            final son = s['son'] as int;
            final aylanalar = s['aylanalar'] as int;
            final sana = s['sana'] as String;
            Kun.parse(sana);
            return SessiyaCompanion.insert(
              zikrId: zikrId,
              toplamId: Value(s['toplamId'] as int?),
              sana: sana,
              son: Value(son),
              aylanalar: Value(aylanalar),
              jami: Value((s['jami'] as int?) ?? aylanalar * (zikrMaqsadi(zikrId) ?? 0) + son),
              boshlandi: DateTime.parse(s['boshlandi'] as String),
              yangilandi: DateTime.parse(s['yangilandi'] as String),
            );
          }(),
      ];
      final yurishlar = [
        // v4 dan oldin yurishlar yo'q edi.
        for (final y in _royxat(xom, 'yurishlar', majburiy: false))
          ToplamYurishCompanion.insert(
            toplamId: y['toplamId'] as int,
            sana: y['sana'] as String,
            qadam: Value(y['qadam'] as int),
            son: Value(y['son'] as int),
            tugadi: Value(y['tugadi'] as bool),
            boshlandi: DateTime.parse(y['boshlandi'] as String),
            yangilandi: DateTime.parse(y['yangilandi'] as String),
          ),
      ];
      final sozlamalar = [
        for (final s in _royxat(xom, 'sozlamalar'))
          if (!_tashqaridagiSozlamalar.contains(s['kalit']))
            SozlamaCompanion.insert(kalit: s['kalit'] as String, qiymat: s['qiymat'] as String),
      ];
      return ZaxiraMalumoti._(ozZikrlar, maqsadlar, sessiyalar, yurishlar, sozlamalar);
    } on ZaxiraXatosi {
      rethrow;
    } catch (e) {
      // TypeError, FormatException va boshqalar: tuzilma buzilgan.
      throw ZaxiraXatosi(ZaxiraXatoTuri.buzuq, '$e');
    }
  }

  /// Hozirgi ma'lumotni zaxiradagi bilan bitta tranzaksiyada almashtiradi.
  /// Standart zikrlar va to'plamlar seed'dan qoladi.
  Future<void> tikla(ZaxiraMalumoti m) {
    return _db.transaction(() async {
      await _db.delete(_db.sessiya).go();
      await _db.delete(_db.toplamYurish).go();
      await (_db.delete(_db.zikr)..where((z) => z.ozZikri.equals(true))).go();
      await (_db.delete(_db.sozlama)..where((s) => s.kalit.isNotIn(_tashqaridagiSozlamalar))).go();

      for (final z in m._ozZikrlar) {
        await _db.into(_db.zikr).insert(z);
      }
      for (final MapEntry(key: id, value: maqsad) in m._maqsadlar.entries) {
        await (_db.update(_db.zikr)..where((z) => z.id.equals(id) & z.ozZikri.equals(false)))
            .write(ZikrCompanion(maqsad: Value(maqsad)));
      }
      for (final s in m._sessiyalar) {
        await _db.into(_db.sessiya).insert(s);
      }
      for (final y in m._yurishlar) {
        await _db.into(_db.toplamYurish).insert(y);
      }
      for (final s in m._sozlamalar) {
        await _db.into(_db.sozlama).insert(s);
      }
    });
  }

  /// Hisobni nollash: barcha sessiyalar va yurishlar o'chadi; zikrlar va sozlamalar qoladi.
  Future<void> hisobniNolla() {
    return _db.transaction(() async {
      await _db.delete(_db.sessiya).go();
      await _db.delete(_db.toplamYurish).go();
      // Yurishlar o'chgani uchun to'plam rejimi ham tugaydi.
      await (_db.delete(_db.sozlama)..where((s) => s.kalit.equals(SozlamaKalit.joriyToplamId))).go();
    });
  }

  static List<Map<String, Object?>> _royxat(
    Map<String, Object?> xom,
    String kalit, {
    bool majburiy = true,
  }) {
    final r = xom[kalit];
    if (r == null && !majburiy) return const [];
    return (r as List).cast<Map<String, Object?>>();
  }
}

/// Tekshirilgan, tiklashga tayyor zaxira.
class ZaxiraMalumoti {
  ZaxiraMalumoti._(this._ozZikrlar, this._maqsadlar, this._sessiyalar, this._yurishlar, this._sozlamalar);

  final List<ZikrCompanion> _ozZikrlar;
  final Map<int, int?> _maqsadlar;
  final List<SessiyaCompanion> _sessiyalar;
  final List<ToplamYurishCompanion> _yurishlar;
  final List<SozlamaCompanion> _sozlamalar;

  int get sessiyalarSoni => _sessiyalar.length;
}
