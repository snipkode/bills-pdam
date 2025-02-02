CREATE DATABASE IF NOT EXISTS pdam_db;
USE pdam_db;

-- Tabel Pengguna (Admin atau Petugas)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik untuk setiap pengguna
    username VARCHAR(50) UNIQUE NOT NULL, -- Nama pengguna unik
    password VARCHAR(255) NOT NULL, -- Kata sandi pengguna
    role ENUM('admin', 'officer') NOT NULL, -- Peran pengguna dalam sistem
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Waktu pembuatan akun
);

-- Tabel Pelanggan PDAM
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik pelanggan
    name VARCHAR(100) NOT NULL, -- Nama pelanggan
    email VARCHAR(100) UNIQUE NOT NULL, -- Email pelanggan (harus unik)
    phone VARCHAR(20) NOT NULL, -- Nomor telepon pelanggan
    address TEXT NOT NULL, -- Alamat pelanggan
    customer_number VARCHAR(50) UNIQUE NOT NULL, -- Nomor pelanggan unik
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Waktu pembuatan data pelanggan
);

-- Tabel Tagihan PDAM
CREATE TABLE bills (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik tagihan
    customer_id INT NOT NULL, -- ID pelanggan terkait tagihan
    month YEAR NOT NULL, -- Periode bulan tagihan
    due_date DATE NOT NULL, -- Tanggal jatuh tempo tagihan
    amount_due DECIMAL(10,2) NOT NULL, -- Jumlah tagihan yang harus dibayar
    status ENUM('UNPAID', 'PAID') DEFAULT 'UNPAID', -- Status pembayaran tagihan
    meter_photo VARCHAR(255) NULL, -- Foto bukti meteran air
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Waktu pembuatan tagihan
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE -- Relasi dengan tabel pelanggan
);

-- Tabel Pembayaran
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik pembayaran
    bill_id INT NOT NULL, -- ID tagihan yang dibayarkan
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Waktu pembayaran dilakukan
    amount_paid DECIMAL(10,2) NOT NULL, -- Jumlah yang dibayarkan
    payment_method ENUM('CASH', 'BANK_TRANSFER', 'E-WALLET', 'MIDTRANS') NOT NULL, -- Metode pembayaran termasuk Midtrans
    status ENUM('PENDING', 'SUCCESS', 'FAILED') DEFAULT 'PENDING', -- Status pembayaran
    midtrans_transaction_id VARCHAR(100) NULL, -- ID transaksi dari Midtrans jika menggunakan Midtrans
    midtrans_status VARCHAR(50) NULL, -- Status pembayaran dari Midtrans
    FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE -- Relasi dengan tabel tagihan
);

-- Tabel Transaksi (untuk audit dan riwayat pembayaran)
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik transaksi
    customer_id INT NOT NULL, -- ID pelanggan yang melakukan transaksi
    bill_id INT NOT NULL, -- ID tagihan terkait transaksi
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Waktu transaksi terjadi
    amount DECIMAL(10,2) NOT NULL, -- Jumlah transaksi
    status ENUM('COMPLETED', 'FAILED') NOT NULL, -- Status transaksi
    payment_id INT NOT NULL, -- ID pembayaran terkait transaksi
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE, -- Relasi dengan tabel pelanggan
    FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE, -- Relasi dengan tabel tagihan
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE -- Relasi dengan tabel pembayaran
);

-- Tabel Log Midtrans (Untuk menyimpan webhook/callback Midtrans)
CREATE TABLE midtrans_logs (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik log
    transaction_id VARCHAR(100) NOT NULL, -- ID transaksi dari Midtrans
    status VARCHAR(50) NOT NULL, -- Status transaksi dari Midtrans
    raw_response TEXT NOT NULL, -- Data lengkap dari response Midtrans
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Waktu pencatatan log
);
