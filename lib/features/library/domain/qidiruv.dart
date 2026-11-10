/// Qidiruv uchun matnni bir xil ko'rinishga keltiradi: kichik harf, apostrof belgilari
/// (ʻ ' ` ʼ ‘ ’) olib tashlanadi, bo'shliqlar bittaga qisqaradi.
///
/// Shunda "astagfirulloh", "astag'firulloh" va "Astagʻfirulloh" bir xil bo'ladi.
String qidiruvUchun(String matn) => matn
    .toLowerCase()
    .replaceAll(RegExp("[ʻʼ‘’'`]"), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// [so'rov] maydonlardan birortasida uchraydimi. Bo'sh so'rov hammasiga mos.
bool qidiruvgaMos(String sorov, Iterable<String?> maydonlar) {
  final s = qidiruvUchun(sorov);
  if (s.isEmpty) return true;
  for (final m in maydonlar) {
    if (m != null && qidiruvUchun(m).contains(s)) return true;
  }
  return false;
}
