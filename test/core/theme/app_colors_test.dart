import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/core/theme/app_colors.dart';
import 'package:zikr/core/theme/app_theme.dart';

/// `CLAUDE.md` dagi jadval: token → (yorug', tun).
const _kutilgan = <String, (int, int)>{
  'fon': (0xFFFFFFFF, 0xFF0F1726),
  'fon2': (0xFFF4F9FE, 0xFF142033),
  'chiziq': (0xFFE5EAF1, 0xFF233149),
  'matn': (0xFF171A21, 0xFFEEF3FA),
  'matn2': (0xFF5E6573, 0xFFA3B0C2),
  'matn3': (0xFF9AA2AF, 0xFF6B7A90),
  'kok': (0xFF2E9BF2, 0xFF4AAEF7),
  'kokOch': (0xFFE7F4FE, 0xFF16304D),
  'kokChuqur': (0xFF1B7FD0, 0xFF7CC4FF),
  'yashil': (0xFF29C25A, 0xFF34C76A),
  'yashilChuqur': (0xFF1E9E47, 0xFF5FD98A),
  'yashilOch': (0xFFEBF9EF, 0xFF12301F),
  'yashilChiziq': (0xFF9FE0B3, 0xFF2C6B43),
  'sariq': (0xFFFFC23D, 0xFFFFC23D),
  'olov': (0xFFFF8A1F, 0xFFFF9A3D),
  'olovOch': (0xFFFFF2E6, 0xFF2B1E14),
  'olovChiziq': (0xFFFFCFA3, 0xFF5A3A1E),
  'qizil': (0xFFF5455C, 0xFFFF6B7C),
  'binafsha': (0xFF8E63FF, 0xFFA68AFF),
  'shisha': (0xB8FFFFFF, 0xB81A2438),
  'shishaFaol': (0x0F000000, 0x1AFFFFFF),
  'shishaChiziq': (0xE6FFFFFF, 0x14FFFFFF),
  'chuqurlik': (0xFFD5E3F1, 0xFF16304D),
  'tugmaYuqori': (0xFFFFFFFF, 0xFF1B2A44),
  'tugmaPast': (0xFFF1F7FD, 0xFF142033),
  'bortiq': (0xFFE5EAF1, 0xFF0A1220),
  'asosiyYuqori': (0xFF62BDFF, 0xFF62BDFF),
  'asosiyPast': (0xFF2E9BF2, 0xFF2E9BF2),
  'asosiySoya': (0xFF1B7FD0, 0xFF14548C),
  'qoplama': (0x6B171A21, 0x8C000000),
  'ijroYangiFon': (0xFFEEF2F6, 0xFF24334C),
  'ijroYangiBelgi': (0xFFA3ACB8, 0xFF8796AD),
  'belgiOq': (0xFFFFFFFF, 0xFFFFFFFF),
  'tugunYashilYuqori': (0xFF5FD98A, 0xFF5FD98A),
  'tugunYashilPast': (0xFF2BC25C, 0xFF2BC25C),
  'tugunYashilSoya': (0xFF1E9E47, 0xFF1E9E47),
  'tugunKokYuqori': (0xFF6CC2FF, 0xFF6CC2FF),
  'tugunKokPast': (0xFF2E9BF2, 0xFF2E9BF2),
  'tugunKokSoya': (0xFF1B7FD0, 0xFF1B7FD0),
  'tugunYangiYuqori': (0xFFFFFFFF, 0xFF26385A),
  'tugunYangiPast': (0xFFEEF2F6, 0xFF1B2A44),
  'tugunYangiSoya': (0xFFD3DBE4, 0xFF0A1220),
  'tugunYangiChegara': (0xFFD3DBE4, 0xFF2E4066),
};

void main() {
  test('AppColors barcha tokenlarni ikkala rejimda qaytaradi', () {
    expect(AppColors.yorug.tokens.keys, _kutilgan.keys);
    expect(AppColors.tun.tokens.keys, _kutilgan.keys);

    _kutilgan.forEach((nom, qiymat) {
      expect(AppColors.yorug.tokens[nom]!.toARGB32(), qiymat.$1, reason: 'yorugʻ: $nom');
      expect(AppColors.tun.tokens[nom]!.toARGB32(), qiymat.$2, reason: 'tun: $nom');
    });
  });

  test('mavzular toʻgʻri AppColors kengaytmasini beradi', () {
    expect(AppTheme.yorug.extension<AppColors>(), same(AppColors.yorug));
    expect(AppTheme.tun.extension<AppColors>(), same(AppColors.tun));
    expect(AppTheme.yorug.brightness, Brightness.light);
    expect(AppTheme.tun.brightness, Brightness.dark);
  });

  testWidgets('context.colors tizim rejimiga ergashadi', (tester) async {
    AppColors? olingan;
    Widget ilova() => MaterialApp(
          theme: AppTheme.yorug,
          darkTheme: AppTheme.tun,
          home: Builder(builder: (context) {
            olingan = context.colors;
            return const SizedBox();
          }),
        );

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(ilova());
    expect(olingan!.fon, AppColors.yorug.fon);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(olingan!.fon, AppColors.tun.fon);

    tester.platformDispatcher.clearPlatformBrightnessTestValue();
  });
}
