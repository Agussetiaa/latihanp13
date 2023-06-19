-- Tabel Perusahaan
CREATE TABLE Perusahaan (
  id_p VARCHAR (10) NOT NULL,
  nama VARCHAR(45) DEFAULT NULL,
  alamat VARCHAR (45)DEFAULT NULL);

INSERT INTO perusahaan (id_p, nama, alamat) VALUES
('P01', 'kantor pusat', NULL),
('P02', 'cabang bekasi', NULL);

-- Tabel Departemen
CREATE TABLE Departemen (
  id_dept VARCHAR(10) NOT NULL,
  nama VARCHAR(45) DEFAULT NULL,
  id_p VARCHAR (10) DEFAULT NULL,
  manajer_nik VARCHAR(10)DEFAULT NULL);
  FOREIGN KEY (id_p) REFERENCES Perusahaan(id_p),
  FOREIGN KEY (id_dept) REFERENCES Karyawan(id_dept);

INSERT INTO Departemen (id_dept, nama, id_p, manajer_nik) VALUES
('D01', 'Produksi', 'P02', 'N01'),
('D02', 'Marketing', 'P01', 'N03'),
('D03', 'RnD', 'P02', NULL),
('D04', 'Logistik', 'P02', NULL);


-- Tabel Karyawan
CREATE TABLE Karyawan (
  nik VARCHAR(10) NOT NULL,
  nama VARCHAR(45) DEFAULT NULL,
  id_dept VARCHAR(10)DEFAULT NULL,
  sup_nik VARCHAR(10)DEFAULT NULL);
  FOREIGN KEY (id_dept) REFERENCES Departemen(id_dept),
  FOREIGN KEY (sup_nik) REFERENCES karyawan(id_nik);

INSERT INTO Karyawan (nik, nama, id_dept, sup_nik) VALUES
('N01','Ari', 'D01', NULL),
('N02','Dina', 'D01', NULL),
('N03','Rika', 'D03', NULL),
('N04','Ratih', 'D01', 'N01'),
('N05','Riko', 'D01', 'N01'),
('N06','Dani', 'D02', NULL),
('N07','Anis', 'D02', 'N05'),
('N08','Dika', 'D02', 'N06');

-- Tabel Karyawan_Project
CREATE TABLE Project_detail (
  id_proj VARCHAR(10) NOT NULL,
  nik VARCHAR(10) NOT NULL);
  FOREIGN KEY (id_proj) REFERENCES proj(id_proj)
  FOREIGN KEY (nik) REFERENCES Karyawan(nik);

INSERT INTO project_detail (id_proj, nik) VALUES
('PJ01', 'N01'),
('PJ01', 'N02'),
('PJ01', 'N03'),
('PJ01', 'N04'),
('PJ01', 'N05'),
('PJ01', 'N07'),
('PJ01', 'N08'),
('PJ02', 'N01'),
('PJ02', 'N03'),
('PJ02', 'N05'),
('PJ03', 'N03'),
('PJ03', 'N07'),
('PJ03', 'N08');

-- Tabel Project
CREATE TABLE Project (
  id_proj VARCHAR(10) NOT NULL,
  nama VARCHAR(45) DEFAULT NULL,
  tgl_mulai DATETIME DEFAULT NULL,
  tgl_selesai DATETIME DEFAULT NULL,
  status TINYINT(1) DEFAULT NULL);

INSERT INTO Project (id_proj, nama, tgl_mulai, tgl_selesai, status) VALUES
('PJ01', 'A', 2019-01-10, 2019-03-10, 1),
('PJ02', 'b', 2019-02-1, 2019-04-10, 1),
('PJ03', 'c', 2019-03-21, 2019-05-10, 1);





-- 1. Departemen apa saja yang terlibat dalam tiap-tiap project
SELECT p.nama AS perusahaan, d.nama AS departemen, pr.nama AS project, COUNT(DISTINCT k.nik) AS jumlah_karyawan
FROM perusahaan p
JOIN departemen d ON p.id_p = d.id_p
JOIN karyawan k ON d.id_dept = k.id_dept
JOIN project_detail pd ON k.nik = pd.nik
JOIN project pr ON pd.id_proj = pr.id_proj
GROUP BY p.nama, d.nama, pr.nama
ORDER BY pr.nama;

-- 2. Jumlah karyawan tiap departemen yang bekerja pada tiap-tiap project
SELECT p.nama AS perusahaan, d.nama AS departemen, pr.nama AS project
FROM perusahaan p
JOIN departemen d ON p.id_p = d.id_p
JOIN karyawan k ON d.id_dept = k.id_dept
JOIN project_detail pd ON k.nik = pd.nik
JOIN project pr ON pd.id_proj = pr.id_proj
ORDER BY pr.nama;

-- 3. Ada berapa project yang sedang dikerjakan oleh departemen RnD? 
-- (ket: project berjalan adalah yang statusnya 1)
SELECT COUNT(DISTINCT pr.id_proj) AS jumlah_karyawan
FROM project pr
JOIN project_detail pd ON pr.id_proj = pd.id_proj
JOIN karyawan k ON pd.nik = k.nik
JOIN departemen dp ON k.id_dept = dp.id_dept
WHERE dp.nama = 'RnD' AND pr.status = 1;

-- 4. Berapa banyak project yang sedang dikerjakan oleh Ari?
SELECT COUNT(DISTINCT pr.id_proj) AS jumlah_project
FROM project pr
JOIN project_detail pd ON pr.id_proj = pd.id_proj
JOIN karyawan k ON pd.nik = k.nik
WHERE k.nama = 'Ari';

-- 5. Siapa saja yang mengerjakan projcet B?
SELECT k.nik, k.nama
FROM karyawan k
JOIN project_detail pj_d ON pj_d.nik=k.nik
JOIN project pj ON pj.id_proj=pj_d.id_proj
WHERE pj.nama = 'B'