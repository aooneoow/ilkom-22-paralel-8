# Aplikasi Media Sosial Microservices

## Deskripsi Proyek
Proyek ini adalah aplikasi media sosial berbasis microservices yang dikembangkan menggunakan Ruby. Aplikasi terdiri dari beberapa layanan independen yang berkomunikasi untuk memberikan fungsionalitas lengkap.

## Layanan
1. **Post Service**: Mengelola pembuatan, pembacaan, pembaruan, dan penghapusan postingan.
2. **Comment Service**: Menangani fungsionalitas komentar pada postingan.
3. **Like Service**: Mengatur sistem like/unlike pada postingan.
4. **Notification Service**: Mengelola notifikasi untuk berbagai aktivitas dalam aplikasi.

## Prasyarat
- Ruby 3.0+
- Bundler
- SQLite3

## Instalasi
1. Clone repository
2. Masuk ke setiap direktori layanan
3. Jalankan `bundle install` untuk menginstal dependensi

## Menjalankan Aplikasi
Untuk menjalankan setiap layanan:
```bash
cd post_service
bundle exec rackup
```

Ulangi untuk setiap layanan.

## Arsitektur
Proyek ini menggunakan arsitektur microservices dengan pembagian tanggung jawab:
- Setiap layanan memiliki database SQLite3 sendiri
- Komunikasi antar layanan dilakukan melalui API REST
- Setiap layanan memiliki kontroler, model, dan service sendiri

## Kontribusi
1. Fork repository
2. Buat branch fitur (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -m 'Menambahkan fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

## Lisensi
[Tentukan Lisensi Anda]