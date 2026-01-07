USE master;
GO
-- Nếu CSDL đã tồn tại thì xóa
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'QUANLYBANHANG')
BEGIN
    DROP DATABASE QUANLYBANHANG;
END
GO
-- Tạo mới CSDL
CREATE DATABASE QUANLYBANHANG;
GO
-- Sử dụng CSDL mới tạo
USE QUANLYBANHANG;
GO

--TẠO TABLE
CREATE TABLE KHACHHANG
(
	MAKH varchar(10),
	TENKH nvarchar(30) NOT NULL,
	DIACHI nvarchar(50),
	DT varchar(11) CHECK(DT IS NULL OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	EMAIL varchar(50),
	PRIMARY KEY(MAKH)
	--Ràng buộc: TENKH not null, DT có thể rỗng hoặc có 10 chữ số.
)
GO
CREATE TABLE VATTU
(
	MAVT varchar(10),
	TENVT Nvarchar(30),
	DVT Nvarchar(20),
	GIAMUA INT CHECK(GIAMUA>0),
	SLTON INT CHECK(SLTON>=0),
	PRIMARY KEY(MAVT)
	--Ràng buộc: TENVT not null, GIAMUA > 0, SLTON >= 0.
)
GO
CREATE TABLE HOADON
(
	MAHD varchar(10),
	NGAY date CHECK(NGAY<GETDATE()),
	MAKH varchar(10),
	TONGTG float,
	PRIMARY KEY(MAHD),
	FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH)
	--Ràng buộc: Giá trị nhập vào cho field NGAY phải trước ngày hiện hành.
)
GO
CREATE TABLE CTHD
(
	MAHD varchar(10),
	MAVT varchar(10),
	SL int CHECK(SL>0),
	KHUYENMAI float,
	GIABAN float,
	PRIMARY KEY(MAHD,MAVT),
	FOREIGN KEY(MAHD) REFERENCES HOADON(MAHD),
	FOREIGN KEY(MAVT) REFERENCES VATTU(MAVT)
	--Ràng buộc: Giá trị nhập vào cho field SL phải lớn hơn 0
)
--Nhập dữ liệu cho Table
GO
INSERT KHACHHANG
VALUES
	(N'KH01', N'Nguyễn Thị Bé', N'Tân Bình', '0913475782', 'bnt@yahoo.com'),
	(N'KH02', N'Lê Hoàng Nam', N'Bình Chánh', '0909342713', 'namlehoang@gmail.com'),
	(N'KH03', N'Trần Thị Chiêu', N'Tân Bình', '0982317865', NULL),
	(N'KH04', N'Mai Thị Quế Anh', N'Bình Chánh', NULL, NULL),
	(N'KH05', N'Lê Văn Sáng', N'Quận 10', NULL, 'sanglv@hcm.vnn.vn'),
	(N'KH06', N'Trần Hoàng', N'Tân Bình', '0378342163', NULL)
--THÊM DỮ KIỆN 
GO
INSERT HOADON
VALUES
	('HD001', '2010-05-12', 'KH01', 0),
	('HD002', '2010-05-25', 'KH02', 0),
	('HD003', '2010-05-25', 'KH01', 0),
	('HD004', '2010-05-25', 'KH04', 0),
	('HD005', '2010-05-26', 'KH04', 0),
	('HD006', '2010-06-02', 'KH03', 0),
	('HD007', '2010-06-22', 'KH04', 0),
	('HD008', '2010-06-25', 'KH03', 0),
	('HD009', '2010-08-15', 'KH04', 0),
	('HD010', '2010-09-30', 'KH01', 0)
GO
INSERT VATTU
VALUES
	(N'VT01', N'Xi măng', N'Bao', 50000, 5000),
	(N'VT02', N'Cát', N'Khối', 45000, 2000),
	(N'VT03', N'Gạch ống', N'Viên', 120, 80000),
	(N'VT04', N'Gạch thẻ', N'Viên', 110, 80000),
	(N'VT05', N'Đá lớn', N'Khối', 25000, 100000),
	(N'VT06', N'Đá nhỏ', N'Khối', 33000, 100000),
	(N'VT07', N'Lam gió', N'Cái', 15000, 50000)
