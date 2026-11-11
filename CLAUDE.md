# Zikr ilovasi (ishchi nom)

Oflayn ishlaydigan, reklamasiz zikr sanagich. Flutter, bitta kod Android va iOS uchun.
Birinchi reliz Android (Google Play). Interfeys tili: o'zbek lotin.

Dizayn manbai: Figma fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi
("Yorugʻ rejim" va "Qorongʻu rejim" bo'limlari, ekranlar 01–16) va "Komponentlar" sahifasi.
Ekranni qurishdan oldin uni Figma MCP orqali o'qi; o'lcham, oraliq va interfeys matnlari
Figma'dan olinadi. Zikr matnlari (nomi, talaffuz, arabcha, ma'no) faqat seed'dan olinadi:
Figma'dagi zikr matnlari joy uchun qisqartirilgan namunalar, ularga tayanma.

## Stack

- Flutter (stable), Dart
- Holat: Riverpod
- Navigatsiya: go_router
- Lokal baza: Drift (SQLite), `drift_flutter` (bazani ochish), `drift_dev` + `build_runner` (kod generatsiyasi)
- Sozlamalar: faqat Drift'dagi `sozlama` jadvali (alohida key-value paketi yo'q)
- Rasmlar: flutter_svg
- Eslatmalar: flutter_local_notifications
- Lokalizatsiya: flutter_localizations, ARB, `intl`

Ro'yxatda yo'q paket kerak bo'lsa, qo'shishdan oldin sababini bir jumlada ayt.

## Papka tuzilmasi

```
lib/
  main.dart
  app/                 # app.dart, router.dart
  core/
    theme/             # app_colors.dart, app_text.dart, app_theme.dart, app_shadows.dart
    db/                # database.dart, tables.dart, seed.dart
    widgets/           # sky_header.dart, osmon_tab_bar.dart, umumiy widget'lar
    l10n/              # app_uz.arb
  features/
    counter/           # har birida: data/, domain/, ui/
    library/
    path/
    stats/
    settings/
    onboarding/
assets/
  fonts/  svg/  seed/
test/
```

## Asosiy qoidalar

1. **Telefon asosiy manba.** Barcha ma'lumot Drift'da. Har bir bosish darhol yoziladi,
   ilova o'ldirilsa ham son yo'qolmaydi.
2. **Matnlar faqat ARB'da.** Widget ichida qattiq yozilgan o'zbekcha matn bo'lmaydi.
   Oʻ va gʻ harflarida ʻ (U+02BB) ishlatiladi.
3. **Ranglar faqat `AppColors` orqali**, matn stillari faqat `AppText` orqali.
   Widget ichida hex rang yoki qo'lda `TextStyle` yozilmaydi.
4. **Domen mantiqi UI'dan ajratilgan.** Aylana, kun va streak hisobi `domain/` ichida,
   Flutter'ga bog'liq bo'lmagan sof Dart kodda va unit test bilan.
5. **Sanagich ekranida reklama, homiy belgisi va chalg'ituvchi element bo'lmaydi.**
6. **Analitika va kuzatuvchi SDK'lar yo'q.**
7. **Reyting, ball, daraja, musobaqa yo'q.** Streak faqat odat kuzatuvi.

## Hozir qurilmaydigan qismlar

Akkaunt, Firebase, sinxronlash, jamoaviy zikr, Pro xaridi, vidjet, namoz vaqtlari.
Ular uchun oldindan abstraksiya yoki bo'sh interfeys yozma. Ular alohida topshiriq bilan keladi.

## Hisoblash qoidalari

- **Aylana:** son maqsadga yetganda tugaydi: son 0 ga qaytadi, aylana +1, kuchli haptik,
  halqa to'lib qisqa yonadi. Maqsad ∞ bo'lsa aylana bo'lmaydi. Oddiy aylanada modal yo'q.
- **Tabrik modali** faqat ikki holatda: to'plam tugadi yoki aylana (to'plamda qadam) tugashi
  bugungi kunni birinchi marta hisoblatdi. To'plam ichida bu holat yuz bersa, modal to'plam
  oxirigacha kechiktiriladi; rejimdan chiqilsa ko'rsatilmaydi. Kun aylana o'rtasida kunlik
  maqsad orqali hisoblansa (∞ maqsad ham), modal yo'q: faqat streak belgisi qisqa masshtab
  animatsiyasi bilan yangilanadi.
