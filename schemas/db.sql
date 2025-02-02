CREATE DATABASE IF NOT EXISTS pdam_db;
USE pdam_db;

-- Tabel Pengguna (Admin atau Petugas)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik untuk setiap pengguna
    username VARCHAR(50) UNIQUE NOT NULL, -- Nama pengguna unik
    password VARCHAR(255) NOT NULL, -- Kata sandi pengguna
    role ENUM('admin', 'officer', 'customer') NOT NULL, -- Peran pengguna dalam sistem, termasuk 'customer'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Waktu pembuatan akun
);

-- Tabel Pelanggan PDAM
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID unik pelanggan
    user_id INT NOT NULL, -- Link to users table
    name VARCHAR(100) NOT NULL, -- Nama pelanggan
    email VARCHAR(100) UNIQUE NOT NULL, -- Email pelanggan (harus unik)
    phone VARCHAR(20) NOT NULL, -- Nomor telepon pelanggan
    address TEXT NOT NULL, -- Alamat pelanggan
    customer_number VARCHAR(50) UNIQUE NOT NULL, -- Nomor pelanggan unik
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Waktu pembuatan data pelanggan
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- Foreign key to users table
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

-- Dummy data for users
INSERT INTO users (username, password, role) VALUES
('admin', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36Zf4d8b5y3y3y3y3y3y3y3y3', 'admin'), -- password: password
('officer1', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36Zf4d8b5y3y3y3y3y3y3y3', 'officer'), -- password: password
('customer1', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36Zf4d8b5y3y3y3y3y3y3y3', 'customer'); -- password: password

-- Dummy data for customers
INSERT INTO customers (user_id, name, email, phone, address, customer_number) VALUES
(3, 'John Doe', 'john.doe@example.com', '1234567890', '123 Main St', 'CUST001'),
(3, 'Jane Smith', 'jane.smith@example.com', '0987654321', '456 Elm St', 'CUST002');

-- Dummy data for bills
INSERT INTO bills (customer_id, month, due_date, amount_due, status) VALUES
(1, 2023, '2023-12-01', 100.00, 'UNPAID'),
(2, 2023, '2023-12-01', 150.00, 'UNPAID');

-- Dummy data for payments
INSERT INTO payments (bill_id, amount_paid, payment_method, status) VALUES
(1, 100.00, 'CASH', 'SUCCESS'),
(2, 150.00, 'BANK_TRANSFER', 'SUCCESS');

-- Dummy data for transactions
INSERT INTO transactions (customer_id, bill_id, amount, status, payment_id) VALUES
(1, 1, 100.00, 'COMPLETED', 1),
(2, 2, 150.00, 'COMPLETED', 2);

-- Dummy data for midtrans_logs
INSERT INTO midtrans_logs (transaction_id, status, raw_response) VALUES
('TRANS001', 'SUCCESS', '{"order_id":"ORDER001","status":"SUCCESS"}'),
('TRANS002', 'SUCCESS', '{"order_id":"ORDER002","status":"SUCCESS"}');