GO
INSERT CTHD
VALUES
	('HD001', 'VT01', 5, 0, 52000),
	('HD001', 'VT05', 10, 0, 30000),
	('HD002', 'VT03', 10000, 0, 150),
	('HD003', 'VT02', 20, 0, 55000),
	('HD004', 'VT03', 50000, 0, 150),
	('HD004', 'VT04', 20000, 0, 120),
	('HD005', 'VT05', 10, 0, 30000),
	('HD005', 'VT06', 15, 0, 35000),
	('HD005', 'VT07', 20, 0, 17000),
	('HD006', 'VT04', 10000, 0, 120),
	('HD007', 'VT04', 20000, 0, 125),
	('HD008', 'VT01', 100, 0, 55000),
	('HD008', 'VT02', 20, 0, 47000),
	('HD009', 'VT02', 25, 0, 48000),
	('HD010', 'VT01', 25, 0, 57000)

GO
----------------------------------------------------------------------------------------------------------------------------------
-- 1. Hiển thị danh sách khách hàng có địa chỉ là "Tân Bình" gồm các thông tin: mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và email.  
SELECT MAKH, TENKH, DIACHI, DT, EMAIL
FROM KHACHHANG
WHERE DIACHI = N'Tân Bình';
-- 2. Hiển thị danh sách khách hàng chưa có số điện thoại gồm mã khách hàng, tên khách hàng, địa chỉ và email.  
SELECT MAKH, TENKH, DIACHI, EMAIL
FROM KHACHHANG
WHERE DT IS NULL OR DT = '';
-- 3. Hiển thị danh sách khách hàng chưa có số điện thoại và cũng chưa có địa chỉ email gồm mã khách hàng, tên khách hàng và địa chỉ. 
SELECT MAKH, TENKH, DIACHI
FROM KHACHHANG
WHERE DT IS NULL OR DT = '' AND EMAIL IS NULL OR EMAIL='';
-- 4. Hiển thị danh sách khách hàng đã có cả số điện thoại và email gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại và email.  
SELECT MAKH, TENKH, DIACHI, DT, EMAIL
FROM KHACHHANG
WHERE DT IS NOT NULL OR DT = '' AND EMAIL IS NOT NULL OR EMAIL='';
-- 5. Hiển thị danh sách vật tư có đơn vị tính là "Cái" gồm mã vật tư, tên vật tư và giá mua.  
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE DVT=N'CÁI';
-- 6. Hiển thị danh sách vật tư có giá mua lớn hơn 25.000 gồm mã vật tư, tên vật tư, đơn vị tính và giá mua. 
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE GIAMUA>25000;
-- 7. Hiển thị danh sách vật tư thuộc nhóm "Gạch" (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, đơn vị tính và giá mua.  
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE TENVT LIKE N'%Gạch%';
-- 8. Hiển thị danh sách vật tư có giá mua trong khoảng từ 20.000 đến 40.000 gồm mã vật tư, tên vật tư, đơn vị tính và giá mua.  
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE (GIAMUA>=25000) AND (GIAMUA<=40000);
-- 9. Lấy thông tin gồm mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại.  
SELECT MAHD, TENKH, DIACHI, DT, MAHD, NGAY
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
-- 10. Lấy thông tin gồm mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của hóa đơn lập ngày 25/5/2010.  
SELECT MAHD, TENKH, DIACHI, DT, MAHD, NGAY
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE NGAY='2010/5/25';
-- 11. Lấy thông tin gồm mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của các hóa đơn trong tháng 6/2010.  
SELECT HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI, KH.DT
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE HD.NGAY >= '2010-06-01' AND HD.NGAY < '2010-07-01';
-- 12. Lấy danh sách khách hàng (tên, địa chỉ, số điện thoại) đã mua hàng trong tháng 6/2010.  
SELECT DISTINCT KH.TENKH, KH.DIACHI, KH.DT
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE HD.NGAY >= '2010-06-01' AND HD.NGAY < '2010-07-01';
-- 13. Lấy danh sách khách hàng (tên, địa chỉ, số điện thoại) không mua hàng trong tháng 6/2010.  
SELECT TENKH, DIACHI, DT
FROM KHACHHANG
WHERE MAKH NOT IN(
	SELECT MAKH
FROM HOADON
WHERE NGAY >= '2010-06-01' AND NGAY < '2010-07-01'
);
-- 14. Lấy chi tiết hóa đơn gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng) và trị giá bán (giá bán * số lượng).  
SELECT
	CTHD.MAHD,
	CTHD.MAVT,
	VT.TENVT,
	VT.DVT,
	CTHD.GIABAN,
	VT.GIAMUA,
	CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [Trị giá mua],
	(CTHD.GIABAN * CTHD.SL) AS [Trị giá bán]
