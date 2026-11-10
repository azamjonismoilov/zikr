# 3-topshiriq: Zikrlar ekrani, zikr tanlash paneli va o'z zikri

Claude Code'ga yozing:
`~/Downloads yoki ~/Documents dagi 03-zikrlar-topshiriq.md ni docs/ ga ko'chir, o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Skelet va sanagich tayyor: sanash mantiqi, saqlash, kun va streak hisobi ishlayapti.
Qoidalar `CLAUDE.md` da. Dizayn: Figma fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi,
ikkala bo'limdagi `02 · Zikrlar`, `06 · Zikr tanlash` va `08 · Oʻz zikringiz` ekranlari.
Komponentlar: `DarsKarta`, `IjroTugma`, `TanlashQator`, `Maydon`, `Rasm/...`.

Interfeys matnlari va o'lchamlar Figma'dan olinadi. Zikr matnlari (nomi, arabcha, ma'nosi)
faqat bazadan olinadi: Figma'dagi zikr matnlari joy uchun qisqartirilgan namunalar.

Bu topshiriq zikrlar bilan ishlashni yopadi: ro'yxat, tanlash va o'z zikrini qo'shish.
Tasbehot yo'li, tabrik modali, statistika va sozlamalar keyingi topshiriqlarda.
</kontekst>

<vazifa>
Uchta ekranni Figma bilan 1:1 qur, ularni sanagich bilan bog'la va testlar yoz.

## 1. Ma'lumot modeli

- `zikr` jadvaliga `ochirilgan` (bool, standart false) ustunini qo'sh. O'chirilgan zikr
  ro'yxatlarda ko'rinmaydi, lekin uning `sessiya` qatorlari saqlanadi (statistika buzilmasin).
- Turkumlar: `namozdan_keyin`, `kun_davomida`, `ertalabki`, `kechki`. Foydalanuvchining o'z
  zikrlari turkumdan qat'i nazar "Mening zikrlarim" bo'limida ko'rsatiladi (`oz_zikri = true`).
- Turkum nomi va rasmi bitta joyda belgilanadi:

  | Turkum | Nomi | Rasm |
  | --- | --- | --- |
  | namozdan_keyin | Namozdan keyin | namoz |
  | kun_davomida | Kun davomida | tasbeh |
  | ertalabki | Ertalabki | tong |
  | kechki | Kechki | tun |
  | (o'z zikrlari) | Mening | yurak |

- Drift migratsiyasi (sxema v3) va `CLAUDE.md` jadvalini yangila.

## 2. Zikr holati (bugun uchun, domen qatlamida)

- **Bajarildi:** shu zikr bo'yicha bugun kamida 1 aylana tugagan.
- **Jarayonda:** bugun `son > 0`, lekin aylana tugamagan. Progress `son / maqsad`,
  yozuvi "12/34". Maqsad ∞ bo'lsa progress chizig'i yo'q, faqat son.
- **Yangi:** qolgan hollar.

## 3. `02 · Zikrlar` ekrani

- **Sarlavha qatori.** "Zikrlar", streak belgisi (sanagichdagi bilan bir xil manba),
  qidiruv tugmasi. Qidiruv tugmasi zikr tanlash panelini (06) qidiruv maydoni faol holda ochadi.
- **Turkumlar kartasi.** Tablar ma'lumotdan yasaladi: ichida zikri bor turkumlar va har doim
  "Mening". Hozirgi seed bilan: Namozdan keyin, Kun davomida, Mening. Tab bosilganda sahifa
  o'sha bo'limga silliq aylanadi; sahifa aylantirilganda faol tab ko'rinib turgan bo'limga
  ergashadi. Tablar sig'masa, karta ichida gorizontal aylanadi.
- **Bo'limlar.** Har turkum bitta bo'lim: rasm, nomi, izoh ("Har farz namozidan soʻng · 3 ta
  zikr" kabi; izoh matni ARB'da, soni ma'lumotdan), yig'ish tugmasi (bo'limni yopadi va ochadi).
  Bo'lim ichida `DarsKarta` ro'yxati, holati 2-banddan.
- **Bog'lovchi chiziq.** Faqat to'plamga kiruvchi bo'limda (Namozdan keyin) kartalar
  vertikal chiziq bilan bog'lanadi. Bajarilgan qadamlar orasida chiziq `yashil`, qolganida `chiziq`.
- **Karta bosilganda** shu zikr joriy zikr bo'ladi va Sanagich bo'limi ochiladi.
- **"Mening" bo'limi.** O'z zikrlari yo'q bo'lsa: bo'sh holat ("Oʻz zikringiz hali yoʻq")
  va "Oʻz zikringizni qoʻshish" tugmasi (06 panelidagi tugma uslubida). Bor bo'lsa: kartalar va
  ostida shu tugma. Kartani uzoq bosish tahrirlash ekranini ochadi.
- Kontent aylanadi va kapsula tab bar ostidan o'tadi; oxirgi karta tab bar ostida qolib
  ketmasligi uchun pastda yetarli bo'sh joy bo'lsin.

## 4. `06 · Zikr tanlash` paneli

- Sanagichdagi nom qatori ("SubhanAllah ▾") bosilganda ochiladi. Shu qatorni bosish endi
  sanamaydi.
- Pastdan chiquvchi panel, orqasi xiralashadi; tutqich, "Zikrni tanlang", yopish tugmasi.
  Panelni pastga tortib yoki fonga bosib yopish mumkin.
- **Qidiruv.** Nomi, talaffuzi va ma'nosi bo'yicha, yozilishi bilanoq filtrlaydi.
  Katta-kichik harf farqlanmaydi; `ʻ`, `'`, `` ` `` va `ʼ` bir xil hisoblanadi
  ("astagfirulloh" va "astag'firulloh" ham "Astagʻfirulloh" ni topadi).
  Hech narsa topilmasa: "Hech narsa topilmadi" va "Oʻz zikringizni qoʻshish" tugmasi.
