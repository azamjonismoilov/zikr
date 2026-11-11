// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ZikrTable extends Zikr with TableInfo<$ZikrTable, ZikrQator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZikrTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomiMeta = const VerificationMeta('nomi');
  @override
  late final GeneratedColumn<String> nomi = GeneratedColumn<String>(
    'nomi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _talaffuzMeta = const VerificationMeta(
    'talaffuz',
  );
  @override
  late final GeneratedColumn<String> talaffuz = GeneratedColumn<String>(
    'talaffuz',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arabchaMeta = const VerificationMeta(
    'arabcha',
  );
  @override
  late final GeneratedColumn<String> arabcha = GeneratedColumn<String>(
    'arabcha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manosiMeta = const VerificationMeta('manosi');
  @override
  late final GeneratedColumn<String> manosi = GeneratedColumn<String>(
    'manosi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maqsadMeta = const VerificationMeta('maqsad');
  @override
  late final GeneratedColumn<int> maqsad = GeneratedColumn<int>(
    'maqsad',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rasmMeta = const VerificationMeta('rasm');
  @override
  late final GeneratedColumn<String> rasm = GeneratedColumn<String>(
    'rasm',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _turkumMeta = const VerificationMeta('turkum');
  @override
  late final GeneratedColumn<String> turkum = GeneratedColumn<String>(
    'turkum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ozZikriMeta = const VerificationMeta(
    'ozZikri',
  );
  @override
  late final GeneratedColumn<bool> ozZikri = GeneratedColumn<bool>(
    'oz_zikri',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("oz_zikri" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tartibMeta = const VerificationMeta('tartib');
  @override
  late final GeneratedColumn<int> tartib = GeneratedColumn<int>(
    'tartib',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ochirilganMeta = const VerificationMeta(
    'ochirilgan',
  );
  @override
  late final GeneratedColumn<bool> ochirilgan = GeneratedColumn<bool>(
    'ochirilgan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ochirilgan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nomi,
    talaffuz,
    arabcha,
    manosi,
    maqsad,
    rasm,
    turkum,
    ozZikri,
    tartib,
    ochirilgan,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zikr';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZikrQator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nomi')) {
      context.handle(
        _nomiMeta,
        nomi.isAcceptableOrUnknown(data['nomi']!, _nomiMeta),
      );
    } else if (isInserting) {
      context.missing(_nomiMeta);
    }
    if (data.containsKey('talaffuz')) {
      context.handle(
        _talaffuzMeta,
        talaffuz.isAcceptableOrUnknown(data['talaffuz']!, _talaffuzMeta),
      );
    }
    if (data.containsKey('arabcha')) {
      context.handle(
        _arabchaMeta,
        arabcha.isAcceptableOrUnknown(data['arabcha']!, _arabchaMeta),
      );
    } else if (isInserting) {
      context.missing(_arabchaMeta);
    }
    if (data.containsKey('manosi')) {
      context.handle(
        _manosiMeta,
        manosi.isAcceptableOrUnknown(data['manosi']!, _manosiMeta),
      );
    } else if (isInserting) {
      context.missing(_manosiMeta);
    }
    if (data.containsKey('maqsad')) {
      context.handle(
        _maqsadMeta,
        maqsad.isAcceptableOrUnknown(data['maqsad']!, _maqsadMeta),
      );
    }
    if (data.containsKey('rasm')) {
      context.handle(
        _rasmMeta,
        rasm.isAcceptableOrUnknown(data['rasm']!, _rasmMeta),
      );
    }
    if (data.containsKey('turkum')) {
      context.handle(
        _turkumMeta,
        turkum.isAcceptableOrUnknown(data['turkum']!, _turkumMeta),
      );
    } else if (isInserting) {
      context.missing(_turkumMeta);
    }
    if (data.containsKey('oz_zikri')) {
      context.handle(
        _ozZikriMeta,
        ozZikri.isAcceptableOrUnknown(data['oz_zikri']!, _ozZikriMeta),
      );
    }
    if (data.containsKey('tartib')) {
      context.handle(
        _tartibMeta,
        tartib.isAcceptableOrUnknown(data['tartib']!, _tartibMeta),
      );
    } else if (isInserting) {
      context.missing(_tartibMeta);
    }
    if (data.containsKey('ochirilgan')) {
      context.handle(
        _ochirilganMeta,
        ochirilgan.isAcceptableOrUnknown(data['ochirilgan']!, _ochirilganMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZikrQator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZikrQator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomi'],
      )!,
      talaffuz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}talaffuz'],
      ),
      arabcha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabcha'],
      )!,
      manosi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manosi'],
      )!,
      maqsad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maqsad'],
      ),
      rasm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rasm'],
      ),
      turkum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turkum'],
      )!,
      ozZikri: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}oz_zikri'],
      )!,
      tartib: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tartib'],
      )!,
      ochirilgan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ochirilgan'],
      )!,
    );
  }

  @override
  $ZikrTable createAlias(String alias) {
    return $ZikrTable(attachedDatabase, alias);
  }
}

class ZikrQator extends DataClass implements Insertable<ZikrQator> {
  final int id;
  final String nomi;

  /// `null` — nomining o'zi talaffuz.
  final String? talaffuz;
  final String arabcha;
  final String manosi;

  /// `null` — cheksiz (∞), aylana bo'lmaydi.
  final int? maqsad;

  /// `assets/svg/rasm_<rasm>.svg` dagi nom, masalan `tasbeh`.
  final String? rasm;
  final String turkum;
  final bool ozZikri;
  final int tartib;