FROM CTHD
	JOIN VATTU VT ON CTHD.MAVT = VT.MAVT
	JOIN HOADON HD ON CTHD.MAHD = HD.MAHD;

-- 15. Lấy chi tiết hóa đơn có giá bán lớn hơn hoặc bằng giá mua gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua, trị giá bán.  
SELECT
	CTHD.MAHD,
	CTHD.MAVT,
	VT.TENVT,
	VT.DVT,
	CTHD.GIABAN,
	VT.GIAMUA,
	CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [Trị giá mua],
	(CTHD.GIABAN * CTHD.SL) AS [Trị giá bán]
FROM CTHD
	JOIN VATTU VT ON CTHD.MAVT = VT.MAVT
	JOIN HOADON HD ON CTHD.MAHD = HD.MAHD
WHERE CTHD.GIABAN >= VT.GIAMUA;
-- 16. Lấy chi tiết hóa đơn với cột khuyến mãi 10% cho các mặt hàng bán trong hóa đơn có trị giá bán lớn hơn 100, gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua và trị giá bán.  
SELECT
	CTHD.MAHD,
	CTHD.MAVT,
	VT.TENVT,
	VT.DVT,
	CTHD.GIABAN,
	VT.GIAMUA,
	CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [Trị giá mua],
	(CTHD.GIABAN * CTHD.SL) AS [Trị giá bán],
	(CTHD.GIABAN * CTHD.SL) * 0.1 AS [Khuyến mãi 10%]
FROM CTHD
	JOIN VATTU VT ON CTHD.MAVT =VT.MAVT
	JOIN HOADON HD ON CTHD.MAHD= HD.MAHD
WHERE (CTHD.GIABAN * CTHD.SL)  >100;
-- 17. Tìm các mặt hàng chưa từng được bán.  
SELECT *
FROM VATTU
WHERE MAVT NOT IN (
    SELECT DISTINCT MAVT
FROM CTHD
);
-- 18. Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán.  
SELECT
	HD.MAHD,
	HD.NGAY,
	KH.TENKH,
	KH.DIACHI,
	KH.DT,
	VT.TENVT,
	VT.GIAMUA,
	CTHD.GIABAN,
	CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [TRỊ GIÁ MUA],
	(CTHD.GIABAN * CTHD.SL) AS [TRỊ GIÁ BÁN]
FROM CTHD
	JOIN HOADON HD ON CTHD.MAHD = HD.MAHD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN VATTU VT ON CTHD.MAVT = VT.MAVT;
-- 19. Tạo bảng tổng hợp các hóa đơn tháng 5/2010 gồm mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán.  
SELECT
	HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI, KH.DT,
	VT.TENVT, VT.DVT, VT.GIAMUA, CTHD.GIABAN, CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [Trị giá mua],
	(CTHD.GIABAN * CTHD.SL) AS [Trị giá bán]
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
	JOIN VATTU VT ON CTHD.MAVT = VT.MAVT
WHERE HD.NGAY >= '2010-05-01' AND HD.NGAY < '2010-06-01';

-- 20. Tạo bảng tổng hợp quý 1 năm 2010 gồm mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán.  
SELECT
	HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI, KH.DT,
	VT.TENVT, VT.DVT, VT.GIAMUA, CTHD.GIABAN, CTHD.SL,
	(VT.GIAMUA * CTHD.SL) AS [Trị giá mua],
	(CTHD.GIABAN * CTHD.SL) AS [Trị giá bán]
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
	JOIN VATTU VT ON CTHD.MAVT = VT.MAVT
WHERE HD.NGAY >= '2010-01-01' AND HD.NGAY < '2010-04-01';


