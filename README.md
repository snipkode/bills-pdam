# Dokumentasi Proyek

Sistem Pembayaran Tagihan PDAM

## 📌 Deskripsi Proyek
Sistem ini adalah REST API untuk mengelola pembayaran tagihan PDAM secara digital. Sistem mencakup pengelolaan pelanggan, tagihan, pembayaran, serta integrasi dengan **Midtrans** sebagai payment gateway.

## 🏗️ Tech Stack
- **Backend**: Express.js (Node.js)
- **Database**: MySQL
- **API Gateway**: Ngrok (untuk pengujian webhook Midtrans)
- **Admin Panel**: PhpMyAdmin
- **Containerization**: Docker & Docker Compose
- **Payment Gateway**: Midtrans

---

## 🔄 Alur Bisnis
1. **Admin/Petugas** menambahkan data pelanggan baru ke dalam sistem.
2. **Sistem** secara otomatis membuat tagihan bulanan untuk pelanggan berdasarkan pemakaian air.
3. **Petugas** mengunggah bukti foto meteran air pelanggan.
4. **Pelanggan** dapat melihat tagihan dan memilih metode pembayaran (tunai, transfer, e-wallet, atau Midtrans).
5. **Jika memilih Midtrans**, pelanggan diarahkan ke halaman pembayaran Midtrans.
6. **Midtrans** mengirim callback status pembayaran ke sistem.
7. **Sistem memperbarui status pembayaran** dan menyimpan data transaksi.

---

## 📊 Schema Database & Relasi
### 1️⃣ **users** (Admin/Petugas)
- Menyimpan data pengguna yang mengelola sistem.

### 2️⃣ **customers** (Pelanggan)
- Menyimpan informasi pelanggan PDAM.

### 3️⃣ **bills** (Tagihan)
- Berisi tagihan pelanggan, termasuk jumlah yang harus dibayar & foto meteran air.
- **Relasi:** `bills.customer_id → customers.id`

### 4️⃣ **payments** (Pembayaran)
- Menyimpan transaksi pembayaran oleh pelanggan.
- **Relasi:** `payments.bill_id → bills.id`

### 5️⃣ **transactions** (Riwayat Transaksi)
- Berisi riwayat transaksi pembayaran pelanggan.
- **Relasi:** `transactions.payment_id → payments.id`

### 6️⃣ **midtrans_logs** (Webhook Midtrans)
- Menyimpan log callback dari Midtrans untuk tracking pembayaran otomatis.

---

## 🚀 Cara Menjalankan Proyek
### 1️⃣ **Clone Repository & Jalankan Docker**
```sh
 git clone https://github.com/snipkode/bills-pdam.git
 cd bills-pdam
 docker-compose up -d
```

### 2️⃣ **Konfigurasi Database**
- Import `schema.sql` ke MySQL menggunakan PhpMyAdmin atau CLI.
- Update file `.env` dengan kredensial database & API Key Midtrans.

### 3️⃣ **Menjalankan Server Backend**
```sh
npm install
npm start
```

---

## 📡 API Endpoint Utama
### 🔹 **1. Pelanggan**
- **GET** `/customers` → List pelanggan
- **POST** `/customers` → Tambah pelanggan baru

### 🔹 **2. Tagihan**
- **GET** `/bills/{customer_id}` → Lihat tagihan pelanggan
- **POST** `/bills` → Tambah tagihan baru

### 🔹 **3. Pembayaran**
- **POST** `/payments` → Proses pembayaran
- **GET** `/payments/status/{transaction_id}` → Cek status pembayaran

### 🔹 **4. Webhook Midtrans**
- **POST** `/midtrans/webhook` → Callback status pembayaran dari Midtrans

---

## 📞 Kontak & Dukungan
Jika ada pertanyaan atau kendala, silakan hubungi developer di **alamhafidz61@gmail.com** atau buka issue di GitHub.

---

🚀 **Happy Coding!**

