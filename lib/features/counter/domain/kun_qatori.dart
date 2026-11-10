import 'kun.dart';

/// Bitta zikrning bitta kalendar kunidagi holati (`sessiya` qatori).
class KunQatori {
  const KunQatori({
    required this.zikrId,
    required this.sana,
    this.son = 0,
    this.jami = 0,
    this.aylanalar = 0,
  });

  final int zikrId;
  final Kun sana;

  /// Joriy aylanadagi son.
  final int son;

  /// Shu kuni shu zikr bo'yicha barcha bosishlar.
  final int jami;

  /// Shu kuni tugagan aylanalar.
  final int aylanalar;

  KunQatori copyWith({Kun? sana, int? son, int? jami, int? aylanalar}) => KunQatori(
        zikrId: zikrId,
        sana: sana ?? this.sana,
        son: son ?? this.son,
        jami: jami ?? this.jami,
        aylanalar: aylanalar ?? this.aylanalar,
      );

  @override
  bool operator ==(Object other) =>
      other is KunQatori &&
      other.zikrId == zikrId &&
      other.sana == sana &&
      other.son == son &&
      other.jami == jami &&
      other.aylanalar == aylanalar;

  @override
  int get hashCode => Object.hash(zikrId, sana, son, jami, aylanalar);

  @override
  String toString() =>
      'KunQatori(zikr: $zikrId, $sana, son: $son, jami: $jami, aylanalar: $aylanalar)';
}
