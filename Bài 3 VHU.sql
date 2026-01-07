
-- Xóa CSDL nếu đã tồn tại--
USE master;
GO
IF EXISTS(SELECT name FROM sys.databases WHERE name = 'QUANLYSINHVIEN')
BEGIN
    ALTER DATABASE QUANLYSINHVIEN SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QUANLYSINHVIEN;
END
GO

-- Tạo mới CSDL
CREATE DATABASE QUANLYSINHVIEN;
GO

-- Sử dụng CSDL vừa tạo
USE QUANLYSINHVIEN;
GO
-- TẠO BẢNG
CREATE TABLE LOP (
    MALOP CHAR(6) PRIMARY KEY,
    TENLOP NVARCHAR(50),
    SISO TINYINT CHECK(SISO > 0) 
	--ràng buộc sỉ số lớn hơn 0
);
GO

CREATE TABLE SINHVIEN (
    MSSV CHAR(6) PRIMARY KEY,
    HOTEN NVARCHAR(50),
    NTNS DATE,
    PHAI BIT DEFAULT 1 CHECK (PHAI IN (0, 1)),
	--Ràng buộc: Phái nhận giá trị là 1 (Nam), 0 (Nữ), mặc định là 1.
    MALOP CHAR(6),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
);
GO

CREATE TABLE MONHOC (
    MAMH CHAR(6) PRIMARY KEY,
    TENMH NVARCHAR(50),
    TCLT TINYINT CHECK(TCLT > 0),
    TCTH TINYINT CHECK(TCTH >= 0) 
	--Ràng buộc: TCLT > 0, TCTH ≥ 0. 
);
GO