- **Kun hisoblanadi**, agar o'sha kalendar kunida kamida 1 ta aylana tugagan bo'lsa yoki
  jami son kunlik maqsadga yetgan bo'lsa. Kun chegarasi: qurilma mahalliy vaqtidagi yarim tun.
- **Yarim tun:** yangi kunda birinchi bosish yangi kun qatorini ochadi. Tugallanmagan `son`
  yangi qatorga ko'chadi, `jami` va `aylanalar` har kun uchun alohida sanaladi.
- **Streak:** bugundan orqaga uzluksiz hisoblangan kunlar soni. Bugun hali hisoblanmagan
  bo'lsa, streak kechagi kun bilan tugaydi.
- **Rekord:** barcha davrdagi eng uzun streak.
- **To'plam rejimi (Tasbehot yo'li):** qadamlar ketma-ket, to'xtovsiz o'tiladi. Bosish
  `toplam_yurish.son` va qadam zikrining bugungi `sessiya.jami` ni oshiradi (alohida `son`
  o'zgarmaydi). Qadam maqsadi to'plamdan olinadi. Qadam tugasa `sessiya.aylanalar + 1` va
  darhol keyingi qadam; oxirgisida yurish tugaydi va rejimdan chiqiladi. "Keyingisi" qadamni
  aylanasiz o'tkazadi; oxirgi qadamda ("Tugatish") yurish tugallanmagan holda o'chiriladi.
  Zikr tanlansa rejimdan chiqiladi, yurish saqlanadi. Alohida rejimda "Keyingisi" yo'q.
- **Nollash** faqat joriy aylanani o'chiradi (`jami -= son`, `son = 0`) va tasdiq so'raydi.
  Tarixni o'chirish faqat Sozlamalar orqali, ikki marta tasdiq bilan.
- **Maqsadni almashtirish:** `son > 0` bo'lsa tasdiq so'raladi va joriy aylana nollanadi.
  Tanlangan maqsad shu zikrning `zikr.maqsad` iga yoziladi.

Streak va statistika saqlanmaydi, sessiyalardan hisoblanadi (`features/stats/domain/`).
Statistika sanagich bilan bitta holatdan o'qiydi: sanagichdagi o'zgarish darhol ko'rinadi.

- **Jamlar:** jami zikr va aylana barcha davrdagi yig'indi, o'chirilgan zikrlar ham kiradi.
  "Eng ko'p aytilgan" davr (7 yoki 30 kun) bo'yicha, o'chirilganlar kirmaydi, tenglikda `tartib`.
- **Joriy hafta** dushanbadan yakshanbagacha; hisoblangan kunda uzluksiz qatordagi tartib raqami.
- **Bosqichlar** (7, 14, 30, 60, 100, 365) rekord bo'yicha: yetilgani streak uzilsa ham ✓ qoladi.
  Navbatdagi — rekorddan katta eng kichik bosqich; "yana k kun" joriy streakdan hisoblanadi.
- **Odat kartasi** (shkala va belgilar) joriy streak bo'yicha: streak < 30 → 30, < 100 → 100,
  aks holda 365.
- 100 000 dan katta son qisqartiriladi ("124 ming").

## Ma'lumot modeli

| Jadval | Maydonlar |
| --- | --- |
| `zikr` | id, nomi, talaffuz?, arabcha, manosi, maqsad? (`null` = ∞), rasm?, turkum, oz_zikri, tartib, ochirilgan |
| `toplam` | id, nomi, qadamlar (zikr_id, maqsad) |
| `sessiya` | id, zikr_id, toplam_id?, son, aylanalar, jami, boshlandi, yangilandi, sana; (zikr_id, sana) unikal |
| `toplam_yurish` | id, toplam_id, sana (boshlangan kun), qadam, son, tugadi, boshlandi, yangilandi; to'plamga bitta tugallanmagan |
| `sozlama` | kalit, qiymat |

`sessiya` — har zikr uchun har kalendar kunga bitta qator. `son` joriy aylanadagi son,
`aylanalar` o'sha kuni tugagan aylanalar, `jami` o'sha kuni shu zikr bo'yicha barcha bosishlar.
`sana` mahalliy kun, `YYYY-MM-DD`. Sxema versiyasi: 4 (`drift_schemas/` da har versiya saqlanadi).

`toplam_yurish` — to'plam bo'yicha bitta o'tish. Tugaganlari saqlanadi ("Bugun n-marta").
Har to'plamga bir vaqtda ko'pi bilan bitta `tugadi = 0` qator (qisman unikal indeks).

`zikr.ochirilgan = true` — zikr ro'yxatlarda ko'rinmaydi, `sessiya` qatorlari saqlanadi
(statistika buzilmaydi). O'z zikri (`oz_zikri = true`) talaffuzi `nomi` ga yoziladi.

Turkumlar (nomi va rasmi faqat `features/library/ui/turkum.dart` da):

| Turkum | Nomi | Rasm |
| --- | --- | --- |
| `namozdan_keyin` | Namozdan keyin | namoz |
| `kun_davomida` | Kun davomida | tasbeh |
| `ertalabki` | Ertalabki | tong |
| `kechki` | Kechki | tun |
| (o'z zikrlari) | Mening | yurak |

O'z zikrlari turkumidan qat'i nazar "Mening" bo'limida ko'rsatiladi.

`sozlama` kalitlari:

| Kalit | Standart | Ma'nosi |
| --- | --- | --- |
| `joriy_zikr_id` | eng kichik `tartib` li zikr (SubhanAllah) | sanagichdagi joriy zikr |
| `haptik` | `1` | tebranish yoqilgan (`0` — o'chiq) |
| `kunlik_maqsad` | `100` | kun hisoblanishi uchun jami bosishlar |
| `joriy_toplam_id` | yo'q | bo'lsa, sanagich shu to'plam rejimida |
| `statistika_davri` | `7` | statistika davri: `7` yoki `30` kun |
| `seed_versiya` | — | seed yuklanganini belgilaydi |

Standart zikrlar `assets/seed/zikrlar.json` dan yuklanadi. Diniy matnlar (arabcha, talaffuz,
ma'no) faqat shu faylda turadi, kodda takrorlanmaydi: ular relizdan oldin mutaxassis
tomonidan tekshiriladi va tuzatiladi.

## Dizayn tokenlari

`AppColors` — `ThemeExtension`, ikki rejim: yorug' va tun.

| Token | Yorug' | Tun |
| --- | --- | --- |
| fon | #FFFFFF | #0F1726 |
| fon2 | #F4F9FE | #142033 |
| chiziq | #E5EAF1 | #233149 |
| matn | #171A21 | #EEF3FA |
| matn2 | #5E6573 | #A3B0C2 |
| matn3 | #9AA2AF | #6B7A90 |
| kok | #2E9BF2 | #4AAEF7 |
| kokOch | #E7F4FE | #16304D |
| kokChuqur | #1B7FD0 | #7CC4FF |
| yashil | #29C25A | #34C76A |
| yashilChuqur | #1E9E47 | #5FD98A |
| yashilOch | #EBF9EF | #12301F |
| yashilChiziq | #9FE0B3 | #2C6B43 |
| sariq | #FFC23D | #FFC23D |
| olov | #FF8A1F | #FF9A3D |
| olovOch | #FFF2E6 | #2B1E14 |
| olovChiziq | #FFCFA3 | #5A3A1E |
| qizil | #F5455C | #FF6B7C |
| binafsha | #8E63FF | #A68AFF |
| shisha | #FFFFFF 72% | #1A2438 72% |
| shishaFaol | #000000 6% | #FFFFFF 10% |
| shishaChiziq | #FFFFFF 90% | #FFFFFF 8% |
| chuqurlik | #D5E3F1 | #16304D |
| tugmaYuqori | #FFFFFF | #1B2A44 |
| tugmaPast | #F1F7FD | #142033 |
| bortiq | #E5EAF1 | #0A1220 |
| asosiyYuqori | #62BDFF | #62BDFF |
| asosiyPast | #2E9BF2 | #2E9BF2 |
| asosiySoya | #1B7FD0 | #14548C |
| qoplama | #171A21 42% | #000000 55% |
| ijroYangiFon | #EEF2F6 | #24334C |
| ijroYangiBelgi | #A3ACB8 | #8796AD |
| belgiOq | #FFFFFF | #FFFFFF |
| tugunYashilYuqori / Past / Soya | #5FD98A / #2BC25C / #1E9E47 | xuddi shunday |
| tugunKokYuqori / Past / Soya | #6CC2FF / #2E9BF2 / #1B7FD0 | xuddi shunday |
| tugunYangiYuqori / Past | #FFFFFF / #EEF2F6 | #26385A / #1B2A44 |
| tugunYangiSoya / Chegara | #D3DBE4 / #D3DBE4 | #0A1220 / #2E4066 |
| streakKartaYuqori / Past | #DDF0FF / #FFFFFF | #16304D / #151F31 |
| odatBoshi / odatOxiri | #FFB23F / #FF7A1F | xuddi shunday |

`AppText` — Inter (interfeys) va Amiri (arabcha), ikkalasi ham ilova ichiga joylanadi.

| Stil | Shrift | O'lcham / qator | Harf oralig'i |
| --- | --- | --- | --- |
| raqam | Inter ExtraBold | 84 / 84 | -4% |
| h1 | Inter Bold | 26 / 32 | -2% |
| h2 | Inter Bold | 20 / 26 | -1.5% |
| h3 | Inter Bold | 16 / 21 | -1% |
| matn | Inter Medium | 14 / 20 | -0.5% |
| kichik | Inter Medium | 13 / 18 | -0.3% |
| teg | Inter SemiBold | 12 / 16 | 0 |
| tugma | Inter SemiBold | 16 / 20 | -0.5% |
| arab | Amiri Regular | 34 / 56 | 0 |
| tabYorliq | Inter SemiBold | 10 / 12 | 0 |
| arabKichik | Amiri Regular | 19 / 30 | 0 |
| arabOrta | Amiri Regular | 28 / 46 | 0 |
| qahramon | Inter ExtraBold | 76 / 80 | -4% |
| olovRaqam / olovRaqamKichik | Inter Bold | 12 / 15, 11 / 14 | 0 |
| arabMaydon | Amiri Regular | 21 / 30 | -0.5% |

Shakl va effektlar:

- Karta radiusi 18–20, asosiy tugma 27 (pill), illyustratsiya plitkasi 14.
- Bo'rtiq (3D) effekt: xiralashmagan soya, `BoxShadow(blurRadius: 0, offset: Offset(0, 4))`.
- Asosiy tugma: yuqoridan pastga gradient `asosiyYuqori` → `asosiyPast`, ostida `asosiySoya`
  bo'rtiq soya. Matn `fon` rangida.
- Karta soyasi: rgba(15, 41, 82, 0.06), y 3, blur 12.
- Pill soyasi: rgba(15, 41, 82, 0.08), y 2, blur 8. Doira ikonka tugma: rgba(15, 41, 82, 0.1), y 3, blur 10.
- Zikr kartasi (`DarsKarta`): rgba(15, 41, 82, 0.06), y 3, blur 5. Turkumlar kartasi: rgba(15, 41, 82, 0.1), y 6, blur 9.
- Odat shkalasi belgisi: rgba(15, 41, 82, 0.1), y 2, blur 6. Kun kapsulasi: rgba(15, 41, 82, 0.05), y 2, blur 3.
- Tabrik kartasi: rgba(0, 0, 0, 0.25), y 20, blur 50. Tunda osmon zonasida markazda sarlavha yoki
  rasm turgan joylarda (08, yo'l ekrani, tabrik, Ketma-ketlik) `SkyHeader(oysiz: true)`.
- Oq tugmalar (maqsad, nollash): `fon`, 1.5 `chiziq` chegara, ostida `bortiq` bo'rtiq soya.
- Tab bar kapsulasi soyasi: rgba(10, 26, 51, 0.14), y 8, blur 28.

Osmon (`SkyHeader`, 390×230, to'rt variant):

| Vaqt | Gradient (yuqoridan pastga) |
| --- | --- |
| Bomdod | #F7A98A → #FCD9C6 → #FFF2EA |
| Peshin | #4AA9F5 → #B9DFFF → #EAF6FF |
| Shom | #E9795A → #F6B48E → #FDE6D6 |
| Xufton | #0A1430 → #16233D |

Yorug' rejimda ekranlar o'z osmonini ishlatadi (Figma'ga qara), tun rejimida hamma ekranda Xufton.

## Platformaga moslash

- **Android:** edge-to-edge, tizim status bari va navigatsiya chizig'i, orqaga imo-ishorasi.
  Tab bar kapsulasi blur'siz, yarim shaffof fon bilan.
- **iOS:** kapsula `BackdropFilter` blur bilan, uy indikatori uchun joy.
- Ovoz tugmasi bilan sanash faqat Android'da.

## Buyruqlar

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## Ish tartibi

- Har topshiriq alohida git branch'da. `main` ga to'g'ridan-to'g'ri yozilmaydi.
- Topshiriq oxirida: o'zgargan fayllar ro'yxati, qanday ishga tushirish va ochiq savollar.
- Do'konga yuklash va imzolash kalitlari bilan ishlash faqat egasining aniq buyrug'i bilan.
