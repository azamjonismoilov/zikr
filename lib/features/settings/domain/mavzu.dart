/// Ilova mavzusi (`mavzu` sozlamasi).
enum Mavzu {
  tizim('tizim'),
  yorug('yorug'),
  tun('tun');

  const Mavzu(this.kalit);
  final String kalit;

  static Mavzu ol(String? kalit) =>
      Mavzu.values.firstWhere((m) => m.kalit == kalit, orElse: () => Mavzu.tizim);
}