  /// O'chirilgan zikr ro'yxatlarda ko'rinmaydi, sessiyalari saqlanadi (v3).
  final bool ochirilgan;
  const ZikrQator({
    required this.id,
    required this.nomi,
    this.talaffuz,
    required this.arabcha,
    required this.manosi,
    this.maqsad,
    this.rasm,
    required this.turkum,
    required this.ozZikri,
    required this.tartib,
    required this.ochirilgan,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nomi'] = Variable<String>(nomi);
    if (!nullToAbsent || talaffuz != null) {
      map['talaffuz'] = Variable<String>(talaffuz);
    }
    map['arabcha'] = Variable<String>(arabcha);
    map['manosi'] = Variable<String>(manosi);
    if (!nullToAbsent || maqsad != null) {
      map['maqsad'] = Variable<int>(maqsad);
    }
    if (!nullToAbsent || rasm != null) {
      map['rasm'] = Variable<String>(rasm);
    }
    map['turkum'] = Variable<String>(turkum);
    map['oz_zikri'] = Variable<bool>(ozZikri);
    map['tartib'] = Variable<int>(tartib);
    map['ochirilgan'] = Variable<bool>(ochirilgan);
    return map;
  }

  ZikrCompanion toCompanion(bool nullToAbsent) {
    return ZikrCompanion(
      id: Value(id),
      nomi: Value(nomi),
      talaffuz: talaffuz == null && nullToAbsent
          ? const Value.absent()
          : Value(talaffuz),
      arabcha: Value(arabcha),
      manosi: Value(manosi),
      maqsad: maqsad == null && nullToAbsent
          ? const Value.absent()
          : Value(maqsad),
      rasm: rasm == null && nullToAbsent ? const Value.absent() : Value(rasm),
      turkum: Value(turkum),
      ozZikri: Value(ozZikri),
      tartib: Value(tartib),
      ochirilgan: Value(ochirilgan),
    );
  }

  factory ZikrQator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZikrQator(
      id: serializer.fromJson<int>(json['id']),
      nomi: serializer.fromJson<String>(json['nomi']),
      talaffuz: serializer.fromJson<String?>(json['talaffuz']),
      arabcha: serializer.fromJson<String>(json['arabcha']),
      manosi: serializer.fromJson<String>(json['manosi']),
      maqsad: serializer.fromJson<int?>(json['maqsad']),
      rasm: serializer.fromJson<String?>(json['rasm']),
      turkum: serializer.fromJson<String>(json['turkum']),
      ozZikri: serializer.fromJson<bool>(json['ozZikri']),
      tartib: serializer.fromJson<int>(json['tartib']),
      ochirilgan: serializer.fromJson<bool>(json['ochirilgan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomi': serializer.toJson<String>(nomi),
      'talaffuz': serializer.toJson<String?>(talaffuz),
      'arabcha': serializer.toJson<String>(arabcha),
      'manosi': serializer.toJson<String>(manosi),
      'maqsad': serializer.toJson<int?>(maqsad),
      'rasm': serializer.toJson<String?>(rasm),
      'turkum': serializer.toJson<String>(turkum),
      'ozZikri': serializer.toJson<bool>(ozZikri),
      'tartib': serializer.toJson<int>(tartib),
      'ochirilgan': serializer.toJson<bool>(ochirilgan),
    };
  }

  ZikrQator copyWith({
    int? id,
    String? nomi,
    Value<String?> talaffuz = const Value.absent(),
    String? arabcha,
    String? manosi,
    Value<int?> maqsad = const Value.absent(),
    Value<String?> rasm = const Value.absent(),
    String? turkum,
    bool? ozZikri,
    int? tartib,
    bool? ochirilgan,
  }) => ZikrQator(
    id: id ?? this.id,
    nomi: nomi ?? this.nomi,
    talaffuz: talaffuz.present ? talaffuz.value : this.talaffuz,
    arabcha: arabcha ?? this.arabcha,
    manosi: manosi ?? this.manosi,
    maqsad: maqsad.present ? maqsad.value : this.maqsad,
    rasm: rasm.present ? rasm.value : this.rasm,
    turkum: turkum ?? this.turkum,
    ozZikri: ozZikri ?? this.ozZikri,
    tartib: tartib ?? this.tartib,
    ochirilgan: ochirilgan ?? this.ochirilgan,
  );
  ZikrQator copyWithCompanion(ZikrCompanion data) {
    return ZikrQator(
      id: data.id.present ? data.id.value : this.id,
      nomi: data.nomi.present ? data.nomi.value : this.nomi,
      talaffuz: data.talaffuz.present ? data.talaffuz.value : this.talaffuz,
      arabcha: data.arabcha.present ? data.arabcha.value : this.arabcha,
      manosi: data.manosi.present ? data.manosi.value : this.manosi,
      maqsad: data.maqsad.present ? data.maqsad.value : this.maqsad,
      rasm: data.rasm.present ? data.rasm.value : this.rasm,
      turkum: data.turkum.present ? data.turkum.value : this.turkum,
      ozZikri: data.ozZikri.present ? data.ozZikri.value : this.ozZikri,
      tartib: data.tartib.present ? data.tartib.value : this.tartib,
      ochirilgan: data.ochirilgan.present
          ? data.ochirilgan.value
          : this.ochirilgan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZikrQator(')
          ..write('id: $id, ')
          ..write('nomi: $nomi, ')
          ..write('talaffuz: $talaffuz, ')
          ..write('arabcha: $arabcha, ')
          ..write('manosi: $manosi, ')
          ..write('maqsad: $maqsad, ')
          ..write('rasm: $rasm, ')
          ..write('turkum: $turkum, ')
          ..write('ozZikri: $ozZikri, ')
          ..write('tartib: $tartib, ')
          ..write('ochirilgan: $ochirilgan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nomi,
    talaffuz,
    arabcha,
    manosi,
    maqsad,
    rasm,
    turkum,
    ozZikri,
    tartib,
    ochirilgan,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZikrQator &&
          other.id == this.id &&
          other.nomi == this.nomi &&
          other.talaffuz == this.talaffuz &&
          other.arabcha == this.arabcha &&
          other.manosi == this.manosi &&
          other.maqsad == this.maqsad &&
          other.rasm == this.rasm &&
          other.turkum == this.turkum &&
          other.ozZikri == this.ozZikri &&
          other.tartib == this.tartib &&
          other.ochirilgan == this.ochirilgan);
}

class ZikrCompanion extends UpdateCompanion<ZikrQator> {
  final Value<int> id;
  final Value<String> nomi;
  final Value<String?> talaffuz;
  final Value<String> arabcha;
  final Value<String> manosi;
  final Value<int?> maqsad;
  final Value<String?> rasm;
  final Value<String> turkum;
  final Value<bool> ozZikri;
  final Value<int> tartib;
  final Value<bool> ochirilgan;
  const ZikrCompanion({
    this.id = const Value.absent(),
    this.nomi = const Value.absent(),
    this.talaffuz = const Value.absent(),
    this.arabcha = const Value.absent(),
    this.manosi = const Value.absent(),
    this.maqsad = const Value.absent(),
    this.rasm = const Value.absent(),
    this.turkum = const Value.absent(),
    this.ozZikri = const Value.absent(),
    this.tartib = const Value.absent(),
    this.ochirilgan = const Value.absent(),
  });
  ZikrCompanion.insert({
    this.id = const Value.absent(),
    required String nomi,
    this.talaffuz = const Value.absent(),
    required String arabcha,
    required String manosi,
    this.maqsad = const Value.absent(),
    this.rasm = const Value.absent(),
    required String turkum,
    this.ozZikri = const Value.absent(),
    required int tartib,
    this.ochirilgan = const Value.absent(),
  }) : nomi = Value(nomi),
       arabcha = Value(arabcha),
       manosi = Value(manosi),
       turkum = Value(turkum),
       tartib = Value(tartib);
  static Insertable<ZikrQator> custom({
    Expression<int>? id,
    Expression<String>? nomi,
    Expression<String>? talaffuz,
    Expression<String>? arabcha,
    Expression<String>? manosi,
    Expression<int>? maqsad,
    Expression<String>? rasm,
    Expression<String>? turkum,
    Expression<bool>? ozZikri,
    Expression<int>? tartib,
    Expression<bool>? ochirilgan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomi != null) 'nomi': nomi,
      if (talaffuz != null) 'talaffuz': talaffuz,
      if (arabcha != null) 'arabcha': arabcha,
      if (manosi != null) 'manosi': manosi,
      if (maqsad != null) 'maqsad': maqsad,
      if (rasm != null) 'rasm': rasm,
      if (turkum != null) 'turkum': turkum,
      if (ozZikri != null) 'oz_zikri': ozZikri,
      if (tartib != null) 'tartib': tartib,
      if (ochirilgan != null) 'ochirilgan': ochirilgan,
    });
  }

  ZikrCompanion copyWith({
    Value<int>? id,
    Value<String>? nomi,
    Value<String?>? talaffuz,
    Value<String>? arabcha,
    Value<String>? manosi,
    Value<int?>? maqsad,
    Value<String?>? rasm,
    Value<String>? turkum,
    Value<bool>? ozZikri,
    Value<int>? tartib,
    Value<bool>? ochirilgan,
  }) {
    return ZikrCompanion(
      id: id ?? this.id,
      nomi: nomi ?? this.nomi,
      talaffuz: talaffuz ?? this.talaffuz,
      arabcha: arabcha ?? this.arabcha,
      manosi: manosi ?? this.manosi,
      maqsad: maqsad ?? this.maqsad,
      rasm: rasm ?? this.rasm,
      turkum: turkum ?? this.turkum,
      ozZikri: ozZikri ?? this.ozZikri,
      tartib: tartib ?? this.tartib,
      ochirilgan: ochirilgan ?? this.ochirilgan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomi.present) {
      map['nomi'] = Variable<String>(nomi.value);
    }
    if (talaffuz.present) {
      map['talaffuz'] = Variable<String>(talaffuz.value);
    }
    if (arabcha.present) {
      map['arabcha'] = Variable<String>(arabcha.value);
    }
    if (manosi.present) {
      map['manosi'] = Variable<String>(manosi.value);
    }
    if (maqsad.present) {
      map['maqsad'] = Variable<int>(maqsad.value);
    }
    if (rasm.present) {
      map['rasm'] = Variable<String>(rasm.value);
    }
    if (turkum.present) {
      map['turkum'] = Variable<String>(turkum.value);
    }
    if (ozZikri.present) {
      map['oz_zikri'] = Variable<bool>(ozZikri.value);
    }
    if (tartib.present) {
      map['tartib'] = Variable<int>(tartib.value);
    }
    if (ochirilgan.present) {
      map['ochirilgan'] = Variable<bool>(ochirilgan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZikrCompanion(')
          ..write('id: $id, ')
          ..write('nomi: $nomi, ')
          ..write('talaffuz: $talaffuz, ')
          ..write('arabcha: $arabcha, ')
          ..write('manosi: $manosi, ')
          ..write('maqsad: $maqsad, ')
          ..write('rasm: $rasm, ')
          ..write('turkum: $turkum, ')
          ..write('ozZikri: $ozZikri, ')
          ..write('tartib: $tartib, ')
          ..write('ochirilgan: $ochirilgan')
          ..write(')'))
        .toString();
  }
}

class $ToplamTable extends Toplam with TableInfo<$ToplamTable, ToplamQator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToplamTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomiMeta = const VerificationMeta('nomi');
  @override
  late final GeneratedColumn<String> nomi = GeneratedColumn<String>(
    'nomi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Qadam>, String> qadamlar =
      GeneratedColumn<String>(
        'qadamlar',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Qadam>>($ToplamTable.$converterqadamlar);
  @override
  List<GeneratedColumn> get $columns => [id, nomi, qadamlar];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'toplam';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToplamQator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nomi')) {
      context.handle(
        _nomiMeta,
        nomi.isAcceptableOrUnknown(data['nomi']!, _nomiMeta),
      );
    } else if (isInserting) {
      context.missing(_nomiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToplamQator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToplamQator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomi'],
      )!,
      qadamlar: $ToplamTable.$converterqadamlar.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}qadamlar'],
        )!,
      ),
    );
  }

  @override
  $ToplamTable createAlias(String alias) {
    return $ToplamTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Qadam>, String> $converterqadamlar =
      const QadamlarConverter();
}

class ToplamQator extends DataClass implements Insertable<ToplamQator> {
  final int id;
  final String nomi;
  final List<Qadam> qadamlar;
  const ToplamQator({
    required this.id,
    required this.nomi,
    required this.qadamlar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nomi'] = Variable<String>(nomi);
    {
      map['qadamlar'] = Variable<String>(
        $ToplamTable.$converterqadamlar.toSql(qadamlar),
      );
    }
    return map;
  }

  ToplamCompanion toCompanion(bool nullToAbsent) {
    return ToplamCompanion(
      id: Value(id),
      nomi: Value(nomi),
      qadamlar: Value(qadamlar),
    );
  }

  factory ToplamQator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToplamQator(
      id: serializer.fromJson<int>(json['id']),
      nomi: serializer.fromJson<String>(json['nomi']),
      qadamlar: serializer.fromJson<List<Qadam>>(json['qadamlar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomi': serializer.toJson<String>(nomi),
      'qadamlar': serializer.toJson<List<Qadam>>(qadamlar),
    };
  }

  ToplamQator copyWith({int? id, String? nomi, List<Qadam>? qadamlar}) =>
      ToplamQator(
        id: id ?? this.id,
        nomi: nomi ?? this.nomi,
        qadamlar: qadamlar ?? this.qadamlar,
      );
  ToplamQator copyWithCompanion(ToplamCompanion data) {
    return ToplamQator(
      id: data.id.present ? data.id.value : this.id,
      nomi: data.nomi.present ? data.nomi.value : this.nomi,
      qadamlar: data.qadamlar.present ? data.qadamlar.value : this.qadamlar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToplamQator(')
          ..write('id: $id, ')
          ..write('nomi: $nomi, ')
          ..write('qadamlar: $qadamlar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nomi, qadamlar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToplamQator &&
          other.id == this.id &&
          other.nomi == this.nomi &&
          other.qadamlar == this.qadamlar);
}

class ToplamCompanion extends UpdateCompanion<ToplamQator> {
  final Value<int> id;
  final Value<String> nomi;
  final Value<List<Qadam>> qadamlar;
  const ToplamCompanion({
    this.id = const Value.absent(),
    this.nomi = const Value.absent(),
    this.qadamlar = const Value.absent(),
  });
  ToplamCompanion.insert({
    this.id = const Value.absent(),
    required String nomi,
    required List<Qadam> qadamlar,
  }) : nomi = Value(nomi),
       qadamlar = Value(qadamlar);
  static Insertable<ToplamQator> custom({
    Expression<int>? id,
    Expression<String>? nomi,
    Expression<String>? qadamlar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomi != null) 'nomi': nomi,
      if (qadamlar != null) 'qadamlar': qadamlar,
    });
  }

  ToplamCompanion copyWith({
    Value<int>? id,
    Value<String>? nomi,
    Value<List<Qadam>>? qadamlar,
  }) {
    return ToplamCompanion(
      id: id ?? this.id,
      nomi: nomi ?? this.nomi,
      qadamlar: qadamlar ?? this.qadamlar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomi.present) {
      map['nomi'] = Variable<String>(nomi.value);
    }
    if (qadamlar.present) {
      map['qadamlar'] = Variable<String>(
        $ToplamTable.$converterqadamlar.toSql(qadamlar.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToplamCompanion(')
          ..write('id: $id, ')
          ..write('nomi: $nomi, ')
          ..write('qadamlar: $qadamlar')
          ..write(')'))
        .toString();
  }
}

class $SessiyaTable extends Sessiya
    with TableInfo<$SessiyaTable, SessiyaQator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessiyaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _zikrIdMeta = const VerificationMeta('zikrId');
  @override
  late final GeneratedColumn<int> zikrId = GeneratedColumn<int>(
    'zikr_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zikr (id)',
    ),
  );
  static const VerificationMeta _toplamIdMeta = const VerificationMeta(
    'toplamId',
  );
  @override
  late final GeneratedColumn<int> toplamId = GeneratedColumn<int>(
    'toplam_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES toplam (id)',
    ),
  );
  static const VerificationMeta _sonMeta = const VerificationMeta('son');
  @override
  late final GeneratedColumn<int> son = GeneratedColumn<int>(
    'son',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aylanalarMeta = const VerificationMeta(
    'aylanalar',
  );
  @override
  late final GeneratedColumn<int> aylanalar = GeneratedColumn<int>(
    'aylanalar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _jamiMeta = const VerificationMeta('jami');
  @override
  late final GeneratedColumn<int> jami = GeneratedColumn<int>(
    'jami',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _boshlandiMeta = const VerificationMeta(
    'boshlandi',
  );
  @override
  late final GeneratedColumn<DateTime> boshlandi = GeneratedColumn<DateTime>(
    'boshlandi',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yangilandiMeta = const VerificationMeta(
    'yangilandi',
  );
  @override
  late final GeneratedColumn<DateTime> yangilandi = GeneratedColumn<DateTime>(
    'yangilandi',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sanaMeta = const VerificationMeta('sana');
  @override
  late final GeneratedColumn<String> sana = GeneratedColumn<String>(
    'sana',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    zikrId,
    toplamId,
    son,
    aylanalar,
    jami,
    boshlandi,
    yangilandi,
    sana,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessiya';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessiyaQator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zikr_id')) {
      context.handle(
        _zikrIdMeta,
        zikrId.isAcceptableOrUnknown(data['zikr_id']!, _zikrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zikrIdMeta);
    }
    if (data.containsKey('toplam_id')) {
      context.handle(
        _toplamIdMeta,
        toplamId.isAcceptableOrUnknown(data['toplam_id']!, _toplamIdMeta),
      );
    }
    if (data.containsKey('son')) {
      context.handle(
        _sonMeta,
        son.isAcceptableOrUnknown(data['son']!, _sonMeta),
      );
    }
    if (data.containsKey('aylanalar')) {
      context.handle(
        _aylanalarMeta,
        aylanalar.isAcceptableOrUnknown(data['aylanalar']!, _aylanalarMeta),
      );
    }
    if (data.containsKey('jami')) {
      context.handle(
        _jamiMeta,
        jami.isAcceptableOrUnknown(data['jami']!, _jamiMeta),
      );
    }
    if (data.containsKey('boshlandi')) {
      context.handle(
        _boshlandiMeta,
        boshlandi.isAcceptableOrUnknown(data['boshlandi']!, _boshlandiMeta),
      );
    } else if (isInserting) {
      context.missing(_boshlandiMeta);
    }
    if (data.containsKey('yangilandi')) {
      context.handle(
        _yangilandiMeta,
        yangilandi.isAcceptableOrUnknown(data['yangilandi']!, _yangilandiMeta),
      );
    } else if (isInserting) {
      context.missing(_yangilandiMeta);
    }
    if (data.containsKey('sana')) {
      context.handle(
        _sanaMeta,
        sana.isAcceptableOrUnknown(data['sana']!, _sanaMeta),
      );
    } else if (isInserting) {
      context.missing(_sanaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessiyaQator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessiyaQator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      zikrId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zikr_id'],
      )!,
      toplamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}toplam_id'],
      ),
      son: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}son'],
      )!,
      aylanalar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aylanalar'],
      )!,
      jami: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jami'],
      )!,
      boshlandi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}boshlandi'],
      )!,
      yangilandi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}yangilandi'],
      )!,
      sana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sana'],
      )!,
    );
  }

  @override
  $SessiyaTable createAlias(String alias) {
    return $SessiyaTable(attachedDatabase, alias);
  }
}

