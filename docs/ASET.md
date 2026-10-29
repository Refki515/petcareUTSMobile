# Catatan aset PetCare

Semua gambar dimuat melalui `Image.asset` dan didaftarkan di `pubspec.yaml`. Tidak ada URL gambar pada aplikasi.

| Berkas | Sumber | Penggunaan |
| --- | --- | --- |
| `assets/images/cat.jpg` | Dibuat dengan built-in imagegen pada sesi mockup PetCare | Kategori dan panduan kucing. |
| `assets/images/dog.jpg` | Dibuat dengan built-in imagegen pada sesi implementasi | Kategori dan panduan anjing. |
| `assets/images/rabbit.jpg` | Dibuat dengan built-in imagegen pada sesi implementasi | Kategori dan panduan kelinci. |
| `assets/images/bird.jpg` | Dibuat dengan built-in imagegen pada sesi implementasi | Kategori dan panduan burung. |
| Ikon launcher Android/web | Digambar lokal sebagai paw gelap pada latar oranye keemasan | Identitas aplikasi. |
| Ikon antarmuka | `Icons` dari Flutter Material | Navigasi dan kontrol. |

Foto hasil generasi dikonversi menjadi JPG lokal untuk mengurangi ukuran aset. Foto Dribbble tidak diunduh atau digunakan.

## Prompt final kucing

```text
Use case: photorealistic-natural. Asset type: hero photograph for PetCare Indonesian pet care mobile UI mockup. Primary request: a beautiful friendly fluffy ginger tabby cat with warm amber eyes sitting, three-quarter body portrait, looking at camera. Scene: seamless matte pale warm apricot studio background. Composition: vertical portrait 4:5; cat occupies center-right, ears fully visible with clear space above, fluffy paws and chest fully visible at bottom, no props. Soft natural window lighting, editorial pet photography, realistic fur, warm and clean. No text, letters, logos, UI, frames, watermarks. Generate just the pet photograph.
```

## Prompt final anjing, kelinci, dan burung

Prompt lengkap mengikuti pola berikut, dengan subjek sesuai daftar di bawahnya:

```text
Use case: photorealistic-natural. Asset type: local pet photograph for PetCare Android app. Generate a realistic editorial studio portrait of {subject}. Vertical 4:5 portrait, full animal fully visible with generous breathing space above head, centered, softly lit natural fur or feather detail, clean warm and calm aesthetic. No text, UI, borders, watermarks or logos.
```

- Anjing: `a friendly golden retriever sitting, looking at camera, soft muted olive cream studio background`
- Kelinci: `a small beige lop-eared rabbit sitting, looking at camera, soft warm taupe studio background`
- Burung: `a small green and yellow budgerigar perched on a natural wooden branch, looking at camera, soft muted sage studio background`

## Inspirasi visual

Sheikh Elias, "Pet care mobile app - UI design concept", Dribbble:
https://dribbble.com/shots/26324428-Pet-care-mobile-app-UI-design-concept

Adaptasi proyek memakai katalog panduan perawatan, Bahasa Indonesia, dua tab utama, radius kartu 10-14 px dengan pill kategori dan navigasi yang lebih bulat sesuai revisi referensi, dan komposisi sendiri berdasarkan masukan pengguna. Referensi bukan klaim desain asli proyek ini.
