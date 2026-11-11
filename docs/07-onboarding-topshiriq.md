# 7-topshiriq: onboarding, qulaylik va maxfiylik sahifasi

Claude Code'ga yozing:
`~/Downloads yoki ~/Documents dagi 07-onboarding-topshiriq.md ni docs/ ga ko'chir, o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Ilovaning barcha asosiy ekranlari tayyor: Sanagich, Zikrlar, Tasbehot yo'li, Statistika,
Ketma-ketlik, Sozlamalar. Qoidalar `CLAUDE.md` da. Dizayn: Figma fayl
`tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi, ikkala bo'limdagi
`10 · Onboarding · Xush kelibsiz` va `11 · Onboarding · Maqsad`. Komponent: `TanlovKarta`.

Bu topshiriq birinchi ochilish tajribasini qo'shadi va ilovani odamlar qo'liga berishdan
oldingi sifat ishlarini yopadi. Auditoriyaning bir qismi katta yoshli odamlar: matn
o'qilishi va tugmalarning kattaligi muhim.
</kontekst>

<vazifa>

## 1. Onboarding (uch qadam, faqat birinchi ochilishda)

`onboarding_korildi` sozlamasi yo'q bo'lsa ko'rsatiladi. Mavjud foydalanuvchilarda (bazada
sessiya bor) ko'rsatilmaydi.