- **Chiplar.** "Hammasi", keyin ichida zikri bor turkumlar va "Mening".
- **Ro'yxat.** `TanlashQator`: rasm, nomi, ma'nosi, arabcha matn, tanlov belgisi. Joriy zikr
  tanlangan holatda. Uzun matnlar bir qatorda qisqartiriladi. Ro'yxat panel ichida aylanadi.
- **Tanlash.** Qator bosilganda joriy zikr almashadi va panel yopiladi. Har zikrning
  tugallanmagan soni o'zida saqlanadi: boshqa zikrga o'tib qaytganda son joyida turadi.
- **"Oʻz zikringizni qoʻshish"** tugmasi 08 ekranini ochadi.

## 5. `08 · Oʻz zikringiz` ekrani

- To'liq ekran: yopish tugmasi, "Yangi zikr", tepada "Saqlash" va pastda "Saqlash" tugmasi.
- **Rasm tanlovi.** 7 ta plitka (tasbeh, yurak, yulduz, namoz, tun, tong, kitob), tanlangani
  `kok` halqa bilan. Standart: yurak.
- **Maydonlar** (`Maydon` komponenti, faol holati bilan):
  - "Talaffuzi": majburiy, 1–40 belgi. `zikr.nomi` ga yoziladi.
  - "Arabcha matn (ixtiyoriy)": Amiri shrifti, o'ngdan chapga.
  - "Maʼnosi": ixtiyoriy, 80 belgigacha.
- **Maqsad.** 33, 99, 100, Maxsus. "Maxsus" sanagichdagi panelni ishlatadi (1–10 000).
- **Eslatma kartasi** bu topshiriqda ko'rsatilmaydi (eslatmalar Sozlamalar topshirig'ida).
- **Saqlash.** Majburiy maydon bo'sh bo'lsa tugmalar nofaol. Saqlangach zikr `oz_zikri = true`
  bilan yoziladi, joriy zikr bo'ladi va Sanagich ochiladi.
- **Tahrirlash.** Xuddi shu ekran, sarlavha "Zikrni tahrirlash", maydonlar to'ldirilgan,
  pastda qo'shimcha "Oʻchirish" (`qizil` matnli) tugmasi. O'chirish tasdiq dialogi bilan,
  `ochirilgan = true` qiladi. O'chirilgan zikr joriy bo'lsa, joriy zikr SubhanAllah'ga qaytadi.
- Yopish tugmasi: maydonlarga biror narsa yozilgan bo'lsa tasdiq so'raydi.

## 6. Testlar

- **Domen:** zikr holati (uch holat, ∞ maqsad); qidiruvdagi apostrof va harf
  normalizatsiyasi.
- **Saqlash:** o'z zikrini qo'shish, tahrirlash, o'chirish; o'chirilgan zikrning sessiyalari
  qoladi; migratsiya v2 → v3.
- **Widget:** karta bosilganda joriy zikr almashib Sanagich ochiladi; panelda qidiruv
  filtrlaydi; zikr almashganda tugallanmagan son saqlanadi; majburiy maydon bo'sh bo'lsa
  saqlash nofaol; bo'sh "Mening" holati.
</vazifa>

<cheklovlar>
- Tasbehot yo'li ekrani, tabrik modali, Statistika, Sozlamalar, eslatmalar bu topshiriqqa
  kirmaydi. "Namozdan keyin" bo'limi sarlavhasini bosish hozircha faqat yig'adi va ochadi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma.
- Zikr matnlarini Figma'dan ko'chirma, faqat bazadan ol.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Yangi paket kerak bo'lsa, sababini bir jumlada yoz.
- Ishni `feat/zikrlar` branch'ida qil (`main` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, uch ekran emulyatorda ikki
rejimda Figma'ga mos, zikr tanlash va o'z zikrini qo'shish sanagich bilan birga ishlaydi.

Yakunda yoz: o'zgargan va yaratilgan fayllar, Figma'dan farq qilgan joylar, o'zing qabul
qilgan qarorlar, ochiq savollar.
</yakun>
