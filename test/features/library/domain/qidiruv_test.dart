import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/library/domain/qidiruv.dart';

void main() {
  test('katta-kichik harf farqlanmaydi', () {
    expect(qidiruvgaMos('SUBHAN', ['SubhanAllah']), isTrue);
    expect(qidiruvgaMos('pokdir', ['Alloh pokdir']), isTrue);
  });

  test('ʻ \' ` ʼ ‘ ’ bir xil hisoblanadi yoki umuman yozilmasligi mumkin', () {
    const nom = 'Astagʻfirulloh';
    for (final s in ['astagfirulloh', "astag'firulloh", 'astag`firulloh', 'astagʼfirulloh', 'astag‘firulloh', 'astag’firulloh', 'ASTAGʻ']) {
      expect(qidiruvgaMos(s, [nom]), isTrue, reason: s);
    }
  });

  test('maʼno ichidagi apostrof ham normallashadi', () {
    expect(qidiruvgaMos("mag'firat", ['Allohdan magʻfirat soʻrayman']), isTrue);
  });

  test('bir nechta maydon, null maydonlar e\'tiborsiz', () {
    expect(qidiruvgaMos('hamd', ['Alhamdulillah', null, 'Allohga hamd boʻlsin']), isTrue);
    expect(qidiruvgaMos('akbar', [null, 'Salavot']), isFalse);
  });

  test('bo\'sh so\'rov hammasiga mos; ortiqcha bo\'shliqlar qisqaradi', () {
    expect(qidiruvgaMos('   ', ['x']), isTrue);
    expect(qidiruvgaMos('la  ilaha', ['La ilaha illalloh']), isTrue);
    expect(qidiruvUchun('  Oʻz   Zikr '), 'oz zikr');
  });
}
