-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 14, 2026 at 12:44 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_mu_skincare_109062500082`
--
CREATE DATABASE IF NOT EXISTS `db_mu_skincare_109062500082` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `db_mu_skincare_109062500082`;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id_customer` int NOT NULL,
  `nama_customer` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_perubahan_stok`
--

CREATE TABLE `log_perubahan_stok` (
  `id_log` int NOT NULL,
  `product_id` varchar(5) DEFAULT NULL,
  `stok_lama` int DEFAULT NULL,
  `stok_baru` int DEFAULT NULL,
  `waktu_ubah` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_riwayat`
--

CREATE TABLE `log_riwayat` (
  `id_log` int NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `waktu` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_stok`
--

CREATE TABLE `log_stok` (
  `id_log` int NOT NULL,
  `id_product` int DEFAULT NULL,
  `stok_lama` int DEFAULT NULL,
  `stok_baru` int DEFAULT NULL,
  `waktu` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id_product` int NOT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id_product`, `product_name`, `kategori`, `harga`, `stock`) VALUES
(21, '[PREMIUM] Serum Retinol Luxury', NULL, 275000.00, 50);

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `cegah_salah_harga` BEFORE UPDATE ON `product` FOR EACH ROW BEGIN
    -- Jika harga baru lebih kecil dari 50% harga lama
    IF NEW.harga < (OLD.harga * 0.5) THEN
        -- Kembalikan harga ke nilai sebelumnya
        SET NEW.harga = OLD.harga;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `label_premium_product` BEFORE INSERT ON `product` FOR EACH ROW BEGIN
    -- Jika harga produk baru lebih dari 250.000
    IF NEW.harga > 250000 THEN
        -- Otomatis menambahkan teks [PREMIUM] di awal nama produk
        SET NEW.product_name = CONCAT('[PREMIUM] ', NEW.product_name);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `perubahan_stok` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
    -- Logika IF untuk mencatat hanya jika angka stok benar-benar berubah
    IF OLD.stock <> NEW.stock THEN
        INSERT INTO log_perubahan_stok (product_id, stok_lama, stok_baru)
        VALUES (NEW.id_product, OLD.stock, NEW.stock);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` varchar(5) NOT NULL,
  `customer_id` varchar(5) DEFAULT NULL,
  `total_price` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_skincare`
--

CREATE TABLE `transaction_skincare` (
  `id_transaksi` int NOT NULL,
  `id_customer` int DEFAULT NULL,
  `id_product` int DEFAULT NULL,
  `jumlah_beli` int DEFAULT NULL,
  `tanggal_transaksi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indexes for table `log_perubahan_stok`
--
ALTER TABLE `log_perubahan_stok`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `log_riwayat`
--
ALTER TABLE `log_riwayat`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `log_stok`
--
ALTER TABLE `log_stok`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id_product`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `transaction_skincare`
--
ALTER TABLE `transaction_skincare`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_customer` (`id_customer`),
  ADD KEY `id_product` (`id_product`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id_customer` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_perubahan_stok`
--
ALTER TABLE `log_perubahan_stok`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_riwayat`
--
ALTER TABLE `log_riwayat`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_stok`
--
ALTER TABLE `log_stok`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id_product` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `transaction_skincare`
--
ALTER TABLE `transaction_skincare`
  MODIFY `id_transaksi` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaction_skincare`
--
ALTER TABLE `transaction_skincare`
  ADD CONSTRAINT `transaction_skincare_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`),
  ADD CONSTRAINT `transaction_skincare_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`);
--
-- Database: `movie`
--
CREATE DATABASE IF NOT EXISTS `movie` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `movie`;

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int NOT NULL,
  `judul` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `genre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tahun_rilis` year NOT NULL,
  `sutradara` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `durasi` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `judul`, `genre`, `tahun_rilis`, `sutradara`, `durasi`) VALUES
