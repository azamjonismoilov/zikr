# 2-topshiriq: sanagich ekrani va sanash mantiqi

Bu faylni `docs/` ga qo'ying va Claude Code'ga yozing:
`docs/02-sanagich-topshiriq.md faylini o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Skelet tayyor: mavzu, navigatsiya, kapsula tab bar, osmon, Drift bazasi va seed ishlayapti.
Qoidalar `CLAUDE.md` da. Dizayn: Figma fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi,
"Yorugʻ rejim" bo'limidagi `01 · Sanagich` va "Qorongʻu rejim" bo'limidagi
`Tun · 01 · Sanagich`.

Bu topshiriq ilovaning yuragi: sanagich ekrani, sanash mantiqi va uning saqlanishi.
Zikr tanlash paneli, tabrik modali, statistika ekrani va sozlamalar keyingi topshiriqlarda.
</kontekst>

<vazifa>
Sanagich ekranini Figma bilan 1:1 qur va sanash mantiqini to'liq, test bilan yoz.

## 1. Ma'lumot modeli o'zgarishlari

- `sessiya` jadvaliga `jami` (int) ustunini qo'sh: shu zikr bo'yicha o'sha kundagi barcha
  bosishlar soni. `son` joriy aylanadagi son bo'lib qoladi, `aylanalar` o'sha kuni tugagan
  aylanalar soni.
- Har zikr uchun har kalendar kunga bitta `sessiya` qatori (`zikr_id` + `sana` unikal).
- `zikr.maqsad` nullable: `null` cheksiz (∞) degani.
- Drift migratsiyasini yoz (sxema versiyasi 2) va `CLAUDE.md` dagi jadvalni yangila.
- `sozlama` kalitlari: `joriy_zikr_id` (standart: SubhanAllah), `haptik` (standart: yoqilgan),
  `kunlik_maqsad` (standart: 100).

## 2. Domen mantiqi (`features/counter/domain/`, sof Dart)

**Bosish.** Har bosish: `son + 1`, `jami + 1`. Agar maqsad `null` bo'lmasa va `son` maqsadga
yetsa: `son = 0`, `aylanalar + 1`, "aylana tugadi" hodisasi chiqadi.

**Yarim tun.** Kun chegarasi qurilma mahalliy vaqtidagi 00:00. Yangi kunda birinchi bosish
yangi kun qatorini ochadi. Joriy aylana uzilmaydi: tugallanmagan `son` yangi kun qatoriga
ko'chadi, `jami` va `aylanalar` esa har kun uchun alohida sanaladi.

**Nollash.** Faqat joriy aylanani o'chiradi: `jami -= son`, `son = 0`. Tugagan aylanalar va
o'tgan kunlar o'zgarmaydi.

**Maqsadni almashtirish.** `son == 0` bo'lsa darhol almashadi. `son > 0` bo'lsa tasdiq
so'raladi ("Joriy aylana nollanadi"), tasdiqlansa nollash bajariladi va maqsad almashadi.
Tanlangan maqsad shu zikr uchun `zikr.maqsad` ga saqlanadi.

**Kun hisobi.** Kun hisoblanadi, agar o'sha kuni istalgan zikr bo'yicha kamida 1 aylana
tugagan bo'lsa yoki barcha zikrlar bo'yicha `jami` yig'indisi `kunlik_maqsad` ga yetgan bo'lsa.

**Streak.** Bugundan orqaga uzluksiz hisoblangan kunlar soni. Bugun hali hisoblanmagan
bo'lsa, sanash kechagi kundan boshlanadi (streak yo'qolmaydi, lekin bugun qo'shilmaydi).
Rekord: barcha davrdagi eng uzun uzluksiz qator.

Vaqtni to'g'ridan-to'g'ri `DateTime.now()` dan olma: soat (`Clock` yoki shunga o'xshash)
tashqaridan beriladi, testlarda almashtiriladi.

## 3. Saqlash

- Ekran holati xotirada darhol yangilanadi, bazaga yozish UI'ni kutdirmaydi.
- Yozuvlar navbat bilan bajariladi va hech bir bosish yo'qolmaydi: ketma-ket 100 ta tez
  bosishdan keyin bazada `jami` 100 bo'lishi kerak.
- Ilova o'ldirilib qayta ochilganda joriy zikr, `son`, aylana raqami va maqsad tiklanadi.

## 4. Sanagich ekrani (Figma bilan 1:1, ikki rejim)

- **Bosish maydoni.** Kontent maydonining istalgan joyiga bosish sanaydi. Tepadagi tugmalar,
  maqsad qatori, nollash va "Keyingisi" tugmasi bundan mustasno.
- **Markaziy tugma.** Bosilganda bo'rtiq tugma 4px pastga tushib qaytadi (taxminan 80 ms).
  Ichida aylana tegi ("2-aylana": bugungi `aylanalar + 1`), son va "/ maqsad".
- **Halqa.** Progress `son / maqsad`, uchlari yumaloq. Son o'zgarganda silliq to'ladi
  (taxminan 150 ms). Maqsad ∞ bo'lsa: faqat kulrang yo'l, aylana tegi va "/ maqsad" yashiriladi.
- **Tepadagi belgilar.** Olov: joriy streak. Tasbeh: bugun tugagan aylanalar soni
  (barcha zikrlar bo'yicha).
- **O'ngdagi tugmalar.** Tebranish tugmasi haptikni yoqadi va o'chiradi; o'chiq holatda
  ikonka `matn3` rangida. Jamoa tugmasi hozircha ko'rsatilmaydi.
- **Zikr bloki.** Arabcha matn, nomi va ma'nosi joriy zikrdan. Nom yonidagi "▾" ko'rinadi,
  lekin hozircha hech narsa ochmaydi.
- **Maqsad qatori.** 33, 99, ∞, Maxsus. "Maxsus" pastdan chiquvchi panel ochadi: 1 dan
  10 000 gacha son kiritiladi (Figma'dagi `Maydon` komponenti uslubida), "Saqlash" tugmasi.
  Joriy maqsad 33, 99 yoki ∞ bo'lmasa, "Maxsus" faol ko'rinadi va o'rnida son yoziladi.
- **Nollash tugmasi.** `son > 0` bo'lganda tasdiq dialogi bilan ishlaydi, `son == 0` da
  hech narsa qilmaydi.
- **"Keyingisi" tugmasi.** Joriy zikr "Namozdan keyingi tasbehot" to'plamida bo'lsa
  ko'rinadi: "Keyingisi: {keyingi zikr nomi}". Bosilganda to'plamdagi keyingi zikrga o'tadi
  (oxirgisidan keyin birinchisiga). To'plamda bo'lmagan zikrlarda yashiriladi.
- **Haptik.** Har bosishda yengil (`HapticFeedback.lightImpact`), aylana tugaganda kuchli
  (`heavyImpact`). `haptik` o'chirilgan bo'lsa ikkalasi ham ishlamaydi.
- **Aylana tugaganda** hozircha faqat kuchli haptik va teg yangilanishi. Tabrik modali
  keyingi topshiriqda.
- Barcha matnlar ARB'da. Sonlar ming ajratgichi bilan ("1 248").

## 5. Testlar

- **Domen:** aylana tugashi; ∞ maqsad; nollash; maqsad almashtirish; yarim tunda `son`
  ko'chishi; kun hisobi (aylana orqali va `kunlik_maqsad` orqali); streak (uzilish bilan,
  bugun hisoblanmagan holat, rekord).
- **Saqlash** (xotiradagi Drift bilan): 100 ta tez bosish yo'qolmaydi; qayta ochilganda
  holat tiklanadi; har zikr va kun uchun bitta qator.
- **Widget:** bosish sonni oshiradi; boshqaruv elementlariga bosish sanamaydi; maqsad
  almashtirishda tasdiq; ∞ da teg va "/ maqsad" yashiriladi.
</vazifa>

<cheklovlar>
- Zikr tanlash paneli, tabrik modali, Zikrlar, Statistika va Sozlamalar ekranlarining
  mazmuni, eslatmalar, tovush va ovoz tugmasi bilan sanash bu topshiriqqa kirmaydi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Yangi paket kerak bo'lsa, sababini bir jumlada yoz.
- Ishni `feat/sanagich` branch'ida qil (`feat/skelet` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, emulyatorda sanagich ikki
rejimda Figma'ga mos, bosish sanaydi, ilova qayta ochilganda son saqlanib qoladi.

Yakunda yoz: o'zgargan va yaratilgan fayllar, Figma'dan farq qilgan joylar, o'zing qabul
qilgan qarorlar, ochiq savollar.
</yakun>
