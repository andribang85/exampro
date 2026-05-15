# 📱 PANDUAN UPLOAD KE GITHUB → BUILD APK OTOMATIS
## Dari File ke APK Siap Install — Tanpa Install Apapun!

---

## 🗂️ FILE YANG PERLU DIUPLOAD

Semua ada di folder download kamu. Struktur yang dibutuhkan di GitHub:

```
exampro/                          ← Root repository
│
├── lib/
│   └── main.dart                 ← ✅ File utama (sudah ada)
│
├── android/
│   ├── app/
│   │   ├── build.gradle          ← ✅ Sudah ada
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml   ← ✅ Sudah ada
│   │           ├── kotlin/
│   │           │   └── com/exampro/app/
│   │           │       └── MainActivity.kt  ← ✅ Sudah ada
│   │           └── res/
│   │               ├── drawable/
│   │               │   └── launch_background.xml ← ✅ Sudah ada
│   │               └── values/
│   │                   └── styles.xml    ← ✅ Sudah ada
│   ├── build.gradle              ← ✅ Sudah ada
│   ├── gradle.properties         ← ✅ Sudah ada
│   ├── settings.gradle           ← ✅ Sudah ada
│   └── gradle/
│       └── wrapper/
│           └── gradle-wrapper.properties ← ✅ Sudah ada
│
├── .github/
│   └── workflows/
│       └── build.yml             ← ✅ Sudah ada (otomatis build APK)
│
└── pubspec.yaml                  ← ✅ Sudah ada
```

---

## 📋 LANGKAH 1 — BUAT AKUN GITHUB (Jika Belum Punya)

```
1. Buka: https://github.com
2. Klik "Sign up"
3. Isi: username, email, password
4. Verifikasi email
5. Selesai!
```

---

## 📁 LANGKAH 2 — BUAT REPOSITORY BARU

```
1. Login ke github.com
2. Klik tombol "+" di pojok kanan atas
3. Pilih "New repository"
4. Isi:
   ┌─────────────────────────────────────────┐
   │ Repository name: exampro                │
   │ Description: Aplikasi Ujian Online      │
   │ ○ Public  ← pilih ini (gratis)          │
   │ ☐ Add a README file ← jangan centang   │
   └─────────────────────────────────────────┘
5. Klik "Create repository"
```

---

## ⬆️ LANGKAH 3 — UPLOAD FILE KE GITHUB

### Cara Termudah: Upload Lewat Browser

**3.1 Upload file satu per satu lewat web GitHub:**

```
Di halaman repository yang baru dibuat:
→ Klik "uploading an existing file" atau
→ Klik "Add file" → "Upload files"
```

**3.2 Tapi lebih mudah pakai GitHub Desktop:**

```
Download: https://desktop.github.com
→ Install → Login dengan akun GitHub
→ File → Clone Repository → exampro
→ Pilih folder lokal
→ Copy semua file ke folder tersebut
→ Commit → Push
```

### Cara Manual (tanpa install apapun):

**Buat struktur folder di GitHub web:**

**Step A — Upload `pubspec.yaml`:**
```
Repository → Add file → Create new file
Name: pubspec.yaml
→ Copy-paste isi file pubspec.yaml
→ Klik "Commit new file"
```

**Step B — Upload `lib/main.dart`:**
```
Repository → Add file → Create new file
Name: lib/main.dart   ← ketik dengan slash
→ Copy-paste isi file main.dart
→ Klik "Commit new file"
```

**Step C — Upload `.github/workflows/build.yml`:**
```
Repository → Add file → Create new file
Name: .github/workflows/build.yml
→ Copy-paste isi file build.yml
→ Klik "Commit new file"
```

**Step D — Upload `android/app/build.gradle`:**
```
Name: android/app/build.gradle
→ Copy-paste isinya → Commit
```

**Step E — Upload `android/build.gradle`:**
```
Name: android/build.gradle
→ Copy-paste → Commit
```

**Step F — Upload `android/gradle.properties`:**
```
Name: android/gradle.properties
→ Copy-paste → Commit
```

**Step G — Upload `android/settings.gradle`:**
```
Name: android/settings.gradle
→ Copy-paste → Commit
```

**Step H — Upload `android/gradle/wrapper/gradle-wrapper.properties`:**
```
Name: android/gradle/wrapper/gradle-wrapper.properties
→ Copy-paste → Commit
```

**Step I — Upload `android/app/src/main/AndroidManifest.xml`:**
```
Name: android/app/src/main/AndroidManifest.xml
→ Copy-paste → Commit
```