CREATE TABLE DIEMSV (
    MSSV CHAR(6),
    MAMH CHAR(6),
    DIEM FLOAT CHECK (DIEM IS NULL OR (DIEM >= 0 AND DIEM <= 10)),
    PRIMARY KEY (MSSV, MAMH),
    FOREIGN KEY (MSSV) REFERENCES SINHVIEN(MSSV),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
GO

-- DỮ LIỆU LỚP
INSERT LOP VALUES
('18DT01', N'CNTT Khóa 18, Lớp 1', 50), 
('18DT02', N'CNTT Khóa 18, Lớp 2', 45),
('19DT01', N'CNTT Khóa 19, Lớp 1', 55),
('19DT02', N'CNTT Khóa 19, Lớp 2', 50),
('19DT03', N'CNTT Khóa 19, Lớp 3', 40);
GO

-- DỮ LIỆU MÔN HỌC
INSERT MONHOC VALUES
('COS201', N'Kỹ thuật lập trình', 2, 1), 
('COS202', N'Lý thuyết đồ thị', 2, 1),
('COS203', N'CSDL và quản trị CSDL', 3, 0), 
('COS204', N'Phân tích thiết kế hệ thống', 3, 0), 
('COS205', N'CSDL phân tán', 3, 0);
GO

-- DỮ LIỆU SINH VIÊN (đã sửa mã lớp và định dạng ngày)
INSERT SINHVIEN VALUES 
('170001', N'Lê Hoài An', '1999-10-12', 0, '18DT01'), 
('180002', N'Nguyễn Thị Hòa Bình', '2000-11-20', 0, '18DT01'),
('180003', N'Phạm Tường Châu', '2000-06-07', 1, '18DT02'),
('180004', N'Trần Công Danh', '2000-01-31', 1, '19DT01');
GO

-- DỮ LIỆU ĐIỂM
INSERT DIEMSV VALUES 
('170001', 'COS201', 10),
('170001', 'COS202', 10), 
('170001', 'COS203', 10), 
('170001', 'COS204', 10), 
('170001', 'COS205', 10), 
('180002', 'COS201', 3.5), 
('180002', 'COS202', 7), 
('180003', 'COS201', 8.5), 
('180003', 'COS202', 2), 
('180003', 'COS203', 6.5),  
('180004', 'COS201', 8), 
('180004', 'COS204', NULL);
GO
-------------------------------------------------------------------------------------------------------
-- 1. Thêm một dòng mới vào bảng SINHVIEN với giá trị: 
-- 190001 
-- Đào Thị Tuyết Hoa 
-- 08/03/2001 
-- 0 
-- 19DTH02 
INSERT INTO SINHVIEN(MSSV,HOTEN,NTNS,PHAI,MALOP)
VALUES( '190001' , N'Đào Thị Tuyết Hoa', '08/03/2001', 0, '19DT02'); 
GO
SELECT *
FROM SINHVIEN
WHERE HOTEN=N'Đào Thị Tuyết Hoa';


-- 2. Hãy đổi tên môn học ‘Lý thuyết đồ thị’ thành ‘Toán rời rạc’. 
UPDATE MONHOC
SET TENMH=N'Toán rời rạc'
WHERE TENMH= N'Lý thuyết đồ thị';
GO 
SELECT TENMH
FROM MONHOC
-- ĐỔI LẠI NHƯ CŨ 
UPDATE MONHOC
SET TENMH=N'Lý thuyết đồ thị'
WHERE TENMH= N'Toán rời rạc';
-- 3. Hiển thị tên các môn học không có thực hành. 
SELECT  TENMH
FROM MONHOC
WHERE TCTH=0;
-- 4. Hiển thị tên các môn học vừa có lý thuyết, vừa có thực hành. 
SELECT  TENMH
FROM MONHOC
WHERE TCLT>=1 AND TCTH>=1;
-- 5. In ra tên các môn học có ký tự đầu của tên là chữ ‘C’. 
SELECT  TENMH
FROM MONHOC
WHERE TENMH LIKE'%C%';
-- 6. Liệt kê thông tin những sinh viên mà họ chứa chữ ‘Thị’. 
SELECT *
FROM SINHVIEN
WHERE HOTEN LIKE N'%Thị%';
-- 7. In ra 2 lớp có sĩ số đông nhất (bằng nhiều cách). Hiển thị: Mã lớp, Tên lớp, Sĩ số. Nhận xét? 
SELECT TOP 2 MALOP, TENLOP, SISO
FROM LOP
ORDER BY SISO DESC;
-- 8. In danh sách SV theo từng lớp: MSSV, Họ tên SV, Năm sinh, Phái (Nam/Nữ). 
SELECT 
    MALOP,
    MSSV,
    HOTEN,
    YEAR(NTNS) AS NamSinh,
    CASE 
        WHEN PHAI = 1 THEN N'Nam'
        WHEN PHAI = 0 THEN N'Nữ'
    END AS Phai
FROM SINHVIEN
ORDER BY MALOP, MSSV;
-- 9. Cho biết những sinh viên có tuổi ≥ 20, thông tin gồm: Họ tên sinh viên, Ngày sinh, Tuổi. 
SELECT 
    HOTEN, 
    NTNS, 
    DATEDIFF(YEAR, NTNS, GETDATE()) - 
        CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, NTNS, GETDATE()), NTNS) > GETDATE() 
            THEN 1 
            ELSE 0 
        END AS TUOI
FROM SINHVIEN
WHERE 
    DATEDIFF(YEAR, NTNS, GETDATE()) - 
        CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, NTNS, GETDATE()), NTNS) > GETDATE() 
            THEN 1 
            ELSE 0 
        END >= 20;