**1-qadam: Xush kelibsiz** (`10` ekrani bilan 1:1). Bomdod osmoni (tunda Xufton, oysiz),
illyustratsiya, sarlavha, matn, 3 ta sahifa nuqtasi, "Boshlash" tugmasi. Tepada
"Oʻtkazib yuborish": standart qiymatlar bilan (kunlik maqsad 100, eslatma o'chiq)
onboardingni yopadi.

**2-qadam: Kunlik maqsad** (`11` ekrani bilan 1:1). Orqaga tugmasi, progress chizig'i (2/3),
rasm, savol, izoh, 4 ta `TanlovKarta`: 100 ta, 300 ta (standart tanlangan), 1 000 ta,
"Oʻzim belgilayman" (Maxsus panelini ochadi, tanlangach kartada son ko'rinadi). "Davom
etish" `kunlik_maqsad` ni saqlaydi.

**3-qadam: Eslatma** (Figma'da yo'q; 2-qadam qolipida quriladi). Progress 3/3, rasm
`Rasm/tong`. Savol: "Har kuni eslatib turaymi?". Izoh: "Bugun zikr qilgan boʻlsangiz,
eslatma kelmaydi". Variantlar: "Ertalab · 06:00", "Kechqurun · 21:00" (standart tanlangan),
"Boshqa vaqt" (tizim vaqt tanlagichi, tanlangach kartada vaqt ko'rinadi), "Kerak emas".
Tugma "Tayyor": vaqt tanlangan bo'lsa bildirishnoma ruxsati so'raladi va eslatma yoqiladi
(ruxsat rad etilsa eslatma o'chiq qoladi, onboarding baribir tugaydi). Keyin Sanagich ochiladi.

Qadamlar orasida orqaga qaytish tanlovlarni saqlaydi. Tizimning orqaga imo-ishorasi ham
oldingi qadamga qaytaradi, 1-qadamda ilovadan chiqadi.

## 2. O'qilish va qulaylik

- **`matn3` rangi** yangilanadi: yorug'da `#7C8594`, tunda `#7A899F`.
- **Qoida:** ma'lumot tashiydigan kichik matn (18 px dan kichik) `matn` yoki `matn2` rangida
  bo'ladi. `matn3` faqat placeholder, nofaol holat va bezak uchun. Barcha ekranlarni shu
  qoidaga moslab chiq (masalan, sanagichdagi "/ 33", ishoralar, izohlar, qiymatlar).
- **Bosish maydoni:** har bir bosiladigan element kamida 48×48 dp. Ko'rinishi kichik bo'lsa,
  bosish maydoni ko'rinmas holda kengaytiriladi.
- **Ekran o'qigich:** ikonkali tugmalarga `Semantics` yorliqlari (ARB'da). Sanagichda son,
  maqsad va zikr nomi bitta mazmunli e'lon bo'lib o'qiladi. Bezak rasmlar o'qilmaydi.
- **Matn kattaligi:** tizim shrift o'lchami 1.3 gacha kattalashtirilganda hech bir ekranda
  matn kesilmaydi va ustma-ust tushmaydi. Undan katta qiymatlar 1.3 da cheklanadi.
- **Tizim panellari:** edge-to-edge. Status bar ikonkalari yorug' osmonda to'q, Xufton'da och.
  Pastki tizim paneli shaffof, kapsula tab bar xavfsiz zonani hisobga oladi.

## 3. Maxfiylik sahifasi

- Repoda `sayt/maxfiylik/index.html` yarat: bitta o'zi yetarli HTML fayl (tashqi resurssiz),
  o'zbek va ingliz tilida, ilova ranglarida, telefonda o'qiladigan.
- Mazmuni ilovaning hozirgi holatiga aynan mos bo'lsin: akkaunt yo'q; ma'lumot faqat
  qurilmada saqlanadi; uchinchi tomonga hech narsa yuborilmaydi; analitika va reklama yo'q;
  bildirishnoma ruxsati faqat eslatma uchun; zaxira fayli foydalanuvchi ixtiyorida;
  qurilma zaxirasi (Android Auto Backup) foydalanuvchining Google hisobida; ma'lumotni
  o'chirish yo'li (Sozlamalar → Hisobni nollash, yoki ilovani o'chirish); aloqa manzili.
- Aloqa emaili va sahifa manzili hali yo'q: ikkalasi kodda bitta konstantalar faylida,
  bo'sh qiymat bilan. Sahifada email o'rnida aniq ko'rinadigan `ALOQA_EMAIL` belgisi qolsin.
- Sozlamalarga "Maxfiylik siyosati" qatori qo'sh (MAʼLUMOTLAR guruhidan keyin, versiya
  matni ustida). Manzil konstantasi bo'sh bo'lsa qator ko'rsatilmaydi; to'ldirilgan bo'lsa
  brauzerda ochadi.

## 4. Testlar

- **Onboarding:** birinchi ochilishda chiqadi, ikkinchisida chiqmaydi; mavjud ma'lumotli
  bazada chiqmaydi; o'tkazib yuborish standart qiymatlarni yozadi; tanlovlar saqlanadi;
  ruxsat rad etilganda ham tugaydi; orqaga qaytish tanlovni saqlaydi.
- **Qulaylik:** asosiy ekranlar 1.3 matn masshtabida overflow bermaydi (yorug' va tun);
  bosiladigan elementlar 48 dp dan kichik emas; ikonkali tugmalarda semantik yorliq bor.
- **Kontrast:** `matn` va `matn2` ning `fon` va `fon2` ustidagi kontrasti ikki rejimda
  kamida 4.5:1 ekanini tekshiradigan test.
</vazifa>

<cheklovlar>
- Ilova ikonkasi, ochilish ekrani (splash), imzolash va do'kon uchun build keyingi
  topshiriqda. Akkaunt va Firebase'ga tegma.
- Maxfiylik sahifasida ilova qilmaydigan narsani yozma va qiladiganini tushirib qoldirma.
- Yangi paket kerak bo'lsa (masalan, havola ochish uchun), sababini bir jumlada yoz va
  `CLAUDE.md` ga qo'sh.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Ishni `feat/onboarding` branch'ida qil (`main` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, toza o'rnatishda onboarding
uch qadam bilan o'tadi, barcha ekranlar 1.3 matn masshtabida ikki rejimda buzilmaydi.

Yakunda yoz: o'zgargan va yaratilgan fayllar, `matn3` dan boshqa rangga o'tkazilgan joylar
ro'yxati, Figma'dan farq qilgan joylar, o'zing qabul qilgan qarorlar, ochiq savollar.
</yakun>
