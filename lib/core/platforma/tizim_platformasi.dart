import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timezone/data/latest_10y.dart' as tz_malumot;
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

import 'platforma.dart';

/// Haqiqiy qurilma platformasi.
class TizimPlatformasi implements Platforma {
  static const _kanal = MethodChannel('uz.azam.zikr/tizim');
  /// Eslatmalar `_eslatmaId` dan boshlab ketma-ket id oladi.
  static const _eslatmaId = 100;

  final _bildirishnoma = FlutterLocalNotificationsPlugin();
  final _ovozTugmasi = StreamController<void>.broadcast();
  final _bosildi = StreamController<void>.broadcast();

  Future<void>? _vaqtZonasi;

  /// Kanal va bildirishnomani tayyorlaydi (yengil qismlar). Vaqt zonasi bazasi og'ir,
  /// u faqat eslatma rejalashtirilganda yuklanadi: Dart asosiy oqimda ishlaydi, ishga
  /// tushishda uni band qilish ANR beradi.
  Future<void> tayyorla() async {
    _kanal.setMethodCallHandler((call) async {
      if (call.method == 'ovozTugmasi') _ovozTugmasi.add(null);
    });

    await _bildirishnoma.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (_) => _bosildi.add(null),
    );
  }

  @override
  bool get android => Platform.isAndroid;

  @override
  Future<String> ilovaVersiyasi() async => (await PackageInfo.fromPlatform()).version;

  @override
  void bosishTovushi() => SystemSound.play(SystemSoundType.click);

  @override
  Future<void> ekranYoniq(bool yoniq) => WakelockPlus.toggle(enable: yoniq);

  @override
  Future<void> ovozTugmasiniUshlash(bool ushlash) async {
    if (!android) return;
    await _kanal.invokeMethod('ovozTugmasiniUshlash', ushlash);
  }

  @override
  Stream<void> get ovozTugmasi => _ovozTugmasi.stream;

  @override
  Stream<void> get bildirishnomaBosildi => _bosildi.stream;

  @override
  Future<bool> bildirishnomaRuxsatiniSora() async {
    if (android) {
      final a = _bildirishnoma
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await a?.requestNotificationsPermission() ?? false;
    }
    final i = _bildirishnoma
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return await i?.requestPermissions(alert: true, sound: true) ?? false;
  }

  Future<void> _vaqtZonasiniTayyorla() => _vaqtZonasi ??= () async {
        tz_malumot.initializeTimeZones();
        try {
          final zona = await FlutterTimezone.getLocalTimezone();
          tz.setLocalLocation(tz.getLocation(zona.identifier));
        } catch (e) {
          debugPrint('Vaqt zonasi aniqlanmadi, UTC ishlatiladi: $e');
        }
      }();

  @override
  Future<void> eslatmalarniRejalashtir(
    List<DateTime> vaqtlar, {
    required String sarlavha,
    required String matn,
  }) async {
    await _vaqtZonasiniTayyorla();
    await eslatmaniBekorQil();
    for (final (i, vaqt) in vaqtlar.indexed) {
      await _bildirishnoma.zonedSchedule(
        id: _eslatmaId + i,
        scheduledDate: tz.TZDateTime.from(vaqt, tz.local),
        title: sarlavha,
        body: matn,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails('kunlik_eslatma', 'Kunlik eslatma'),
          iOS: DarwinNotificationDetails(),
        ),
        // Noaniq rejim: aniq signal ruxsati kerak emas.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  // Ilovada eslatmadan boshqa bildirishnoma yo'q: hammasini o'chirish
  // avvalgi versiyalardan qolgan id'larni ham tozalaydi.
  @override
  Future<void> eslatmaniBekorQil() => _bildirishnoma.cancelAll();

  @override
  Future<void> bildirishnomaSozlamalariniOch() => _kanal.invokeMethod('bildirishnomaSozlamalari');

  @override
  Future<void> faylniUlash(String nom, Uint8List bayt) async {
    await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(bayt, mimeType: 'application/json', name: nom)],
      fileNameOverrides: [nom],
    ));
  }

  @override
  Future<String?> faylniTanlash() async {
    final fayllar = await FilePicker.pickFiles();
    if (fayllar.isEmpty) return null;
    return utf8.decode(await fayllar.first.readAsBytes(), allowMalformed: true);
  }
}
