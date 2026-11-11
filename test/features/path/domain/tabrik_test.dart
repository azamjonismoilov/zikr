import 'package:flutter_test/flutter_test.dart';
import 'package:zikr/features/path/domain/tabrik.dart';

void main() {
  group('alohida rejim', () {
    test('oddiy aylana (kun allaqachon hisoblangan) — modal yo\'q', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: false,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: false,
        kechiktirilgan: false,
      );
      expect(q.turi, isNull);
      expect(q.kechiktirilgan, isFalse);
    });

    test('bugun birinchi marta kun hisobga olindi — "kun hisoblandi", dalda bilan', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: false,
        aylanaKunniHisoblatdi: true,
        toplamTugadi: false,
        kechiktirilgan: false,
      );
      expect(q.turi, TabrikTuri.kunHisoblandi);
      expect(q.dalda, isTrue);
    });
  });

  group('to\'plam rejimi', () {
    test('kun hisobga olinsa, modal to\'plam oxirigacha kechiktiriladi', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: true,
        toplamTugadi: false,
        kechiktirilgan: false,
      );
      expect(q.turi, isNull);
      expect(q.kechiktirilgan, isTrue);
    });

    test('kechiktirilgan holat keyingi bosishlarda saqlanadi', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: false,
        kechiktirilgan: true,
      );
      expect(q.turi, isNull);
      expect(q.kechiktirilgan, isTrue);
    });

    test('to\'plam tugadi: bitta modal, kechiktirilgan bo\'lsa dalda bilan', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: true,
        kechiktirilgan: true,
      );
      expect(q.turi, TabrikTuri.toplamTugadi);
      expect(q.dalda, isTrue);
      expect(q.kechiktirilgan, isFalse);
    });

    test('to\'plam tugadi, kun avvaldan hisoblangan: dalda yo\'q', () {
      final q = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: true,
        kechiktirilgan: false,
      );
      expect(q.turi, TabrikTuri.toplamTugadi);
      expect(q.dalda, isFalse);
    });

    test('oxirgi qadam o\'tkazib yuborildi: kechiktirilgan "kun hisoblandi" endi chiqadi', () {
      final bor = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: false,
        yurishYopildi: true,
        kechiktirilgan: true,
      );
      expect(bor.turi, TabrikTuri.kunHisoblandi);
      final yoq = TabrikHisobi.qaror(
        toplamRejimi: true,
        aylanaKunniHisoblatdi: false,
        toplamTugadi: false,
        yurishYopildi: true,
        kechiktirilgan: false,
      );
      expect(yoq.turi, isNull);
    });
  });
}