(1, 'Interstellar', 'Sci-Fi', '2014', 'Christopher Nolan', 169),
(2, 'The Conjuring', 'Horror', '2013', 'James Wan', 112),
(3, 'Avengers: Endgame', 'Action', '2019', 'Anthony Russo', 181),
(4, 'Laskar Pelangi', 'Drama', '2008', 'Riri Riza', 125),
(5, 'Spirited Away', 'Animation', '2001', 'Hayao Miyazaki', 125);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- Database: `mu_skincare`
--
CREATE DATABASE IF NOT EXISTS `mu_skincare` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `mu_skincare`;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` varchar(5) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `member_type` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `customer_name`, `member_type`) VALUES
('C001', 'Budi Santoso', 'Silver');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` varchar(5) NOT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `stock` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `price`, `stock`) VALUES
('P001', 'Somethinc Niacinamide Serum', 120000, 45),
('P002', 'Somethinc Ceramide Moisturizer', 150000, 15);

-- --------------------------------------------------------

--
-- Table structure for table `skincare_category`
--

CREATE TABLE `skincare_category` (
  `category_id` int NOT NULL,
  `category_name` varchar(100) DEFAULT NULL,
  `category_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` varchar(5) NOT NULL,
  `customer_id` varchar(5) DEFAULT NULL,
  `total_price` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `customer_id`, `total_price`) VALUES
('T001', 'C001', 120000);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `skincare_category`
--
ALTER TABLE `skincare_category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);
--
-- Database: `telkom_profile`
--
CREATE DATABASE IF NOT EXISTS `telkom_profile` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `telkom_profile`;

-- --------------------------------------------------------

--
-- Table structure for table `berita`
--

CREATE TABLE `berita` (
  `id` int UNSIGNED NOT NULL,
  `judul` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ringkasan` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isi` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tanggal_publish` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `berita`
--

INSERT INTO `berita` (`id`, `judul`, `ringkasan`, `isi`, `tanggal_publish`, `created_at`) VALUES
(1, 'Workshop Git untuk Mahasiswa', 'Mahasiswa mempraktikkan version control melalui proyek web terpadu.', 'Kegiatan workshop membahas repository lokal, staging, commit, branch, merge, remote, push, pull, dan kolaborasi dasar melalui GitHub.', '2026-09-20', '2026-10-01 12:45:45'),
(2, 'Praktikum Web Dinamis', 'Pembelajaran mengintegrasikan PHP native dan basis data.', 'Mahasiswa membangun halaman program studi, berita, dan kontak berbasis PHP native serta MySQL/MariaDB.', '2026-09-18', '2026-10-01 12:45:45'),
(3, 'Simulasi Kolaborasi Developer', 'Mahasiswa mempraktikkan branch dan penyelesaian conflict.', 'Simulasi dilakukan dengan dua folder kerja yang mewakili dua perangkat agar alur push dan pull lebih mudah dipahami.', '2026-09-15', '2026-10-01 12:45:45');

-- --------------------------------------------------------

--
-- Table structure for table `pesan`
--

