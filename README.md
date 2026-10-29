# PetCare — MVVM dengan JSON lokal

Proyek Flutter/Dart untuk katalog panduan perawatan dasar hewan. Versi ini membaca delapan panduan dari **assets/data/guides.json**, menggantikan objek data yang sebelumnya ditulis langsung dalam Dart. Desain Beranda, Panduan, dan Detail mengikuti revisi terakhir. Halaman Tentang PetCare ditambahkan melalui tab Tentang di navigasi bawah.

## Struktur

```text
lib/
├── main.dart
├── model/care_guide.dart
├── data/guide_repository.dart
├── viewmodel/guide_viewmodel.dart
└── view/
    ├── about_page.dart
    ├── home_page.dart
    ├── guide_pages.dart
    └── widgets.dart
assets/
├── data/guides.json
└── images/
```

Ada delapan file Dart utama; about_page.dart berisi halaman tambahan yang bersifat informatif. Model menyimpan bentuk panduan. Folder Data berisi pembaca JSON, sementara isi katalog berada di aset JSON. ViewModel mengatur proses memuat, kegagalan, pencarian, filter, dan tab. View mengatur tampilan, controller teks, serta Navigator.push/pop.

Alurnya: rootBundle.loadString → jsonDecode → GuideCatalog.fromJson → CareGuide.fromJson → GuideViewModel → View. Katalog dibaca ketika shell dibuat dan disimpan di memori; mengetik pencarian tidak membaca file berulang kali. Saat gagal memuat, aplikasi menampilkan pesan dan tombol Coba lagi.

## Membuka proyek

Ekstrak ZIP, pilih Open pada Android Studio, dan buka folder **petcare-json** yang berisi pubspec.yaml.

```sh
flutter pub get
flutter run
```

Implementasi diperiksa dengan Flutter 3.35.3 / Dart 3.9.2. Tidak ada dependency runtime tambahan. Android dan web memiliki konfigurasi proyek; APK belum dihasilkan pada sesi ini karena kendala SDK/NDK lingkungan sebelumnya.

## Mengubah atau menambah panduan

1. Buka assets/data/guides.json.
2. Ubah objek di array guides, atau salin satu objek dengan ID baru yang unik.
3. Isi id, petType, category, title, summary, imagePath, materials, steps, note, dan readingMinutes. ReadingMinutes dapat dihilangkan untuk memakai nilai bawaan 4.
4. PetType dan category harus tercantum pada petTypes dan categories. Gunakan JSON yang valid: tanda kutip ganda dan tanpa koma terakhir sebelum penutup array/objek.
5. Jika gambar baru dipakai, letakkan berkasnya di assets/images dan sesuaikan imagePath.
6. FeaturedGuideId dan popularGuideIds harus menunjuk ID panduan yang tersedia.
7. Jalankan ulang aplikasi untuk memuat perubahan aset.

JSON ini dibundel bersama aplikasi. Perubahan tidak otomatis masuk ke aplikasi yang sudah terpasang; distribusikan build baru untuk memperbarui aset pada perangkat. Aplikasi tetap bekerja tanpa server/API dan tanpa internet.

## Pemeriksaan

- Analisis Dart: bersih.
- 13 pengujian utama: isi JSON dan model, penolakan data rusak/ID duplikat, filter dan pencarian, kegagalan lalu percobaan ulang, dispose saat memuat, navigasi daftar/detail, ukuran layar 320/600 dengan teks besar, serta tab Tentang, filter yang tetap tersimpan, dan tombol kembali sistem.
- Gambar dokumentasi dari renderer Flutter tersedia di docs/screenshots; bukan bukti pengujian pada perangkat Android.

```sh
dart analyze
flutter test
flutter test tool/capture_screens_test.dart
```

## Naskah dan usulan pengembangan

NASKAH_VIDEO.md berisi urutan rekaman, potongan kode, dan narasi, termasuk pembacaan JSON dan halaman Tentang. Tentang merupakan StatelessWidget dengan ListView, tujuan aplikasi, cara penggunaan, informasi offline, dan versi. Tab Tentang memakai indeks 2; Beranda indeks 0 dan Panduan indeks 1. Halaman ini tidak memerlukan dependency tambahan.

Referensi visual berasal dari gambar tugas. Foto hewan dibuat dengan bantuan imagegen; ikon memakai Material Icons. Rincian aset ada di docs/ASET.md.