class SessiyaQator extends DataClass implements Insertable<SessiyaQator> {
  final int id;
  final int zikrId;
  final int? toplamId;

  /// Joriy aylanadagi son.
  final int son;

  /// Shu kuni tugagan aylanalar.
  final int aylanalar;

  /// Shu kuni shu zikr bo'yicha barcha bosishlar (v2).
  final int jami;
  final DateTime boshlandi;
  final DateTime yangilandi;

  /// Mahalliy kalendar kuni, `YYYY-MM-DD`.
  final String sana;
  const SessiyaQator({
    required this.id,
    required this.zikrId,
    this.toplamId,
    required this.son,
    required this.aylanalar,
    required this.jami,
    required this.boshlandi,
    required this.yangilandi,
    required this.sana,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zikr_id'] = Variable<int>(zikrId);
    if (!nullToAbsent || toplamId != null) {
      map['toplam_id'] = Variable<int>(toplamId);
    }
    map['son'] = Variable<int>(son);
    map['aylanalar'] = Variable<int>(aylanalar);
    map['jami'] = Variable<int>(jami);
    map['boshlandi'] = Variable<DateTime>(boshlandi);
    map['yangilandi'] = Variable<DateTime>(yangilandi);
    map['sana'] = Variable<String>(sana);
    return map;
  }

  SessiyaCompanion toCompanion(bool nullToAbsent) {
    return SessiyaCompanion(
      id: Value(id),
      zikrId: Value(zikrId),
      toplamId: toplamId == null && nullToAbsent
          ? const Value.absent()
          : Value(toplamId),
      son: Value(son),
      aylanalar: Value(aylanalar),
      jami: Value(jami),
      boshlandi: Value(boshlandi),
      yangilandi: Value(yangilandi),
      sana: Value(sana),
    );
  }

  factory SessiyaQator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessiyaQator(
      id: serializer.fromJson<int>(json['id']),
      zikrId: serializer.fromJson<int>(json['zikrId']),
      toplamId: serializer.fromJson<int?>(json['toplamId']),
      son: serializer.fromJson<int>(json['son']),
      aylanalar: serializer.fromJson<int>(json['aylanalar']),
      jami: serializer.fromJson<int>(json['jami']),
      boshlandi: serializer.fromJson<DateTime>(json['boshlandi']),
      yangilandi: serializer.fromJson<DateTime>(json['yangilandi']),
      sana: serializer.fromJson<String>(json['sana']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zikrId': serializer.toJson<int>(zikrId),
      'toplamId': serializer.toJson<int?>(toplamId),
      'son': serializer.toJson<int>(son),
      'aylanalar': serializer.toJson<int>(aylanalar),
      'jami': serializer.toJson<int>(jami),
      'boshlandi': serializer.toJson<DateTime>(boshlandi),
      'yangilandi': serializer.toJson<DateTime>(yangilandi),
      'sana': serializer.toJson<String>(sana),
    };
  }

  SessiyaQator copyWith({
    int? id,
    int? zikrId,
    Value<int?> toplamId = const Value.absent(),
    int? son,
    int? aylanalar,
    int? jami,
    DateTime? boshlandi,
    DateTime? yangilandi,
    String? sana,
  }) => SessiyaQator(
    id: id ?? this.id,
    zikrId: zikrId ?? this.zikrId,
    toplamId: toplamId.present ? toplamId.value : this.toplamId,
    son: son ?? this.son,
    aylanalar: aylanalar ?? this.aylanalar,
    jami: jami ?? this.jami,
    boshlandi: boshlandi ?? this.boshlandi,
    yangilandi: yangilandi ?? this.yangilandi,
    sana: sana ?? this.sana,
  );
  SessiyaQator copyWithCompanion(SessiyaCompanion data) {
    return SessiyaQator(
      id: data.id.present ? data.id.value : this.id,
      zikrId: data.zikrId.present ? data.zikrId.value : this.zikrId,
      toplamId: data.toplamId.present ? data.toplamId.value : this.toplamId,
      son: data.son.present ? data.son.value : this.son,
      aylanalar: data.aylanalar.present ? data.aylanalar.value : this.aylanalar,
      jami: data.jami.present ? data.jami.value : this.jami,
      boshlandi: data.boshlandi.present ? data.boshlandi.value : this.boshlandi,
      yangilandi: data.yangilandi.present
          ? data.yangilandi.value
          : this.yangilandi,
      sana: data.sana.present ? data.sana.value : this.sana,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessiyaQator(')
          ..write('id: $id, ')
          ..write('zikrId: $zikrId, ')
          ..write('toplamId: $toplamId, ')
          ..write('son: $son, ')
          ..write('aylanalar: $aylanalar, ')
          ..write('jami: $jami, ')
          ..write('boshlandi: $boshlandi, ')
          ..write('yangilandi: $yangilandi, ')
          ..write('sana: $sana')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    zikrId,
    toplamId,
    son,
    aylanalar,
    jami,
    boshlandi,
    yangilandi,
    sana,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessiyaQator &&
          other.id == this.id &&
          other.zikrId == this.zikrId &&
          other.toplamId == this.toplamId &&
          other.son == this.son &&
          other.aylanalar == this.aylanalar &&
          other.jami == this.jami &&
          other.boshlandi == this.boshlandi &&
          other.yangilandi == this.yangilandi &&
          other.sana == this.sana);
}

class SessiyaCompanion extends UpdateCompanion<SessiyaQator> {
  final Value<int> id;
  final Value<int> zikrId;
  final Value<int?> toplamId;
  final Value<int> son;
  final Value<int> aylanalar;
  final Value<int> jami;
  final Value<DateTime> boshlandi;
  final Value<DateTime> yangilandi;
  final Value<String> sana;
  const SessiyaCompanion({
    this.id = const Value.absent(),
    this.zikrId = const Value.absent(),
    this.toplamId = const Value.absent(),
    this.son = const Value.absent(),
    this.aylanalar = const Value.absent(),
    this.jami = const Value.absent(),
    this.boshlandi = const Value.absent(),
    this.yangilandi = const Value.absent(),
    this.sana = const Value.absent(),
  });
  SessiyaCompanion.insert({
    this.id = const Value.absent(),
    required int zikrId,
    this.toplamId = const Value.absent(),
    this.son = const Value.absent(),
    this.aylanalar = const Value.absent(),
    this.jami = const Value.absent(),
    required DateTime boshlandi,
    required DateTime yangilandi,
    required String sana,
  }) : zikrId = Value(zikrId),
       boshlandi = Value(boshlandi),
       yangilandi = Value(yangilandi),
       sana = Value(sana);
  static Insertable<SessiyaQator> custom({
    Expression<int>? id,
    Expression<int>? zikrId,
    Expression<int>? toplamId,
    Expression<int>? son,
    Expression<int>? aylanalar,
    Expression<int>? jami,
    Expression<DateTime>? boshlandi,
    Expression<DateTime>? yangilandi,
    Expression<String>? sana,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zikrId != null) 'zikr_id': zikrId,
      if (toplamId != null) 'toplam_id': toplamId,
      if (son != null) 'son': son,
      if (aylanalar != null) 'aylanalar': aylanalar,
      if (jami != null) 'jami': jami,
      if (boshlandi != null) 'boshlandi': boshlandi,
      if (yangilandi != null) 'yangilandi': yangilandi,
      if (sana != null) 'sana': sana,
    });
  }

  SessiyaCompanion copyWith({
    Value<int>? id,
    Value<int>? zikrId,
    Value<int?>? toplamId,
    Value<int>? son,
    Value<int>? aylanalar,
    Value<int>? jami,
    Value<DateTime>? boshlandi,
    Value<DateTime>? yangilandi,
    Value<String>? sana,
  }) {
    return SessiyaCompanion(
      id: id ?? this.id,
      zikrId: zikrId ?? this.zikrId,
      toplamId: toplamId ?? this.toplamId,
      son: son ?? this.son,
      aylanalar: aylanalar ?? this.aylanalar,
      jami: jami ?? this.jami,
      boshlandi: boshlandi ?? this.boshlandi,
      yangilandi: yangilandi ?? this.yangilandi,
      sana: sana ?? this.sana,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zikrId.present) {
      map['zikr_id'] = Variable<int>(zikrId.value);
    }
    if (toplamId.present) {
      map['toplam_id'] = Variable<int>(toplamId.value);
    }
    if (son.present) {
      map['son'] = Variable<int>(son.value);
    }
    if (aylanalar.present) {
      map['aylanalar'] = Variable<int>(aylanalar.value);
    }
    if (jami.present) {
      map['jami'] = Variable<int>(jami.value);
    }
    if (boshlandi.present) {
      map['boshlandi'] = Variable<DateTime>(boshlandi.value);
    }
    if (yangilandi.present) {
      map['yangilandi'] = Variable<DateTime>(yangilandi.value);
    }
    if (sana.present) {
      map['sana'] = Variable<String>(sana.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessiyaCompanion(')
          ..write('id: $id, ')
          ..write('zikrId: $zikrId, ')
          ..write('toplamId: $toplamId, ')
          ..write('son: $son, ')
          ..write('aylanalar: $aylanalar, ')
          ..write('jami: $jami, ')
          ..write('boshlandi: $boshlandi, ')
          ..write('yangilandi: $yangilandi, ')
          ..write('sana: $sana')
          ..write(')'))
        .toString();
  }
}

class $SozlamaTable extends Sozlama
    with TableInfo<$SozlamaTable, SozlamaQator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SozlamaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kalitMeta = const VerificationMeta('kalit');
  @override
  late final GeneratedColumn<String> kalit = GeneratedColumn<String>(
    'kalit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qiymatMeta = const VerificationMeta('qiymat');
  @override
  late final GeneratedColumn<String> qiymat = GeneratedColumn<String>(
    'qiymat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kalit, qiymat];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sozlama';
  @override
  VerificationContext validateIntegrity(
    Insertable<SozlamaQator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kalit')) {
      context.handle(
        _kalitMeta,
        kalit.isAcceptableOrUnknown(data['kalit']!, _kalitMeta),
      );
    } else if (isInserting) {
      context.missing(_kalitMeta);
    }
    if (data.containsKey('qiymat')) {
      context.handle(
        _qiymatMeta,
        qiymat.isAcceptableOrUnknown(data['qiymat']!, _qiymatMeta),
      );
    } else if (isInserting) {
      context.missing(_qiymatMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kalit};
  @override
  SozlamaQator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SozlamaQator(
      kalit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kalit'],
      )!,
      qiymat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qiymat'],
      )!,
    );
  }

  @override
  $SozlamaTable createAlias(String alias) {
    return $SozlamaTable(attachedDatabase, alias);
  }
}

class SozlamaQator extends DataClass implements Insertable<SozlamaQator> {
  final String kalit;
  final String qiymat;
  const SozlamaQator({required this.kalit, required this.qiymat});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kalit'] = Variable<String>(kalit);
    map['qiymat'] = Variable<String>(qiymat);
    return map;
  }

  SozlamaCompanion toCompanion(bool nullToAbsent) {
    return SozlamaCompanion(kalit: Value(kalit), qiymat: Value(qiymat));
  }

  factory SozlamaQator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SozlamaQator(
      kalit: serializer.fromJson<String>(json['kalit']),
      qiymat: serializer.fromJson<String>(json['qiymat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kalit': serializer.toJson<String>(kalit),
      'qiymat': serializer.toJson<String>(qiymat),
    };
  }

  SozlamaQator copyWith({String? kalit, String? qiymat}) =>
      SozlamaQator(kalit: kalit ?? this.kalit, qiymat: qiymat ?? this.qiymat);
  SozlamaQator copyWithCompanion(SozlamaCompanion data) {
    return SozlamaQator(
      kalit: data.kalit.present ? data.kalit.value : this.kalit,
      qiymat: data.qiymat.present ? data.qiymat.value : this.qiymat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SozlamaQator(')
          ..write('kalit: $kalit, ')
          ..write('qiymat: $qiymat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kalit, qiymat);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SozlamaQator &&
          other.kalit == this.kalit &&
          other.qiymat == this.qiymat);
}

class SozlamaCompanion extends UpdateCompanion<SozlamaQator> {
  final Value<String> kalit;
  final Value<String> qiymat;
  final Value<int> rowid;
  const SozlamaCompanion({
    this.kalit = const Value.absent(),
    this.qiymat = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SozlamaCompanion.insert({
    required String kalit,
    required String qiymat,
    this.rowid = const Value.absent(),
  }) : kalit = Value(kalit),
       qiymat = Value(qiymat);
  static Insertable<SozlamaQator> custom({
    Expression<String>? kalit,
    Expression<String>? qiymat,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kalit != null) 'kalit': kalit,
      if (qiymat != null) 'qiymat': qiymat,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SozlamaCompanion copyWith({
    Value<String>? kalit,
    Value<String>? qiymat,
    Value<int>? rowid,
  }) {
    return SozlamaCompanion(
      kalit: kalit ?? this.kalit,
      qiymat: qiymat ?? this.qiymat,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kalit.present) {
      map['kalit'] = Variable<String>(kalit.value);
    }
    if (qiymat.present) {
      map['qiymat'] = Variable<String>(qiymat.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SozlamaCompanion(')
          ..write('kalit: $kalit, ')
          ..write('qiymat: $qiymat, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToplamYurishTable extends ToplamYurish
    with TableInfo<$ToplamYurishTable, YurishQator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToplamYurishTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _toplamIdMeta = const VerificationMeta(
    'toplamId',
  );
  @override
  late final GeneratedColumn<int> toplamId = GeneratedColumn<int>(
    'toplam_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES toplam (id)',
    ),
  );
  static const VerificationMeta _sanaMeta = const VerificationMeta('sana');
  @override
  late final GeneratedColumn<String> sana = GeneratedColumn<String>(
    'sana',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qadamMeta = const VerificationMeta('qadam');
  @override
  late final GeneratedColumn<int> qadam = GeneratedColumn<int>(
    'qadam',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sonMeta = const VerificationMeta('son');
  @override
  late final GeneratedColumn<int> son = GeneratedColumn<int>(
    'son',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tugadiMeta = const VerificationMeta('tugadi');
  @override
  late final GeneratedColumn<bool> tugadi = GeneratedColumn<bool>(
    'tugadi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tugadi" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _boshlandiMeta = const VerificationMeta(
    'boshlandi',
  );
  @override
  late final GeneratedColumn<DateTime> boshlandi = GeneratedColumn<DateTime>(
    'boshlandi',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yangilandiMeta = const VerificationMeta(
    'yangilandi',
  );
  @override
  late final GeneratedColumn<DateTime> yangilandi = GeneratedColumn<DateTime>(
    'yangilandi',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    toplamId,
    sana,
    qadam,
    son,
    tugadi,
    boshlandi,
    yangilandi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'toplam_yurish';
  @override
  VerificationContext validateIntegrity(
    Insertable<YurishQator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('toplam_id')) {
      context.handle(
        _toplamIdMeta,
        toplamId.isAcceptableOrUnknown(data['toplam_id']!, _toplamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toplamIdMeta);
    }
    if (data.containsKey('sana')) {
      context.handle(
        _sanaMeta,
        sana.isAcceptableOrUnknown(data['sana']!, _sanaMeta),
      );
    } else if (isInserting) {
      context.missing(_sanaMeta);
    }
    if (data.containsKey('qadam')) {
      context.handle(
        _qadamMeta,
        qadam.isAcceptableOrUnknown(data['qadam']!, _qadamMeta),
      );
    }
    if (data.containsKey('son')) {
      context.handle(
        _sonMeta,
        son.isAcceptableOrUnknown(data['son']!, _sonMeta),
      );
    }
    if (data.containsKey('tugadi')) {
      context.handle(
        _tugadiMeta,
        tugadi.isAcceptableOrUnknown(data['tugadi']!, _tugadiMeta),
      );
    }
    if (data.containsKey('boshlandi')) {
      context.handle(
        _boshlandiMeta,
        boshlandi.isAcceptableOrUnknown(data['boshlandi']!, _boshlandiMeta),
      );
    } else if (isInserting) {
      context.missing(_boshlandiMeta);
    }
    if (data.containsKey('yangilandi')) {
      context.handle(
        _yangilandiMeta,
        yangilandi.isAcceptableOrUnknown(data['yangilandi']!, _yangilandiMeta),
      );
    } else if (isInserting) {
      context.missing(_yangilandiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  YurishQator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YurishQator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      toplamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}toplam_id'],
      )!,
      sana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sana'],
      )!,
      qadam: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qadam'],
      )!,
      son: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}son'],
      )!,
      tugadi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tugadi'],
      )!,
      boshlandi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}boshlandi'],
      )!,
      yangilandi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}yangilandi'],
      )!,
    );
  }

  @override
  $ToplamYurishTable createAlias(String alias) {
    return $ToplamYurishTable(attachedDatabase, alias);
  }
}

class YurishQator extends DataClass implements Insertable<YurishQator> {
  final int id;
  final int toplamId;

  /// Boshlangan mahalliy kun, `YYYY-MM-DD`.
  final String sana;

  /// Joriy qadam indeksi, 0 dan.
  final int qadam;

  /// Joriy qadamdagi son.
  final int son;
  final bool tugadi;
  final DateTime boshlandi;
  final DateTime yangilandi;
  const YurishQator({
    required this.id,
    required this.toplamId,
    required this.sana,
    required this.qadam,
    required this.son,
    required this.tugadi,
    required this.boshlandi,
    required this.yangilandi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['toplam_id'] = Variable<int>(toplamId);
    map['sana'] = Variable<String>(sana);
    map['qadam'] = Variable<int>(qadam);
    map['son'] = Variable<int>(son);
    map['tugadi'] = Variable<bool>(tugadi);
    map['boshlandi'] = Variable<DateTime>(boshlandi);
    map['yangilandi'] = Variable<DateTime>(yangilandi);
    return map;
  }

  ToplamYurishCompanion toCompanion(bool nullToAbsent) {
    return ToplamYurishCompanion(
      id: Value(id),
      toplamId: Value(toplamId),
      sana: Value(sana),
      qadam: Value(qadam),
      son: Value(son),
      tugadi: Value(tugadi),
      boshlandi: Value(boshlandi),
      yangilandi: Value(yangilandi),
    );
  }

  factory YurishQator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YurishQator(
      id: serializer.fromJson<int>(json['id']),
      toplamId: serializer.fromJson<int>(json['toplamId']),
      sana: serializer.fromJson<String>(json['sana']),
      qadam: serializer.fromJson<int>(json['qadam']),
      son: serializer.fromJson<int>(json['son']),
      tugadi: serializer.fromJson<bool>(json['tugadi']),
      boshlandi: serializer.fromJson<DateTime>(json['boshlandi']),
      yangilandi: serializer.fromJson<DateTime>(json['yangilandi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'toplamId': serializer.toJson<int>(toplamId),
      'sana': serializer.toJson<String>(sana),
      'qadam': serializer.toJson<int>(qadam),
      'son': serializer.toJson<int>(son),
      'tugadi': serializer.toJson<bool>(tugadi),
      'boshlandi': serializer.toJson<DateTime>(boshlandi),
      'yangilandi': serializer.toJson<DateTime>(yangilandi),
    };
  }

  YurishQator copyWith({
    int? id,
    int? toplamId,
    String? sana,
    int? qadam,
    int? son,
    bool? tugadi,
    DateTime? boshlandi,
    DateTime? yangilandi,
  }) => YurishQator(
    id: id ?? this.id,
    toplamId: toplamId ?? this.toplamId,
    sana: sana ?? this.sana,
    qadam: qadam ?? this.qadam,
    son: son ?? this.son,
    tugadi: tugadi ?? this.tugadi,
    boshlandi: boshlandi ?? this.boshlandi,
    yangilandi: yangilandi ?? this.yangilandi,
  );
  YurishQator copyWithCompanion(ToplamYurishCompanion data) {
    return YurishQator(
      id: data.id.present ? data.id.value : this.id,
      toplamId: data.toplamId.present ? data.toplamId.value : this.toplamId,
      sana: data.sana.present ? data.sana.value : this.sana,
      qadam: data.qadam.present ? data.qadam.value : this.qadam,
      son: data.son.present ? data.son.value : this.son,
      tugadi: data.tugadi.present ? data.tugadi.value : this.tugadi,
      boshlandi: data.boshlandi.present ? data.boshlandi.value : this.boshlandi,
      yangilandi: data.yangilandi.present
          ? data.yangilandi.value
          : this.yangilandi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YurishQator(')
          ..write('id: $id, ')
          ..write('toplamId: $toplamId, ')
          ..write('sana: $sana, ')
          ..write('qadam: $qadam, ')
          ..write('son: $son, ')
          ..write('tugadi: $tugadi, ')
          ..write('boshlandi: $boshlandi, ')
          ..write('yangilandi: $yangilandi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    toplamId,
    sana,
    qadam,
    son,
    tugadi,
    boshlandi,
    yangilandi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YurishQator &&
          other.id == this.id &&
          other.toplamId == this.toplamId &&
          other.sana == this.sana &&
          other.qadam == this.qadam &&
          other.son == this.son &&
          other.tugadi == this.tugadi &&
          other.boshlandi == this.boshlandi &&
          other.yangilandi == this.yangilandi);
}

class ToplamYurishCompanion extends UpdateCompanion<YurishQator> {
  final Value<int> id;
  final Value<int> toplamId;
  final Value<String> sana;
  final Value<int> qadam;
  final Value<int> son;
  final Value<bool> tugadi;
  final Value<DateTime> boshlandi;
  final Value<DateTime> yangilandi;
  const ToplamYurishCompanion({
    this.id = const Value.absent(),
    this.toplamId = const Value.absent(),
    this.sana = const Value.absent(),
    this.qadam = const Value.absent(),
    this.son = const Value.absent(),
    this.tugadi = const Value.absent(),
    this.boshlandi = const Value.absent(),
    this.yangilandi = const Value.absent(),
  });
  ToplamYurishCompanion.insert({
    this.id = const Value.absent(),
    required int toplamId,
    required String sana,
    this.qadam = const Value.absent(),
    this.son = const Value.absent(),
    this.tugadi = const Value.absent(),
    required DateTime boshlandi,
    required DateTime yangilandi,
  }) : toplamId = Value(toplamId),
       sana = Value(sana),
       boshlandi = Value(boshlandi),
       yangilandi = Value(yangilandi);
  static Insertable<YurishQator> custom({
    Expression<int>? id,
    Expression<int>? toplamId,
    Expression<String>? sana,
    Expression<int>? qadam,
    Expression<int>? son,
    Expression<bool>? tugadi,
    Expression<DateTime>? boshlandi,
    Expression<DateTime>? yangilandi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (toplamId != null) 'toplam_id': toplamId,
      if (sana != null) 'sana': sana,
      if (qadam != null) 'qadam': qadam,
      if (son != null) 'son': son,
      if (tugadi != null) 'tugadi': tugadi,
      if (boshlandi != null) 'boshlandi': boshlandi,
      if (yangilandi != null) 'yangilandi': yangilandi,
    });
  }

  ToplamYurishCompanion copyWith({
    Value<int>? id,
    Value<int>? toplamId,
    Value<String>? sana,
    Value<int>? qadam,
    Value<int>? son,
    Value<bool>? tugadi,
    Value<DateTime>? boshlandi,
    Value<DateTime>? yangilandi,
  }) {
    return ToplamYurishCompanion(
      id: id ?? this.id,
      toplamId: toplamId ?? this.toplamId,
      sana: sana ?? this.sana,
      qadam: qadam ?? this.qadam,
      son: son ?? this.son,
      tugadi: tugadi ?? this.tugadi,
      boshlandi: boshlandi ?? this.boshlandi,
      yangilandi: yangilandi ?? this.yangilandi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (toplamId.present) {
      map['toplam_id'] = Variable<int>(toplamId.value);
    }
    if (sana.present) {
      map['sana'] = Variable<String>(sana.value);
    }
    if (qadam.present) {
      map['qadam'] = Variable<int>(qadam.value);
    }
    if (son.present) {
      map['son'] = Variable<int>(son.value);
    }
    if (tugadi.present) {
      map['tugadi'] = Variable<bool>(tugadi.value);
    }
    if (boshlandi.present) {
      map['boshlandi'] = Variable<DateTime>(boshlandi.value);
    }
    if (yangilandi.present) {
      map['yangilandi'] = Variable<DateTime>(yangilandi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToplamYurishCompanion(')
          ..write('id: $id, ')
          ..write('toplamId: $toplamId, ')
          ..write('sana: $sana, ')
          ..write('qadam: $qadam, ')
          ..write('son: $son, ')
          ..write('tugadi: $tugadi, ')
          ..write('boshlandi: $boshlandi, ')
          ..write('yangilandi: $yangilandi')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ZikrTable zikr = $ZikrTable(this);
  late final $ToplamTable toplam = $ToplamTable(this);
  late final $SessiyaTable sessiya = $SessiyaTable(this);
  late final $SozlamaTable sozlama = $SozlamaTable(this);
  late final $ToplamYurishTable toplamYurish = $ToplamYurishTable(this);
  late final Index sessiyaZikrSana = Index(
    'sessiya_zikr_sana',
    'CREATE UNIQUE INDEX sessiya_zikr_sana ON sessiya (zikr_id, sana)',
  );
  late final Index toplamYurishTugallanmagan = Index(
    'toplam_yurish_tugallanmagan',
    'CREATE UNIQUE INDEX toplam_yurish_tugallanmagan ON toplam_yurish (toplam_id) WHERE tugadi = 0',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    zikr,
    toplam,
    sessiya,
    sozlama,
    toplamYurish,
    sessiyaZikrSana,
    toplamYurishTugallanmagan,
  ];
}

typedef $$ZikrTableCreateCompanionBuilder = ZikrCompanion Function({
  Value<int> id,
  required String nomi,
  Value<String?> talaffuz,
  required String arabcha,
  required String manosi,
  Value<int?> maqsad,
  Value<String?> rasm,
  required String turkum,
  Value<bool> ozZikri,
  required int tartib,
  Value<bool> ochirilgan,
});
typedef $$ZikrTableUpdateCompanionBuilder = ZikrCompanion Function({
  Value<int> id,
  Value<String> nomi,
  Value<String?> talaffuz,
  Value<String> arabcha,
  Value<String> manosi,
  Value<int?> maqsad,
  Value<String?> rasm,
  Value<String> turkum,
  Value<bool> ozZikri,
  Value<int> tartib,
  Value<bool> ochirilgan,
});

final class $$ZikrTableReferences
    extends BaseReferences<_$AppDatabase, $ZikrTable, ZikrQator> {
  $$ZikrTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessiyaTable, List<SessiyaQator>>
  _sessiyaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessiya,
    aliasName: 'zikr__id__sessiya__zikr_id',
  );

  $$SessiyaTableProcessedTableManager get sessiyaRefs {
    final manager = $$SessiyaTableTableManager(
      $_db,
      $_db.sessiya,
    ).filter((f) => f.zikrId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessiyaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ZikrTableFilterComposer extends Composer<_$AppDatabase, $ZikrTable> {
  $$ZikrTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomi => $composableBuilder(
    column: $table.nomi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get talaffuz => $composableBuilder(
    column: $table.talaffuz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabcha => $composableBuilder(
    column: $table.arabcha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manosi => $composableBuilder(
    column: $table.manosi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maqsad => $composableBuilder(
    column: $table.maqsad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rasm => $composableBuilder(
    column: $table.rasm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get turkum => $composableBuilder(
    column: $table.turkum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ozZikri => $composableBuilder(
    column: $table.ozZikri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tartib => $composableBuilder(
    column: $table.tartib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ochirilgan => $composableBuilder(
    column: $table.ochirilgan,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessiyaRefs(
    Expression<bool> Function($$SessiyaTableFilterComposer f) f,
  ) {
    final $$SessiyaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessiya,
      getReferencedColumn: (t) => t.zikrId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessiyaTableFilterComposer(
            $db: $db,
            $table: $db.sessiya,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZikrTableOrderingComposer extends Composer<_$AppDatabase, $ZikrTable> {
  $$ZikrTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomi => $composableBuilder(
    column: $table.nomi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get talaffuz => $composableBuilder(
    column: $table.talaffuz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabcha => $composableBuilder(
    column: $table.arabcha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manosi => $composableBuilder(
    column: $table.manosi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maqsad => $composableBuilder(
    column: $table.maqsad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rasm => $composableBuilder(
    column: $table.rasm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turkum => $composableBuilder(
    column: $table.turkum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ozZikri => $composableBuilder(
    column: $table.ozZikri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tartib => $composableBuilder(
    column: $table.tartib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ochirilgan => $composableBuilder(
    column: $table.ochirilgan,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZikrTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZikrTable> {
  $$ZikrTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomi =>
      $composableBuilder(column: $table.nomi, builder: (column) => column);

  GeneratedColumn<String> get talaffuz =>
      $composableBuilder(column: $table.talaffuz, builder: (column) => column);

  GeneratedColumn<String> get arabcha =>
      $composableBuilder(column: $table.arabcha, builder: (column) => column);

  GeneratedColumn<String> get manosi =>
      $composableBuilder(column: $table.manosi, builder: (column) => column);

  GeneratedColumn<int> get maqsad =>
      $composableBuilder(column: $table.maqsad, builder: (column) => column);

  GeneratedColumn<String> get rasm =>
      $composableBuilder(column: $table.rasm, builder: (column) => column);

  GeneratedColumn<String> get turkum =>
      $composableBuilder(column: $table.turkum, builder: (column) => column);

  GeneratedColumn<bool> get ozZikri =>
      $composableBuilder(column: $table.ozZikri, builder: (column) => column);

  GeneratedColumn<int> get tartib =>
      $composableBuilder(column: $table.tartib, builder: (column) => column);

  GeneratedColumn<bool> get ochirilgan => $composableBuilder(
    column: $table.ochirilgan,
    builder: (column) => column,
  );

  Expression<T> sessiyaRefs<T extends Object>(
    Expression<T> Function($$SessiyaTableAnnotationComposer a) f,
  ) {
    final $$SessiyaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessiya,
      getReferencedColumn: (t) => t.zikrId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessiyaTableAnnotationComposer(
            $db: $db,
            $table: $db.sessiya,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZikrTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZikrTable,
          ZikrQator,
          $$ZikrTableFilterComposer,
          $$ZikrTableOrderingComposer,
          $$ZikrTableAnnotationComposer,
          $$ZikrTableCreateCompanionBuilder,
          $$ZikrTableUpdateCompanionBuilder,
          (ZikrQator, $$ZikrTableReferences),
          ZikrQator,
          PrefetchHooks Function({bool sessiyaRefs})
        > {
  $$ZikrTableTableManager(_$AppDatabase db, $ZikrTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZikrTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZikrTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZikrTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomi = const Value.absent(),
                Value<String?> talaffuz = const Value.absent(),
                Value<String> arabcha = const Value.absent(),
                Value<String> manosi = const Value.absent(),
                Value<int?> maqsad = const Value.absent(),
                Value<String?> rasm = const Value.absent(),
                Value<String> turkum = const Value.absent(),
                Value<bool> ozZikri = const Value.absent(),
                Value<int> tartib = const Value.absent(),
                Value<bool> ochirilgan = const Value.absent(),
              }) => ZikrCompanion(
                id: id,
                nomi: nomi,
                talaffuz: talaffuz,
                arabcha: arabcha,
                manosi: manosi,
                maqsad: maqsad,
                rasm: rasm,
                turkum: turkum,
                ozZikri: ozZikri,
                tartib: tartib,
                ochirilgan: ochirilgan,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomi,
                Value<String?> talaffuz = const Value.absent(),
                required String arabcha,
                required String manosi,
                Value<int?> maqsad = const Value.absent(),
                Value<String?> rasm = const Value.absent(),
                required String turkum,
                Value<bool> ozZikri = const Value.absent(),
                required int tartib,
                Value<bool> ochirilgan = const Value.absent(),
              }) => ZikrCompanion.insert(
                id: id,
                nomi: nomi,
                talaffuz: talaffuz,
                arabcha: arabcha,
                manosi: manosi,
                maqsad: maqsad,
                rasm: rasm,
                turkum: turkum,
                ozZikri: ozZikri,
                tartib: tartib,
                ochirilgan: ochirilgan,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZikrTable, ZikrQator>(table),
                  $$ZikrTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessiyaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessiyaRefs) db.sessiya],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessiyaRefs)
                    await $_getPrefetchedDataByColumns<
                      ZikrQator,
                      $ZikrTable,
                      SessiyaQator,
                      $SessiyaTable
                    >(
                      currentTable: table,
                      referencedTable: $$ZikrTableReferences._sessiyaRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ZikrTableReferences(db, table, p0).sessiyaRefs,
                      currentColumn: 'id',
                      referencedColumn: 'zikr_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ZikrTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZikrTable,
      ZikrQator,
      $$ZikrTableFilterComposer,
      $$ZikrTableOrderingComposer,
      $$ZikrTableAnnotationComposer,
      $$ZikrTableCreateCompanionBuilder,
      $$ZikrTableUpdateCompanionBuilder,
      (ZikrQator, $$ZikrTableReferences),
      ZikrQator,
      PrefetchHooks Function({bool sessiyaRefs})
    >;
typedef $$ToplamTableCreateCompanionBuilder = ToplamCompanion Function({
  Value<int> id,
  required String nomi,
  required List<Qadam> qadamlar,
});
typedef $$ToplamTableUpdateCompanionBuilder = ToplamCompanion Function({
  Value<int> id,
  Value<String> nomi,
  Value<List<Qadam>> qadamlar,
});

final class $$ToplamTableReferences
    extends BaseReferences<_$AppDatabase, $ToplamTable, ToplamQator> {
  $$ToplamTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessiyaTable, List<SessiyaQator>>
  _sessiyaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessiya,
    aliasName: 'toplam__id__sessiya__toplam_id',
  );

  $$SessiyaTableProcessedTableManager get sessiyaRefs {
    final manager = $$SessiyaTableTableManager(
      $_db,
      $_db.sessiya,
    ).filter((f) => f.toplamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessiyaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ToplamYurishTable, List<YurishQator>>
  _toplamYurishRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.toplamYurish,
    aliasName: 'toplam__id__toplam_yurish__toplam_id',
  );

  $$ToplamYurishTableProcessedTableManager get toplamYurishRefs {
    final manager = $$ToplamYurishTableTableManager(
      $_db,
      $_db.toplamYurish,
    ).filter((f) => f.toplamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_toplamYurishRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ToplamTableFilterComposer
    extends Composer<_$AppDatabase, $ToplamTable> {
  $$ToplamTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomi => $composableBuilder(
    column: $table.nomi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Qadam>, List<Qadam>, String>
  get qadamlar => $composableBuilder(
    column: $table.qadamlar,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> sessiyaRefs(
    Expression<bool> Function($$SessiyaTableFilterComposer f) f,
  ) {
    final $$SessiyaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessiya,
      getReferencedColumn: (t) => t.toplamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessiyaTableFilterComposer(
            $db: $db,
            $table: $db.sessiya,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> toplamYurishRefs(
    Expression<bool> Function($$ToplamYurishTableFilterComposer f) f,
  ) {
    final $$ToplamYurishTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.toplamYurish,
      getReferencedColumn: (t) => t.toplamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamYurishTableFilterComposer(
            $db: $db,
            $table: $db.toplamYurish,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ToplamTableOrderingComposer
    extends Composer<_$AppDatabase, $ToplamTable> {
  $$ToplamTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomi => $composableBuilder(
    column: $table.nomi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qadamlar => $composableBuilder(
    column: $table.qadamlar,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToplamTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToplamTable> {
  $$ToplamTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomi =>
      $composableBuilder(column: $table.nomi, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Qadam>, String> get qadamlar =>
      $composableBuilder(column: $table.qadamlar, builder: (column) => column);

  Expression<T> sessiyaRefs<T extends Object>(
    Expression<T> Function($$SessiyaTableAnnotationComposer a) f,
  ) {
    final $$SessiyaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessiya,
      getReferencedColumn: (t) => t.toplamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessiyaTableAnnotationComposer(
            $db: $db,
            $table: $db.sessiya,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> toplamYurishRefs<T extends Object>(
    Expression<T> Function($$ToplamYurishTableAnnotationComposer a) f,
  ) {
    final $$ToplamYurishTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.toplamYurish,
      getReferencedColumn: (t) => t.toplamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamYurishTableAnnotationComposer(
            $db: $db,
            $table: $db.toplamYurish,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ToplamTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToplamTable,
          ToplamQator,
          $$ToplamTableFilterComposer,
          $$ToplamTableOrderingComposer,
          $$ToplamTableAnnotationComposer,
          $$ToplamTableCreateCompanionBuilder,
          $$ToplamTableUpdateCompanionBuilder,
          (ToplamQator, $$ToplamTableReferences),
          ToplamQator,
          PrefetchHooks Function({bool sessiyaRefs, bool toplamYurishRefs})
        > {
  $$ToplamTableTableManager(_$AppDatabase db, $ToplamTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToplamTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToplamTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToplamTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nomi = const Value.absent(),
            Value<List<Qadam>> qadamlar = const Value.absent(),
          }) => ToplamCompanion(id: id, nomi: nomi, qadamlar: qadamlar),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nomi,
            required List<Qadam> qadamlar,
          }) => ToplamCompanion.insert(id: id, nomi: nomi, qadamlar: qadamlar),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToplamTable, ToplamQator>(table),
                  $$ToplamTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessiyaRefs = false, toplamYurishRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessiyaRefs) db.sessiya,
                    if (toplamYurishRefs) db.toplamYurish,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessiyaRefs)
                        await $_getPrefetchedDataByColumns<
                          ToplamQator,
                          $ToplamTable,
                          SessiyaQator,
                          $SessiyaTable
                        >(
                          currentTable: table,
                          referencedTable: $$ToplamTableReferences
                              ._sessiyaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ToplamTableReferences(
                                db,
                                table,
                                p0,
                              ).sessiyaRefs,
                          currentColumn: 'id',
                          referencedColumn: 'toplam_id',
                          typedResults: items,
                        ),
                      if (toplamYurishRefs)
                        await $_getPrefetchedDataByColumns<
                          ToplamQator,
                          $ToplamTable,
                          YurishQator,
                          $ToplamYurishTable
                        >(
                          currentTable: table,
                          referencedTable: $$ToplamTableReferences
                              ._toplamYurishRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ToplamTableReferences(
                                db,
                                table,
                                p0,
                              ).toplamYurishRefs,
                          currentColumn: 'id',
                          referencedColumn: 'toplam_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ToplamTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToplamTable,
      ToplamQator,
      $$ToplamTableFilterComposer,
      $$ToplamTableOrderingComposer,
      $$ToplamTableAnnotationComposer,
      $$ToplamTableCreateCompanionBuilder,
      $$ToplamTableUpdateCompanionBuilder,
      (ToplamQator, $$ToplamTableReferences),
      ToplamQator,
      PrefetchHooks Function({bool sessiyaRefs, bool toplamYurishRefs})
    >;
typedef $$SessiyaTableCreateCompanionBuilder = SessiyaCompanion Function({
  Value<int> id,
  required int zikrId,
  Value<int?> toplamId,
  Value<int> son,
  Value<int> aylanalar,
  Value<int> jami,
  required DateTime boshlandi,
  required DateTime yangilandi,
  required String sana,
});
typedef $$SessiyaTableUpdateCompanionBuilder = SessiyaCompanion Function({
  Value<int> id,
  Value<int> zikrId,
  Value<int?> toplamId,
  Value<int> son,
  Value<int> aylanalar,
  Value<int> jami,
  Value<DateTime> boshlandi,
  Value<DateTime> yangilandi,
  Value<String> sana,
});

final class $$SessiyaTableReferences
    extends BaseReferences<_$AppDatabase, $SessiyaTable, SessiyaQator> {
  $$SessiyaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ZikrTable _zikrIdTable(_$AppDatabase db) =>
      db.zikr.createAlias('sessiya__zikr_id__zikr__id');

  $$ZikrTableProcessedTableManager get zikrId {
    final $_column = $_itemColumn<int>('zikr_id')!;

    final manager = $$ZikrTableTableManager(
      $_db,
      $_db.zikr,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zikrIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ToplamTable _toplamIdTable(_$AppDatabase db) =>
      db.toplam.createAlias('sessiya__toplam_id__toplam__id');

  $$ToplamTableProcessedTableManager? get toplamId {
    final $_column = $_itemColumn<int>('toplam_id');
    if ($_column == null) return null;
    final manager = $$ToplamTableTableManager(
      $_db,
      $_db.toplam,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toplamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessiyaTableFilterComposer
    extends Composer<_$AppDatabase, $SessiyaTable> {
  $$SessiyaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get son => $composableBuilder(
    column: $table.son,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aylanalar => $composableBuilder(
    column: $table.aylanalar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jami => $composableBuilder(
    column: $table.jami,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get boshlandi => $composableBuilder(
    column: $table.boshlandi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sana => $composableBuilder(
    column: $table.sana,
    builder: (column) => ColumnFilters(column),
  );

  $$ZikrTableFilterComposer get zikrId {
    final $$ZikrTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zikrId,
      referencedTable: $db.zikr,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZikrTableFilterComposer(
            $db: $db,
            $table: $db.zikr,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ToplamTableFilterComposer get toplamId {
    final $$ToplamTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableFilterComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessiyaTableOrderingComposer
    extends Composer<_$AppDatabase, $SessiyaTable> {
  $$SessiyaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get son => $composableBuilder(
    column: $table.son,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aylanalar => $composableBuilder(
    column: $table.aylanalar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jami => $composableBuilder(
    column: $table.jami,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get boshlandi => $composableBuilder(
    column: $table.boshlandi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sana => $composableBuilder(
    column: $table.sana,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZikrTableOrderingComposer get zikrId {
    final $$ZikrTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zikrId,
      referencedTable: $db.zikr,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZikrTableOrderingComposer(
            $db: $db,
            $table: $db.zikr,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ToplamTableOrderingComposer get toplamId {
    final $$ToplamTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableOrderingComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessiyaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessiyaTable> {
  $$SessiyaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get son =>
      $composableBuilder(column: $table.son, builder: (column) => column);

  GeneratedColumn<int> get aylanalar =>
      $composableBuilder(column: $table.aylanalar, builder: (column) => column);

  GeneratedColumn<int> get jami =>
      $composableBuilder(column: $table.jami, builder: (column) => column);

  GeneratedColumn<DateTime> get boshlandi =>
      $composableBuilder(column: $table.boshlandi, builder: (column) => column);

  GeneratedColumn<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sana =>
      $composableBuilder(column: $table.sana, builder: (column) => column);

  $$ZikrTableAnnotationComposer get zikrId {
    final $$ZikrTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.zikrId,
      referencedTable: $db.zikr,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZikrTableAnnotationComposer(
            $db: $db,
            $table: $db.zikr,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ToplamTableAnnotationComposer get toplamId {
    final $$ToplamTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableAnnotationComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessiyaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessiyaTable,
          SessiyaQator,
          $$SessiyaTableFilterComposer,
          $$SessiyaTableOrderingComposer,
          $$SessiyaTableAnnotationComposer,
          $$SessiyaTableCreateCompanionBuilder,
          $$SessiyaTableUpdateCompanionBuilder,
          (SessiyaQator, $$SessiyaTableReferences),
          SessiyaQator,
          PrefetchHooks Function({bool zikrId, bool toplamId})
        > {
  $$SessiyaTableTableManager(_$AppDatabase db, $SessiyaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessiyaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessiyaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessiyaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> zikrId = const Value.absent(),
                Value<int?> toplamId = const Value.absent(),
                Value<int> son = const Value.absent(),
                Value<int> aylanalar = const Value.absent(),
                Value<int> jami = const Value.absent(),
                Value<DateTime> boshlandi = const Value.absent(),
                Value<DateTime> yangilandi = const Value.absent(),
                Value<String> sana = const Value.absent(),
              }) => SessiyaCompanion(
                id: id,
                zikrId: zikrId,
                toplamId: toplamId,
                son: son,
                aylanalar: aylanalar,
                jami: jami,
                boshlandi: boshlandi,
                yangilandi: yangilandi,
                sana: sana,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int zikrId,
                Value<int?> toplamId = const Value.absent(),
                Value<int> son = const Value.absent(),
                Value<int> aylanalar = const Value.absent(),
                Value<int> jami = const Value.absent(),
                required DateTime boshlandi,
                required DateTime yangilandi,
                required String sana,
              }) => SessiyaCompanion.insert(
                id: id,
                zikrId: zikrId,
                toplamId: toplamId,
                son: son,
                aylanalar: aylanalar,
                jami: jami,
                boshlandi: boshlandi,
                yangilandi: yangilandi,
                sana: sana,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessiyaTable, SessiyaQator>(table),
                  $$SessiyaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({zikrId = false, toplamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (zikrId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.zikrId,
                        referencedTable: $$SessiyaTableReferences._zikrIdTable(
                          db,
                        ),
                        referencedColumn: $$SessiyaTableReferences
                            ._zikrIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (toplamId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.toplamId,
                        referencedTable: $$SessiyaTableReferences
                            ._toplamIdTable(db),
                        referencedColumn: $$SessiyaTableReferences
                            ._toplamIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessiyaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessiyaTable,
      SessiyaQator,
      $$SessiyaTableFilterComposer,
      $$SessiyaTableOrderingComposer,
      $$SessiyaTableAnnotationComposer,
      $$SessiyaTableCreateCompanionBuilder,
      $$SessiyaTableUpdateCompanionBuilder,
      (SessiyaQator, $$SessiyaTableReferences),
      SessiyaQator,
      PrefetchHooks Function({bool zikrId, bool toplamId})
    >;
typedef $$SozlamaTableCreateCompanionBuilder = SozlamaCompanion Function({
  required String kalit,
  required String qiymat,
  Value<int> rowid,
});
typedef $$SozlamaTableUpdateCompanionBuilder = SozlamaCompanion Function({
  Value<String> kalit,
  Value<String> qiymat,
  Value<int> rowid,
});

class $$SozlamaTableFilterComposer
    extends Composer<_$AppDatabase, $SozlamaTable> {
  $$SozlamaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kalit => $composableBuilder(
    column: $table.kalit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qiymat => $composableBuilder(
    column: $table.qiymat,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SozlamaTableOrderingComposer
    extends Composer<_$AppDatabase, $SozlamaTable> {
  $$SozlamaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kalit => $composableBuilder(
    column: $table.kalit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qiymat => $composableBuilder(
    column: $table.qiymat,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SozlamaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SozlamaTable> {
  $$SozlamaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kalit =>
      $composableBuilder(column: $table.kalit, builder: (column) => column);

  GeneratedColumn<String> get qiymat =>
      $composableBuilder(column: $table.qiymat, builder: (column) => column);
}

class $$SozlamaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SozlamaTable,
          SozlamaQator,
          $$SozlamaTableFilterComposer,
          $$SozlamaTableOrderingComposer,
          $$SozlamaTableAnnotationComposer,
          $$SozlamaTableCreateCompanionBuilder,
          $$SozlamaTableUpdateCompanionBuilder,
          (
            SozlamaQator,
            BaseReferences<_$AppDatabase, $SozlamaTable, SozlamaQator>,
          ),
          SozlamaQator,
          PrefetchHooks Function()
        > {
  $$SozlamaTableTableManager(_$AppDatabase db, $SozlamaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SozlamaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SozlamaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SozlamaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> kalit = const Value.absent(),
            Value<String> qiymat = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SozlamaCompanion(kalit: kalit, qiymat: qiymat, rowid: rowid),
          createCompanionCallback:
              ({
                required String kalit,
                required String qiymat,
                Value<int> rowid = const Value.absent(),
              }) => SozlamaCompanion.insert(
                kalit: kalit,
                qiymat: qiymat,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SozlamaTable, SozlamaQator>(table),
                  BaseReferences<_$AppDatabase, $SozlamaTable, SozlamaQator>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SozlamaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SozlamaTable,
      SozlamaQator,
      $$SozlamaTableFilterComposer,
      $$SozlamaTableOrderingComposer,
      $$SozlamaTableAnnotationComposer,
      $$SozlamaTableCreateCompanionBuilder,
      $$SozlamaTableUpdateCompanionBuilder,
      (
        SozlamaQator,
        BaseReferences<_$AppDatabase, $SozlamaTable, SozlamaQator>,
      ),
      SozlamaQator,
      PrefetchHooks Function()
    >;
typedef $$ToplamYurishTableCreateCompanionBuilder =
    ToplamYurishCompanion Function({
      Value<int> id,
      required int toplamId,
      required String sana,
      Value<int> qadam,
      Value<int> son,
      Value<bool> tugadi,
      required DateTime boshlandi,
      required DateTime yangilandi,
    });
typedef $$ToplamYurishTableUpdateCompanionBuilder =
    ToplamYurishCompanion Function({
      Value<int> id,
      Value<int> toplamId,
      Value<String> sana,
      Value<int> qadam,
      Value<int> son,
      Value<bool> tugadi,
      Value<DateTime> boshlandi,
      Value<DateTime> yangilandi,
    });

final class $$ToplamYurishTableReferences
    extends BaseReferences<_$AppDatabase, $ToplamYurishTable, YurishQator> {
  $$ToplamYurishTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ToplamTable _toplamIdTable(_$AppDatabase db) =>
      db.toplam.createAlias('toplam_yurish__toplam_id__toplam__id');

  $$ToplamTableProcessedTableManager get toplamId {
    final $_column = $_itemColumn<int>('toplam_id')!;

    final manager = $$ToplamTableTableManager(
      $_db,
      $_db.toplam,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toplamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ToplamYurishTableFilterComposer
    extends Composer<_$AppDatabase, $ToplamYurishTable> {
  $$ToplamYurishTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sana => $composableBuilder(
    column: $table.sana,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qadam => $composableBuilder(
    column: $table.qadam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get son => $composableBuilder(
    column: $table.son,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tugadi => $composableBuilder(
    column: $table.tugadi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get boshlandi => $composableBuilder(
    column: $table.boshlandi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => ColumnFilters(column),
  );

  $$ToplamTableFilterComposer get toplamId {
    final $$ToplamTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableFilterComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToplamYurishTableOrderingComposer
    extends Composer<_$AppDatabase, $ToplamYurishTable> {
  $$ToplamYurishTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sana => $composableBuilder(
    column: $table.sana,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qadam => $composableBuilder(
    column: $table.qadam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get son => $composableBuilder(
    column: $table.son,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tugadi => $composableBuilder(
    column: $table.tugadi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get boshlandi => $composableBuilder(
    column: $table.boshlandi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => ColumnOrderings(column),
  );

  $$ToplamTableOrderingComposer get toplamId {
    final $$ToplamTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableOrderingComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToplamYurishTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToplamYurishTable> {
  $$ToplamYurishTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sana =>
      $composableBuilder(column: $table.sana, builder: (column) => column);

  GeneratedColumn<int> get qadam =>
      $composableBuilder(column: $table.qadam, builder: (column) => column);

  GeneratedColumn<int> get son =>
      $composableBuilder(column: $table.son, builder: (column) => column);

  GeneratedColumn<bool> get tugadi =>
      $composableBuilder(column: $table.tugadi, builder: (column) => column);

  GeneratedColumn<DateTime> get boshlandi =>
      $composableBuilder(column: $table.boshlandi, builder: (column) => column);

  GeneratedColumn<DateTime> get yangilandi => $composableBuilder(
    column: $table.yangilandi,
    builder: (column) => column,
  );

  $$ToplamTableAnnotationComposer get toplamId {
    final $$ToplamTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toplamId,
      referencedTable: $db.toplam,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ToplamTableAnnotationComposer(
            $db: $db,
            $table: $db.toplam,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ToplamYurishTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToplamYurishTable,
          YurishQator,
          $$ToplamYurishTableFilterComposer,
          $$ToplamYurishTableOrderingComposer,
          $$ToplamYurishTableAnnotationComposer,
          $$ToplamYurishTableCreateCompanionBuilder,
          $$ToplamYurishTableUpdateCompanionBuilder,
          (YurishQator, $$ToplamYurishTableReferences),
          YurishQator,
          PrefetchHooks Function({bool toplamId})
        > {
  $$ToplamYurishTableTableManager(_$AppDatabase db, $ToplamYurishTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToplamYurishTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToplamYurishTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToplamYurishTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> toplamId = const Value.absent(),
                Value<String> sana = const Value.absent(),
                Value<int> qadam = const Value.absent(),
                Value<int> son = const Value.absent(),
                Value<bool> tugadi = const Value.absent(),
                Value<DateTime> boshlandi = const Value.absent(),
                Value<DateTime> yangilandi = const Value.absent(),
              }) => ToplamYurishCompanion(
                id: id,
                toplamId: toplamId,
                sana: sana,
                qadam: qadam,
                son: son,
                tugadi: tugadi,
                boshlandi: boshlandi,
                yangilandi: yangilandi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int toplamId,
                required String sana,
                Value<int> qadam = const Value.absent(),
                Value<int> son = const Value.absent(),
                Value<bool> tugadi = const Value.absent(),
                required DateTime boshlandi,
                required DateTime yangilandi,
              }) => ToplamYurishCompanion.insert(
                id: id,
                toplamId: toplamId,
                sana: sana,
                qadam: qadam,
                son: son,
                tugadi: tugadi,
                boshlandi: boshlandi,
                yangilandi: yangilandi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToplamYurishTable, YurishQator>(table),
                  $$ToplamYurishTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({toplamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (toplamId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.toplamId,
                        referencedTable: $$ToplamYurishTableReferences
                            ._toplamIdTable(db),
                        referencedColumn: $$ToplamYurishTableReferences
                            ._toplamIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ToplamYurishTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToplamYurishTable,
      YurishQator,
      $$ToplamYurishTableFilterComposer,
      $$ToplamYurishTableOrderingComposer,
      $$ToplamYurishTableAnnotationComposer,
      $$ToplamYurishTableCreateCompanionBuilder,
      $$ToplamYurishTableUpdateCompanionBuilder,
      (YurishQator, $$ToplamYurishTableReferences),
      YurishQator,
      PrefetchHooks Function({bool toplamId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ZikrTableTableManager get zikr => $$ZikrTableTableManager(_db, _db.zikr);
  $$ToplamTableTableManager get toplam =>
      $$ToplamTableTableManager(_db, _db.toplam);
  $$SessiyaTableTableManager get sessiya =>
      $$SessiyaTableTableManager(_db, _db.sessiya);
  $$SozlamaTableTableManager get sozlama =>
      $$SozlamaTableTableManager(_db, _db.sozlama);
  $$ToplamYurishTableTableManager get toplamYurish =>
      $$ToplamYurishTableTableManager(_db, _db.toplamYurish);
}