CREATE TABLE `pesan` (
  `id` int UNSIGNED NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pesan` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pesan`
--

INSERT INTO `pesan` (`id`, `nama`, `email`, `pesan`, `created_at`) VALUES
(1, 'farrel', 'farrelpanji2503@gmail.com', 'Farrel Ganteng, Jefri Nichol kalah', '2026-10-01 14:00:13');

-- --------------------------------------------------------

--
-- Table structure for table `program_studi`
--

CREATE TABLE `program_studi` (
  `id` int UNSIGNED NOT NULL,
  `nama` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenjang` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `program_studi`
--

INSERT INTO `program_studi` (`id`, `nama`, `jenjang`, `deskripsi`, `created_at`) VALUES
(1, 'Sistem Informasi', 'S1', 'Mempelajari integrasi proses bisnis, data, manusia, dan teknologi informasi.', '2026-10-01 12:45:45'),
(2, 'Informatika', 'S1', 'Mempelajari pengembangan perangkat lunak, komputasi, dan kecerdasan buatan.', '2026-10-01 12:45:45'),
(3, 'Teknik Telekomunikasi', 'S1', 'Mempelajari jaringan, komunikasi digital, dan teknologi telekomunikasi.', '2026-10-01 12:45:45'),
(4, 'Bisnis Digital', 'S1', 'Mempelajari strategi bisnis yang memanfaatkan teknologi dan data digital.', '2026-10-01 12:45:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `berita`
--
ALTER TABLE `berita`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pesan`
--
ALTER TABLE `pesan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `program_studi`
--
ALTER TABLE `program_studi`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `berita`
--
ALTER TABLE `berita`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pesan`
--
ALTER TABLE `pesan`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `program_studi`
--
ALTER TABLE `program_studi`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Database: `tubes_perpus`
--
CREATE DATABASE IF NOT EXISTS `tubes_perpus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `tubes_perpus`;

-- --------------------------------------------------------

--
-- Table structure for table `anggota`
--

CREATE TABLE `anggota` (
  `id_anggota` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `alamat` text,
  `no_telepon` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `tanggal_daftar` date NOT NULL,
  `status` enum('Aktif','Beku','Kadaluwarsa','Diblokir') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `anggota`
--

INSERT INTO `anggota` (`id_anggota`, `nama`, `alamat`, `no_telepon`, `email`, `tanggal_daftar`, `status`) VALUES
('A001', 'Fade', 'Purwokerto', '08123456789', 'fade@email.com', '2025-03-20', 'Kadaluwarsa'),
('A002', 'Rael', 'Cilacap', '08234567890', 'rael@email.com', '2026-01-11', 'Aktif'),
('A003', 'Yoll', 'Kebumen', '08345678901', 'yoll@email.com', '2026-01-12', 'Aktif'),
('A004', 'Urel', 'Banyumas', '08456789012', 'urel@email.com', '2025-03-12', 'Diblokir'),
('A005', 'Sage', 'Purbalingga', '08567890123', 'sage@email.com', '2020-01-13', 'Beku'),
('A006', 'Pai', 'Tangerang', '088889999', 'pai@gmail.com', '2025-03-24', 'Kadaluwarsa');

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` varchar(10) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `tahun_terbit` int DEFAULT NULL,
  `stok_total` int NOT NULL,
  `stok_tersedia` int NOT NULL,
  `id_penerbit` varchar(10) DEFAULT NULL,
  `id_rak` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `isbn`, `tahun_terbit`, `stok_total`, `stok_tersedia`, `id_penerbit`, `id_rak`) VALUES
('B001', 'Belajar Database Modern', '978-602-123', 2025, 5, 5, 'PN01', 'R01'),
('B003', 'Sistem Informasi Dasar', '978-602-001', 2026, 5, 5, 'PN01', 'R01'),
('B004', 'Sistem Informasi Dasar', '978-602-005', 2026, 5, 5, 'PN01', 'R01');

-- --------------------------------------------------------

--
-- Table structure for table `buku_kategori`
--

CREATE TABLE `buku_kategori` (
  `id_buku` varchar(10) NOT NULL,
  `id_kategori` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `buku_kategori`
--

INSERT INTO `buku_kategori` (`id_buku`, `id_kategori`) VALUES
('B001', 'K01'),
('B003', 'K01'),
('B004', 'K01');

-- --------------------------------------------------------

--
-- Table structure for table `buku_penulis`
--

CREATE TABLE `buku_penulis` (
  `id_buku` varchar(10) NOT NULL,
  `id_penulis` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `buku_penulis`
--

INSERT INTO `buku_penulis` (`id_buku`, `id_penulis`) VALUES
('B001', 'W01'),
('B003', 'W01'),
('B004', 'W01');

-- --------------------------------------------------------

--
-- Table structure for table `denda`
--

CREATE TABLE `denda` (
  `id_denda` varchar(10) NOT NULL,
  `jumlah_denda` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status_bayar` enum('Belum Lunas','Lunas') NOT NULL,
  `tanggal_bayar` date DEFAULT NULL,
  `id_peminjaman` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `denda`
--

INSERT INTO `denda` (`id_denda`, `jumlah_denda`, `status_bayar`, `tanggal_bayar`, `id_peminjaman`) VALUES
('D001', 6000.00, 'Belum Lunas', NULL, 'P001');

-- --------------------------------------------------------

--
-- Table structure for table `detail_peminjaman`
--

CREATE TABLE `detail_peminjaman` (
  `id_detail` varchar(10) NOT NULL,
  `id_peminjaman` varchar(10) DEFAULT NULL,
  `id_buku` varchar(10) DEFAULT NULL,
  `jumlah` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `detail_peminjaman`
--

INSERT INTO `detail_peminjaman` (`id_detail`, `id_peminjaman`, `id_buku`, `jumlah`) VALUES
('DT001', 'P001', 'B001', 3);

--
-- Triggers `detail_peminjaman`
--
DELIMITER $$
CREATE TRIGGER `tg_kurangi_stok_sebelum_pinjam` BEFORE INSERT ON `detail_peminjaman` FOR EACH ROW BEGIN
    IF (SELECT stok_tersedia FROM buku WHERE id_buku = NEW.id_buku) < NEW.jumlah THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Stok buku tidak mencukupi untuk dipinjam!';
    ELSE
        UPDATE buku 
        SET stok_tersedia = stok_tersedia - NEW.jumlah 
        WHERE id_buku = NEW.id_buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` varchar(10) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL,
  `deskripsi` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`, `deskripsi`) VALUES
('K01', 'Teknologi', 'Buku bertema pemrograman dan sistem informasi');

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` varchar(10) NOT NULL,
  `tanggal_peminjaman` date NOT NULL,
  `tgl_kembali_rencana` date NOT NULL,
  `tgl_kembali_aktual` date DEFAULT NULL,
  `status` enum('Dipinjam','Kembali','Terlambat') NOT NULL,
  `id_anggota` varchar(10) DEFAULT NULL,
  `id_petugas` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `tanggal_peminjaman`, `tgl_kembali_rencana`, `tgl_kembali_aktual`, `status`, `id_anggota`, `id_petugas`) VALUES
('P001', '2026-06-10', '2026-06-17', '2026-06-20', 'Kembali', 'A001', 'P001');

--
-- Triggers `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `tg_hitung_denda_keterlambatan` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    DECLARE jumlah_hari INT;
    DECLARE total_denda DECIMAL(10,2);
    
    IF NEW.tgl_kembali_aktual IS NOT NULL AND NEW.tgl_kembali_aktual > NEW.tgl_kembali_rencana THEN
        SET jumlah_hari = DATEDIFF(NEW.tgl_kembali_aktual, NEW.tgl_kembali_rencana);
        SET total_denda = jumlah_hari * 2000;
        
        INSERT INTO denda (id_denda, jumlah_denda, status_bayar, tanggal_bayar, id_peminjaman)
        VALUES (
            CONCAT('D', SUBSTRING(NEW.id_peminjaman, 2)), 
            total_denda,
            'Belum Lunas',
            NULL,
            NEW.id_peminjaman
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_kembalikan_stok_buku` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF NEW.status = 'Kembali' AND OLD.status != 'Kembali' THEN
        UPDATE buku b
        JOIN detail_peminjaman dp ON b.id_buku = dp.id_buku
        SET b.stok_tersedia = b.stok_tersedia + dp.jumlah
        WHERE dp.id_peminjaman = NEW.id_peminjaman;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `penerbit`
--

CREATE TABLE `penerbit` (
  `id_penerbit` varchar(10) NOT NULL,
  `nama_penerbit` varchar(100) NOT NULL,
  `kota` varchar(50) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `penerbit`
--

INSERT INTO `penerbit` (`id_penerbit`, `nama_penerbit`, `kota`, `telepon`) VALUES
('PN01', 'Erlangga', 'Jakarta', '021-555666');

-- --------------------------------------------------------

--
-- Table structure for table `penulis`
--

CREATE TABLE `penulis` (
  `id_penulis` varchar(10) NOT NULL,
  `nama_penulis` varchar(100) NOT NULL,
  `kebangsaan` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `penulis`
--

INSERT INTO `penulis` (`id_penulis`, `nama_penulis`, `kebangsaan`) VALUES
('W01', 'Robert T. Kiyosaki', 'Amerika');

-- --------------------------------------------------------

--
-- Table structure for table `petugas`
--

CREATE TABLE `petugas` (
  `id_petugas` varchar(10) NOT NULL,
  `nama_petugas` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `jabatan` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `petugas`
--

INSERT INTO `petugas` (`id_petugas`, `nama_petugas`, `username`, `password`, `jabatan`) VALUES
('P001', 'Fai', 'Fai_perpus', 'password123', 'Admin'),
('P002', 'Andi', 'andi_perpus', 'password125', 'Pustakawan');

-- --------------------------------------------------------

--
-- Table structure for table `rak`
--

CREATE TABLE `rak` (
  `id_rak` varchar(10) NOT NULL,
  `kode_rak` varchar(20) NOT NULL,
  `lokasi` varchar(50) DEFAULT NULL,
  `kapasitas` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rak`
--

INSERT INTO `rak` (`id_rak`, `kode_rak`, `lokasi`, `kapasitas`) VALUES
('R01', 'RAK-INF-01', 'Lantai 2 - Sayap Kanan', 50);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anggota`
--
ALTER TABLE `anggota`
  ADD PRIMARY KEY (`id_anggota`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`),
  ADD KEY `id_penerbit` (`id_penerbit`),
  ADD KEY `id_rak` (`id_rak`);

--
-- Indexes for table `buku_kategori`
--
ALTER TABLE `buku_kategori`
  ADD PRIMARY KEY (`id_buku`,`id_kategori`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `buku_penulis`
--
ALTER TABLE `buku_penulis`
  ADD PRIMARY KEY (`id_buku`,`id_penulis`),
  ADD KEY `id_penulis` (`id_penulis`);

--
-- Indexes for table `denda`
--
ALTER TABLE `denda`
  ADD PRIMARY KEY (`id_denda`),
  ADD KEY `id_peminjaman` (`id_peminjaman`);

--
-- Indexes for table `detail_peminjaman`
--
ALTER TABLE `detail_peminjaman`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_peminjaman` (`id_peminjaman`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_anggota` (`id_anggota`),
  ADD KEY `id_petugas` (`id_petugas`);

--
-- Indexes for table `penerbit`
--
ALTER TABLE `penerbit`
  ADD PRIMARY KEY (`id_penerbit`);

--
-- Indexes for table `penulis`
--
ALTER TABLE `penulis`
  ADD PRIMARY KEY (`id_penulis`);

--
-- Indexes for table `petugas`
--
ALTER TABLE `petugas`
  ADD PRIMARY KEY (`id_petugas`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `rak`
--
ALTER TABLE `rak`
  ADD PRIMARY KEY (`id_rak`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `buku`
--
ALTER TABLE `buku`
  ADD CONSTRAINT `buku_ibfk_1` FOREIGN KEY (`id_penerbit`) REFERENCES `penerbit` (`id_penerbit`) ON DELETE SET NULL,
  ADD CONSTRAINT `buku_ibfk_2` FOREIGN KEY (`id_rak`) REFERENCES `rak` (`id_rak`) ON DELETE SET NULL;

--
-- Constraints for table `buku_kategori`
--
ALTER TABLE `buku_kategori`
  ADD CONSTRAINT `buku_kategori_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON DELETE CASCADE,
  ADD CONSTRAINT `buku_kategori_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`) ON DELETE CASCADE;

--
-- Constraints for table `buku_penulis`
--
ALTER TABLE `buku_penulis`
  ADD CONSTRAINT `buku_penulis_ibfk_1` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON DELETE CASCADE,
  ADD CONSTRAINT `buku_penulis_ibfk_2` FOREIGN KEY (`id_penulis`) REFERENCES `penulis` (`id_penulis`) ON DELETE CASCADE;

--
-- Constraints for table `denda`
--
ALTER TABLE `denda`
  ADD CONSTRAINT `denda_ibfk_1` FOREIGN KEY (`id_peminjaman`) REFERENCES `peminjaman` (`id_peminjaman`) ON DELETE CASCADE;

--
-- Constraints for table `detail_peminjaman`
--
ALTER TABLE `detail_peminjaman`
  ADD CONSTRAINT `detail_peminjaman_ibfk_1` FOREIGN KEY (`id_peminjaman`) REFERENCES `peminjaman` (`id_peminjaman`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON DELETE RESTRICT;

--
-- Constraints for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `anggota` (`id_anggota`) ON DELETE RESTRICT,
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_petugas`) REFERENCES `petugas` (`id_petugas`) ON DELETE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
