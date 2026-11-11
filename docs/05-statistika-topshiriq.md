# 5-topshiriq: Statistika va Ketma-ketlik ekranlari

Claude Code'ga yozing:
`~/Downloads yoki ~/Documents dagi 05-statistika-topshiriq.md ni docs/ ga ko'chir, o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Sanagich, Zikrlar, zikr tanlash, o'z zikri, to'plam rejimi va Tasbehot yo'li tayyor.
Kun hisobi, streak va rekord domen qatlamida bor. Qoidalar `CLAUDE.md` da. Dizayn: Figma
fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi, ikkala bo'limdagi `04 · Statistika` va
`12 · Ketma-ketlik`. Komponentlar: `KunKapsula`, `Qahramon/olov`, `Rasm/olov`.

Bu topshiriq foydalanuvchiga o'z odatini ko'rsatadi. Ohang sokin: reyting, ball, daraja,
boshqalar bilan taqqoslash yo'q. Hamma raqam sessiyalardan hisoblanadi, alohida saqlanmaydi.
</kontekst>

<vazifa>
Ikki ekranni Figma bilan 1:1 qur, hisoblarni domen qatlamida yoz va testla.

## 1. Hisoblar (`features/stats/domain/`, sof Dart)

- **Jami zikr:** barcha davrdagi `jami` yig'indisi. **Aylana:** barcha davrdagi `aylanalar`
  yig'indisi. **Bugun:** bugungi `jami` yig'indisi. O'chirilgan zikrlarning sessiyalari ham
  hisobga kiradi.
- **Kunlik qator:** oxirgi N kun (bugun bilan) uchun har kunning `jami` yig'indisi.
- **Eng ko'p aytilgan:** tanlangan davrda `jami` bo'yicha eng yuqori 3 ta zikr
  (o'chirilganlar ro'yxatga kirmaydi). Teng bo'lsa `zikr.tartib` bo'yicha.
- **Hafta holati (7 kun, bugun oxirida):** har kun uchun: hisoblangan, hisoblanmagan,
  yoki bugun-hali-hisoblanmagan.
- **Joriy hafta (dushanbadan yakshanbagacha):** har kun uchun: hisoblangan (va shu kunning
  joriy streakdagi tartib raqami), o'tib ketgan va hisoblanmagan, yoki kelajak.
- **Streak boshlangan sana:** joriy streakning birinchi kuni; streak 0 bo'lsa yo'q.
- **Bosqichlar:** 7, 14, 30, 60, 100, 365 kun. Har biri uchun: yetilgan, navbatdagi
  (necha kun qolgani bilan) yoki keyingi.
- **Odat maqsadi:** streak 30 dan kichik bo'lsa 30 (belgilar 7, 14, 30); 100 dan kichik
  bo'lsa 100 (belgilar 30, 60, 100); aks holda 365 (belgilar 100, 200, 365).

## 2. `04 · Statistika` ekrani

- **Sarlavha.** "Statistika" va davr tugmasi ("7 kun ▾"). Bosilganda pastki panel: "7 kun"
  va "30 kun". Tanlov `sozlama` da saqlanadi. Davr faqat "Eng ko'p aytilgan" va grafik
  kartasiga ta'sir qiladi.
- **Ketma-ketlik kartasi.** `Rasm/olov`, "{n} kun", izoh, o'ngda "›". Ostida hafta holati:
  hisoblangan kun yashil belgi, bugun-hali-hisoblanmagan ko'k "boshlash" belgisi,
  hisoblanmagan o'tgan kun bo'sh kulrang doira (`chiziq` chegarali). Kun nomlari ikki harfli:
  Du, Se, Ch, Pa, Ju, Sh, Ya. Karta bosilganda Ketma-ketlik ekrani ochiladi.
  Izoh: streak 0 bo'lsa "Bugun birinchi kunni boshlang"; bugun hali hisoblanmagan bo'lsa
  "Bugun hali zikr qilmadingiz"; aks holda "kun ketma-ket zikr qildingiz".
- **Uchta raqam kartasi.** "jami zikr", "aylana", "bugun": rangli ikonka belgisi, son, yozuv.
  Uchalasi bir xil balandlikda. Sonlar ming ajratgichi bilan; 100 000 dan katta son
  qisqartiriladi ("124 ming").
- **"Eng koʻp aytilgan" kartasi.** Har qatorda zikr rasmi, nomi, soni va shkala (eng
  yuqorisiga nisbatan). Davrda ma'lumot bo'lmasa: "Bu davrda hali zikr qilinmagan".
- **Grafik kartasi.** Sarlavha "Oxirgi 7 kun" yoki "Oxirgi 30 kun", o'ngda davr jami
  ("1 248 zikr"). Ustunlar balandligi davrdagi eng katta kunga nisbatan; bugungi ustun `kok`,
  qolganlari `kokOch`; nol kun 4 px balandlikda. 7 kunda har ustun ostida kun nomi; 30 kunda
  ustunlar ingichka, yozuv har 5-kunda (oy kuni raqami).
- Sahifa aylanadi va kapsula tab bar ostidan o'tadi; oxirgi karta tab bar ostida qolmaydi.
- Ekran ochiq turganda sanagichdagi o'zgarishlar bu yerda ham yangilanadi (bitta manba).

## 3. `12 · Ketma-ketlik` ekrani

- **Kirish.** Statistikadagi Ketma-ketlik kartasidan va Sanagichdagi olov belgisidan.
  Tab bar ustida ochiladi, yopish tugmasi orqaga qaytaradi.
- **Osmon.** Yorug'da Shom, tunda Xufton (oysiz).
- **Qahramon.** `Qahramon/olov`, katta son (`olov` rangida), ostida "kun ketma-ket".
  Streak 0: son "0", yozuv "Bugun birinchi kunni boshlang", olov kulrang (`matn3`).
  Bugun hali hisoblanmagan: son saqlanadi, ostida qo'shimcha "Bugun hali zikr qilmadingiz"
  (`matn2`).
- **Joriy hafta.** 7 ta `KunKapsula` (Du–Ya). Hisoblangan kun: rangli olov va ichida
  streakdagi tartib raqami. Bugun: `olov` chegarali. O'tib ketgan hisoblanmagan kun va
  kelajak: kulrang olov, raqamsiz.
- **Odat kartasi.** Sarlavha "{maqsad} kunlik odat", o'ngda "{streak} / {maqsad} kun",
  shkala va uchta belgi (yetilgani `olov`, qolgani oq).
- **Ikki ko'rsatkich.** "Boshlangan" (sana "17-oktabr" ko'rinishida; yo'q bo'lsa "—") va
  "Eng uzun" ("21 kun"). Oy nomlari ARB'da.
- **Bosqichlar ro'yxati.** 6 ta qator. Yetilgan: `olovOch` fon, belgi ✓. Navbatdagi:
  "{n} kun · yana {k} kun qoldi". Keyingilar: "{n} kun · {nomi}". Nomlar: bir hafta, ikki
  hafta, bir oy, ikki oy, yuz kun, bir yil.
- Sahifa aylanadi.

## 4. Testlar

- **Domen:** jami, aylana, bugun; kunlik qator (bo'sh kunlar bilan); eng ko'p aytilgan
  (o'chirilgan zikr, tenglik); hafta holati; joriy hafta va tartib raqamlari; streak
  boshlangan sana; bosqichlar holati; odat maqsadi chegaralari (29, 30, 99, 100).
- **Widget:** bo'sh baza holati; ma'lumot bilan to'ldirilgan holat; davr almashganda grafik
  va ro'yxat yangilanishi; karta bosilganda Ketma-ketlik ochilishi; streak 0 va
  bugun-hali-hisoblanmagan holatlar.
- Testlarda vaqt mavjud `Soat` interfeysi orqali beriladi.
</vazifa>

<cheklovlar>
- Sozlamalar, eslatmalar, onboarding bu topshiriqqa kirmaydi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma. Oylik va yillik kengaytirilgan
  statistika qurilmaydi.
- Grafik uchun tashqi kutubxona ishlatma, ustunlar oddiy widget'lar bilan chiziladi.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Ishni `feat/statistika` branch'ida qil (`main` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, ikki ekran emulyatorda ikki
rejimda Figma'ga mos, raqamlar sanagichdagi ma'lumot bilan mos keladi.

Yakunda yoz: o'zgargan va yaratilgan fayllar, Figma'dan farq qilgan joylar, o'zing qabul
qilgan qarorlar, ochiq savollar.
</yakun>
