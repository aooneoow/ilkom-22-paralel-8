# Social Media Microservices Application

## Deskripsi Proyek
Proyek ini adalah aplikasi media sosial sederhana yang menggunakan arsitektur microservices. Aplikasi ini dibangun menggunakan Sinatra sebagai framework utama untuk layanan-layanan berikut:

1. **Post Service**: Mengelola postingan pengguna.
2. **Comment Service**: Mengelola komentar pada postingan.
3. **Like Service**: Mengelola jumlah like pada postingan.
4. **Notification Service**: Mengelola notifikasi untuk pengguna.

## Fitur Utama
- **Post Service**: Menandai postingan sebagai selesai dan mengambil data terkait seperti komentar dan likes.
- **Comment Service**: Mengambil komentar yang relevan untuk postingan tertentu.
- **Like Service**: Menghitung jumlah likes untuk postingan tertentu.
- **Notification Service**: Mengirim notifikasi terkait aktivitas postingan.

## Teknologi yang Digunakan
- **Bahasa Pemrograman**: Ruby
- **Framework**: Sinatra
- **Database**: SQLite3
- **Pengujian**: Apache JMeter
- **Dependency Management**: Bundler

## Cara Menjalankan Aplikasi
1. **Persiapan Lingkungan**:
   - Pastikan Ruby sudah terinstal di sistem Anda.
   - Instal dependensi proyek dengan menjalankan:
     ```bash
     bundle install
     ```

2. **Menjalankan Layanan**:
   - Jalankan setiap layanan di port yang ditentukan:
     - Post Service: `http://localhost:4567`
     - Comment Service: `http://localhost:4568`
     - Like Service: `http://localhost:4569`
     - Notification Service: `http://localhost:4570`
   - Gunakan perintah berikut untuk menjalankan layanan, misalnya untuk Post Service:
     ```bash
     ruby post_service.rb
     ```

3. **Pengujian API**:
   - Gunakan cURL untuk mengakses endpoint, contohnya:
     ```bash
     curl -X GET http://localhost:4567/posts/1/complete
     ```
   - Alternatif: Gunakan Postman untuk pengujian manual.

4. **Pengujian Kinerja dengan JMeter**:
   - Impor file JMeter `.jmx` ke dalam aplikasi Apache JMeter.
   - Jalankan pengujian untuk semua layanan dengan parameter berikut:
     - **Thread Count**: 1000
     - **Ramp-Up Period**: 10 detik
     - **Loop Count**: 1

## Endpoint Layanan
### Post Service
- **GET /posts/:id/complete**
  - Mengembalikan data postingan, komentar, dan likes terkait.

### Comment Service
- **GET /comments/:post_id**
  - Mengembalikan daftar komentar untuk postingan tertentu.

### Like Service
- **GET /likes/:post_id**
  - Mengembalikan jumlah likes untuk postingan tertentu.

### Notification Service
- **GET /notifications/:user_id**
  - Mengembalikan daftar notifikasi untuk pengguna tertentu.

## Catatan Penting
- Pastikan semua layanan berjalan pada port yang benar sesuai dengan konfigurasi.
- Gunakan JMeter untuk menguji kinerja layanan secara keseluruhan.
- Optimalkan layanan jika waktu respon atau throughput tidak memenuhi ekspektasi.

## Kontributor
- **Nama Proyek**: Social Media Microservices
- **Pengembang**: Mahasiswa Ilmu Komputer Paralel 7

## Lisensi
Proyek ini dilisensikan di bawah MIT License.
