/// Kalendar kuni (yil, oy, kun), vaqt va vaqt mintaqasisiz.
///
/// Kun chegarasi qurilma mahalliy vaqtidagi yarim tun, shuning uchun [Kun.dan]
/// mahalliy `DateTime` oladi. Kunlar orasidagi amallar UTC'da bajariladi,
/// yozgi vaqtga o'tish ularni buzmaydi.
class Kun implements Comparable<Kun> {
  const Kun(this.yil, this.oy, this.kun);

  factory Kun.dan(DateTime vaqt) {
    final mahalliy = vaqt.toLocal();
    return Kun(mahalliy.year, mahalliy.month, mahalliy.day);
  }

  /// `YYYY-MM-DD` ko'rinishidagi matndan.
  factory Kun.parse(String matn) {
    final q = matn.split('-');
    if (q.length != 3) throw FormatException('Kun formati notoʻgʻri', matn);
    return Kun(int.parse(q[0]), int.parse(q[1]), int.parse(q[2]));
  }

  final int yil;
  final int oy;
  final int kun;

  DateTime get _utc => DateTime.utc(yil, oy, kun);

  Kun qoshish(int kunlar) {
    final d = _utc.add(Duration(days: kunlar));
    return Kun(d.year, d.month, d.day);
  }

  Kun get oldingi => qoshish(-1);
  Kun get keyingi => qoshish(1);

  /// Bazadagi `sessiya.sana` ko'rinishi.
  String get kalit =>
      '${yil.toString().padLeft(4, '0')}-${oy.toString().padLeft(2, '0')}-${kun.toString().padLeft(2, '0')}';

  @override
  int compareTo(Kun other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) =>
      other is Kun && other.yil == yil && other.oy == oy && other.kun == kun;

  @override
  int get hashCode => Object.hash(yil, oy, kun);

  @override
  String toString() => kalit;
}
