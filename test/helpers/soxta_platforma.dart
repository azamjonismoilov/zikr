import 'dart:async';
import 'dart:typed_data';

import 'package:zikr/core/platforma/platforma.dart';

/// Testlar uchun platforma: chaqiruvlarni yozib boradi, javoblarni test belgilaydi.
class SoxtaPlatforma implements Platforma {
  SoxtaPlatforma({this.android = true, this.ruxsat = true});

  @override
  bool android;

  /// `bildirishnomaRuxsatiniSora` javobi.
  bool ruxsat;

  /// `faylniTanlash` javobi.
  String? tanlanadiganFayl;

  int tovushlar = 0;
  bool ekranYoniqHolati = false;
  bool ovozUshlanmoqda = false;
  final ekranYoniqTarixi = <bool>[];
  final ulashilganlar = <(String, Uint8List)>[];
  final rejalar = <(DateTime, String, String)>[];
  int bekorQilishlar = 0;
  int sozlamalarOchildi = 0;

  final _ovoz = StreamController<void>.broadcast();
  final _bosildi = StreamController<void>.broadcast();

  void ovozTugmasiniBos() => _ovoz.add(null);
  void bildirishnomaniBos() => _bosildi.add(null);

  @override
  Future<String> ilovaVersiyasi() async => '1.0.0';

  @override
  void bosishTovushi() => tovushlar++;

  @override
  Future<void> ekranYoniq(bool yoniq) async {
    ekranYoniqHolati = yoniq;
    ekranYoniqTarixi.add(yoniq);
  }

  @override
  Future<void> ovozTugmasiniUshlash(bool ushlash) async => ovozUshlanmoqda = ushlash;

  @override
  Stream<void> get ovozTugmasi => _ovoz.stream;

  @override
  Stream<void> get bildirishnomaBosildi => _bosildi.stream;

  @override
  Future<bool> bildirishnomaRuxsatiniSora() async => ruxsat;

  @override
  Future<void> eslatmalarniRejalashtir(List<DateTime> vaqtlar, {required String sarlavha, required String matn}) async =>
      rejalar.add((vaqtlar.first, sarlavha, matn));

  @override
  Future<void> eslatmaniBekorQil() async => bekorQilishlar++;

  @override
  Future<void> bildirishnomaSozlamalariniOch() async => sozlamalarOchildi++;

  @override
  Future<void> faylniUlash(String nom, Uint8List bayt) async => ulashilganlar.add((nom, bayt));

  @override
  Future<String?> faylniTanlash() async => tanlanadiganFayl;
}