-- 10. Liệt kê tên các môn học SV đã dự thi nhưng chưa có điểm. 
SELECT MH.MAMH ,MH.TENMH
FROM DIEMSV
JOIN MONHOC MH ON DIEMSV.MAMH = MH.MAMH
WHERE DIEM IS NULL;
-- 11. Liệt kê kết quả học tập của SV có mã số 170001. Hiển thị: MSSV, HoTen, TenMH, Diem. 
SELECT SV.MSSV, SV.HOTEN, MH.TENMH, DV.DIEM
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
JOIN MONHOC MH ON DV.MAMH = MH.MAMH
WHERE SV.MSSV = 170001;
-- 12. Liệt kê tên sinh viên và mã môn học mà sv đó đăng ký với điểm trên 7 điểm. 
SELECT SV.HOTEN,DS.MAMH,DS.DIEM
FROM SINHVIEN SV
JOIN DIEMSV DS ON SV.MSSV=DS.MSSV
WHERE DS.DIEM > 7;
-- 13. Liệt tên môn học cùng số lượng SV đã học và đã có điểm. 
SELECT MH.TENMH, COUNT(DISTINCT DS.MSSV) AS SoLuongSV
FROM MONHOC MH
JOIN DIEMSV DS ON MH.MAMH = DS.MAMH
WHERE DS.DIEM IS NOT NULL
GROUP BY MH.TENMH;
-- 14. Liệt kê tên SV và điểm trung bình của SV đó. 
SELECT SV.HOTEN, AVG(DV.DIEM) AS ' DIEM TRUNG BINH '
FROM DIEMSV DV
JOIN SINHVIEN SV ON DV.MSSV= SV.MSSV
GROUP BY SV.HOTEN;
-- 15. Liệt kê tên sinh viên đạt điểm cao nhất của môn học ‘Kỹ thuật lập trình’. 
SELECT SV.HOTEN,DV.DIEM
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV= DV.MSSV
JOIN MONHOC MH ON DV.MAMH= MH.MAMH
WHERE MH.TENMH =  N'Kỹ thuật lập trình'
AND DV.DIEM = (
	SELECT MAX(DIEM)
	FROM DIEMSV DV
	JOIN MONHOC MH ON DV.MAMH = MH.MAMH
	);
-- 16. Liệt kê tên SV có điểm trung bình cao nhất. 
SELECT SV.HOTEN, AVG(DV.DIEM) AS DTB
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
GROUP BY SV.MSSV, SV.HOTEN
HAVING AVG(DV.DIEM) = (
    SELECT MAX(DTB)
    FROM (
        SELECT AVG(DIEM) AS DTB
        FROM DIEMSV
        GROUP BY MSSV
    ) AS DTB_TABLE
);

-- 17. Liệt kê tên SV chưa học môn ‘Toán rời rạc’. 
SELECT SV.HOTEN
FROM SINHVIEN SV
WHERE NOT EXISTS (
    SELECT *
    FROM DIEMSV DV
    JOIN MONHOC MH ON DV.MAMH = MH.MAMH
    WHERE MH.TENMH = N'Toán rời rạc' AND SV.MSSV = DV.MSSV
);

-- 18. Cho biết sinh viên có năm sinh cùng với sinh viên tên ‘Danh’. 
SELECT *
FROM SINHVIEN
WHERE YEAR(NGAYSINH) = (
    SELECT YEAR(NGAYSINH)
    FROM SINHVIEN
    WHERE HOTEN LIKE N'%Danh%'
);

-- 19. Cho biết tổng sinh viên và tổng số sinh viên nữ. 
SELECT COUNT(*) AS TONG_SV,
       SUM(CASE WHEN PHAI = N'Nữ' THEN 1 ELSE 0 END) AS TONG_NU
FROM SINHVIEN;

-- 20. Cho biết danh sách các sinh viên rớt ít nhất 1 môn. 
SELECT DISTINCT SV.HOTEN
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
WHERE DV.DIEM < 5;

-- 21. Cho biết MSSV, Họ tên SV đã học và có điểm ít nhất 3 môn. 
SELECT SV.MSSV, SV.HOTEN
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
GROUP BY SV.MSSV, SV.HOTEN
HAVING COUNT(DISTINCT DV.MAMH) >= 3;

