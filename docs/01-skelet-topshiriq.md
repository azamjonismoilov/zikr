# 1-topshiriq: skelet, tokenlar va asosiy qobiq

Claude Code'ga shu faylning `<kontekst>` dan `<yakun>` gacha bo'lgan qismini to'liq yuboring.
Effort: `medium` dan boshlang.

---

<kontekst>
Bo'sh repoda yangi Flutter ilovasi boshlanadi. Loyiha qoidalari, stack, papka tuzilmasi,
dizayn tokenlari va ma'lumot modeli `CLAUDE.md` da. Dizayn Figma faylida
(`tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" va "Komponentlar" sahifalari), Figma MCP orqali o'qiladi.

Bu birinchi topshiriq: ilovaning qobig'i. Sanash mantiqi va ekranlarning ichki mazmuni
keyingi topshiriqlarda quriladi.
</kontekst>

<vazifa>
Ishga tushadigan ilova skeletini qur. Natijada ilova Android emulyatorda ochilishi,
to'rtta bo'lim orasida o'tishi va yorug' hamda tun rejimida Figma'dagi qobiqqa mos
ko'rinishi kerak.

1. **Loyiha.** Flutter loyihasini yarat (Android va iOS). `applicationId` va bundle ID:
   `uz.azam.zikr` (vaqtinchalik, do'konga yuklashdan oldin almashtiriladi). Ilova nomi: "Zikr".
   `CLAUDE.md` dagi stack paketlarini qo'sh va papka tuzilmasini yarat.

2. **Mavzu.** `AppColors` ni `ThemeExtension` sifatida yoz, `CLAUDE.md` jadvalidagi barcha
   tokenlar ikki rejimda. `AppText` ni jadvaldagi 9 ta stil bilan yoz. `AppShadows` ga karta
   soyasi va bo'rtiq soya yordamchilarini qo'sh. Rejim tizim sozlamasiga ergashadi;
   qo'lda tanlash keyingi topshiriqda.

3. **Shriftlar.** Inter (Medium, SemiBold, Bold, ExtraBold) va Amiri (Regular) fayllarini
   `assets/fonts/` ga joyla va `pubspec.yaml` da e'lon qil. Ikkalasi ham OFL litsenziyasida,
   Google Fonts'dan olinadi.

4. **Lokalizatsiya.** `flutter_localizations` va ARB'ni sozla, `app_uz.arb` ni yarat.
   Shu topshiriqdagi barcha ko'rinadigan matnlar (bo'lim nomlari, sarlavhalar) ARB'dan keladi.

5. **Navigatsiya.** `go_router` bilan to'rtta bo'lim: Sanagich (`/`), Zikrlar (`/zikrlar`),
   Statistika (`/statistika`), Sozlamalar (`/sozlamalar`). Bo'limlar orasida o'tganda har
   birining holati saqlanadi (`StatefulShellRoute`).

6. **`OsmonTabBar`.** Figma'dagi `OsmonTabBar` komponenti bo'yicha suzuvchi kapsula:
   chetlardan 16, balandligi 62, to'liq yumaloq, `shisha` fon, `shishaChiziq` chegara,
   faol bo'lim ostida `shishaFaol` pill, faol ikonka va yorliq `kok`, qolganlari `matn`.
   Android'da blur'siz, iOS'da `BackdropFilter` bilan. Ikonkalarni Figma'dan SVG qilib ol.

7. **`SkyHeader`.** Figma'dagi `OsmonFon` komponentining to'rt varianti (Bomdod, Peshin,
   Shom, Xufton): gradient, konsentrik halqalar, bulutlar; Xufton'da oy va yulduzlar.
   Variantlarni Figma'dan SVG sifatida eksport qilib `assets/svg/` ga joyla. Tun rejimida
   har doim Xufton ko'rsatiladi.

8. **Bo'lim qobiqlari.** Har to'rt bo'lim uchun ekran: tepada `SkyHeader`, ustida sarlavha
   (`h1`), ostida bo'sh kontent maydoni. Yorug' rejimda osmon: Sanagich va Statistika Peshin,
   Zikrlar Bomdod, Sozlamalar Shom. Sanagich ekranida sarlavha o'rniga hozircha bo'sh joy.

9. **Baza.** Drift bazasini `CLAUDE.md` dagi to'rt jadval bilan yarat. Birinchi ishga
   tushishda `assets/seed/zikrlar.json` dan standart zikrlar va "Namozdan keyingi tasbehot"
   to'plamini yukla. Seed mazmuni:

   | nomi | arabcha | manosi | maqsad | turkum |
   | --- | --- | --- | --- | --- |
   | SubhanAllah | سُبْحَانَ ٱللَّٰهِ | Alloh pokdir | 33 | namozdan_keyin |
   | Alhamdulillah | ٱلْحَمْدُ لِلَّٰهِ | Allohga hamd boʻlsin | 33 | namozdan_keyin |
   | Allohu Akbar | ٱللَّٰهُ أَكْبَرُ | Alloh buyukdir | 34 | namozdan_keyin |
   | La ilaha illalloh | لَا إِلَٰهَ إِلَّا ٱللَّٰهُ | Allohdan oʻzga iloh yoʻq | 100 | kun_davomida |
   | Astagʻfirulloh | أَسْتَغْفِرُ ٱللَّٰهَ | Allohdan magʻfirat soʻrayman | 100 | kun_davomida |
   | Salavot | ٱللَّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ | Paygʻambarimizga salovat | 10 | kun_davomida |

   To'plam qadamlari: SubhanAllah 33, Alhamdulillah 33, Allohu Akbar 34.

10. **Testlar.** Seed yuklanishi (6 ta zikr, 1 ta to'plam, ikkinchi ishga tushishda
    takrorlanmaydi) va `AppColors` ikki rejimda barcha tokenlarni qaytarishi uchun testlar.
</vazifa>

<cheklovlar>
- Sanash mantiqi, haptik, statistika, eslatmalar va ekranlarning ichki mazmuni bu
  topshiriqqa kirmaydi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Figma'dan aniq eksport qilib bo'lmaydigan element chiqsa, eng yaqin yechimni qo'lla va
  yakunda farqini yoz.
- Ishni `feat/skelet` branch'ida qil.
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, ilova Android emulyatorda
ochiladi, to'rt bo'lim orasida kapsula tab bar orqali o'tiladi, tizim rejimi almashganda
ranglar va osmon almashadi.

Yakunda yoz: o'zgargan va yaratilgan fayllar ro'yxati, ishga tushirish buyruqlari,
Figma'dan farq qilgan joylar, ochiq savollar.
</yakun>
