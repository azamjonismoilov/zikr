# 4-topshiriq: Tasbehot yo'li, to'plam rejimi va tabrik

Claude Code'ga yozing:
`~/Downloads yoki ~/Documents dagi 04-yol-topshiriq.md ni docs/ ga ko'chir, o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Skelet, sanagich, Zikrlar ekrani, zikr tanlash paneli va o'z zikri tayyor. Qoidalar
`CLAUDE.md` da. Dizayn: Figma fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi, ikkala
bo'limdagi `03 · Tasbehot yoʻli` va `07 · Aylana tugadi`. Komponent: `YolTugun`.

Bu topshiriq to'plam bilan sanashni yopadi: namozdan keyingi tasbehot bitta uzluksiz oqim
bo'lib o'tadi. Asosiy talab: sanash paytida foydalanuvchi telefonga qaramasligi mumkin,
shuning uchun qadamlar orasida hech narsa uni to'xtatmaydi.

Figma'dagi yo'lda 4-tugun (Oyatal Kursiy) namuna sifatida chizilgan. Tugunlar ma'lumotdan
yasaladi, hozirgi seed bilan 3 ta bo'ladi.
</kontekst>

<vazifa>
To'plam rejimini, Tasbehot yo'li ekranini va tabrik modalini qur, testlar yoz.

## 1. Ma'lumot modeli

- Yangi jadval `toplam_yurish`: `id`, `toplam_id`, `sana` (boshlangan kun), `qadam` (joriy
  qadam indeksi, 0 dan), `son` (joriy qadamdagi son), `tugadi` (bool), `boshlandi`,
  `yangilandi`. Har to'plam uchun bir vaqtda ko'pi bilan bitta tugallanmagan yurish bo'ladi.
  Tugagan yurishlar saqlanadi (kunlik soni kerak).
- `sozlama` kaliti `joriy_toplam_id` (nullable): bo'sh bo'lmasa, sanagich to'plam rejimida.
- Drift migratsiyasi (sxema v4) va `CLAUDE.md` yangilanadi.

## 2. To'plam rejimi (domen, sof Dart)

Sanagichning ikki rejimi bor: **alohida** (hozirgi xatti-harakat) va **to'plam**.

- **To'plamda bosish.** `yurish.son + 1` va shu qadam zikrining bugungi `sessiya.jami + 1`.
  Alohida rejimning `sessiya.son` qiymati o'zgarmaydi.
- **Qadam maqsadi** to'plam qadamidan olinadi (33, 33, 34), `zikr.maqsad` dan emas.
- **Qadam tugashi.** `yurish.son` qadam maqsadiga yetganda: shu zikrning `sessiya.aylanalar + 1`,
  `yurish.son = 0`, `yurish.qadam + 1`, kuchli haptik. Sanagich darhol keyingi qadam zikrini
  ko'rsatadi. Hech qanday oyna chiqmaydi.
- **To'plam tugashi.** Oxirgi qadam tugaganda `yurish.tugadi = true`, tabrik modali chiqadi
  (4-band). Modal yopilgach `joriy_toplam_id` bo'shatiladi va sanagich alohida rejimga,
  to'plamning birinchi zikriga qaytadi.
- **Qadamni o'tkazib yuborish.** `yurish.qadam + 1`, `yurish.son = 0`, sessiyaga aylana
  qo'shilmaydi. Oxirgi qadamda o'tkazib yuborish yurishni tugallanmagan holda yopadi
  (qator o'chiriladi), modal chiqmaydi.
- **Nollash.** Joriy qadamni nolga qaytaradi: `sessiya.jami -= yurish.son`, `yurish.son = 0`.
- **Rejimdan chiqish.** Zikr tanlash panelidan istalgan zikr tanlansa yoki Zikrlar ekranida
  karta bosilsa, `joriy_toplam_id` bo'shatiladi. Yurish saqlanib qoladi va yo'ldan
  davom ettirish mumkin.
- **Yarim tun.** Yurish uzilmaydi; bosishlar yangi kunning sessiya qatoriga yoziladi.
- Kun hisobi va streak qoidalari o'zgarmaydi.

## 3. Sanagich ekrani (to'plam rejimida)

- Zikr bloki joriy qadam zikrini ko'rsatadi.
- Markaziy tugmadagi teg: "{qadam} / {jami}" (masalan "2 / 3"). Son va "/ maqsad" qadamga
  tegishli. Halqa `yurish.son / qadam maqsadi`.
- Maqsad qatori ko'rsatilmaydi.
- Pastki qator: nollash tugmasi va "Keyingisi: {keyingi zikr}" tugmasi (qadamni o'tkazib
  yuboradi). Oxirgi qadamda yozuvi "Tugatish".
- **Alohida rejimda "Keyingisi" tugmasi endi umuman ko'rsatilmaydi**; nollash maqsad qatorida
  turadi (hozirgi "to'plamda bo'lmagan zikr" ko'rinishi barcha zikrlarga tegishli bo'ladi).

## 4. Aylana tugashi va tabrik modali

Modal faqat mazmunli paytda chiqadi, har aylanada emas.

- **Oddiy aylana tugashi (alohida rejim).** Modal yo'q. Kuchli haptik, halqa to'lib qisqa
  yonadi (taxminan 600 ms) va nolga qaytadi, teg raqami kichik masshtab animatsiyasi bilan
  yangilanadi.
- **Modal chiqadigan ikki holat:**
  1. **To'plam tugadi.**
  2. **Bugungi kun hisobga olindi:** alohida rejimda aylana tugashi yoki bosish natijasida
     bugun birinchi marta "kun hisoblanadi" sharti bajarildi (streak bir kunga oshdi).
     To'plam ichida bu holat yuz bersa, modal to'plam oxirigacha kechiktiriladi.
- **Ko'rinishi** (`07 · Aylana tugadi` bilan 1:1): sanagich ustida xira qoplama, karta,
  tepasida osmon (yorug'da Peshin, tunda Xufton), katta `Rasm/tasbeh`, uchqunlar, yashil belgi,
  sarlavha, izoh, dalda qatori, asosiy va ikkinchi tugma. Kuchli haptik. Fonga bosish yopadi.
- **Matnlar** (hammasi ARB'da, parametrli):

  | | To'plam tugadi | Kun hisobga olindi |
  | --- | --- | --- |
  | Belgi | "{jami} / {jami}" (masalan "100 / 100") | "{maqsad} / {maqsad}" |
  | Arabcha matn | ko'rsatilmaydi | joriy zikrniki |
  | Sarlavha | "Tasbehot tugadi" | "Aylana tugadi" |
  | Izoh | "Bugun {n}-marta" | "{zikr nomi} · {maqsad} marta" |
  | Asosiy tugma | "Tayyor" | "Davom etish" |
  | Ikkinchi tugma | "Yana bir marta" (yangi yurish boshlaydi) | "Boshqa zikr tanlash" (panelni ochadi) |

- **Dalda qatori:** shu modal bilan streak oshgan bo'lsa "{n} kun ketma-ket. Davom eting!";
  aks holda qator ko'rsatilmaydi.

## 5. `03 · Tasbehot yoʻli` ekrani

- **Kirish.** Zikrlar ekranida "Namozdan keyin" bo'limi sarlavhasini bosish (yig'ish tugmasidan
  tashqari joyi) yo'lni ochadi. Yig'ish tugmasi avvalgidek bo'limni yig'adi.
- **Sarlavha qatori.** Yopish tugmasi; o'ngda "{tugagan qadamlar} / {jami qadamlar}" belgisi.
  Sarlavha: to'plam nomi.
- **Bosqich kartasi.** Rasm (namoz), kichik yozuv "Bugun {n}-marta" (n: bugun tugagan
  yurishlar + 1), sarlavha "Tasbehot · {jami} zikr", halqa: tugagan qadamlar soni va ulushi.
- **Yo'l.** Tugunlar to'plam qadamlaridan: bajarilgan, joriy, yangi (`YolTugun`). Joylashuvi
  Figma'dagi zigzag tartibida takrorlanadi. Yozuvlar: "{nomi} · {maqsad}", joriy qadamda
  "{nomi} · {son}/{maqsad}". Tugallanmagan yurish bo'lmasa, birinchi tugun joriy.
- **Maslahat kartasi.** Matni ARB'da (Figma'dagi matn). "Batafsil" havolasi ko'rsatilmaydi.
- **Pastki tugma.** Yurish yo'q bo'lsa "Boshlash", tugallanmagan yurish bo'lsa "Davom etish".
  Bosilganda `joriy_toplam_id` o'rnatiladi va Sanagich joriy qadamda ochiladi. Joriy tugunni
  bosish ham shuni qiladi. Boshqa tugunlar bosilmaydi.
- Fon doiralari Figma'dagidek.

## 6. Testlar

- **Domen:** qadam tugashi va avtomatik o'tish; to'plam tugashi; o'tkazib yuborish (o'rtada
  va oxirgi qadamda); nollash; rejimdan chiqib qayta davom ettirish; alohida `son`
  o'zgarmasligi; yarim tun; modal shartlari (oddiy aylana, kun hisobga olinishi, to'plam
  ichida kechiktirish).
- **Saqlash:** yurish qayta ochilganda tiklanadi; bir to'plamga bitta tugallanmagan yurish;
  migratsiya v3 → v4.
- **Widget:** yo'ldan boshlash Sanagichni to'plam rejimida ochadi; 33 ta bosishdan keyin
  zikr o'zi almashadi va oyna chiqmaydi; oxirgi qadamdan keyin modal chiqadi; "Yana bir
  marta" yangi yurish boshlaydi; alohida rejimda oddiy aylana modal chiqarmaydi.
</vazifa>

<cheklovlar>
- Statistika, Ketma-ketlik va Sozlamalar ekranlari, eslatmalar, tovush bu topshiriqqa kirmaydi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma.
- Zikr matnlari faqat bazadan olinadi.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Yangi paket kerak bo'lsa, sababini bir jumlada yoz.
- Ishni `feat/yol` branch'ida qil (`main` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, emulyatorda tasbehot
boshidan oxirigacha uzluksiz o'tadi, yo'l ekrani va modal ikki rejimda Figma'ga mos.

Yakunda yoz: o'zgargan va yaratilgan fayllar, Figma'dan farq qilgan joylar, o'zing qabul
qilgan qarorlar, ochiq savollar.
</yakun>