-- 22. In danh sách SV có điểm môn ‘Kỹ thuật lập trình’ cao nhất theo từng lớp. 
SELECT L.MALOP, SV.HOTEN, DV.DIEM
FROM SINHVIEN SV
JOIN LOP L ON SV.MALOP = L.MALOP
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
JOIN MONHOC MH ON DV.MAMH = MH.MAMH
WHERE MH.TENMH = N'Kỹ thuật lập trình'
  AND DV.DIEM = (
    SELECT MAX(DV2.DIEM)
    FROM DIEMSV DV2
    JOIN SINHVIEN SV2 ON SV2.MSSV = DV2.MSSV
    JOIN MONHOC MH2 ON DV2.MAMH = MH2.MAMH
    WHERE MH2.TENMH = N'Kỹ thuật lập trình' AND SV2.MALOP = L.MALOP
);

-- 23. In danh sách sinh viên có điểm cao nhất theo từng môn, từng lớp. 
SELECT L.MALOP, MH.TENMH, SV.HOTEN, DV.DIEM
FROM SINHVIEN SV
JOIN LOP L ON SV.MALOP = L.MALOP
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
JOIN MONHOC MH ON DV.MAMH = MH.MAMH
WHERE DV.DIEM = (
    SELECT MAX(DV2.DIEM)
    FROM DIEMSV DV2
    JOIN SINHVIEN SV2 ON SV2.MSSV = DV2.MSSV
    WHERE SV2.MALOP = L.MALOP AND DV2.MAMH = DV.MAMH
);

-- 24. Cho biết những sinh viên đạt điểm cao nhất của từng môn. 
SELECT MH.TENMH, SV.HOTEN, DV.DIEM
FROM DIEMSV DV
JOIN MONHOC MH ON DV.MAMH = MH.MAMH
JOIN SINHVIEN SV ON DV.MSSV = SV.MSSV
WHERE DV.DIEM = (
    SELECT MAX(DIEM)
    FROM DIEMSV
    WHERE MAMH = DV.MAMH
);

-- 25. Cho biết MSSV, Họ tên SV chưa đăng ký học môn nào. 
SELECT SV.MSSV, SV.HOTEN
FROM SINHVIEN SV
WHERE NOT EXISTS (
    SELECT *
    FROM DIEMSV DV
    WHERE DV.MSSV = SV.MSSV
);

-- 26. Danh sách sinh viên có tất cả các điểm đều 10. 
SELECT SV.MSSV, SV.HOTEN
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
GROUP BY SV.MSSV, SV.HOTEN
HAVING MIN(DV.DIEM) = 10 AND MAX(DV.DIEM) = 10;

-- 27. Đếm số sinh viên nam, nữ theo từng lớp. 
SELECT L.MALOP,
       SUM(CASE WHEN PHAI = N'Nam' THEN 1 ELSE 0 END) AS NAM,
       SUM(CASE WHEN PHAI = N'Nữ' THEN 1 ELSE 0 END) AS NU
FROM SINHVIEN SV
JOIN LOP L ON SV.MALOP = L.MALOP
GROUP BY L.MALOP;

-- 28. Cho biết những sinh viên đã học tất cả các môn nhưng không rớt môn nào. 
SELECT SV.MSSV, SV.HOTEN
FROM SINHVIEN SV
JOIN DIEMSV DV ON SV.MSSV = DV.MSSV
GROUP BY SV.MSSV, SV.HOTEN
HAVING COUNT(DISTINCT DV.MAMH) = (SELECT COUNT(*) FROM MONHOC)
   AND MIN(DV.DIEM) >= 5;

-- 29. Xoá tất cả những sinh viên chưa dự thi môn nào. 
DELETE FROM SINHVIEN
WHERE MSSV NOT IN (
    SELECT DISTINCT MSSV FROM DIEMSV
);

-- 30. Cho biết những môn đã được tất cả các sinh viên đăng ký học. 
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE NOT EXISTS (
    SELECT *
    FROM SINHVIEN SV
    WHERE NOT EXISTS (
        SELECT *
        FROM DIEMSV DV
        WHERE DV.MSSV = SV.MSSV AND DV.MAMH = MH.MAMH
    )
);
