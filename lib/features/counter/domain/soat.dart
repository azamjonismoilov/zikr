/// Joriy vaqt manbai. Domen va controller vaqtni faqat shu orqali oladi,
/// testlarda [QoldaSoat] bilan almashtiriladi.
abstract interface class Soat {
  DateTime hozir();
}

class TizimSoati implements Soat {
  const TizimSoati();

  @override
  DateTime hozir() => DateTime.now();
}

/// Testlar uchun: vaqt qo'lda o'rnatiladi va suriladi.
class QoldaSoat implements Soat {
  QoldaSoat(this._vaqt);

  DateTime _vaqt;

  @override
  DateTime hozir() => _vaqt;

  set vaqt(DateTime v) => _vaqt = v;

  void sur(Duration d) => _vaqt = _vaqt.add(d);
}