**Step J — Upload `android/app/src/main/kotlin/com/exampro/app/MainActivity.kt`:**
```
Name: android/app/src/main/kotlin/com/exampro/app/MainActivity.kt
→ Copy-paste → Commit
```

**Step K — Upload `android/app/src/main/res/values/styles.xml`:**
```
Name: android/app/src/main/res/values/styles.xml
→ Copy-paste → Commit
```

**Step L — Upload `android/app/src/main/res/drawable/launch_background.xml`:**
```
Name: android/app/src/main/res/drawable/launch_background.xml
→ Copy-paste → Commit
```

---

## ⚡ LANGKAH 4 — TUNGGU BUILD OTOMATIS

Setelah semua file terupload:

```
1. Buka tab "Actions" di repository GitHub kamu
   (ada di menu atas: Code | Issues | Pull requests | Actions)

2. Kamu akan melihat workflow "🚀 Build ExamPro APK" sedang berjalan
   Status: 🟡 Kuning = sedang proses
           🟢 Hijau  = BERHASIL
           🔴 Merah  = Ada error

3. Waktu build: ± 8-15 menit
   (Pertama kali agak lama, selanjutnya lebih cepat karena ada cache)
```

---

## 📥 LANGKAH 5 — DOWNLOAD APK

```
1. Klik workflow yang sudah ✅ hijau
2. Scroll ke bawah ke bagian "Artifacts"
3. Kamu akan melihat 3 file:

   📦 ExamPro-APK-Universal      ← Pakai ini! (untuk semua HP)
   📦 ExamPro-APK-ARM64-Modern   ← HP modern 2018+ (lebih kecil)
   📦 ExamPro-APK-ARM32-Lama     ← HP lama 32-bit

4. Klik nama artifact → ZIP akan terdownload
5. Extract ZIP → dapatkan file .apk
```

---

## 📲 LANGKAH 6 — INSTALL KE HP

```
1. Transfer file .apk ke HP:
   - WhatsApp ke diri sendiri
   - Google Drive / upload lalu download di HP
   - Kabel USB

2. Di HP Android:
   → Buka file .apk
   → Muncul popup "Install"
   → Jika muncul "Sumber tidak dikenal":
      Pengaturan → Keamanan → Izinkan dari sumber ini ✅
   → Klik Install
   → Selesai! ExamPro sudah terinstall 🎉
```

---

## 🔴 JIKA BUILD GAGAL (ERROR)

### Error paling umum dan solusinya:

**Error 1: "Gradle build failed"**
```
Solusi: Pastikan file android/app/build.gradle sudah terupload
dan isinya persis sama dengan yang diberikan.
```

**Error 2: "Could not find main.dart"**
```
Solusi: Pastikan file ada di lib/main.dart
bukan di main.dart langsung di root.
```

**Error 3: "AndroidManifest not found"**
```
Solusi: Path harus persis:
android/app/src/main/AndroidManifest.xml
```

**Error 4: Build timeout (> 60 menit)**
```
Solusi: Klik "Re-run jobs" di halaman Actions.
GitHub Actions gratis = shared server, kadang antri.
```

**Cara lihat detail error:**
```
Actions → Klik workflow yang merah
→ Klik job "Build Android APK"
→ Expand step yang merah
→ Baca pesan errornya
→ Screenshot dan tanyakan ke Claude
```

---

## 🔄 UPDATE APK (Jika Ada Perubahan Kode)

Setiap kali kamu edit/upload file baru ke GitHub:
```
→ Build otomatis berjalan lagi
→ Tunggu 10 menit
→ Download APK terbaru dari Artifacts
```

---

## 💡 TIPS PENTING

```
✅ Gunakan "ExamPro-APK-Universal" untuk testing awal
✅ Artifacts tersimpan 30 hari, download sebelum kadaluarsa
✅ GitHub Actions gratis 2000 menit/bulan (cukup untuk ~130x build)
✅ Jika akun GitHub baru, Actions mungkin perlu di-enable:
   Settings → Actions → Allow all actions ✅
```

---

## 📞 BUTUH BANTUAN?

Jika ada error saat build, kirimkan:
1. Screenshot halaman Actions yang merah
2. Copy-paste pesan error dari log

Kemudian tanyakan ke Claude untuk solusi!

---

*Panduan ini untuk ExamPro v1.0.0 | GitHub Actions Free Tier*
*© 2026 EduTech Indonesia*
