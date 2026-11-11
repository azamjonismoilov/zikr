import '../../counter/domain/kun.dart';

/// To'plam qadami: qaysi zikr va nechta (qadam maqsadi `zikr.maqsad` dan ustun).
class YolQadami {
  const YolQadami({required this.zikrId, required this.maqsad});

  final int zikrId;
  final int maqsad;
}

/// To'plam bo'yicha bitta o'tish (`toplam_yurish` qatori).
class Yurish {
  const Yurish({
    this.id,
    required this.toplamId,
    required this.sana,
    this.qadam = 0,
    this.son = 0,
    this.tugadi = false,
  });

  /// Bazaga yozilmagan bo'lsa `null`.
  final int? id;
  final int toplamId;

  /// Boshlangan kun.
  final Kun sana;

  /// Joriy qadam indeksi (0 dan). Tugagan yurishda qadamlar soniga teng.
  final int qadam;

  /// Joriy qadamdagi son.
  final int son;
  final bool tugadi;

  Yurish copyWith({int? id, int? qadam, int? son, bool? tugadi}) => Yurish(
        id: id ?? this.id,
        toplamId: toplamId,
        sana: sana,
        qadam: qadam ?? this.qadam,
        son: son ?? this.son,
        tugadi: tugadi ?? this.tugadi,
      );

  @override
  bool operator ==(Object other) =>
      other is Yurish &&
      other.id == id &&
      other.toplamId == toplamId &&
      other.sana == sana &&
      other.qadam == qadam &&
      other.son == son &&
      other.tugadi == tugadi;

  @override
  int get hashCode => Object.hash(id, toplamId, sana, qadam, son, tugadi);

  @override
  String toString() => 'Yurish(toplam: $toplamId, qadam: $qadam, son: $son, tugadi: $tugadi)';
}
