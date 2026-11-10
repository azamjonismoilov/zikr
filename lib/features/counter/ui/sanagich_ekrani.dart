import 'package:flutter/material.dart';

import '../../../core/widgets/osmon_ekran.dart';
import '../../../core/widgets/sky_header.dart';

class SanagichEkrani extends StatelessWidget {
  const SanagichEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    // Sarlavha o'rnida hozircha bo'sh joy; ko'rsatkichlar keyingi topshiriqda.
    return const OsmonEkran(vaqt: OsmonVaqt.peshin, yuqoriBalandlik: 52);
  }
}
