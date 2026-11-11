# 6-topshiriq: Sozlamalar, eslatma, zaxira

Claude Code'ga yozing:
`~/Downloads yoki ~/Documents dagi 06-sozlamalar-topshiriq.md ni docs/ ga ko'chir, o'qi va undagi topshiriqni to'liq bajar.`
Effort: `medium` dan boshlang.

---

<kontekst>
Sanagich, Zikrlar, Tasbehot yo'li, Statistika va Ketma-ketlik tayyor. Qoidalar `CLAUDE.md`
da. Dizayn: Figma fayl `tzJanNy81VnQGnhdcMZ6dd`, "Ekranlar" sahifasi, ikkala bo'limdagi
`05 · Sozlamalar`. Qatorlar rangli ikonka plitkasi, nomi va o'ngda toggle yoki qiymat bilan
(ikonka chizig'i 1.5 px).

Bu topshiriq Sozlamalar ekranini va uning ortidagi barcha funksiyalarni yopadi. Figma'dagi
tepadagi profil kartasi akkauntga tegishli, hozir ko'rsatilmaydi. Figma'da yo'q, lekin kerak
bo'lgan bir necha qator qo'shiladi; ular mavjud qator uslubida quriladi.
</kontekst>

<vazifa>
Sozlamalar ekranini qur va har bir sozlamani oxirigacha ishlaydigan qil.

## 1. Ekran tuzilishi

Yorug'da Shom osmoni, tunda Xufton. Sahifa aylanadi va kapsula tab bar ostidan o'tadi.

| Guruh | Qator | O'ng tomoni | Ikonka plitkasi |
| --- | --- | --- | --- |
| SANASH | Tebranish | toggle | kok |
| | Bosish tovushi | toggle | binafsha |
| | Ovoz tugmalari bilan sanash (faqat Android) | toggle | yashil |
| | Ekran oʻchmasin | toggle | sariq |
| | Kunlik maqsad | qiymat ("100") | olov |
| ILOVA | Mavzu | qiymat ("Tizim") | kokChuqur |
| | Kunlik eslatma | qiymat ("05:30" yoki "Oʻchiq") | sariq |
| MAʼLUMOTLAR | Zaxira nusxa olish | › | kok |
| | Zaxiradan tiklash | › | yashil |
| | Hisobni nollash (qizil matn) | › | qizil |

Ostida maxfiylik izohi (qalqon ikonkasi, Figma'dagi matn) va ilova versiyasi ("Zikr 1.0.0").
"Til" qatori hozircha ko'rsatilmaydi (bitta til bor). Yangi qatorlar uchun ikonkalar Figma
"Komponentlar" sahifasidagi `icon/...` to'plamidan olinadi.

## 2. Sanash sozlamalari

- **Tebranish.** Mavjud `haptik` sozlamasi; sanagichdagi tugma bilan bir xil manba.
- **Bosish tovushi** (`tovush`, standart: o'chiq). Har bosishda `SystemSound.play(SystemSoundType.click)`.
- **Ovoz tugmalari bilan sanash** (`ovoz_tugmasi`, standart: o'chiq, faqat Android). Yoqilgan
  va Sanagich ekrani ochiq bo'lganda ovoz balandligi tugmalari (ikkalasi ham) bosishni
  sanaydi va tizim ovoz balandligini o'zgartirmaydi. Boshqa ekranlarda va sozlama o'chiq
  bo'lganda tugmalar odatdagidek ishlaydi. Native qism `MainActivity` da, Flutter bilan
  kanal orqali. iOS'da qator ko'rsatilmaydi.
- **Ekran oʻchmasin** (`ekran_yoniq`, standart: yoqilgan). Sanagich ekrani ochiq va oxirgi
  bosishdan 2 daqiqa o'tmagan bo'lsa, ekran o'chmaydi. 2 daqiqa bosilmasa yoki boshqa ekranga
  o'tilsa, odatdagi holatga qaytadi.
- **Kunlik maqsad** (`kunlik_maqsad`). Sanagichdagi "Maxsus" panelini ishlatadi (1–10 000),
  tayyor variantlar: 100, 300, 1 000.

## 3. Mavzu

`mavzu` sozlamasi: Tizim (standart), Yorugʻ, Tun. Pastki panelda uch variant, tanlangach
darhol qo'llanadi.

## 4. Kunlik eslatma

- Pastki panel: yoqish toggle'i va vaqt tanlash (tizim vaqt tanlagichi). Standart vaqt 21:00.
  Sozlamalar: `eslatma_yoniq`, `eslatma_vaqti`.
- Har kuni tanlangan vaqtda mahalliy bildirishnoma. Aniq signal ruxsati talab qilinmasin
  (noaniq rejim yetarli). Qurilma qayta yoqilganda ham saqlanadi.
- Matn: sarlavha "Zikr vaqti". Mazmuni ilova har ochilganda qayta rejalashtirilib yangilanadi:
  streak 1 dan katta bo'lsa "{n} kunlik ketma-ketlikni davom ettiring", aks holda "Bugungi
  zikringizni unutmang".
- Bugun kun allaqachon hisoblangan bo'lsa, bugungi bildirishnoma ko'rsatilmaydi (ilova
  ochilganda bugungisi bekor qilinib, ertadan rejalashtiriladi).
- Ruxsat faqat foydalanuvchi eslatmani yoqqanda so'raladi. Rad etilsa: toggle o'chiq qoladi
  va panelda "Bildirishnomaga ruxsat berilmagan" yozuvi hamda tizim sozlamalarini ochadigan
  tugma ko'rinadi.
- Bildirishnoma bosilganda ilova Sanagichda ochiladi.

## 5. Zaxira

- **Zaxira nusxa olish.** Barcha ma'lumot bitta JSON faylga yoziladi: o'z zikrlari va zikr
  maqsadlari, sessiyalar, yurishlar, sozlamalar. Fayl nomi `zikr-zaxira-2026-11-11.json`
  ko'rinishida, ichida format versiyasi va sxema versiyasi bor. Tizimning ulashish oynasi
  orqali beriladi (Telegram, Drive, Fayllar).
- **Zaxiradan tiklash.** Fayl tanlanadi, format tekshiriladi, tasdiq so'raladi ("Hozirgi
  maʼlumot zaxiradagi bilan almashtiriladi"), almashtirish bitta tranzaksiyada. Noto'g'ri
  yoki buzuq faylda ma'lumot o'zgarmaydi va tushunarli xabar chiqadi. Eski sxema
  versiyasidagi zaxira ham tiklanadi.
- **Android avtomatik zaxirasi** yoqilgan bo'lsin va baza fayli unga kirsin.

## 6. Hisobni nollash

Ikki bosqichli tasdiq. Birinchi dialogda "Avval zaxira olish" tugmasi ham bor. Tasdiqlansa
barcha sessiyalar va yurishlar o'chadi; zikrlar (o'z zikrlari ham) va sozlamalar qoladi.

## 7. Testlar

- **Domen va saqlash:** zaxira → tiklash aylanasi (ma'lumot aynan tiklanadi); buzuq fayl;
  eski sxemadagi zaxira; nollash nimani o'chirib nimani qoldirishi; eslatma matni tanlovi va
  "bugun hisoblangan" holati.
- **Widget:** har toggle sozlamani saqlaydi va qayta ochilganda tiklanadi; mavzu almashishi;
  kunlik maqsad o'zgarishi kun hisobiga ta'sir qilishi; nollashning ikki bosqichli tasdig'i;
  ruxsat rad etilgan holat.
- Platformaga bog'liq qismlar (bildirishnoma, ovoz tugmasi, ekran yoniqligi, ulashish) interfeys
  ortiga olinadi va testlarda soxta nusxa bilan almashtiriladi.
</vazifa>

<cheklovlar>
- Akkaunt, profil kartasi, sinxronlash, onboarding bu topshiriqqa kirmaydi.
- `CLAUDE.md` dagi "Hozir qurilmaydigan qismlar" ga tegma.
- Yangi paketlar kutiladi (bildirishnoma uchun vaqt zonasi, ulashish, fayl tanlash, ekran
  yoniqligi). Har birini nima uchun tanlaganingni bir jumlada yoz va `CLAUDE.md` stack
  ro'yxatiga qo'sh.
- So'ralgan narsani so'ralgan hajmda bajar. Oddiy qarorlarni o'zing qabul qil; faqat turli
  talqinlar tubdan boshqa natijaga olib borsa so'ra.
- Ishni `feat/sozlamalar` branch'ida qil (`main` dan ochiladi).
</cheklovlar>

<yakun>
Tayyor holat: `flutter analyze` xatosiz, `flutter test` o'tadi, Sozlamalar ekrani emulyatorda
ikki rejimda Figma uslubiga mos, har bir sozlama ishlaydi.

Yakunda yoz: o'zgargan va yaratilgan fayllar, qo'shilgan paketlar va sababi, Figma'dan farq
qilgan joylar, o'zing qabul qilgan qarorlar, emulyatorda tekshirib bo'lmagan narsalar
(haqiqiy qurilmada sinash kerak bo'lganlar), ochiq savollar.
</yakun>
