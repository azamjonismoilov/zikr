import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Platformaga bog'liq barcha imkoniyatlar shu interfeys ortida.
/// Ilova `TizimPlatformasi` bilan ishlaydi, testlar soxta nusxa beradi.
abstract interface class Platforma {
  /// Ovoz tugmasi bilan sanash faqat Android'da.
  bool get android;

  Future<String> ilovaVersiyasi();

  /// Bosish tovushi (tizim "click" tovushi).
  void bosishTovushi();

  /// Ekran o'chmasligi (wakelock).
  Future<void> ekranYoniq(bool yoniq);

  /// Ovoz balandligi tugmalarini sanash uchun ushlash (faqat Android).
  Future<void> ovozTugmasiniUshlash(bool ushlash);

  /// Ushlangan ovoz tugmasi bosilishi.
  Stream<void> get ovozTugmasi;

  /// Bildirishnoma bosilib ilova ochildi.
  Stream<void> get bildirishnomaBosildi;

  /// Bildirishnoma ruxsatini so'raydi; berilgan bo'lsa `true`.
  Future<bool> bildirishnomaRuxsatiniSora();

  /// Har bir [vaqtlar] uchun bittadan eslatma (avvalgilarini almashtiradi).
  Future<void> eslatmalarniRejalashtir(List<DateTime> vaqtlar, {required String sarlavha, required String matn});

  /// Barcha rejalashtirilgan eslatmalarni bekor qiladi.
  Future<void> eslatmaniBekorQil();

  /// Ilovaning bildirishnoma sozlamalarini ochadi.
  Future<void> bildirishnomaSozlamalariniOch();

  /// Faylni tizimning ulashish oynasi orqali beradi.
  Future<void> faylniUlash(String nom, Uint8List bayt);

  /// Faylni tanlatadi va matnini qaytaradi; bekor qilinsa `null`.
  Future<String?> faylniTanlash();

  /// Havolani tizim brauzerida ochadi.
  Future<void> havolaniOch(String manzil);
}

/// `main()` da haqiqiy platforma bilan almashtiriladi.
final platformaProvider = Provider<Platforma>(
  (ref) => throw UnimplementedError('platformaProvider main() da beriladi'),
);