-- 21. Lấy danh sách hóa đơn gồm số hóa đơn, ngày lập, tên khách hàng, địa chỉ khách hàng và tổng trị giá hóa đơn.  
SELECT
	HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI,
	SUM(CTHD.GIABAN * CTHD.SL) AS [Tổng trị giá]
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
GROUP BY HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI;

-- 22. Lấy hóa đơn có tổng trị giá lớn nhất gồm số hóa đơn, ngày lập, tên khách hàng, địa chỉ khách hàng và tổng trị giá.  
SELECT TOP 1
	HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI,
	SUM(CTHD.GIABAN * CTHD.SL) AS [Tổng trị giá]
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
GROUP BY HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI
ORDER BY [Tổng trị giá] DESC;

-- 23. Lấy hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm số hóa đơn, ngày lập, tên khách hàng, địa chỉ khách hàng và tổng trị giá.  
SELECT TOP 1
	HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI,
	SUM(CTHD.GIABAN * CTHD.SL) AS [Tổng trị giá]
FROM HOADON HD
	JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
WHERE HD.NGAY >= '2010-05-01' AND HD.NGAY < '2010-06-01'
GROUP BY HD.MAHD, HD.NGAY, KH.TENKH, KH.DIACHI
ORDER BY [Tổng trị giá] DESC;

-- 24. Đếm số hóa đơn của từng khách hàng.  
SELECT KH.MAKH, KH.TENKH, COUNT(HD.MAHD) AS [Số hóa đơn]
FROM KHACHHANG KH
	LEFT JOIN HOADON HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.TENKH;

-- 25. Đếm số hóa đơn của từng khách hàng theo từng tháng.  

SELECT
	KH.MAKH, KH.TENKH,
	MONTH(HD.NGAY) AS Thang,
	COUNT(HD.MAHD) AS [Số hóa đơn]
FROM KHACHHANG KH
	JOIN HOADON HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.TENKH, MONTH(HD.NGAY);
-- 26. Lấy thông tin khách hàng có số lượng hóa đơn mua nhiều nhất.  

SELECT TOP 1
	KH.MAKH, KH.TENKH, COUNT(HD.MAHD) AS [Số hóa đơn]
FROM KHACHHANG KH
	JOIN HOADON HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.TENKH
ORDER BY [Số hóa đơn] DESC;
-- 27. Lấy thông tin khách hàng có số lượng hàng mua nhiều nhất.  

SELECT TOP 1
	KH.MAKH, KH.TENKH, SUM(CTHD.SL) AS [Tổng SL]
FROM KHACHHANG KH
	JOIN HOADON HD ON KH.MAKH = HD.MAKH
	JOIN CTHD ON HD.MAHD = CTHD.MAHD
GROUP BY KH.MAKH, KH.TENKH
ORDER BY [Tổng SL] DESC;
-- 28. Lấy thông tin mặt hàng được bán trong nhiều hóa đơn nhất.  
SELECT TOP 1
	VT.MAVT, VT.TENVT, COUNT(DISTINCT CTHD.MAHD) AS [Số hóa đơn xuất hiện]
FROM VATTU VT
	JOIN CTHD ON VT.MAVT = CTHD.MAVT
GROUP BY VT.MAVT, VT.TENVT
ORDER BY [Số hóa đơn xuất hiện] DESC;

-- 29. Lấy thông tin mặt hàng có số lượng bán nhiều nhất. 
SELECT TOP 1
	VT.MAVT, VT.TENVT, SUM(CTHD.SL) AS [Tổng SL]
FROM VATTU VT
	JOIN CTHD ON VT.MAVT = CTHD.MAVT
GROUP BY VT.MAVT, VT.TENVT
ORDER BY [Tổng SL] DESC;

-- 30. Lấy danh sách tất cả khách hàng gồm mã khách hàng, tên khách hàng, địa chỉ và số lượng hóa đơn đã mua (trường hợp chưa mua thì số lượng hóa đơn để trống).  
SELECT
	KH.MAKH, KH.TENKH, KH.DIACHI, COUNT(HD.MAHD) AS [Số hóa đơn]
FROM KHACHHANG KH
	LEFT JOIN HOADON HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.TENKH, KH.DIACHI;
